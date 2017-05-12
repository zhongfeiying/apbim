_ENV = module(...,ap.adv)

local zip_ = require'luazip'



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
	local s = ar:stat(file, zip_.OR(zip_.FL_NOCASE, zip_.FL_NODIR))
	return s.size;
end

-- t={zip=,file=}
function get_string(t)
	if not t.zip then return nil end
	ar = zip_.open(t.zip, zip_.CREATE);
	if not ar then return nil end
	local file = ar:open(t.file,zip_.OR(zip_.FL_NOCASE, zip_.FL_NODIR));
	if not file then ar:close() return nil end
	local str = file:read(get_size(ar,t.file));
	ar:close()
	return str;
end

-- t={zip=,file=,pos=}
function extract(t)
	local str = get_string(t);
	if not str then return nil end
	local name = require'sys.str'.get_filename(t.file);
	local f = io.open(t.pos..name,'w')
	if not f then return end
	f:write(str)
	f:close();
end

function get_fdx(ar,file)
	local fdx = ar:name_locate(file, zip_.OR(zip_.FL_NOCASE, zip_.FL_NODIR));
	return fdx;
end

-- t={zip=,file=}
-- function get_fdx(t)
	-- ar = zip_.open(t.zip, zip_.CREATE);
	-- local fdx = ar:name_locate(t.file, zip_.OR(zip_.FL_NOCASE, zip_.FL_NODIR));
	-- ar:close()
	-- return fdx;
-- end

-- t={zip=,file=,key=}
function read(t)
	local str = get_string(t);
	if not str then return nil end
	local env = {};
	local f = load(str,'read_zip','bt',env);
	if type(f)~='function' then return nil end
	local result = f();
	if t.key then return env[t.key] else return result end
end

-- arg=""/{zip=}
function open(arg)
	local zip = type(arg)=='string' and arg or type(arg)=='table' and type(arg.zip)=='string' and arg.zip or nil;
	if not zip then return nil end
	local ar = zip_.open(zip,zip_.CREATE);
	return ar;
end

function close(ar)
	ar:close();
end

--ar,file,"string"/"file",src
function add(ar,file,mode,src)
	local f = ar:open(file,zip_.OR(zip_.FL_NOCASE, zip_.FL_NODIR));
	if f then ar:delete(file) end
	ar:add(file,mode,src);
end

--ar,file,"string"/"file",src
function add(ar,file,mode,src)
	local fdx = get_fdx(ar,file);
	if fdx then ar:replace(fdx,mode,src) return end
	ar:add(file,mode,src);
end

