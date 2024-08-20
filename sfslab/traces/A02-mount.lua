-- This does rudimentary checks on the mounting
-- and unmounting functionality. This should work out
-- of the box.

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

-- largely taken from user `hookenz` on StackOverflow:
-- https://stackoverflow.com/a/27028488
local function dump(o)
    if type(o) == 'table' then
        local s = ''
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s
    else
        return tostring(o)
    end
end

check(disk.format("disks/A02-first.sfs", 8 * 512))
local fd1 = check(disk.open("first.txt"))
assert(dump(disk.list()) == "[1] = first.txt,")
disk.close(fd1)
check(disk.unmount())
check(disk.format("disks/A02-second.sfs", 8 * 512))
assert(dump(disk.list()) == '')
local fd2 = check(disk.open("second.txt"))
assert(dump(disk.list()) == "[1] = second.txt,")
disk.close(fd2)
check(disk.unmount())
check(disk.mount("disks/A02-first.sfs"))
assert(dump(disk.list()) == "[1] = first.txt,")
