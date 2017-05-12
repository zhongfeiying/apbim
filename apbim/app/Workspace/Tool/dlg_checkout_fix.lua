module(...,package.seeall)

require "iuplua"

local dlg_ = nil
local return_val_ = nil
local function init_buttons()
	local wid = "50x"
	btn_yes_ = iup.button{title = "Yes",rastersize = wid}
	btn_no_ = iup.button{title = "No",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	lab_msg_ = iup.label{title = "Expect check to a existed project ,Do you want to fix the cur version ?" ,rastersize = "400x"} 
	tog_all_ = iup.toggle{title = "Fixed All"}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_msg_};
			iup.hbox{
				iup.vbox{iup.fill{},tog_all_,iup.fill{},};
				iup.fill{},
				btn_yes_,
				btn_no_,
				btn_cancel_
			};
			margin = "5x5";
			alignment = "ARIGHT";
		};
		title = "Notice";
	}
end

local function init_msg()
	function btn_cancel_:action()
		dlg_:hide()
	end
	function btn_no_:action()
		return_val_ = 3
		dlg_:hide()
	end
	function btn_yes_:action()
		return_val_ = 1
		if tog_all_.value == "ON" then 
			return_val_ = 2
		end 
		dlg_:hide()
	end
end

local function init_data()
	return_val_ = nil
	tog_all_.value = "OFF"
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


function return_data()
	return return_val_
end

function pop()
	if dlg_ then show() else init() end
end