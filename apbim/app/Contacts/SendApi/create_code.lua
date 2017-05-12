_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local set_msg_ = require_files_.set_msg()

-------------------------------------------------------------
--[[
-- {id = ,To = ,Gid = ,Name = ,}
function group_invite_member(arg)
	local user = require"sys.mgr".get_user()
	local str = ''
	str = str ..set_msg_.set_dlg_title("Invite Confirmation")
	str = str ..set_msg_.set_dlg_msg('From ' .. user .. '\'s invitation ! Whether to join the group ( ' .. arg.Name .. ') £¿')
	str = str ..set_msg_.set_group_name(arg.Name)
	str = str ..set_msg_.set_group_id(arg.Gid)
	str = str ..set_msg_.set_group_exe()
	str = str..' local function exe_f() \n';
	--str = str ..set_msg_.set_group_exe()
	str = str .. 'local filepath = ap_this_msg().exe_file  '
	str = str .. 'local function pop(filepath) \n '
		str = str .. 'local file = io.open(string.gsub(filepath,"%.","\\"),"r") \n '
		str = str .. 'if  file then  \n '
			str = str .. 'local dlg_group_invite_ = require (filepath)  \n '
			str = str .. 'if dlg_group_invite_ then   \n '
			str = str .. 'dlg_group_invite_.pop(msg) \n '
		str = str .. 'end \n '
	str = str .. 'end  \n ' 
	str = str .. " \n "
	str = str .. "end \n "
	str = str .. "pop(filepath) \n "
	str = str .. "end \n "
	--str = str..' ap_invite_member([==[' .. arg.id .. ']==],[==[' .. user .. ']==]) \n'
	str = str ..' ap_set_exe_cbf(exe_f) ';
	return str
end
--]]
-- {id = ,To = ,Gid = ,Name = ,}
function group_invite_member(arg)
	local user = require_files_.get_user() 
	local str = ''
	str = str ..set_msg_.set_dlg_title("Invite Confirmation")
	str = str ..set_msg_.set_dlg_msg('From ' .. user .. '\'s invitation ! Whether to join the group \"' .. arg.Name .. '\" £¿')
	str = str ..set_msg_.set_cmd_type('Group Invite')
	str = str ..set_msg_.set_group_name(arg.Name)
	str = str ..set_msg_.set_group_id(arg.Gid)
	str = str ..set_msg_.set_group_note(arg.Note)
	
	str = str ..set_msg_.set_group_exe()
	str = str..' local function exe_f() \n';
	str = str..' ap_pop([==[' .. arg.id .. ']==],[==[' .. user .. ']==]) \n'
	str = str..' end \n';
	str = str ..' exe_f() ';
	return str
end

function ap_dissolution_group(data) 
	local user = require_files_.get_user() 
	local str = ''
	str = str ..' ap_set_new_msg([==[' .. data.Gid .. ']==],[==['..user..']==]) \n';
	--str = str .. 'ap_set_msg_type([==['..data.Gid..']==],[==['..user..']==],[==[System]==]) \n'
	str = str..'local function exe_f() \n';
	str = str ..' ap_quit_group([==[' .. data.Gid .. ']==],[==['..user..']==]) \n';
	str = str ..' end ';
	str = str ..' ap_set_exe_cbf(exe_f) ';
	return str
end 


function ap_update_group(data) 
	local user = require_files_.get_user() 
	local str = ''
	str = str .. ' ap_set_new_msg([==[' .. data.id .. ']==],[==['..user..']==]) \n';
	--str = str .. ' ap_set_new_msg([==[' .. data.id .. ']==],[==['..user..']==]) \n';
	--str = str .. set_msg_.set_msg_type("System")
	str = str .. 'local function exe_f() \n';
	str = str .. set_msg_.set_group_id(data.Gid)
	str = str .. 'ap_set_update_group([==['..data.Gid..']==],[==['..user..']==])  \n'
	str = str ..' end \n';
	str = str ..'  ap_set_exe_cbf(exe_f) \n';
	--str = str ..' exe_f() \n';
	return str
end 

------------------------------------------------------------------------
function get_msg_code()
	local str = ''
	return str
end

function get_view_code(data)
	local str = ''
	str = str..'local function exe_f() \n';
	str = str.. set_msg_.set_project_id(data.ProjectId)
	str = str.. set_msg_.set_project_fileName(data.ProjectName)
	str = str.. set_msg_.set_view_id(data.ViewId)
	str = str..'ap_update_model_file([==['..data.id..']==],[==['..data.user..']==])';
	str = str..'end \n';
	str = str..'ap_set_exe_cbf(exe_f)\n';
	return str
end

function get_selected_code()
	local str = ''
	local sels = require'sys.mgr'.curs();
	for k,v in pairs(sels) do
		str = str .. set_msg_.set_cur_project()
		str = str..'ap_select_item("'..k..'",true); ';
		str = str..'ap_redraw_item("'..k..'"); ';
	end
		str = str..'ap_update_scene(); ';
	str = str..'end ';
	str = str..'ap_set_exe_cbf(exe_f)';
	return str
end

function get_file_code()
	local str = ''
	return str
end

function get_project_code()
	local str = ''
	return str
end





