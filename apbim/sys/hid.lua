_ENV = module(...,ap.adv)

local flag_ = '_apcad_aphid'
local sample_ = 'c54393220f444d50c31e2c1058e645a0e249b870'

--[[
function get_hash_id(f)
	local file = io.open(f,"rb");
	local s = file:read("*all");
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(s);
	trace_out(s1);
	d:reset();
	file:close();
	
end
--]]

local function get_flag()
	return flag_
end

function is(str)
	if type(str)~='string' then return false end
	local pos = string.len(sample_);
	local begin = pos+1;
	local last = pos+string.len(flag_);
	local sub = string.sub(str,begin,last)
	return sub==flag_;
end

function is_hid_file(str)
	local filename = require'sys.str'.get_filename(str);
	-- local sub = string.sub(filename,41,43)
	-- return sub==flag_;
	return is(filename);
end

function get_by_string(str)
	local dig = require"crypto".digest;
	if not dig then return nil end
	local d = dig.new("sha1");
	local s = d:final(str)..flag_;
	d:reset();
	return s;
end

function get_by_file(arg)
	local file = type(arg)=='string' and arg or type(arg)=='table' and type(arg.file)=="string" and arg.file;
	if type(file)~='string' then return end
	local f = io.open(file,"rb");
	if not f then return nil end
	local str = f:read("*all");
	f:close();
	return get_by_string(str);
end

-- t={str=,path=,exname=}
function str_to_file(t)
	local name = get_by_string(t.str);
	local file = t.path..name..(t.exname or "")
	local f = io.open(file,"w");
	if not f then trace_out("Error: sys.hid.str_to_file()\n") return end
	f:write(t.str);
	f:close();
	return name;
end
