ENV = module_seeall(...,package.seeall)

local ctr_require_ = require "app.Contacts.require_files"
local dlg_merge_send_ = ctr_require_.dlg_merge_send()

local file_op_ = ctr_require_.file_op()

local function table_is_empty(t)
	return _G.next(t) == nil
end

local CurFiles_ = nil
local data_ = nil
local merge_data_ = nil
local function send_msg_code()
	if not CurFiles_ then return end 
	for k,v in ipairs (CurFiles_) do
		os.remove(v.Hid)
	end
	local t = {}
	t.To = data_.User
	t.Name = data_.Title
	t.Text = data_.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_merge(merge_data_); 
	t.Arrived_Report = data_.Arrived 
	t.Read_Report= data_.Read 
	t.Confirm_Report= data_.Confirm 
	require "sys.net.msg".send_msg(t)
	data_ = nil
	CurFiles_ = nil
end


function send_msg(data)
	if not data then return end 
	dlg_merge_send_.set_data()
	dlg_merge_send_.pop()
	local merge_data = dlg_merge_send_.get_data()
	if not merge_data then return end 
	data_ = data
	merge_data_ = merge_data
	if merge_data.Files and not table_is_empty(merge_data.Files) then 
		
		for k,v in ipairs (merge_data.Files) do
			local hash = file_op_.get_file_hash(v.AllPath)
			if hash then 
				v.Hid = hash
				file_op_.copy_file(v.AllPath,hash)
			end
		end

		local ts = {}
		for k,v in ipairs (merge_data.Files) do
			table.insert(ts,{name = v.Hid,path = ""})
		end
		CurFiles_ = merge_data.Files
		require'sys.net.file'.sends(ts,send_msg_code);
		return 
	end
	
	
	local t = {}
	t.To = data_.User
	t.Name = data_.Title
	t.Text = data_.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_merge(merge_data); --获取选中构件的代码
	t.Arrived_Report = data_.Arrived 
	t.Read_Report= data_.Read 
	t.Confirm_Report= data_.Confirm 
	data_ = nil
	merge_data_ = nil
	require "sys.net.msg".send_msg(t)
	
end

function send_channel(data)
end







