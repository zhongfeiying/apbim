local require  = require 
local package_loaded_ = package.loaded
local frm_hwnd  = frm_hwnd 
local ipairs = ipairs
local string = string
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
local language_;
local language_pack_ ;
local init_data_;
local return_data_;

local function init_language_pack()
	language_pack_ = {
		['English'] =true;
		['Chinese'] = true;
		btn_ok = {
			['English'] = 'Ok';
			['Chinese'] = '设置';
		};
		btn_cancel = {
			['English'] = 'Cacnel';
			['Chinese'] = '取消';
		};
		tabtile_project_introduction = {
			['English'] = 'Introduction';
			['Chinese'] = '介绍';
		};
		lab_project_id = {
			['English'] = 'No. : ';
			['Chinese'] = '编号 ： ';
		};
		lab_project_category = {
			['English'] = 'Category  : ';
			['Chinese'] = '类别 ： ';
		};
		lab_project_property = {
			['English'] = 'Property : ';
			['Chinese'] = '性质 ： ';
		};
		lab_start_time= {
			['English'] = 'Start Time : ';
			['Chinese'] = '启动时间 ： ';
		};
		lab_end_time= {
			['English'] = 'End Time : ';
			['Chinese'] = '结束时间 ： ';
		};
		lab_plan_time= {
			['English'] = 'Plan Time : ';
			['Chinese'] = '预计时间 ： ';
		};
		frame_description = {
			['English'] = 'Description';
			['Chinese'] = '描述';
		};
		dlg_title =  {
			['English'] = 'Setting Project Base information';
			['Chinese'] = '设置工程基本信息';
		};
	}
end

local btn_ok_;
local btn_cancel_;
local lab_company_;
local list_company_;
local lab_address_;
local list_address_;
local tab_;
local lab_project_id_;
local txt_project_id_;
local dlg_;

local function init_language()
	-- language_ = require 'sys.language'.get()
	if not language_ or not language_pack_[language_] then 
		language_ ='English'  --'English' 
	end
end

local function init_buttons()
	local wid = '70x'
	btn_ok_ = iup.button{}
	btn_ok_.title =  language_pack_.btn_ok[language_] 
	btn_ok_.rastersize = wid
	
	btn_cancel_ = iup.button{}
	btn_cancel_.title = language_pack_.btn_cancel[language_] 
	btn_cancel_.rastersize = wid
end

local function init_controls()
	local lab_wid = '100x'
	
	lab_project_id_ = iup.label{}
	lab_project_id_.title =  language_pack_.lab_project_id[language_] 
	lab_project_id_.rastersize = lab_wid
	txt_project_id_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	
	lab_project_category_ = iup.label{}
	lab_project_category_.title =  language_pack_.lab_project_category[language_] 
	lab_project_category_.rastersize = lab_wid
	txt_project_category_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	
	lab_project_property_ = 	iup.label{}
	lab_project_property_.title =  language_pack_.lab_project_property[language_] 
	lab_project_property_.rastersize = lab_wid
	txt_project_property_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}

	lab_start_time_ = 	iup.label{}
	lab_start_time_.title =  language_pack_.lab_start_time[language_] 
	lab_start_time_.rastersize = lab_wid
	txt_start_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	lab_end_time_ = 	iup.label{}
	lab_end_time_.title =  language_pack_.lab_end_time[language_] 
	lab_end_time_.rastersize = lab_wid
	-- txt_end_time_ = iup.text{expand = 'HORIZONTAL';rastersize = '200x'}
	txt_end_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	lab_plan_time_ = 	iup.label{}
	lab_plan_time_.title =  language_pack_.lab_plan_time[language_] 
	lab_plan_time_.rastersize = lab_wid
	txt_plan_time_ = iup.datepick{ZEROPRECED= 'yes',ORDER = 'MDY',CALENDARWEEKNUMBERS = 'yes',expand = 'HORIZONTAL'}
	
	txt_description_ = iup.text{expand = 'HORIZONTAL';rastersize = '400x200',multiline = 'YES',}
	frame_description_ = iup.frame{
		txt_description_;
		title = language_pack_.frame_description[language_] ;
	}
	
	frame_project_introduction_ --= iup.frame{
	=	iup.vbox{
			iup.hbox{lab_project_id_,txt_project_id_};
			iup.hbox{lab_project_category_,txt_project_category_};
			iup.hbox{lab_project_property_,txt_project_property_};
			iup.hbox{lab_start_time_,txt_start_time_};
			iup.hbox{lab_plan_time_,txt_plan_time_};
			iup.hbox{lab_end_time_,txt_end_time_};
			iup.hbox{frame_description_};
			margin = '5x5';
			alignment = 'ALEFT';
			tabtitle =  language_pack_.tabtile_project_introduction[language_] 
		};
		
	-- }
	tabs_ = iup.tabs{frame_project_introduction_}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			tabs_;
			iup.hbox{btn_ok_,btn_cancel_};
			margin = '10x10';
			alignment = 'ARIGHT';
		};
		title =  language_pack_.dlg_title[language_] 
	}
end

local function init_callback()
	function btn_cancel_:action()
		dlg_:hide()
	end
	
	function btn_ok_:action()
		return_data_ = {}
		return_data_.id = txt_project_id_.value
		return_data_.category = txt_project_category_.value
		return_data_.description = txt_description_.value
		return_data_.property = txt_project_property_.value
		return_data_.start_time = txt_start_time_.value
		return_data_.plan_time = txt_plan_time_.value
		return_data_.end_time = txt_end_time_.value
		dlg_:hide()
	end
	
	function dlg_:map_cb()
	end
	
	function dlg_:close_cb()
	end
end

local function init_data()
	if type(init_data_) == 'table' then 
		txt_project_id_.value = init_data_.id
		txt_project_category_.value = init_data_.category
		txt_description_.value = init_data_.description
		txt_project_property_.value = init_data_.property
		txt_start_time_.value = init_data_.start_time
		txt_plan_time_.value = init_data_.plan_time
		txt_end_time_.value = init_data_.end_time
	end 
end

local function init()
	init_language_pack()
	init_language()
	init_buttons()
	init_controls()
	init_dlg()
end

local function show()
	init_callback()
	dlg_:map()
	init_data()
	dlg_:popup()
	-- iup.MainLoop()
end

local function set_data(data)
	init_data_ = data
end 

function pop()
	if not dlg_ then init() end 
	show()
end

function get_data()
	return return_data_
end

local function init_file_data()
	init_data_ = nil
	return_data_ = nil;
	dlg_ = nil
end 

function main(data)
	init_file_data()
	set_data(data)
	pop()
	return get_data()
end