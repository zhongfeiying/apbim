_ENV = module(...,ap.adv)

local zip_ = require'luazip'
local cfg_file_ = "cfg\\projects_path.lua";

local PATH_ = 'Projects/';
local name_ = nil;

function init()
	name_ = nil;
end

function set_path(str)
	require'sys.table'.tofile{file=cfg_file_,src=get_path()}
end

function get_path()
	local path = require'sys.io'.read_file{file=cfg_file_};
	return type(path)=='string' and path or PATH_;
end

function set_name(str)
	name_ = str;
end

function get_name()
	return name_;
end

function get_file()
	if not get_path() or not get_name() then return nil end
	return get_path()..get_name()..require'sys.mgr'.get_zip_exname();
end

function get_item(id)
	if not id or not get_file() or not require'sys.io'.is_there_file(get_file()) then return nil end
	local it = require'sys.zip'.read{zip=get_file(),file=require'sys.mgr'.get_zip_model()..id..require'sys.mgr'.get_db_exname(),key=require'sys.mgr'.get_db_key()};
	if type(it)~='table' then return nil; end
	it = require'sys.mgr.ifo'.new(it);
	return it;
end

