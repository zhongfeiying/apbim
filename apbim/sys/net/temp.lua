

_ENV = module(...,ap.adv)

-- local pos_ = 'sys\\net\\__temp\\record\\'
local record_pos_ = require'sys.mgr'.get_path()..'record\\'
local temp_pos_ = require'sys.mgr'.get_path()..'temp\\'
require'sys.api.dos'.md(record_pos_);
require'sys.api.dos'.md(temp_pos_);

function add_record(name)
	local f = io.open(record_pos_..name,'w');
	if f then f:close() end
end

function del_record(name)
	os.remove(record_pos_..name);
end

function clear()
	-- os.remove(record_pos_..'*.*');
	require'sys.api.dos'.del(record_pos_..'*.*')
end

function is_record(name)
	local f = io.open(record_pos_..name,'r');
	if f then f:close() return true else return false end
end

function get_temp_path()
	-- return 'sys/net/__temp/temp/'
	return temp_pos_;
end
