

local lfs_ = require "lfs"

------------------------------------------------------------------------------------------------------------

-- local function invite_member(id,user)
	-- local msg = require"sys.net.msg".get_msg(id);
	-- if type(msg)~="table" then return end
	-- local cur_user = require"sys.mgr".get_user()
	-- if cur_user == user then return end 
	-- local str =  "app.Contacts.dlg.dlg_group_invite"
	-- local file = io.open(string.gsub(str,"%.","\\"),"r")
	-- if  file then 
		-- local dlg_group_invite_ = require "app.Contacts.dlg.dlg_group_invite"
		-- if dlg_group_invite_ then 
			-- dlg_group_invite_.pop(msg)
		-- end
	-- end 
	
	
-- end
-- require'sys.net.msg'.add_envf("ap_invite_member",invite_member);


local function pop(id,user)
	local msg = require"sys.net.msg".get_msg(id);
	
	if type(msg)~="table" then return end
	if msg.Delete then return end
	msg.id = id
	local require_files_ = require "app.Contacts.require_files" 
	local cur_user = require_files_.get_user() 
	if cur_user == user then return end 
	local str = msg.exe_file
	local file = io.open(string.gsub(str,"%.","\\") .. '.lua',"r")
	if  file then 
		local dlg = require (str)
		if dlg then 
			local func = {}
			func.accept_invite = require 'app.Contacts.op_rmenu'.accept_invite
			func.refuse_invite = require 'app.Contacts.op_rmenu'.refuse_invite
			dlg.pop(msg,func)
		end
	end 
end
require'sys.net.msg'.add_envf("ap_pop",pop);


