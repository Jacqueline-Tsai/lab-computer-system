-- Read files sequentially. A new file is created and
-- filled with some data, and then we read five times.
lanes.configure { with_timers = false }

local N_THREADS = 5
local CONTENTS = -- 640 characters exactly (including newlines)
[[0@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
1@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
2@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
3@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
4@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
5@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
6@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
7@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
8@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
9@ABCDEFGHIJKLMNOPQRSTUVWXYZ[/]^_`abcdefghijklmnopqrstuvwxyz{|}
]]

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

-- minimum page size
check(disk.format("disks/B03-read.sfs", 4096))
local fd = check(disk.open("B03-tmp.txt"))
disk.close(fd)
assert(check(disk.rename("B03-tmp.txt", "B03-fname.txt")))
fd = check(disk.open("B03-fname.txt"))
assert(check(disk.write(fd, CONTENTS)) == #CONTENTS)

local function readfile()
    local fd = check(disk.open("B03-fname.txt"))
    assert(check(disk.read(fd, #CONTENTS)) == CONTENTS)
    disk.close(fd)
    return true
end

for i = 1, N_THREADS do
    readfile()
end

local files = disk.list()
table.sort(files)
assert(files[1] == "B03-fname.txt")
