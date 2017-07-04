
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
local pairs = pairs
local tostring = tostring

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
	cancel = {English = 'Close',Chinese = 'ÖÕÖ¹'};
	dlg = {English = 'Saving',Chinese = '±£´æ'};
	checking =  {English = 'Checking ... ',Chinese = '¼ì²é ... '};
	saving =  {English = 'Saving ... ',Chinese = '±£´æ ... '};
}
local matrix_num_ = 0;
local lan;

local btn_wid = '100x';
local btn_cancel_ = iup.button{title = 'Close',rastersize = btn_wid};
local lab_wid = '70x'
local gauge_ = iup.gauge{expand = 'HORIZONTAL',rastersize = 'x30'};
local matrix_info_ = iup.matrix{
	numcol = 2;
	numlin = 20;
	HIDDENTEXTMARKS = 'yes';
	RESIZEMATRIX = 'YES';
	RASTERWIDTH1 = '400x';
	RASTERWIDTH2 = '50x';
	MARKMODE = 'CELL';
	rastersize = '480x300';
	bgcolor = '255 255 255';
	ALIGNMENT1 = 'ALEFT';
	ALIGNMENT2 = 'ARIGHT';
	FRAMECOLOR = '255 255 255';
}
--[[
local frame_info_ = iup.frame{
	iup.vbox{
		
		alignment = 'ARIGHT';
		margin = '5x5';
	};
	-- bgcolor = '255 255 255';
};
--]]
local dlg_ = iup.dialog{
	iup.vbox{
		gauge_;
		matrix_info_;
		iup.hbox{btn_cancel_};
		alignment = 'ARIGHT';
		margin = '10x10';
	};
	title = 'Attributes';
};

local function init_title()
	lan =  language_.get()
	lan = lan and language_package_[lan] or language_package_.default_
	btn_cancel_.title = language_package_.cancel[lan]
	dlg_.title = language_package_.dlg[lan]
end

local function init_select_matrix(lin,state)
	local state = state or 1
	matrix_info_['MARK' .. lin .. ':1'] = state 
	matrix_info_['MARK' .. lin .. ':2'] = state 
	if state == 1 then
		txt_key_.value = matrix_info_:getcell(lin,1)
		txt_val_.value = matrix_info_:getcell(lin,2)
	end
end

--arg = {key,value}
local function matrix_add_line(arg)
	matrix_num_ = matrix_num_ + 1
	if matrix_num_ > tonumber(matrix_info_.numlin) then 
		matrix_info_.numlin = matrix_num_
	end
	matrix_info_:setcell(matrix_num_,1,tostring(arg.key))
	matrix_info_:setcell(matrix_num_,2,tostring(arg.value))
	if arg.redraw then 
		matrix_info_.redraw = 'L' .. matrix_num_
	end
end

local function matrix_edit_line(arg)
	matrix_info_:setcell(arg.lin,1,arg.key)
	matrix_info_:setcell(arg.lin,2,arg.value)
	matrix_info_.redraw = 'L' .. arg.lin
end

local function get_selected_lin()
	local str = matrix_info_.FOCUSCELL
	local lin = tonumber(string.match(str,'%d+'))
	return lin
end

local function get_matrix_data()
	if matrix_num_ <=0 then return {} end 
	local data = {}
	for i = 1,matrix_num_ do 
		data[matrix_info_:getcell(i,1)] = matrix_info_:getcell(i,2)
	end
	return data
end

local function init_callback(arg)
	
	function btn_cancel_:action()
		dlg_:hide()
	end
	
	function matrix_info_:click_cb(lin, col,state)
		lin = tonumber(lin)
		col =tonumber(col)
		if string.find(state,'1') then 
			init_select_matrix(lin)
		end
	end
	
end

local function sort(data)
	local t = {}
	for k,v in pairs(data) do 
		table.insert(t,{key = k,value = v})
	end
	table.sort(t,function(a,b) return a.key<b.key end)
	return t
end

local function clear_matrix()
	if matrix_num_ >0 then	
		matrix_info_.DELLIN = 1 .. '-' .. matrix_num_
		matrix_info_.numlin =20
	end
	matrix_num_ = 0
end

local function waiting_guage(max)
	gauge_.TEXT  = language_package_.checking[lan]
	gauge_.MAX = max
	gauge_.min = 0
end

local function guage_up()
	local val = tonumber(gauge_.value) +1
	gauge_.value =val
	if val >= tonumber(gauge_.MAX )  then
		dlg_:hide()
	end
end

local function init_data(arg)
	arg = arg or {}
	clear_matrix()
	if type(arg.init) then 
		arg.init{
			waiting_guage = waiting_guage;
		}
	end 
	-- init_guage('checking',)
	matrix_add_line{key = v.key,value = v.value}
	matrix_info_.redraw = 'all'
end



function pop(arg)
	arg = arg or {}
	local function init()
		init_title()
		init_callback(arg)
		dlg_:map()
		init_data(arg)
	end

	init()
	dlg_:popup()
end
