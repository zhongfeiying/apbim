
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

local language_ = require 'sys.language'

local language_package_ = {
	default_ = 'Chinese';
	support_ = {English = 'English',Chinese = 'Chinese'};
	cancel = {English = 'Cancel',Chinese = '取消'};
	ok = {English = 'Ok',Chinese = '确定'};
	add = {English = 'Add',Chinese = '添加'};
	delete = {English = 'Delete',Chinese = '删除'};
	key = {English = ' Key : ',Chinese = ' 属性 ： '};
	val = {English = ' Value : ',Chinese = ' 值： '};
	Mkey = {English = 'Key',Chinese = '属性 '};
	Mval = {English = 'Value ',Chinese = '值'};
	dlg = {English = 'Setting Attributes',Chinese = '设置属性'};
	edit =  {English = 'Edit',Chinese = '编辑'};
} 


local btn_wid = '100x';
local btn_cancel_ = iup.button{title = 'Cancel',rastersize = btn_wid};
local btn_ok_ = iup.button{title = 'Ok',rastersize = btn_wid};
local btn_add_ = iup.button{title = 'Add',rastersize = btn_wid};
local btn_delete_ = iup.button{title = 'Delete',rastersize = btn_wid};
local btn_edit_ = iup.button{title = 'Edit',rastersize = btn_wid};
local lab_wid = '50x'
local lab_key_ = iup.label{title = 'Key : ',rastersize = lab_wid}
local txt_key_ = iup.text{expand = 'HORIZONTAL'}
local lab_val_ = iup.label{title = 'Value : ',rastersize = lab_wid}
local txt_val_ = iup.text{expand = 'HORIZONTAL',rastersize = 'x100',multiline = 'YES',wordwarp = 'YES'}
local matrix_info_ = iup.matrix{
	numcol = 2;
	numlin = 20;
	HIDDENTEXTMARKS = 'yes';
	RESIZEMATRIX = 'YES';
	RASTERWIDTH1 = '200x';
	RASTERWIDTH2 = '200x';
	MARKMODE = 'NO';
	rastersize = '430x300';
	bgcolor = '255 255 255';
}
local frame_info_ = iup.frame{
	iup.vbox{
		matrix_info_;
		iup.hbox{lab_key_,txt_key_};
		iup.hbox{lab_val_,txt_val_};
		iup.hbox{btn_add_,btn_edit_,btn_delete_};
		alignment = 'ARIGHT';
		margin = '5x5';
	};
	-- bgcolor = '255 255 255';
};
local dlg_ = iup.dialog{
	iup.vbox{
		frame_info_;
		iup.hbox{btn_ok_,btn_cancel_};
		alignment = 'ARIGHT';
		margin = '10x10';
	};
	title = 'Attributes';
};

local function init_title()
	local lan =  language_.get()
	lan = lan and language_package_[lan] or language_package_.default_
	
	btn_ok_.title = language_package_.ok[lan]
	btn_cancel_.title = language_package_.cancel[lan]
	btn_add_.title = language_package_.add[lan]
	btn_delete_.title  = language_package_.delete[lan]
	lab_key_.title =  language_package_.key[lan]
	dlg_.title = language_package_.dlg[lan]
	btn_edit_.title = language_package_.edit[lan]
	lab_val_.title = language_package_.val[lan]
	
	local function init_matrix_head()
		matrix_info_:setcell(0,1, language_package_.Mkey[lan])
		matrix_info_:setcell(0,2,language_package_.Mval[lan])
	end
	init_matrix_head()
end

local function init_callback()
	function btn_ok_:action()
	end
	
	function btn_cancel_:action()
	end
	
	
end



local function init_data()
end



function pop(arg)
	local function init()
		init_title()
		init_callback()
		dlg_:map()
		init_data()
	end

	init()
	dlg_:popup()
end
