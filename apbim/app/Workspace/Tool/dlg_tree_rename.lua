module(...,package.seeall)

local dlg_ = nil
local old_name_ = nil;
local new_name_ = nil;
local folder_data_ = nil

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
end 

local function init_controls()
	local wid = "100x"
	lab_new_name_ = iup.label{title = "New Name : ",rastersize = wid}
	txt_new_name_ = iup.text{rastersize = "300x"}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_new_name_,txt_new_name_};
			iup.hbox{btn_ok_};
			alignment = "ARIGHT";
			margin = "10x10"
		};
		title = "Rename";
		resize = "NO";
	}
end 

local function init_callback()
	function btn_ok_:action()
		if not string.find(txt_new_name_.value,"%S+") then return end 
		if folder_data_ and folder_data_[txt_new_name_.value] then 
			iup.Message("Warning","There is a same name in zhe folder,Please rename !")
			return 
		end
		new_name_ = txt_new_name_.value
		dlg_:hide()
	end 
end 

local function init_data()
	new_name_ = nil;
	if old_name_ then 
		txt_new_name_.value = old_name_
	end 
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

function set_data(t)
	folder_data_ = t
end

function set_val(str)
	old_name_ = str
end 

function get_val()
	folder_data_= nil
	return new_name_
end 