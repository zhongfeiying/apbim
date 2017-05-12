_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local send_code_ = require_files_.send_code()
local luaext_ = require_files_.luaext()

function group_invite_member(name,data)
	local tempt = {}
	tempt.Gid = data.Gid
	tempt.Name = data.GroupName
	tempt.To = name
	tempt.id = luaext_.guid()
	tempt.Note = data.Note
	send_code_.send_subscribe_invitation(tempt)
end



function recv_msg_callback()
	--require "sys.net.msg".resgister_rcvf(del_msg)
end





