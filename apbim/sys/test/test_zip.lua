local zip = require "luazip"
assert(zip)
local test_file_source = "test_file_source.zip"
function test()
	os.remove(test_file_source)
	local ar = assert(zip.open(test_file_source, zip.CREATE));
	ar:add("file.txt","file","file.txt")
	ar:close()
end
local test_zip_file = "test.zip"
function test_stat()
	local ar = assert(zip.open(test_zip_file))

	local expect = {
		name = "test/text.txt",
		index = 2,
		crc = 635884982,
		size = 14,
		mtime = 1296450278,
		comp_size = 14,
		comp_method = 0,
		encryption_method = 0,
	}

	local stat =
	assert(ar:stat("TEXT.TXT", zip.OR(zip.FL_NOCASE, zip.FL_NODIR)))

	--is_deeply(stat, expect, "TEST.TXT stat")

	stat = assert(ar:stat(2))

	--is_deeply(stat, expect, "index 2 stat")

	ar:close()
end
function test_read_file()
    local ar = assert(zip.open(test_zip_file))

    local file =
        assert(ar:open("TEXT.TXT",
                       zip.OR(zip.FL_NOCASE, zip.FL_NODIR)))

    local str = file:read(256)
    assert(str == "one\ntwo\nthree\n",
       "[" .. tostring(str) .. "] == [one\ntwo\nthree\n]")

    file:close()

    -- The data at index 2 is not compressed:
    file = assert(ar:open(2, zip.FL_COMPRESSED))
    str = file:read(256)
    assert(str == "one\ntwo\nthree\n",
       "[" .. tostring(str) .. "] == [one\ntwo\nthree\n]")

    ar:close()

    -- Closing the file after the archive was closed!
    file:close()
end

function test_add()
    -- Make sure we start with a clean slate:
    local test_add_file = "test_add.zip"

    os.remove(test_add_file)
    local ar = assert(zip.open(test_add_file,
                                zip.OR(zip.CREATE, zip.EXCL)));

    ar:add("dir/add.txt", "string", "Contents")

    ar:close()

    local ar = assert(zip.open(test_add_file, zip.CHECKCONS))
    assert(1 == #ar, "Archive contains one entry: " .. #ar)

    local file =
        assert(ar:open("add.TXT",
                       zip.OR(zip.FL_NOCASE, zip.FL_NODIR)))
    local str = assert(file:read(256))
    assert(str == "Contents", str .. " == 'Contents'")

    file:close()
    ar:close()
end

test()
test_stat()
test_read_file()
test_add()
