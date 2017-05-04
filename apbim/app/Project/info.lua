_ENV = module(...,ap.adv)

local index_file_ = "__index.apc";
-- local index_key_ = "gid";
local model_ = "Model\\";

local pos_ = nil;
local name_ = nil;

function init()
	-- gid_ = nil;
	pos_ = nil;
	name_ = nil;
end

function get_model_pos()
	if not pos_ then return nil end
	return pos_..model_;
end

function get_pos()
	return pos_;
end

function set_pos(str)
	pos_ = str;
	require"sys.api.dir".create_folder(get_model_pos());
end

function get_name()
	if name_ then return name_ end
end

function set_name(str)
	name_ = str;
end

function get_gid()
	if not pos_ then return nil end
	local gid = require"sys.io".read_file{file=get_model_pos()..index_file_};
	if gid then return gid end
	gid = string.upper(require"luaext".guid()); 
	require"sys.table".tofile{file=get_model_pos()..index_file_,src=gid};
	return gid;
end

function set_gid(str)
	if not pos_ then return end
	if not str or str=="" then return end
	require"sys.table".tofile{file=get_model_pos()..index_file_,src=str};
	return str;
end
