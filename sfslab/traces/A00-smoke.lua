-- This is a "smoke test."  Think of plugging an old electronic gadget
-- into the wall and then looking for any smoke coming out.
---
-- The starting version of sfs-disk.c passes this test.  If this test
-- starts failing, you have broken something that used to work.

local function check(rv, ...)
    if not rv then
        message = ...
        error(message, 2)
    end
    return rv
end

local function assert_eq(a, b, ...)
    if a ~= b then
        message = string.format(...)
        error(message .. ":\ngot:\n" .. a .. "\nexpected:\n" .. b .. "\n----",
              2)
    end
end

local function test_split_read(fname, text)
    local fd = check(disk.open(fname))
    assert_eq(check(disk.write(fd, text)), #text,
              "writing contents of %s", fname)
    -- can't use disk.seek() in this trace
    disk.close(fd)
    for split = 0, #text - 1 do
        fd = check(disk.open(fname))
        if split > 0 then
            assert_eq(check(disk.read(fd, split)),
                      string.sub(text, 1, split),
                      "read back [0, %d) of %s", split, fname)
        end
        assert_eq(check(disk.read(fd, #text - split)),
                  string.sub(text, split+1, -1),
                  "read back [%d, %d) of %s", split, #text, fname)
        assert_eq(check(disk.read(fd, 16)), "",
                  "read back EOF of %s", fname)
        disk.close(fd)
    end
end

local function test_split_write(fname, text)
    for split = 1, #text - 1 do
        check(disk.remove(fname))
        local fd = check(disk.open(fname))
        local head = string.sub(text, 1, split)
        local tail = string.sub(text, split+1, -1)

        assert_eq(check(disk.write(fd, head)), #head,
                  "writing contents of %s (head)", fname)
        assert_eq(check(disk.write(fd, tail)), #tail,
                  "writing contents of %s (tail)", fname)

        -- can't use disk.seek() in this trace
        disk.close(fd)
        fd = disk.open(fname)
        assert_eq(check(disk.read(fd, #text + 512)), text,
                  "read back contents of %s", fname)
        assert_eq(check(disk.read(fd, 16)), "",
                  "read back EOF of %s", fname)
        disk.close(fd)
    end
end

local testcases = {
    { name="one-block.txt",
      contents="hello world\n" },
    { name="two-blocks.txt",
      contents=[[
This quotation from "Alice in Wonderland" is long enough to require
two blocks on disk:

> "The first thing I've got to do," said Alice to herself, as she
> wandered about in the wood, "is to grow to my right size again;
> and the second thing is to find my way into that lovely garden.
> I think that will be the best plan."

> It sounded an excellent plan, no doubt, and very neatly and simply
> arranged; the only difficulty was, that she had not the smallest idea
> how to set about it; and, while she was peering about anxiously among
> the trees, a little sharp bark just over her head made her look up in
> a great hurry.

> An enormous puppy was looking down at her with large round eyes, and
> feebly stretching out one paw, trying to touch her.
]] },
    { name="three-blocks.txt",
      contents=[[
This quotation from "The Count of Monte-Cristo" is long enough to
require three blocks on disk:

> At first the captain had received Dantès on board with a certain
> degree of distrust. He was very well known to the customs officers
> of the coast; and as there was between these worthies and himself a
> perpetual battle of wits, he had at first thought that Dantès might
> be an emissary of these industrious guardians of rights and duties,
> who perhaps employed this ingenious means of learning some of the
> secrets of his trade. But the skilful manner in which Dantès had
> handled the lugger had entirely reassured him; and then, when he saw
> the light plume of smoke floating above the bastion of the Château
> d’If, and heard the distant report, he was instantly struck with the
> idea that he had on board his vessel one whose coming and going,
> like that of kings, was accompanied with salutes of artillery. This
> made him less uneasy, it must be owned, than if the new-comer had
> proved to be a customs officer; but this supposition also
> disappeared like the first, when he beheld the perfect tranquillity
> of his recruit.

> Edmond thus had the advantage of knowing what the owner was, without
> the owner knowing who he was; and however the old sailor and his crew
> tried to “pump” him, they extracted nothing more from him; he gave
> accurate descriptions of Naples and Malta, which he knew as well as
> Marseilles, and held stoutly to his first story.
]] }
}

check(disk.format("disks/A00-smoke.sfs", 8 * 512))

for i, tc in ipairs(testcases) do
    test_split_read(tc.name, tc.contents)
    test_split_write(tc.name, tc.contents)
end

local listing = check(disk.list())
assert_eq(#listing, #testcases)
for i = 1, #listing do
    assert_eq(listing[i], testcases[i].name)
end
