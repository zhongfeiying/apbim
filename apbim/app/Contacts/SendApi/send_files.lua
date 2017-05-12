_ENV = module(...,ap.adv)
local ctr_require_ = require "app.Contacts.require_files"
local dlg_import_files_ = ctr_require_.dlg_import_files()

local file_op_ = ctr_require_.file_op()
local temp_path_ = "cfg\\ApcadTempFile\\"
local lfs_ =require "lfs"
os.execute("if not exist " .. "\"" .. temp_path_ .. "\"" .. "  mkdir  ".. "\"" .. temp_path_ .. "\"")

--[[
function send_files()
	local gids = select_files();
	local txt = get_note();
	uploads(gids);
	local code = create_code(gid,txt);	
	send_msg(code,send_to);
end
--]]
----------------------------------------------------sjy---------------------
local function table_is_empty(t)
	return _G.next(t) == nil
end


local CurFiles_ = nil
local data_ = nil

local function send_msg_code()
	if not CurFiles_ then return end 
	--lfs_.rmdir(string.sub(temp_path_,1,-2))
	for k,v in ipairs (CurFiles_) do
		os.remove(temp_path_ .. v.Hid)
	--	trace_out("v.hid = " .. v.Hid .. "\n")
	end
	local t = {}
	t.To = data_.User
	t.Name = data_.Title
	t.Text = data_.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_files(CurFiles_); --获取选中构件的代码
	t.Arrived_Report = data_.Arrived 
	t.Read_Report= data_.Read 
	t.Confirm_Report= data_.Confirm 
	require "sys.net.msg".send_msg(t)
	data_ = nil
	CurFiles_ = nil
end



function send_msg (data)
	if not data then return end 
	dlg_import_files_.set_data()
	dlg_import_files_.pop()
	local files = dlg_import_files_.get_data()
	if not files or table_is_empty(files) then return end 
	--os.execute("if not exist " .. "\"" .. temp_path_ .. "\"" .. "  mkdir  ".. "\"" .. temp_path_ .. "\"")
	data_ = data
	for k,v in ipairs (files) do
		local hash = file_op_.get_file_hash(v.AllPath)
		if hash then 
			v.Hid = hash
			file_op_.copy_file(v.AllPath,temp_path_ .. hash)
		end
	end

	local ts = {}
	for k,v in ipairs (files) do
		table.insert(ts,{name = v.Hid,path = temp_path_})
	end
	CurFiles_ = files
	require'sys.net.file'.send_s(ts,send_msg_code);
end


local function send_channel_code()
	if not CurFiles_ then return end 
	for k,v in ipairs (CurFiles_) do
		os.remove(temp_path_ ..v.Hid)
	end
	local t = {}
	t.To = data_.User
	t.Name = data_.Title
	t.Text = data_.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_files(CurFiles_); --获取选中构件的代码
	t.Arrived_Report = data_.Arrived 
	t.Read_Report= data_.Read 
	t.Confirm_Report= data_.Confirm 
	require "sys.net.msg".send_channel(t)
	data_ = nil
	CurFiles_ = nil
end

function send_channel(data)
	if not data then return end 
	dlg_import_files_.set_data()
	dlg_import_files_.pop()
	local files = dlg_import_files_.get_data()
	if not files or table_is_empty(files) then return end 
	os.execute("if not exist " .. "\"" .. temp_path_ .. "\"" .. "  mkdir  ".. "\"" .. temp_path_ .. "\"")
	data_ = data
	for k,v in ipairs (files) do
		local hash = file_op_.get_file_hash(v.AllPath)
		if hash then 
			v.Hid = hash
			file_op_.copy_file(v.AllPath,temp_path_ .. hash)
		end
	end

	local ts = {}
	for k,v in ipairs (files) do
		table.insert(ts,{name = v.Hid,path = temp_path_})
	end
	CurFiles_ = files
	require'sys.net.file'.send_s(ts,send_channel_code);
end





