-- Random file copier to produce chains of identical files so the head
-- and the tail can be diff'd at the end of each iteration.  Largely a
-- test for data corruption. Loosely based on xfstests/generic/001.

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

local function checkSeeks(fd, startPos, curPos, n)
    -- seek by zero should do nothing
    local seekPos = check(disk.seek(fd, 0))
    assert(seekPos == curPos)
    assert(check(disk.getPos(fd)) == curPos)

    -- seek by -n should put us back where we were originally
    seekPos = check(disk.seek(fd, -n))
    assert(seekPos == startPos)
    assert(check(disk.getPos(fd)) == startPos)
end

-- Compare files A and B, raising an error if they are different.
local function cmp(a, b)
    local a_fd = check(disk.open(a))
    local b_fd = check(disk.open(b))
    local offset = 0
    repeat
        local a_block = check(disk.read(a_fd, 1024))
        local b_block = check(disk.read(b_fd, 1024))
        if #a_block ~= #b_block then
            error(string.format("at offset %d: %s read %d bytes, %s read %d",
                                offset, a, #a_block, b, #b_block))
        end
        if a_block ~= b_block then
            error(string.format("data mismatch at offset %d for %s and %s",
                                offset, a, b))
        end
        offset = offset + #a_block
    until #a_block == 0
    disk.close(a_fd)
    disk.close(b_fd)
end

-- Copy the contents of START to START.1. Then copy START.1 to START.2
-- and delete START.1.  Then copy START.2 to START.3 and delete START.2.
-- Keep doing this until we have done it COPIES times.  Return the file
-- name START.{COPIES}.
local function copy_chain(start, copies)
    local function copy1(from_f, to_f)
        local from_fd = check(disk.open(from_f))
        local to_fd = check(disk.open(to_f))
        while true do
            local block = check(disk.read(from_fd, 1024))
            if #block == 0 then break end
            assert(check(disk.write(to_fd, block)) == #block)
        end
        disk.close(from_fd)
        disk.close(to_fd)
    end

    local src = start
    local dest = start .. ".1"
    copy1(src, dest)
    for i = 2, copies do
        src = dest
        dest = string.format("%s.%d", start, i)
        copy1(src, dest)
        check(disk.remove(src))
    end
    return dest
end

local function creat(file, contents)
    local fd = check(disk.open(file))
    local startPos = check(disk.getPos(fd))
    assert(check(disk.write(fd, contents)) == #contents)
    local curPos = check(disk.getPos(fd))
    
    checkSeeks(fd, startPos, curPos, #contents)
    disk.close(fd)
end

local SMALL_FILE = -- 1500 characters exactly (including newlines)
[[The uncertain, unsettled condition of this science of Cetology is in
the very vestibule attested by the fact, that in some quarters it
still remains a moot point whether a whale be a fish. In his System of
Nature, AD. 1776, Linnaeus declares, "I hereby separate the whales
from the fish." But of my own knowledge, I know that down to the year
1850, sharks and shad, alewives and herring, against Linnaeus's
express edict, were still found dividing the possession of the same
seas with the Leviathan.
Be it known that, waiving all argument, I take the good old
fashioned ground that the whale is a fish, and call upon holy Jonah to
back me. This fundamental thing settled, the next point is, in what
internal respect does the whale differ from other fish. Above,
Linnaeus has given you those items. But in brief, they are these:
lungs and warm blood; whereas all other fish are lungless and cold
blooded. Next: how shall we define the whale, by his obvious
externals, so as to label him for all time?
In short, a whale is a spouting fish with a horizontal tail. There you
have him. A walrus spouts much like a whale, but the walrus is not a
fish, because he is amphibious. But the last term of the definition is
still more cogent, as coupled with the first. Almost any one must have
noticed that all the fish familiar to landsmen have not a flat, but a
vertical, or up-and-down tail. Whereas, among spouting fish the tail,
though it may be similarly shaped, invariably assumes an horizontal
position.
]]

local MEDIUM_FILE = SMALL_FILE .. SMALL_FILE .. SMALL_FILE
local LARGE_FILE = MEDIUM_FILE .. MEDIUM_FILE .. MEDIUM_FILE
local HUGE_FILE = LARGE_FILE .. LARGE_FILE .. LARGE_FILE

-- We need space for 3 copies each of the 4 file sizes, plus the
-- superblock.  For each 500 bytes of data there are 12 bytes of
-- overhead.
local N_BLOCKS = (
    3 * (#SMALL_FILE / 500
         + #MEDIUM_FILE / 500
         + #LARGE_FILE / 500
         + #HUGE_FILE / 500)
    + 1) * 512
-- And as usual we must round up to a multiple of 4096.
N_BLOCKS = ((N_BLOCKS + 4095) // 4096) * 4096

check(disk.format("disks/B02-copychain.sfs", N_BLOCKS))

creat("small", SMALL_FILE)
creat("medium", MEDIUM_FILE)
creat("large", LARGE_FILE)
creat("huge", HUGE_FILE)

copy_chain("small", 20)
copy_chain("medium", 20)
copy_chain("large", 20)
copy_chain("huge", 20)

cmp("small", "small.20")
cmp("medium", "medium.20")
cmp("large", "large.20")
cmp("huge", "huge.20")
