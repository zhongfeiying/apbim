module(...,package.seeall)
require "iuplua"
local dlg_ = nil
local cur_path_ = nil
local return_val_ = {}
local function init_buttons()
	local wid = "100x"
	--btn_cover_ = iup.button{title = "Cover",rastersize = wid}
	--btn_ignore_ = iup.button{title = "Ignore",rastersize = wid}
	--btn_rename_ = iup.button{title = "Rename",rastersize = wid}
	btn_forced_ = iup.button{title = "Forced Update",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	
	lab_notice_ = iup.label{title = "The local file has been changed ,what do you want to ?",WORDWRAP = "YES",fgcolor = "255 0 0",rastersize = "500x",ELLIPSIS = "YES",expand = "VERTICAL"}
	tog_all_ = iup.toggle{title = "Apply to all",fontsize = 12}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_notice_};
			iup.hbox{tog_all_,iup.fill{},btn_forced_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Update Warning";
		--resize = "NO";
		MENUBOX = "NO";
	}
end

local function init_msg()
	function btn_forced_:action()
		return_val_.force = true
		if tog_all_.value == "OFF" then 
			return_val_.all = nil
		end 
		dlg_:hide()
	end
	function btn_cancel_:action()
		if tog_all_.value == "OFF" then 
			return_val_.all = nil
		end 
		dlg_:hide()
	end
	
	
end

local function init_data()
	tog_all_.value = "ON"
	return_val_ = {}
	return_val_.all = true
	if cur_path_ then 
		lab_notice_.title = "Notice : " .. cur_path_ .. " file has been changed  !"
	end 
end


local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
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

function get_data()
	return return_val_
end

function set_data(path)
	cur_path_ = path
end