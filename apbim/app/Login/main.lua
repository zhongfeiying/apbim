_ENV = module(...,ap.adv)

local login_dlg_ = require "app.Login.login_dlg"
local set_server_dlg_ = require "app.Login.set_server_dlg"
function on_load()
	require"app.Login.function".load();
end

function pop_login()
	local db = set_server_dlg_.get_db()
	local t = nil
	if not db.auto then 
		set_server_dlg_.pop()
		t = set_server_dlg_.get_db()
	else 
		t = db
		if not set_server_dlg_.check_server(t) then 
			set_server_dlg_.pop()
			t = set_server_dlg_.get_db()
		else 
			trace_out("Server OK !")
		end 
	end 
	
	local db = login_dlg_.get_db()
	if not db.passwd then 
		login_dlg_.pop()
	else 
		local temp = {}
		temp.user = db.user
		temp.passwd = login_dlg_.passwd_Decrypt(db.passwd)
		login_dlg_.set_user(temp)
		login_dlg_.check_login(temp)
	end 
	-- login_tab_ = login_dlg_.return_db()
	-- if not login_tab_ then 
		-- frmclose()
	-- end
end 

function set_status(msg)
	return login_dlg_.set_status(msg)
end 

function set_reg_status(msg)
	return login_dlg_.set_reg_status(msg)
end 

function on_init()
end

function on_esc()
end

