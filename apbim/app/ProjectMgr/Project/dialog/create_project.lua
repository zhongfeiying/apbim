
local require  = require 
local package_loaded_ = package.loaded
local frm_hwnd  = frm_hwnd 
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup = require 'iuplua'
require 'iupluacontrols'

local dlg_;

local function init_buttons()
	local wid = '100x'
	btn_ok_ = iup.button{title = 'Ok',rastersize = wid}
	btn_cancel_ = iup.button{title = 'Cancel',rastersize = wid}
	
	
end

local function init_controls()
	list_template_ = iup.list{rastersize = '400x400'}
	txt_template_info_ = iup.text{rastersize = '200x400'}
	lab_project_name_ = iup.label{title = 'Project Name : ',rastersize = '100x'}
	txt_project_name_ = iup.text{expand = 'HORIZONTAL'}
	
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{
				list_template_;
				txt_template_info_;
			};
			iup.hbox{lab_project_name_,txt_project_name_};
			iup.hbox{btn_ok_,btn_cancel_};
			alignment = 'ARIGHT';
			margin = '5x5';
		};
		title = 'Create Project';
	}
	dlg_.NATIVEPARENT = frm_hwnd
end

local function init_callback(fun)
	function btn_ok_:action()
		if type(fun.on_ok) == 'function' then 
			fun.on_ok()
		end
	end
	
	function btn_cancel_:action()
	end
end

local function init_data(data)
	
end

function pop(arg)
	arg = arg or {}
	local function init()
		init_buttons()
		init_controls()
		init_dlg()
	end
	
	local function show()
		init_callback()
		dlg_:map()
		init_data(arg.data)
		dlg_:popup()
	end
	
	if not dlg_ then init() end
	show()
end
