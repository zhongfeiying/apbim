-- require"test_zip"
-- require "app.Zip.zip_mgr".open_zip();
-- require "app.Zip.zip_mgr".add_zip_file("main.lua");
-- require "app.Zip.zip_mgr".add_zip_dir("sys");
-- require "app.Zip.zip_mgr".close();

local zip = require"luazip"

local zip_file = 'sys\\test\\zip\\test.zip';
local src_file = "sys\\test\\zip\\m_m.lua";
local dst_file = "m\\m.lua";

local function del()
	ar = zip.open(zip_file, zip.CREATE);
	ar:delete(dst_file)
	ar:close()
end

local function add_file()
	ar = zip.open(zip_file, zip.CREATE);
	ar:add(dst_file,"file",src_file)
	ar:close()
end

local function add_string()
	ar = zip.open(zip_file, zip.CREATE);
	ar:add(dst_file,"string","abcdefg\n")
	ar:close()
end

-- function replace_string()
	-- ar = zip.open(zip_file, zip.CREATE);
	-- ar:replace(dst_file,"string","12345678\n")
	-- ar:close()
-- end

local function read_string()
	ar = zip.open(zip_file, zip.CREATE);
	local file = ar:open(dst_file,zip.OR(zip.FL_NOCASE, zip.FL_NODIR));
	if not file then ar:close() return end
	local str = file:read(615);
	-- local env = {};
	-- local f = load(str,'unname','bt',env)
	-- f()
	require"sys.str".totrace(str);
	ar:close()
end

local function stat()
	ar = zip.open(zip_file, zip.CREATE);
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
	local s = ar:stat(dst_file, zip.OR(zip.FL_NOCASE, zip.FL_NODIR))
	require"sys.table".totrace{stat=s};
	ar:close()
end

local function get_size(ar,file)
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
	local s = ar:stat(file, zip.OR(zip.FL_NOCASE, zip.FL_NODIR))
	return s.size;
end

local function get_fdx()
	ar = zip.open(zip_file, zip.CREATE);
	local fdx = ar:name_locate(dst_file, zip.OR(zip.FL_NOCASE, zip.FL_NODIR));
	trace_out(tostring(fdx));
	ar:close()
end

local function add_loop()
	ar = zip.open(zip_file, zip.CREATE);
	for i=0,10000 do
		ar:add('m'..i..'.lua',"string","This = nil\n")
		trace_out(i..'\n');
	end
	ar:close()
end

local function extract(t)
	local str = get_string(t);
	if not str then return nil end
	local name = require'sys.str'.get_filename(t.file);
	local f = io.open(t.pos..name,'w')
	if not f then return end
	f:write(str)
	f:close();
end

local function read_loop()
	for i=0,10000 do
	ar = zip.open(zip_file, zip.CREATE);
		local file = ar:open('m'..i..'.lua',zip.OR(zip.FL_NOCASE, zip.FL_NODIR));
		if not file then return end
		local str = file:read(get_size(ar,'m'..i..'.lua'));
		trace_out(i..'\n');
	ar:close()
	end
end

-- del()
-- add_file();
-- add_string();
-- replace_string();
-- read_string();
-- stat();
-- get_fdx()


-- add_loop()
-- read_loop()

