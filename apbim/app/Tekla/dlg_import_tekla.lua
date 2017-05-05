
local require = require

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
 -- _ENV = module_seeall(...,package.seeall)

--module(...,package.seeall)
require "iuplua"
require "iupluacontrols"

local dlg_ = nil
local select_tekla_ver_ = nil

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end 

local function init_controls()
	tog_17_ = iup.toggle{title = "Tekla 17.0",fontsize = 12}
	tog_18_ = iup.toggle{title = "Tekla 18.0",fontsize = 12}
	tog_19_ = iup.toggle{title = "Tekla 19.0",fontsize = 12}
	radio_ver_ = iup.radio{
			iup.vbox{
				iup.fill{};
				iup.hbox{iup.fill{};tog_17_;iup.fill{}};
				iup.fill{};
				iup.hbox{iup.fill{};tog_18_;iup.fill{}};
				iup.fill{};
				iup.hbox{iup.fill{};tog_19_;iup.fill{}};
				iup.fill{};
			};
		};
	frame_sel_ver_ = iup.frame{
		radio_ver_;
		rastersize = "300x200";
		title = "Select Version";
	}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_sel_ver_};
			iup.hbox{iup.fill{},btn_ok_,iup.fill{},btn_cancel_,iup.fill{}};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Import Tekla";
		resize = "NO";
	}
end 

local function init_msg()
	function btn_ok_:action() 
		select_tekla_ver_ = radio_ver_.VALUE.title
		dlg_:hide()
	end
	
	function btn_cancel_:action()
		dlg_:hide()
	end
end 

local function init_data()
	select_tekla_ver_ = nil
	radio_ver_.VALUE  = tog_17_
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

function return_select_tekla_version()
	return select_tekla_ver_
end
