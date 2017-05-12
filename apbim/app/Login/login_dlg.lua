_ENV = module(...,ap.adv)
local user_tab_ = nil
local file_save_path_ = "data\\"
local file_save_name_ = "admin.lua"
local DB_Doc_ = require "app.Login.file_op"


local function init_buttons()
	local wid = "100x"
	btn_add_ = iup.button{title="Login",rastersize=wid};
	btn_close_ = iup.button{title="Cancel",rastersize=wid};
	btn_reg_ = iup.button{title="Register",rastersize=wid};
end

local function init_controls()
	--lab_global_id_ = iup.label{title = "Global ID:",rastersize = "100x"}
	--txt_global_id_ = iup.text{rastersize = "245x"}
	local txt_wid = "300x"
	local wid = "100x"
	lab_user_ = iup.label{title = "Name:",rastersize = wid}
	txt_user_ = iup.text{rastersize = txt_wid}
	lab_pass_word_ = iup.label{title = "Password : ",rastersize = wid}
	txt_pass_word_ = iup.text{rastersize = txt_wid,PASSWORD = "yes"}
	
	tog_autologing_  = iup.toggle{title = "Auto-Login",fontsize = 12}
end



local function init_dlg()

	dlg_= iup.dialog{
		DEFAULTENTER = btn_add_;
		--DEFAULTESC = btn_close_;
		iup.frame{
			iup.vbox{
				--iup.hbox{lab_global_id_,txt_global_id_,gap = 10,},
				iup.hbox{lab_user_,txt_user_,},
				iup.hbox{lab_pass_word_,txt_pass_word_,},
				--iup.hbox{btn_reg_,iup.fill{},tog_Automatic_landing_,btn_add_,btn_close_},
				iup.hbox{btn_reg_,iup.fill{},iup.vbox{iup.fill{},iup.hbox{tog_autologing_},iup.fill{},margin = "0x0"},btn_add_},
				alignment = "ARIGHT",
			},
		},
		title = "Login",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end

function get_db()
	return DB_Doc_.get_sava_path_file(file_save_name_)
end 	

local function init_data(tab)
	user_tab_ = nil;
	txt_user_.value = ""
	txt_pass_word_.value = ""
	txt_user_.CANFOCUS = "YES"
	if tab then 
		txt_user_.value = tab.user
		txt_user_.CANFOCUS = "NO"
		--txt_pass_word_.
		if tab.passwd then 
			tog_autologing_.value = "ON"
		end 
	end
end


function check_login(t)
	init_send_connect()
	user_login(t)
end


local function passwd_Encryption(val) --加密
	local str = ""
	for i = 1,#val do 
		if i == #val then 
			str = str .. string.byte(string.sub(val,i,i)) 
		else
			str = str .. string.byte(string.sub(val,i,i)) .. ","
		end 
		
	end 
	return str
end

function passwd_Decrypt(val) -- 解密
	local str = ""
	for num in string.gmatch(val,"[^%,]+") do 
		str = str .. string.char(num)
	end
	return str
end

local function deal_add_action()
	local t = {}
	t.user = txt_user_.value
	t.passwd = txt_pass_word_.value
	user_tab_ = {}
	user_tab_.user = txt_user_.value
	check_login(t)
end 




local function msg()
	
	function btn_add_:action()
		if not string.find(txt_user_.value,"%S+") then iup.Message("Warning","Please enter name !") return end 
		if not string.find(txt_pass_word_.value,"%S+") then iup.Message("Warning","Please enter password !") return end
		deal_add_action()
		--dlg_:hide()
	end
	
	function btn_close_:action()
		dlg_:hide()
	end
	
	function dlg_:close_cb()
		frmclose()
	end
	
	function btn_reg_:action()
		require "app.login.reg_dlg".pop()
		init_data(get_db())
	end
end



local function show()
	init_data(get_db())
	dlg_:popup();
end


local function init() 
	init_buttons();
	init_controls();
	init_dlg();
	msg();
	init_data(get_db())
	dlg_:popup();
end

function return_db()
	return user_tab_
end

function set_data(t)
	--t.user = txt_user_.value
	--t.passwd = txt_pass_word_.value
end

function pop()	
	if dlg_ then 
		show() 
	else
		init()
	end
end

function set_status(cur_msg)
	if cur_msg ~= "-1" then 
		if user_tab_.passwd then 
			trace_out("Login OK !")
			return 
		end 
		if tog_autologing_.value == "ON" then 
			user_tab_.passwd = passwd_Encryption(txt_pass_word_.value)
		end 
		user_tab_.gid = cur_msg
		DB_Doc_.save_path_db(file_save_name_,user_tab_)
		dlg_:hide()
	else 
		iup.Message("Warning","Login Failure !Please check whether your username and password are incorrect or not!")
		if user_tab_.passwd then 
			user_tab_ = nil
			pop()	
			return 
		end
		
		user_tab_ = nil
	end 
end

function set_user(t)
	user_tab_ = t
end

function set_reg_status(msg)
	require "app.login.reg_dlg".set_status(msg)
end

