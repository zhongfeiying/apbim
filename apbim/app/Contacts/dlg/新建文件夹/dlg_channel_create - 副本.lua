_ENV = module(...,ap.adv)

local dlg_ = nil
local data_ = nil
local save_data_ = nil
local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_change_ = iup.button{title = "Get",rastersize = "50x"}
end 

local function init_controls()
	local wid = "100x"
	lab_id_ = iup.label{title = "ID : ",rastersize = "50x"}
	txt_id_ = iup.text{rastersize = "200x"}
	
	lab_name_ = iup.label{title = "Name : ",rastersize ="50x"}
	txt_name_ = iup.text{rastersize = "200x",expand = "HORIZONTAL"}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_name_,txt_name_};
			iup.hbox{lab_id_,txt_id_,btn_change_};
			iup.hbox{btn_ok_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "10x10"
		};
		title = "Create Channel";
		resize = "NO";
	}
end 

local function deal_ok_action()
	data_ = {}
	if save_data_ then 
		for k,v in pairs (save_data_) do 
			data_[k] = v
		end 
	end 
	data_.Gid = txt_id_.value
	data_.Name = txt_name_.value
	
end

local function init_callback()
	function btn_ok_:action()
		if not string.find(txt_id_.value,"%S+") then 
			iup.Message("Warning","Id can not be empty !")
			return 
		end
		if not string.find(txt_name_.value,"%S+") then 
			iup.Message("Warning","Name can not be empty !")
			return 
		end 
		deal_ok_action()
		dlg_:hide()
	end 
	function btn_change_:action()
		txt_id_.value = require "luaext".guid()
	end
	function btn_cancel_:action()
		dlg_:hide()
	end
end 

local function init_data()
	txt_id_.value = ""
	txt_name_.value = ""
	txt_id_.readonly = "NO"
	btn_change_.active = "YES"
	save_data_ = nil
	if data_  then
		txt_id_.value = data_.Gid
		txt_name_.value = data_.Name
		btn_change_.active = "NO"
		--txt_id_.active = "NO"
		txt_id_.readonly = "yes"
	end 
	save_data_ = data_
	data_ = nil
end 



local function init()
	
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	init_data()
	dlg_:popup()
end 

local function show()
	init_data()
	dlg_:popup()
end 

function pop()
	if dlg_ then show() else init() end 
end

function set_data(data)
	data_ = data
end

function get_data()
	return  data_
end



