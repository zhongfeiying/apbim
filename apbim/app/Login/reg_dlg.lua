_ENV = module(...,ap.adv)
local user_tab_ = nil
local file_op_ = require "app.Login.file_op"

local function init_buttons()
	local wid = "100x"
	btn_ok= iup.button{title="OK",rastersize=wid};
	btn_cancel = iup.button{title="Cancel",rastersize=wid};
end

local function init_controls()
	local wid = "130x"
	local txt_wid = "300x"
	lab_global_id_ = iup.label{title = "Global ID:",rastersize = wid}
	txt_global_id_ = iup.text{rastersize = txt_wid}
	user_lab_ = iup.label{title = "Name:",rastersize = wid}
	txt_user_ = iup.text{rastersize = txt_wid}
	lab_password_ = iup.label{title = "Password:",rastersize = wid}
	txt_password_ = iup.text{rastersize = txt_wid,PASSWORD = "yes"}
	lab_confirm_password_ = iup.label{title = "Confirm Password:",rastersize = wid}
	txt_confirm_password_ = iup.text{rastersize = txt_wid,PASSWORD = "yes"}
	lab_mail_ = iup.label{title = "E-Mail:",rastersize = wid}
	txt_mail_ = iup.text{rastersize = txt_wid}
	lab_phone_ = iup.label{title = "Phone:",rastersize = wid}
	txt_phonel_ = iup.text{rastersize = txt_wid}
	lab_note_ = iup.label{title = "Note:",rastersize = wid}
	txt_note_ = iup.text{rastersize = txt_wid}
end

local function init_dlg()

	dlg_= iup.dialog{
		DEFAULTENTER = btn_ok;
		DEFAULTESC = btn_cancel;
		iup.frame{
			iup.vbox{
				iup.hbox{lab_global_id_,txt_global_id_,},
				iup.hbox{user_lab_,txt_user_,},
				iup.hbox{lab_password_,txt_password_,},
				iup.hbox{lab_confirm_password_,txt_confirm_password_,},
				iup.hbox{lab_mail_,txt_mail_,},
				iup.hbox{lab_phone_,txt_phonel_,},
				--iup.hbox{lab_note_,txt_note_,},
			    iup.hbox{iup.fill{},btn_ok,iup.fill{},btn_cancel,iup.fill{}},
				alignment = "ALEFT",
			},
		},
		title = "Register",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end	

local function deal_add_action()
	user_tab_ = {}
	user_tab_.gid = txt_global_id_.value
	user_tab_.user = txt_user_.value
	user_tab_.passwd = txt_password_.value
	--user_tab_.note = txt_note_.value
	user_tab_.mail = txt_mail_.value
	user_tab_.phone = txt_phonel_.value
	init_send_connect()
	user_reg(user_tab_)
end 

local function deal_warning_action()
	if not string.find(txt_user_.value,"%S+") then iup.Message("Warning","Please enter name !") return end 
	if not string.find(txt_password_.value,"%S+") then iup.Message("Warning","Please enter password !") return end 
	if not string.find(txt_confirm_password_.value,"%S+") then iup.Message("Warning","Please enter password again !") return end 
	if not string.find(txt_mail_.value,"%S+") then iup.Message("Warning","Please enter E-mail !") return end 
	if not string.find(txt_phonel_.value,"%S+") then iup.Message("Warning","Please enter phone number !") return end 
	if txt_password_.value ~= txt_confirm_password_.value then 
		iup.Message("Warning","Confirm password is not same as password!")
		return
	end
	
	return true 
end 

local function msg()
	
	function btn_ok:action()
		if not deal_warning_action() then return end 
		deal_add_action()
	end
	
	function btn_cancel:action()
		dlg_:hide()
	end
	
	function txt_password_:action()
	end
end


local function init_active()
	txt_global_id_.active = "NO"
	txt_global_id_.value=require"luaext".guid() .. "0"
end 

local function init_Val()
	user_tab_ = nil;
	txt_user_.value = ""
	txt_mail_.value = ""
	txt_phonel_.value = ""
	txt_password_.value = ""
	txt_confirm_password_.value = ""
end 

local function init_data()
	init_active()
	init_Val()
end

local function show()
	init_data()
	dlg_:popup() 
end


local function init() 
	init_buttons();
	init_controls();
	init_dlg();
	msg();
	init_data()
	dlg_:popup();
end

function set_status(cur_msg)
	if cur_msg == "ok" then 
	--	require "app.Document.DB_Doc".save_path_db(user_tab_.gid,user_tab_)
		local t = {user = user_tab_.user,gid = user_tab_.gid}
		file_op_.save_path_db("admin.lua",t)
		dlg_:hide()
	else 
		iup.Message("Warning","Register Failure !Please repeat or Check network link !")
		user_tab_ = nil;
	end 
end



function pop()	
	if dlg_ then 
		show() 
	else
		init()
	end
end


