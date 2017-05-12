
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"

function load()
	local Contacts_Page_ = require_files_.contacts_page()
	local dock_ = require_files_.dock()
	dock_.add_page(Contacts_Page_.pop());
	Contacts_Page_.init_datas()
	local op_msg_ = require_files_.op_msg()
	op_msg_.recv_msg_callback()
end




