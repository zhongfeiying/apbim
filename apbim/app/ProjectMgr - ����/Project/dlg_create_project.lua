
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local frm_hwnd  = frm_hwnd 
local ipairs = ipairs
local table = table
local type = type
local print = print
local tonumber = tonumber

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup = require 'iuplua'
require 'iupluacontrols'
require "iupluaimglib"

local dlg_;
local default_image_ = 'template/res/default.bmp'
local dafualt_path_ = 'Projects\\'


local btn_next_;
local btn_cancel_;
local list_template_;
local frame_list_;
local frame_info_;
local lab_info_;
local lab_image_;
local lab_name_;
local lab_location_;
local txt_location_;
local txt_name_;
local filedlg_;

local function init_language(language)
	cur_ = language or 'English'
end

local function init_buttons(language)
	local wid = '100x'
	
	btn_next_ = iup.button{}
	btn_next_.title =language.btn_next_[cur_]
	btn_next_.rastersize = wid
	
	btn_cancel_ = iup.button{}
	btn_cancel_.title =language.btn_cancel_[cur_]
	btn_cancel_.rastersize = wid
	
	btn_dir_ = iup.button{}
	btn_dir_.title =language.btn_dir[cur_]
	btn_dir_.rastersize = '50x'
end

local function init_controls(language)
	
	local wid = '70x'
	list_template_ = iup.list{
		fontsize = '12',
		SHOWIMAGE= 'YES';
		rastersize = '350x450';
		expand = 'HORIZONTAL',
		VISIBLECOLUMNS = 3;
	}
	frame_list_ = iup.frame{
		list_template_;
		title = language.frame_list[cur_];
	}
	lab_info_ = iup.label{
		expand = 'YES',
		ALIGNMENT='ALEFT:ATOP',
		fontsize = 12,
		multiline = 'yes',
		wordwrap = 'yes',
		ellipsis = 'yes';	
	}
	lab_image_ = iup.label{
		rastersize = '200x200';
		ALIGNMENT='ACENTER:ACENTER',
		IMAGE ='yes'
	}
	frame_info_ = iup.frame{
		iup.vbox{
			lab_info_;
		--	iup.label{SEPARATOR  = 'HORIZONTAL'};
			--iup.frame{
			lab_image_;
		--		bgcolor = '255 255 255';
		--		title =  language.frame_image[cur_];
		--	};
			margin = '5x10';
		};
		title = language.frame_info[cur_];
	}
	
	lab_name_ = iup.label{}
	lab_name_.title = language.lab_name[cur_]
	lab_name_.rastersize = wid
	txt_name_ = iup.text{expand = 'HORIZONTAL'}
	
	lab_location_= iup.label{}
	lab_location_.title = language.lab_location[cur_]
	lab_location_.rastersize =wid
	txt_location_ = iup.text{expand = 'HORIZONTAL',readonly = 'YES',value = dafualt_path_}
	
	filedlg_ = iup.filedlg{DIALOGTYPE = 'DIR';}
end

local function init_dlg(language)

	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{
				frame_list_;
				frame_info_;
			};
			iup.hbox{lab_name_,txt_name_};
			-- iup.hbox{lab_location_,txt_location_,btn_dir_};
			iup.fill{rastersize = 'x10'};
			iup.hbox{btn_next_,btn_cancel_};
			alignment = 'ARIGHT';
			margin = '5x5';
		};
		title = language.dlg_title[cur_]
	}
	dlg_.NATIVEPARENT = frm_hwnd
end

local function init_callback(arg)
	arg = arg or {}
	local function exit_dlg()
		dlg_:hide()
		--iup.Destroy(dlg_)
		--dlg_ = nil
	end
	
	local data = arg.data or {}
	function btn_next_:action()
		local  selected_item = tonumber(list_template_.value)
		if selected_item < 1 then return end 
		if not string.find(txt_location_.value,'%S+') then return end 
		if not string.find(txt_name_.value,'%S+') then return end 
		
		if type(arg.on_next) == 'function' then 
			arg.on_next{
				name = txt_name_.value;
				path = txt_location_.value;
				tpl = data[selected_item] and data[data[selected_item]];
			}
		exit_dlg()
		end
		
	end
	
	function btn_cancel_:action()
		-- dlg_:hide()
		exit_dlg()
	end
	
	function btn_dir_:action()
		filedlg_:popup()
		local val = filedlg_.value 
		if not val then return end
		if string.sub(val,-1,-1) ~= '\\' then 
			val = val .. '\\'
		end
		txt_location_.value = val 
	end
	
	function list_template_:action(text, item, state)
		if state == 1 then 
			local t = data[data[item]]
			if type(t) == 'table' then 
				lab_image_.image = t.preimage
				lab_info_.title = t.information
			else 
				lab_image_.image = nil
				lab_info_.title = nil
			end 
		end
	end
	
end

local function init_data(data)
	list_template_[1] = nil
	if type(data) ~= 'table' then return end 
	for k,v in ipairs (data) do 
		list_template_.APPENDITEM  = v
		v = data[v]
		if type(v) == 'table' then
			list_template_['image' .. k ] =  v.image --string.gsub(v.image,'/','\\')
		else 
			list_template_['image' .. 1] = default_image_ --'IUP_NavigateHome' --default_image_
		end
	end 
	
end

function pop(arg)
	arg = arg or {}
	local function init()
		init_language(arg.language)
		init_buttons(arg.languagePack)
		init_controls(arg.languagePack)
		init_dlg(arg.languagePack)
	end
	
	local function show()
		init_callback(arg)
		dlg_:map()
		init_data(arg.data)
		dlg_:popup()
	end
	
	-- if not dlg_ then init() end
	init()
	show()
end
