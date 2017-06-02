local string = string
local print = print
local type = type
local require =require
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] =M
_ENV = M

local language_ = require 'sys.language'
local language_file_ = "cfg/language.lua";
local iup = require 'iuplua'
local default_language_ = 'English'
local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	dlg = {English = 'Change Language',Chinese = '切换语言'};
	ok = {English = 'Ok',Chinese = '确认'};
	cancel = {English = 'Cancel',Chinese = '取消'};
	title = {English = 'Language',Chinese = '语言'};
}

local lab_wid = '50x'
local lab_title_ = iup.label{rastersize = lab_wid}
local list_title_ = iup.list{expand="Yes",editbox="Yes",DROPDOWN="Yes"}


local btn_wid = '80x'
local btn_ok_ = iup.button{rastersize = btn_wid}
local btn_cancel_ = iup.button{rastersize = btn_wid}


local dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{lab_title_,list_title_};
		iup.hbox{btn_ok_,btn_cancel_};
		margin ='10x10';
		alignment = 'ARIGHT';
		rastersize = '300x';
	};
	expand = 'YES';
}

local function get_file_data()
	local s = require"sys.io".read_file{file=language_file_};
	if type(s)~="table" then s={} end
	return s;
end

local function add_lan_to_list(name)
	local s = get_file_data()
	s[name]= name 
	s.__LAST = name
	require'sys.table'.tofile{file=language_file_,src=s};
end

local function init_callback(arg)
	arg = arg or {}
	function btn_ok_:action()
		local name = list_title_.value
		add_lan_to_list(name)
	end

	function btn_cancel_:action()
		dlg_:hide()
	end
end

local function init_data(data)
	
end

function pop(arg)
	arg  = arg or {}
	local lan = arg.lan -- language_.get()
	lan = lan and language_package_.support_[lan] or 'English'

	local function init_title()
		lab_title_.title = language_package_.title[lan]
		dlg_.title = language_package_.dlg[lan]
		btn_ok_.title = language_package_.ok[lan]
		btn_cancel_.title = language_package_.cancel[lan]
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
