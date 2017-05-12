
--[[
package.cpath = "?.dll;?53.dll;" .. package.cpath

function module_seeall(modname)
	-- local modname = ...
	local M = {}
	setmetatable(M,{__index=_G})
	_G[modname] = M
	package.loaded[modname] = M
	-- _ENV = M
	return M
end
--]]
_ENV = module(...,ap.adv)
require "iuplua"
require "iupluacontrols"


local dlg_ = nil
local data_ = nil
local tog_val_ = {}

local function init_buttons()
	local wid = "100x"
	btn_close_ = iup.button{title = "Close",rastersize = wid}
	btn_forward_ = iup.button{title = "Forward",rastersize = wid}
	btn_execute_ = iup.button{title = "Execute",rastersize = wid}
	btn_deleted_ = iup.button{title = "Deleted",rastersize = wid}
	btn_open_ = iup.button{title = "Open",rastersize = wid}
end

local function init_controls()
	local wid = "60x"
	local txt_wid = "400x"
	lab_from_ = iup.label{title = "From : ",rastersize = wid}
	txt_from_ = iup.text{rastersize = txt_wid,expand ="HORIZONTAL"}
	lab_title_ = iup.label{title = "Title : ",rastersize = wid}
	txt_title_ = iup.text{rastersize = txt_wid,expand ="HORIZONTAL"}
	lab_text_ = iup.label{title = "Text : ",rastersize = wid,fontsize = 12}
	txt_text_ = iup.text{rastersize = txt_wid .. "300",expand ="YES"}

	txt_text_.MULTILINE = "YES"
	txt_text_.WORDWRAP = "YES"



	local tog_wid = "100x"
	tog_cmd_ = iup.toggle{title = "Cmd"}
	tog_view_ = iup.toggle{title = "View",rastersize = tog_wid}
	tog_file_ = iup.toggle{title = "File",rastersize = tog_wid}
	frame_type_ = iup.frame{
		title = "Message Type";
		iup.hbox{
			--tog_cmd_;
			tog_view_;
			tog_file_;
			iup.fill{},
			btn_open_;
		};
	}
	

	--lab__ = iup.label{title = "From : ",rastersize = wid}
	--lab_from_ = iup.label{title = "From : ",rastersize = wid}
end



local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_from_,txt_from_};
			iup.hbox{lab_title_,txt_title_};
			iup.hbox{frame_type_};
			iup.hbox{
				iup.vbox{
					lab_text_;
					txt_text_;
					margin = "x2";
				};
			};
			iup.hbox{btn_forward_,btn_deleted_,btn_execute_,btn_close_};
			--iup.hbox{lab_text_};
			alignment = "ARIGHT";
			margin = "10x10";
			--iup.hbox{txt_text_};
		};
		resize = "NO";
		title = "Message";
	}
end

local function table_is_empty(t)
	return _G.next(t) == nil
end

local function action_open()
	if tog_view_.value == "ON" then 
	end
	if tog_file_.value == "ON" then 
	end 
end

local function action_forward()
end

local function action_deleted()
end

local function init_callback()
	function btn_open_:action()
		action_open()
	end

	function btn_close_:action()
		dlg_:hide()
	end

	function btn_forward_:action()
		action_forward()
	end

	function btn_execute_:action()
	
	end

	function btn_deleted_:action()
		action_deleted()
	end

	function tog_view_:action(state)
		tog_val_.view = (state == 1) and true  or nil
		btn_open_.active =  table_is_empty(tog_val_) and "NO" or "YES"
	end
	
	function tog_file_:action(state)
		tog_val_.file = (state == 1) and true  or nil
		btn_open_.active =  table_is_empty(tog_val_) and "NO" or "YES"
	end

end

local function init_active()
	frame_type_.active = "NO"
	tog_view_.active = "NO"
	tog_file_.active = "NO"
	btn_open_.active = "NO"
end

local function init_data()
	init_active()
	txt_from_.value = ""
	txt_title_.value = ""
	txt_text_.value = ""
	tog_view_.value = "OFF"
	tog_file_.value = "OFF"
	tog_val_ = {}
	if data_ then 
		txt_from_.value = data_.From
		txt_title_.value = data_.Name
		txt_text_.value = data_.Text
		if data_.AdditionalFile  then 
			frame_type_.active = "YES"
			tog_file_.active = "YES"
			btn_open_.active = "YES"
			tog_file_.value = "YES"
			tog_val_.file = true
		end
		if data_.AdditionalView  then 
			frame_type_.active = "YES"
			tog_view_.active = "YES"
			tog_view_.value = "ON"
			btn_open_.active = "YES"
			tog_val_.view = true
		end 
	end 
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	dlg_:map()
	init_data()
	dlg_:popup()
end

local function show()
	dlg_:map()
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

