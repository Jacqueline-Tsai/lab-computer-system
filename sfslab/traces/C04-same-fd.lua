-- 1. Creates a file that consists of 405000 characters of A, followed by 405000 characters of B
-- 2. Creates 2 threads, which share the file descriptor to the above mentioned file
-- 3. Both threads read half of the file, and write the contents to 2 different files
-- 4. The combination of the 2 files written by the 2 threads must be the original file
-- 5. 2 sets of 2 threads perform this same operation (1-4)
lanes.configure { with_timers = false }

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

-- Read half of the file which corresponds to from_fd file descriptor
-- that is shared across threads
local function copy_chain(from_fd, id)
    local function copy1(from_fd, to_f)
        local to_fd = check(disk.open(to_f))
        local i = 0
        local block = check(disk.read(from_fd, 40500*10))
        -- print(block)
        assert(check(disk.write(to_fd, block)) == #block)
        disk.close(to_fd)
    end

    local dest = "huge." .. id
    copy1(from_fd, dest)
    return dest
end

local function creat(file, contents)
    local fd = check(disk.open(file))
    assert(check(disk.write(fd, contents)) == #contents)
    disk.close(fd)
end

local SMALL_FILE = -- 1500 characters exactly
[[AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA]]

local MEDIUM_FILE = SMALL_FILE .. SMALL_FILE .. SMALL_FILE
local LARGE_FILE = MEDIUM_FILE .. MEDIUM_FILE .. MEDIUM_FILE
local HUGE_FILE_A = LARGE_FILE .. LARGE_FILE .. LARGE_FILE

HUGE_FILE_A = HUGE_FILE_A .. HUGE_FILE_A .. HUGE_FILE_A .. HUGE_FILE_A .. HUGE_FILE_A
HUGE_FILE_A = HUGE_FILE_A .. HUGE_FILE_A
-- size is 405000 bytes

local SMALL_FILE_B = -- 1500 characters exactly
[[BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB]]

local MEDIUM_FILE_B = SMALL_FILE_B .. SMALL_FILE_B .. SMALL_FILE_B
local LARGE_FILE_B = MEDIUM_FILE_B .. MEDIUM_FILE_B .. MEDIUM_FILE_B
local HUGE_FILE_B = LARGE_FILE_B .. LARGE_FILE_B .. LARGE_FILE_B

HUGE_FILE_B = HUGE_FILE_B .. HUGE_FILE_B .. HUGE_FILE_B .. HUGE_FILE_B .. HUGE_FILE_B
HUGE_FILE_B = HUGE_FILE_B .. HUGE_FILE_B
-- size is 405000 bytes

local HUGE_FILE = HUGE_FILE_A .. HUGE_FILE_B

-- We need space for 3 copies each of huge file, plus the
-- superblock.  For each 500 bytes of data there are 12 bytes of
-- overhead.
local N_BLOCKS = (
    3 * (#HUGE_FILE / 500)
    + 1) * 512
-- And as usual we must round up to a multiple of 4096.
N_BLOCKS = ((N_BLOCKS + 4095) // 4096) * 4096

check(disk.format("disks/C04-same-fd.sfs", N_BLOCKS))

creat("huge", HUGE_FILE)

local lane_copy = lanes.gen("string,disk", copy_chain)
local lanes = {}

local from_fd_1 = check(disk.open("huge"))
local from_fd_2 = check(disk.open("huge"))

lanes[1] = lane_copy(from_fd_1, 1)
lanes[2] = lane_copy(from_fd_1, 2)

lanes[3] = lane_copy(from_fd_2, 3)
lanes[4] = lane_copy(from_fd_2, 4)

check(lanes[1]:join())
check(lanes[2]:join())
check(lanes[3]:join())
check(lanes[4]:join())

disk.close(from_fd_1)
disk.close(from_fd_2)

local file_1 = check(disk.open("huge.1"))
local file_2 = check(disk.open("huge.2"))
local file_3 = check(disk.open("huge.3"))
local file_4 = check(disk.open("huge.4"))

local block_1 = check(disk.read(file_1, 40500*10))
local block_2 = check(disk.read(file_2, 40500*10))
local block_3 = check(disk.read(file_3, 40500*10))
local block_4 = check(disk.read(file_4, 40500*10))

local combination_1 = block_1 .. block_2
local combination_2 = block_2 .. block_1

local combination_3 = block_3 .. block_4
local combination_4 = block_4 .. block_3

-- any combination could be equal to HUGE_FILE, depending on which
-- thread started the read first
if combination_1 ~= HUGE_FILE and combination_2 ~= HUGE_FILE and combination_3 ~= HUGE_FILE and combination_4 ~= HUGE_FILE then
    error(string.format("ERROR"))
end

disk.close(file_1)
disk.close(file_2)
disk.close(file_3)
disk.close(file_4)