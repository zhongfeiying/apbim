_ENV = module(...,ap.adv)
--[[
function send_select_objs()
	local gids = get_cur_objs();
	local txt = get_note();
	local code = get_code_sel_objs(gids,txt);	
	code = get_code_project(code,txt);	
	--判断是否需要保存该信息
	if(is_save_msg())then
		code = get_code_save_msg(code);
		--此时构件是否需要上传
		upload_objs(gids);
	end
	--判断是否需要提醒该信息
	if(is_remind_msg())then
		code = get_code_remind_msg(code);
	end
	send_msg(code,send_to);
	
	
	
end
---------------------------------------------------

local function get_selection_code()
	local str = '';
	str = str..'local function exe_f() ';
	local sels = require'sys.mgr'.curs();
	for k,v in pairs(sels) do
		str = str..'ap_select_item("'..k..'",true); ';
		str = str..'ap_redraw_item("'..k..'"); ';
	end
	str = str..'ap_update_scene(); ';
	str = str..'end ';
	--str = str..'f1()';
	str = str..'ap_set_exe_cbf(exe_f)';
	trace_out("str = " .. str .. "\n")
	return str;
end

--]]

function send_msg(data)
	
	if not data then return end 
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	--t.Code = get_selection_code()
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_sel_objs(); --获取选中构件的代码
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	require "sys.net.msg".send_msg(t)
end

function send_channel(data)
	if not data then return end 
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	--t.Code = get_selection_code()
	t.Code = require "app.Contacts.SendApi.create_code".ap_get_code_sel_objs(); --获取选中构件的代码
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	require "sys.net.msg".send_channel(t)
end








