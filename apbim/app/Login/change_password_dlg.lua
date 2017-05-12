_ENV = module(...,ap.adv)


local file_op_ = require "app.Login.file_op"

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title="Change",rastersize=wid};
	btn_close_ = iup.button{title="Cancel",rastersize=wid};
end

local function init_controls()
	local txt_wid = "300x"
	local wid = "100x"
	lab_pass_word_ = iup.label{title = "Old :",rastersize = wid}
	txt_pass_word_ = iup.text{rastersize = txt_wid}
	lab_new_pass_word_ = iup.label{title = "New :",rastersize = wid}
	txt_new_pass_word_ = iup.text{rastersize = txt_wid,PASSWORD = "yes"}
	lab_confirm_password_ = iup.label{title = "Confirm :",rastersize = wid}
	txt_confirm_password_ = iup.text{rastersize = txt_wid,PASSWORD = "yes"}
end



local function init_dlg()

	dlg_= iup.dialog{
		DEFAULTENTER = btn_ok_;
		DEFAULTESC = btn_close_;
		iup.frame{
			iup.vbox{
				--iup.hbox{lab_global_id_,txt_global_id_,gap = 10,},
				iup.hbox{lab_pass_word_,txt_pass_word_,},
				iup.hbox{lab_new_pass_word_,txt_new_pass_word_,},
				iup.hbox{lab_confirm_password_,txt_confirm_password_,},
				iup.hbox{iup.fill{},btn_ok_,iup.fill{},btn_close_,iup.fill{}},
				alignment = "ARIGHT",
			},
		},
		title = "Change Password",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end


local function init_data()
	txt_pass_word_.value = ""
	txt_new_pass_word_.value = ""
	txt_confirm_password_.value = ""
	
end
local function deal_add_action()
	local t = {}
	local db = file_op_.get_sava_path_file("admin.lua")
	if db then 
		t.user = db.user
	end
	t.passwd = txt_pass_word_.value
	t.newpass = txt_new_pass_word_.value
	init_send_connect()
	user_change_passwd(t)
end 



local function msg()
	
	function btn_ok_:action()
		if not string.find(txt_pass_word_.value,"%S+") then iup.Message("Warning","Please enter password !") return end 
		if not string.find(txt_new_pass_word_.value,"%S+") then iup.Message("Warning","Please enter new password !") return end 
		if not string.find(txt_confirm_password_.value,"%S+") then iup.Message("Warning","Please enter new confirm password !") return end 
		if txt_new_pass_word_.value ~= txt_confirm_password_.value then 
			iup.Message("Warning","Confirm password is not same as password!")
			return
		end
		deal_add_action()
	end
	
	function btn_close_:action()
		dlg_:hide()
	end
	
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

function pop()	
	if dlg_ then 
		show() 
	else
		init()
	end
end

function set_status(msg)
	if msg == "ok" then 
		dlg_:hide()
	else 
		iup.Message("Warning","Change Failure !Please check whether your username and password are incorrect or not!")
	end 
end

