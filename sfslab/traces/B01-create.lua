-- Sequential version of C01-create.lua.  Should do exactly the same
-- thing, just not in parallel.

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
check(disk.format("disks/B01-create.sfs", 32 * 512))

for tid = 1, N_THREADS do
    for i = 1, N_FILES do
        local fname = string.format("f-%d-%d", tid, i)
        local fd = check(disk.open(fname))
        assert(check(disk.write(fd, CONTENTS)) == #CONTENTS)
        assert(check(disk.getPos(fd)) == #CONTENTS)
        local seekPos = #CONTENTS
        assert(check(disk.seek(fd, -seekPos)) == 0)
        disk.close(fd)
    end
end

local files = disk.list()
table.sort(files)
for i = 1, N_THREADS do
    for j = 1, N_FILES do
        assert(files[(i-1)*N_FILES + j] == string.format("f-%d-%d", i, j))
    end
end
