_ENV = module(...,ap.adv)
--[[
--package.cpath = "?53.dll;" .. package.cpath
local M = {}
_G[...] = M
package.loaded[...] = M
setmetatable(M,{__index = _G})
--]]
require "iuplua"
local datas_ = nil
local dlg_ = nil
local function init_buttons()
	local wid = "100x"
	local smallwid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	local wid = "60x"
	lab_title_ = iup.label{title = "Title : ",rastersize = wid}
	txt_title_ = iup.text{expand = "HORIZONTAL"}

	lab_content_ = iup.label{title = "Content : ",rastersize = wid}
	txt_content_ = iup.text{
		rastersize = "400x200",
		expand = "HORIZONTAL",
		multiline = "YES";
		wordwrap = "YES"
	}

	
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_title_,txt_title_};
			iup.hbox{lab_content_,iup.fill{}};
			iup.hbox{txt_content_};
			iup.hbox{btn_ok_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "5x5";
		};
		title = "Assigning";
		resize = "NO";
		--BRINGFRONT = "YES";
		--TOPMOST = "YES";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
end

local function deal_ok_msg()
	datas_.title = txt_title_.value
	datas_.content = txt_content_.value
end

local function init_msg()
	function btn_ok_:action()
		if not string.find(txt_title_.value,"%S+") then return end 
		if not string.find(txt_content_.value,"%S+") then return end 
		deal_ok_msg()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end
end

local function init_data()
	txt_title_.value = ""
	txt_content_.value = ""
	return_datas_ = nil
	if datas_ then 
		txt_title_.value = datas_.title
		txt_content_.value = datas_.content
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

function set_data(data)
	datas_ = data
end


--pop()
