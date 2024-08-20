-- This is a basic getpos test. It does not
-- test getpos with seek. It tries bad inputs.
--
-- Once you have implemented sfs_getpos, this
-- should work for you.

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

check(disk.format("disks/A01-pos.sfs", 8 * 512))

local fd1 = check(disk.open("postest.txt"))
assert(check(disk.getPos(fd1)) == 0)
string = "hello world\n"
assert(check(disk.write(fd1, string)) == #string)
assert(check(disk.getPos(fd1)) == #string)

local fd2 = check(disk.open("postest.txt"))
assert(check(disk.getPos(fd2)) == 0)
assert(check(disk.read(fd2, 64)) == string)
assert(check(disk.getPos(fd2)) == #string)
-- Try a never-existed fd (should receive an error)
assert(not disk.getPos(fd1+fd2+1))
-- Try now-closed fds (should also receive an error)
disk.close(fd1)
assert(not disk.getPos(fd1))
disk.close(fd2)
assert(not disk.getPos(fd2))
