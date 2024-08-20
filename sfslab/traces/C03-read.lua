-- Read files concurrently. Two new files are created and
-- filled with some data, and then
-- 6 threads each try to read from the files.
-- Probably works on the base implementation, but may
-- expose issues with your threading implementation
lanes.configure { with_timers = false }

local ITER = 5
local N_THREADS = 6
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
check(disk.format("disks/C03-read.sfs", 4096))
local fd = check(disk.open("C03-fnameA.txt"))
assert(check(disk.write(fd, CONTENTS)) == #CONTENTS)
local fdB = check(disk.open("C03-fnameB.txt"))
assert(check(disk.write(fdB, CONTENTS)) == #CONTENTS)

local function readA()
    for i = 1, ITER do
        local fd = check(disk.open("C03-fnameA.txt"))
        assert(check(disk.read(fd, #CONTENTS)) == CONTENTS)
        local A_STR = "A"
        disk.write(fd, A_STR)
        disk.close(fd)
    end
    return true
end

local function readB()
    for i = 1, ITER do
        local fd = check(disk.open("C03-fnameB.txt"))
        assert(check(disk.read(fd, #CONTENTS)) == CONTENTS)
        disk.close(fd)
    end
    return true
end

local laneprocA = lanes.gen("string,disk",
    function(tid)
        readA()
        readB()
        return true
    end
)

local laneprocB = lanes.gen("string,disk",
    function(tid)
        readB()
        readA()
        return true
    end
)

local lanes = {}
for i = 1, N_THREADS do
    if i > 3 then
        lanes[i] = laneprocA(i)
    else
        lanes[i] = laneprocB(i)
    end
end

for i = 1, N_THREADS do
    check(lanes[i]:join())
end

local files = disk.list()
table.sort(files)
assert(files[1] == "C03-fnameA.txt")
