_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local file_op_ = require_files_.file_op()
local temp_path_ = "TempData"
os.execute("if not exist " .. "\"" .. temp_path_ .. "\"" .. "  mkdir  ".. "\"" .. temp_path_ .. "\"")
--[[
function send_view(send_to)
	local txt = ap_get_note();
	local code = require "app.message.create_code".ap_get_code_view();	
	code = code .. require "app.message.create_code".ap_get_code_project();	
	if(require "app.message.base_function".ap_is_save_msg())then
		code = code .. require "app.message.create_code".ap_get_code_save_msg();
	end
	if(require "app.message.base_function".ap_is_remind_msg())then
		code = code .. require "app.message.create_code".ap_get_code_remind_msg();
	end
	
	require'sys.net.main'.send_msg(send_to,code)
end--]]

--------------------------------------sjy -----------------------
--[[

local function get_view_code(sc)
	local str = ''
	local vw = require "sys.mgr".get_view(sc)
	local smd = require "sys.Group".Class:new(vw)
	smd:set_name("Test")
	smd:set_scene(sc)
	smd:add_scene_all()
	if smd.mgrids then 
		for k,v in pairs (smd.mgrids) do 
			smd.mgrids[k] = require "sys.mgr".get_table(k)
		end
	end
	local tstr = require "sys.table".tostr(smd)
	str = str .. "local function exe_f() "
	str = str .. ' local str = '  .. tstr 
	str = str .. ' local data = ap_str_to_tab(str) '
	str = str .. ' data:open() '
	str = str .. ' end '
	str = str .. 'ap_set_exe_cbf(exe_cbf)'
	return str
end
--]]
function send_msg(data)
	if not data then return end 
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_project_view(); --获取view 的 代码
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	require "sys.net.msg".send_msg(t)--]]
	file_op_.save_table_to_file(temp_path_ .. "\\" .. "test.lua",t)
end


function send_channel(data)
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_project_view(); --获取view 的 代码
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	require "sys.net.msg".send_channel(t)
	
end

----------------------------------------------------------------------------
--2016年5月24日19:28:26
--[[
local require_files_ = require "app.Contacts.require_files"
local create_code_ = require_files_.create_code()
local op_project_ = require_files_.op_project()
local luaext_ = require_files_.luaext()

local data_ = nil
local kind_ = nil

local function init()
	data_ = nil
	kind_ = nil
end

local function send()
	if not data_ then return end
	if not kind_ then return end 
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	data_.id = luaext_.guid()
	t.Code = create_code_.get_view_code(data_); --获取view 的 代码
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	t.id = data_.id
	if kind_  == "msg" then 
		require "sys.net.msg".send_msg(t)
	else 
		require "sys.net.msg".send_channel(t)
	end 
	init()
end

local function set_data(data)
	local mgrid = op_project_.send_view()
	if not mgrid then return end 
	local zipfile = require "sys.mgr.model".get_zipfile()
	if not zipfile then  iup.Message("Warning","Please open a project !")  return end
	data_ = data 
	data_.ProjectId = require "sys.mgr".get_model_id()
	data_.ViewId = mgrid
	data_.ProjectName = string.gsub(zipfile,"\\","/")
	
end 

local function set_kind(str)
	kind_ = str
end

function send_msg(data)
	if not data then return end 
	if data_ then return end 
	set_data(data)
	if not data_ then return end 
	set_kind("msg")
	op_project_.update_project(data_.ProjectName,send)
end


function send_channel(data)
	if not data then return end 
	if data_ then return end 
	set_data(data)
	if not data_ then return end 
	set_kind("channel")
	op_project_.update_project(data_.ProjectName,send)
	--require "sys.net.msg".send_channel(t)
end
--]]


