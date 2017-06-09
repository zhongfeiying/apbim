

local require = require
local print = print
local table = table
local pairs = pairs
local ipairs = ipairs
local string = string
local print = print
local type = type

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local iup = require 'iuplua'
local default_language_ = 'English'
local language_ = require 'sys.language'

local language_package_ = {
	support_ = {English = 'English',Chinese = 'Chinese'};
	dlg = {English = 'Change Bgcolor',Chinese = '改变背景色'};
	ok = {English = 'Ok',Chinese = '确定'};
	add = {English = 'Add',Chinese = '添加'};
	cancel = {English = 'Cancel',Chinese = '取消'};
	preview = {English = 'Preview',Chinese = '预览'};
	selector = {English = 'Selector',Chinese = '选择器'};
	name = {English = 'Name : ',Chinese = '名称 ： '};
	
	lb = {English = 'Left Bottom : ',Chinese = '左下 ： '};
	rb = {English = 'Right Bottom  : ',Chinese = '右下 ： '};
	ru = {English = 'Right Up : ',Chinese = '右上 ： '};
	lu = {English = 'Left Up : ',Chinese = '坐上 ： '};

	red = {English = 'Red : ',Chinese = '红色 ： '};
	green = {English = 'Green : ',Chinese = '绿色 ： '};
	blue = {English = 'Blue : ',Chinese = '蓝色 ： '};
	lib =  {English = 'Bgcolor Lib',Chinese = '背景颜色库'};
}

local btn_wid = '100x';
local small_wid = '50x'
local btn_pre_ = iup.button{rastersize = btn_wid}
local btn_ok_ = iup.button{rastersize = btn_wid}
local btn_cancel_= iup.button{rastersize = btn_wid}
local btn_add_ = iup.button{rastersize = small_wid}
local lab_wid = '50x'
local lab_name_ = iup.label{title = 'Name : ',rastersize = lab_wid}
local txt_name_ = iup.text{rastersize = '200x',expand = 'HORIZONTAL'}
local lab_lb_ = iup.label{title = 'Left Bottom  : ',rastersize = lab_wid}
local lab_rb_ = iup.label{title = 'Right Bottom : ',rastersize = lab_wid}
local lab_ru_ = iup.label{title = 'Right Up : ',rastersize = lab_wid}
local lab_lu_ = iup.label{title = 'Left Up : ',rastersize = lab_wid}

local list_ = iup.list{rastersize = '200x200',expand = 'yes',dropdown = 'NO'}
local frame_lib_ = iup.frame{
	list_;
	title = 'Bgcolor Lib';
}
local controls_ = {}

local function get_color_control()
	local function init_txt_value(t)
		
	end

	local t
	t = {
		iup.label{title = 'Red : ',rastersize = small_wid,ctitle = 'red'},
		iup.text{expand = 'HORIZONTAL',init = function(arg) arg = arg or {} t[2].value = arg.r  end,filter = 'NUMBER',alignment = 'ARIGHT' },
		iup.label{title = 'Green : ',rastersize = small_wid,ctitle = 'green'},
		iup.text{expand = 'HORIZONTAL',init = function(arg) arg = arg or {} t[4].value = arg.g  end,filter = 'NUMBER',alignment = 'ARIGHT' },
		iup.label{title = 'Blue : ',rastersize = small_wid,ctitle = 'blue'},
		iup.text{expand = 'HORIZONTAL',init = function(arg) arg = arg or {} t[6].value = arg.b  end,filter = 'NUMBER',alignment = 'ARIGHT' },
		iup.button{title = 'Selector',ctitle = 'selector',rastersize = small_wid,action = function() 
			local dlg = iup.colordlg{}
			dlg.value = t[2].value .. ' ' .. t[4].value .. ' ' .. t[6].value
			dlg:popup()
			local val = dlg.value
			if not val or val == '' then return end 
			t[2].value,t[4].value,t[6].value = string.match(val,'(%d+)%s+(%d+)%s+(%d+)')
		end
		},
	}
	table.insert(controls_,t)
	return t[1],t[2],t[3],t[4],t[5],t[6],t[7]
		
end

local dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{
			frame_lib_;
			iup.vbox{
				iup.fill{};
				iup.hbox{lab_name_,txt_name_,btn_add_};
				iup.fill{};
				iup.hbox{lab_lb_,get_color_control()};
				iup.fill{};
				iup.hbox{lab_rb_,get_color_control()};
				iup.fill{};
				iup.hbox{lab_ru_,get_color_control()};
				iup.fill{};
				iup.hbox{lab_lu_,get_color_control()};
				iup.fill{};
			};
		};
		iup.hbox{btn_pre_,btn_ok_,btn_cancel_};
		alignment = 'ARIGHT';
		margin = '10x10';
	};
};

local function init_title(lan)
	lab_name_.title = language_package_.name[lan]
	dlg_.title = language_package_.dlg[lan]
	btn_ok_.title = language_package_.ok[lan]
	btn_cancel_.title = language_package_.cancel[lan]
	btn_pre_.title = language_package_.preview[lan]
	lab_lb_.title = language_package_.lb[lan]
	lab_rb_.title = language_package_.rb[lan]
	lab_lu_.title = language_package_.lu[lan]
	lab_ru_.title = language_package_.ru[lan]
	btn_add_.title = language_package_.add[lan]
	frame_lib_.title = language_package_.lib[lan]
	for k,v in ipairs (controls_) do 
		for m,n in ipairs(v) do 	
			if n.ctitle then 
				n.title = language_package_[n.ctitle][lan]
			end
		end
	end
end
local bgcolor_lib_file_ = 'app/bgcolorLib.lua'
local function get()
	local s = require"sys.io".read_file{file=bgcolor_lib_file_};
	if type(s)~="table" then s={} end
	return s;
end

local function save()
	require'sys.table'.tofile{file=bgcolor_lib_file_,src=t};
end

local function init_list()
	local t = get()
	for k,v in ipairs(t) do 
		list_.appenditem = v.name
	end
end

local function init_txt(arg)
	for k,v in ipairs (controls_) do 
		local t = v
		t[2].value,t[4].value,t[6].value = 0,0,0
--[[
		for m,n in ipairs(v) do 	
			if type(n.init) == 'function' then 
				n.init(arg)
			end
		end
		--]]
	end
end

local function init_data()
	 init_list()
	 init_txt()
end

local function init_color_value()
	return {
		leftbottom = {r = ,g = ,b = };
		rightbottom = {r = ,g = ,b = };
		leftup = {r = ,g = ,b = };
		rightup = {r = ,g = ,b = };
	}
end

local function add()
	local name = txt_name_.value
end

local function init_callback(arg)
	arg = arg or {}
	local function close()
		if type(arg.on_close) == 'function' then 
			arg.on_close()
		end
	end

	function btn_add_:action()
		add()
	end
	
	function btn_pre_:action()
		if type(arg.on_preview) == 'function' then 
			arg.on_preview()
		end
	end
	
	function btn_ok_:action()
		if type(arg.on_ok) == 'function' then 
			arg.on_ok()
		end
	end
	
	function btn_cancel_:action()
		close()
	end
	
	function dlg_:close_cb()
		close()
	end
	
	function list_:action(text, item, state)
		 print(text,item,state)
	end
end

function pop(arg)
	arg= arg or {}
	local lan =  language_.get()
	lan = lan and language_package_.support_[lan] or 'English'
	
	local function init()
		init_title(lan)
		init_callback(arg)
		dlg_:map()
		init_data()
	end
	
	init()
	dlg_:popup()
	
end
