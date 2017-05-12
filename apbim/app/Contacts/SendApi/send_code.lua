
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local op_server_ = require_files_.op_server()
local luaext_ = require_files_.luaext()
--arg = {id = ,To = ,Gid = ,Name = ,}
function send_subscribe_invitation(arg)
	local t = {}
	t.id = arg.id or require "luaext".guid()
	t.To = arg.To
	t.Name = "Group Invitation"
	t.Text =  require_files_.get_user()  .. " invite you to join the group(" .. arg.Name .. ") ."
	t.Code = require "app.Contacts.SendApi.create_code".group_invite_member(arg) 
	--t.Arrived_Report = true
	op_server_.send_msg(t)
end


function send_dissolution_group(data)
	if type(data) ~= "table" then return end 
	data.id =  require "luaext".guid()
	local t = {}
	t.To = data.Gid
	t.Name = "Dissolved Group"
	t.Text =  " A group has been Dissoluted !"
	t.id = data.id
	--t.Code = require "app.Contacts.SendApi.create_code".ap_dissolution_group(data) 
	require "sys.net.msg".send_channel(t)
end

function send_quit_group(data)
	if type(data) ~= "table" then return end 
	local user = require_files_.get_user() 
	data.id =  luaext_.guid()
	local t = {}
	t.To = data.Gid
	t.id = data.id
	t.Name = "Quit Group"
	t.Text = "Notice : " .. user .. " quit the group !"
	--t.Code = require "app.Contacts.SendApi.create_code".ap_update_group(data)
	require "sys.net.msg".send_channel(t)
end

function send_into_group(data)
	if type(data) ~= "table" then return end 
	data.id =  require "luaext".guid()
	local t = {}
	t.id = data.id
	t.To = data.Gid
	t.Name = "New Member"
	t.Text = "New Member :  " ..  require_files_.get_user()  .. " go into the group !"
	--t.Code = require "app.Contacts.SendApi.create_code".ap_update_group(data)
	require "sys.net.msg".send_channel(t)
end
