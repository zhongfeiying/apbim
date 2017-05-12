_ENV = module(...,ap.adv)
require "iuplua"
local server_tab_ = nil
local file_save_path_ = "data\\"
local file_save_name_ = "server.lua"
local sys_tab_ = require "sys.table"

local file_op_ = require "app.Login.file_op"

local function init_buttons()
	local wid = "100x"
	btn_add_ = iup.button{title="OK",rastersize=wid};
	btn_close_ = iup.button{title="Cancel",rastersize=wid};
end

local function init_controls()
	local txt_wid = "300x"
	local wid = "100x"
	lab_server_ = iup.label{title = "Server:",rastersize = wid}
	txt_server_ = iup.text{value="www.apcad.com",rastersize = txt_wid}
	lab_port_ = iup.label{title = "Port: ",rastersize = wid}
	txt_port_ = iup.text{value="8000",rastersize = txt_wid,}
	tog_autologing_  = iup.toggle{title = "Auto-Setting",fontsize = 12}
end

function get_db()
	return file_op_.get_sava_path_file(file_save_name_)
end 

local function init_dlg()

	dlg_= iup.dialog{
		DEFAULTENTER = btn_add_;
		--DEFAULTESC = btn_close_;
		iup.frame{
			iup.vbox{
				--iup.hbox{lab_global_id_,txt_global_id_,gap = 10,},
				iup.hbox{lab_server_,txt_server_,},
				iup.hbox{lab_port_,txt_port_,},
				iup.hbox{iup.fill{},tog_autologing_,btn_add_,},
				alignment = "ARIGHT",
			},
		},
		title = "Set Server",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end


local function init_data(tab)
	txt_server_.value = "www.apcad.com"
	txt_port_.value = "8000"
	if tab then 
		server_tab_= tab
		txt_server_.value = tab.server
		txt_port_.value=tab.port
		if tab.auto then 
			tog_autologing_.value = "ON"
		end 
	end
end

local function deal_add_action()
	local t = {}
	t.server = txt_server_.value
	t.port = txt_port_.value
	if tog_autologing_.value == "ON" then 
		t.auto = true
	end 
	file_op_.save_path_db(file_save_name_,t)
end 

function check_server(t)
	local ct = init_send_connect(t)
	if ct == 0 then 
		iup.Message("Warning","Ip address or port error ! Please check and re-enter !")
		return
	else 
		on_hubquit(ct)
	end 
	return true 
end

local function msg()
	
	function btn_add_:action()
		if not string.find(txt_server_.value,"%S+") then iup.Message("Warning","Please enter server !") return end 
		if not string.find(txt_port_.value,"%S+") then iup.Message("Warning","Please enter port !") return end 
		
		local t = {}
		t.server = txt_server_.value
		t.port = txt_port_.value
		if not check_server(t) then return end 
		
		deal_add_action()
		dlg_:hide()
	end
	
	function btn_close_:action()
		server_tab_ = nil
		dlg_:hide()
		frmclose()
	end
	
	function dlg_:close_cb()
		server_tab_ = nil
	end
end



local function show()
	--get_db();
	init_data(get_db());
	dlg_:popup() 
end


local function init() 
	init_buttons();
	init_controls();
	init_dlg();
	get_db();
	--if tab1 then init_user(tab1) end
	msg();
	init_data(get_db())
	dlg_:popup();
end

function return_db()
	--require "sys.table".totrace(user_tab_)
	return server_tab_
end

function pop()	
	if dlg_ then 
		show() 
	else
		init()
	end
end


