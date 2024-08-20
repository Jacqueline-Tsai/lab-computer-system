-- Create files concurrently. 5 threads each try to create 3 files and
-- write enough data that two blocks are required for each.
lanes.configure { with_timers = false }

local N_THREADS = 5
local N_FILES = 3
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

-- 2 blocks * 3 files * 5 threads + superblock + 1 more to meet the
-- requirement that the filesystem size be a multiple of the system page size.
-- (32 * 512 = 16384 = 4 * 4096)
check(disk.format("disks/C01-create.sfs", 32 * 512))

local laneproc = lanes.gen("string,disk",
    function(tid)
        local fds = {}
        for i = 1, N_FILES do
            local fname = string.format("f-%d-%d", tid, i)
            fds[i] = check(disk.open(fname))
        end
        for i = 1, N_FILES do
            assert(check(disk.write(fds[i], CONTENTS)) == #CONTENTS)
            disk.close(fds[i])
        end
        return true
    end
)

local lanes = {}
for i = 1, N_THREADS do
    lanes[i] = laneproc(i)
end

for i = 1, N_THREADS do
    check(lanes[i]:join())
end

local files = disk.list()
table.sort(files)
for i = 1, N_THREADS do
    for j = 1, N_FILES do
        assert(files[(i-1)*N_FILES + j] == string.format("f-%d-%d", i, j))
    end
end
