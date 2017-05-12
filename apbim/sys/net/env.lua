_ENV = module(...,ap.adv)

local get_msg = require'sys.net.msg'.get_msg;
local add_envf = require'sys.net.msg'.add_envf;

local function append_file(file,text)
	local f = io.open(file,"a")
	if not f then return end
	f:write(text);
	f:close()
end

local function open_group_by_str(str) 
	str=str or 'nil';
	str='return '..str;
	local id=require'sys.mgr'.add(require'sys.str'.toifo{str=str}); 
	local item=require'sys.mgr'.get_table(id); 
	if not require'sys.Group'.Class:is_class(item) then return end
	item:open() 
end

local function add_mgr_f(get_id,get_msg) 
	add_envf("ap_trace_out",trace_out);
	add_envf("ap_append_file",append_file);
	add_envf("ap_open_project_name",function(str) require'app.Project.function'.open_name{name=str} end);
	add_envf("ap_open_project_id",require'app.Project.function'.open_id);
	add_envf("ap_add_item",function(str) return require'sys.mgr'.add(require'sys.str'.toifo{str=str})end);
	add_envf("ap_redraw_item",function(id)require'sys.mgr'.redraw(require'sys.mgr'.get_table(id))end);
	add_envf("ap_select_item",function(id,light)require'sys.mgr'.select(require'sys.mgr'.get_table(id),light)end);
	add_envf("ap_update_scene",require'sys.mgr'.update);
	add_envf("ap_get_item",require'sys.mgr'.get_table);
	add_envf("ap_open_msg_view",function() open_group_by_str(get_msg().View) end);
end

local function add_msg_f(get_id,get_msg) 
	add_envf("ap_set_msg_type_channel",function() get_msg(msgid).Channel=true end);
	add_envf("ap_set_msg_name",function(str) get_msg(msgid).Name=str end);
	add_envf("ap_set_msg_text",function(str) get_msg(msgid).Text=str end);
	add_envf("ap_set_msg_from",function(str) get_msg(msgid).From=str end);
	add_envf("ap_set_msg_to",function(str) get_msg(msgid).To=str end);
	add_envf("ap_set_msg_send_time",function(num) get_msg(msgid).Send_Time=num end);
	add_envf("ap_set_msg_arrived",function(bool) get_msg(msgid).Arrived=bool end);
	add_envf("ap_set_msg_arrived_time",function(num) get_msg(msgid).Arrived_Time=num end);
	add_envf("ap_set_msg_read",function(bool) get_msg(msgid).Read=bool end);
	add_envf("ap_set_msg_read_time",function(num) get_msg(msgid).Read_Time=num end);
	add_envf("ap_set_msg_read_cbf",function(cbf) get_msg(msgid).Read_cbf=cbf end);
	add_envf("ap_set_msg_confirm",function(arg) get_msg(msgid).Confirm=arg end);
	add_envf("ap_set_msg_confirm_time",function(num) get_msg(msgid).Confirm_Time=num end);
	add_envf("ap_set_msg_confirm_cbf",function(cbf) get_msg(msgid).Confirm_cbf=cbf end);
	add_envf("ap_set_exe_cbf",function(cbf) get_msg(msgid).exe_cbf=cbf end);
	require "app.contacts.sendapi.env"
end

function add(get_id,get_msg) 
	add_msg_f(get_id,get_msg) 
	add_mgr_f(get_id,get_msg)
end

