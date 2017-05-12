_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local luaext_ = require_files_.luaext()
local create_code_ = require_files_.create_code()



function send_msg(data)
	if not data then return end 
	local t = {}
	t.To = data.User
	t.Name = data.Title
	t.Text = data.Content
	t.Code = create_code_.get_msg_code()
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
	t.Code = create_code_.get_msg_code()
	t.Arrived_Report = data.Arrived 
	t.Read_Report= data.Read 
	t.Confirm_Report= data.Confirm 
	require "sys.net.msg".send_channel(t)
end
