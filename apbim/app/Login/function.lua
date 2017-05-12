_ENV = module(...,ap.adv)
local change_password_dlg_ = require "app.Login.change_password_dlg"
local login_dlg_ = require "app.Login.login_dlg"
local set_server_dlg_ = require "app.Login.set_server_dlg"

local function Change_Password()
	change_password_dlg_.pop()
end 

function set_passwd_status(msg)
	change_password_dlg_.set_status(msg)
end


function Modify_Login_Information()
	login_dlg_.pop()
end 


function Modify_Server_Information()
	set_server_dlg_.pop()
end 

function load()
	require"sys.menu".add{frame=true,view=true,app="Login",pos={"Tools",},name={"Tools","Modify","Login Information"},f=Modify_Login_Information};
	require"sys.menu".add{frame=true,view=true,app="Login",pos={"Tools",},name={"Tools","Modify","Server Information"},f=Modify_Server_Information};
	require"sys.menu".add{frame=true,view=true,app="Login",pos={"Tools",},name={"Tools","Modify","New Password"},f=Change_Password};
end