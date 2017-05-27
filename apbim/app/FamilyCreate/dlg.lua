local string = string
local print = print
local type = type
local require =require
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] =M
_ENV = M
--local language_ = require 'sys.language'

local iup = require 'iuplua'
local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	title = {English = 'Title : ',Chinese = '标题 ：'};
	path = {English = 'Path : ',Chinese = '路径 ：'};
	image = {English = 'Image : ',Chinese = '图片 ：'};
	tip = {English = 'Tip : ',Chinese = '提示 ： '};
	remark = {English = 'Remark',Chinese = '备注'};
	dlg = {English = 'Create System Family',Chinese = '创建系统族'};
	ok = {English = 'Create',Chinese = '创建'};
	cancel = {English = 'Cancel',Chinese = '取消'};
	sel = {English = 'Select',Chinese = '选择'};
	select_objects = {English = 'Selected Objects',Chinese = '选中的对象'};
	select_all = {English = 'All',Chinese = '全部'};

}

local lab_wid = '50x'
local lab_title_ = iup.label{rastersize = lab_wid}
local txt_title_ = iup.text{expand = 'HORIZONTAL'}
local lab_path_ = iup.label{rastersize = lab_wid}
local txt_path_ = iup.text{expand = 'HORIZONTAL'}
local btn_path_ = iup.button{title = '. . .',rastersize = '50x'}
local lab_image_ = iup.label{rastersize = lab_wid}
local txt_image_ = iup.text{expand = 'HORIZONTAL'};
local btn_image_ = iup.button{rastersize = '50x'};
local lab_tip_ = iup.label{rastersize = lab_wid}
local txt_tip_ = iup.text{expand = 'HORIZONTAL'}
local txt_remark_ = iup.text{expand = 'yes',rastersize = '400x200',multiline = 'yes',wordwrap = 'yes'}
local frame_ = iup.frame{
	txt_remark_;
}

local btn_wid = '100x'
local btn_ok_ = iup.button{rastersize = btn_wid}
local btn_cancel_ = iup.button{rastersize = btn_wid}

local tog_selected_ = iup.toggle{fontsize = 12}
local tog_all_ = iup.toggle{fontsize = 12}

local radio_sel_= iup.radio{
	iup.hbox{
	--	tog_selected_;
		tog_all_;
	};
	gap = 5;
	margin = '0x0';
}

local dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{lab_title_,txt_title_};
		iup.hbox{lab_tip_,txt_tip_};
		iup.hbox{lab_path_,txt_path_};
		iup.hbox{lab_image_,txt_image_,btn_image_};
		iup.hbox{frame_};

		iup.hbox{tog_selected_,iup.fill{},btn_ok_,btn_cancel_};
		margin ='10x10';
		alignment = 'ARIGHT';
	};
	expand = 'YES';
}

local filedlg_;

local default_data_ = {
	title ='';
	icon = '';
	tip = '';
	remark = '';
	path = '';
	image_tip = '16x16 bmp file !';
}

local function init_callback(arg)
	arg = arg or {}
	local fileDlgStyle = {
		dir = {
			DIALOGTYPE = 'DIR';
			DIRECTORY = default_data_.path;
			value = default_data_.path;
		};
		file = {
			DIALOGTYPE = 'OPEN';
			file = txt_image_.value;
			extfilter = 'bmp file|*.bmp;|';
		};
	}
	local function init_filedlg(type)
		filedlg_ = iup.filedlg(fileDlgStyle[type])
		filedlg_:popup()
		return filedlg_.value
	end

	local function warning(str)
		local warnings = {
			title = 'Please input title !';
			path = 'Please input path !';
			icon = 'Please input icon !';
			no_selected = 'No selected entities !';
			no = 'No entities in the view !';
			sc = 'Please open view with objects !';

		}
		iup.Message('Notice',warnings[str])
	end

	local function is_ok()
		local t = {}
		t.title = txt_title_.value
		t.icon = txt_image_.value
		t.tip = txt_tip_.value
		t.remark = txt_remark_.value
		t.path = txt_path_.value
		t.selected = tog_selected_.value == 'ON' and true or nil
		t.warning = warning
		if not string.find(t.title,'%S+') then warning('title') return end 
		if not string.find(t.path,'%S+') then warning('path')return end 
		if not string.find(t.icon,'%S+') then warning('icon')return end 
		return t
	end

	function btn_path_:action()
		local str =	init_filedlg('dir')
		if str then 
			str = string.gsub(str,'\\','/')
			if string.sub(str,-1,-1) ~= '/' then str = str .. '/' end
			txt_path_.value = str
		end 
	end

	function btn_image_:action()
		local str =	init_filedlg('file')
		if str then 
			str = string.gsub(str,'\\','/')
			txt_image_.value = str
		end 
	end

	function btn_ok_:action()
		local t = is_ok()
		if not t then return end
		if type(arg.on_ok) == 'function' then 
			local status = arg.on_ok(t)
			if status then 
				dlg_:hide()
			end
		
		end
	end

	function btn_cancel_:action()
		dlg_:hide()
	end
end

local function init_data(data)
	local t =type(data) == 'table' and data or default_data_
	txt_title_.value= t.title
	txt_image_.value = t.icon
	txt_path_.value = t.path
	txt_tip_.value = t.tip
	txt_remark_.value = t.remark
	tog_selected_.value = 'ON'
end

function pop(arg)
	arg  = arg or {}
	local lan = arg.lan -- language_.get()
	lan = lan and language_package_.support_[lan] or 'English'

	local function init_title()
		lab_title_.title = language_package_.title[lan]
		lab_path_.title = language_package_.path[lan]
		lab_image_.title = language_package_.image[lan]
		lab_tip_.title = language_package_.tip[lan]
		frame_.title = language_package_.remark[lan]
		dlg_.title = language_package_.dlg[lan]
		btn_ok_.title = language_package_.ok[lan]
		btn_cancel_.title = language_package_.cancel[lan]
		btn_image_.title = language_package_.sel[lan]
		tog_selected_.title = language_package_.select_objects[lan]
		tog_all_.title = language_package_.select_all[lan]

	end
	local function init()
		init_title()
		init_callback(arg)
	end

	local function show()
		dlg_:map()
		init_data(arg.data)
		dlg_:popup()
	end
	init()
	show()
end
