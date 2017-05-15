
_ENV = module(...,ap.adv)

local dlg_ = nil
local data_ = nil

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end 

local function init_controls()
	local wid = "100x"
	lab_name_ = iup.label{title = "Name : ",}
	txt_name_ = iup.text{rastersize = "400x",expand ="HORIZONTAL"}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_name_,txt_name_};
			iup.hbox{btn_ok_,btn_close_};
			alignment = "ARIGHT";
			margin = "10x10"
		};
		title = "Add";
		resize = "NO";
	}
end 

local function  deal_ok()
	data_ = {}
	data_.Name = txt_name_.value
end

local function init_callback()
	function btn_ok_:action()
		if not string.find(txt_name_.value,"%S+") then return end 
		deal_ok()
		dlg_:hide()
	end
	function btn_close_:action()
		dlg_:hide()
	end
end 

local function init_data()
	txt_name_.value = ""
	if data_  then 
		txt_name_.value = data_.Name or ""
	end
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
	return data_
end 
