
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
	message1 = {English = {'Notice','Please input key !'},Chinese = {'注意','请输入属性名！'}};
	message2 = {English = {'Notice','The key has been exists !'},Chinese = {'注意','这个属性已经被定义 ！'}};
} 
local matrix_num_ = 0;
local lan;

local btn_wid = '100x';
local btn_cancel_ = iup.button{title = 'Cancel',rastersize = btn_wid};
local btn_ok_ = iup.button{title = 'Ok',rastersize = btn_wid};
local btn_add_ = iup.button{title = 'Add',rastersize = btn_wid};
local btn_delete_ = iup.button{title = 'Delete',rastersize = btn_wid};
local btn_edit_ = iup.button{title = 'Edit',rastersize = btn_wid};
local lab_wid = '70x'
local lab_key_ = iup.label{title = ' Key : ',}
local txt_key_ = iup.text{expand = 'HORIZONTAL'}
local lab_val_ = iup.label{title = ' Value : '}
local txt_val_ = iup.text{expand = 'HORIZONTAL',
-- rastersize = 'x100',multiline = 'YES',wordwarp = 'YES'
}
local matrix_info_ = iup.matrix{
	numcol = 2;
	numlin = 20;
	HIDDENTEXTMARKS = 'yes';
	RESIZEMATRIX = 'YES';
	RASTERWIDTH1 = '300x';
	RASTERWIDTH2 = '300x';
	MARKMODE = 'CELL';
	rastersize = '635x300';
	bgcolor = '255 255 255';
	ALIGNMENT1 = 'ALEFT';
	ALIGNMENT2 = 'ALEFT';
	ALIGNMENTLIN0 = 'ALEFT';
}
local frame_info_ = iup.frame{
	iup.vbox{
		matrix_info_;
		iup.hbox{lab_key_,txt_key_,lab_val_,txt_val_};
		-- iup.hbox{lab_val_,txt_val_};
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
	lan =  language_.get()
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

local function init_text()
	txt_key_.value = '';
	txt_val_.value ='';
end

local function init_callback(arg)
	function btn_ok_:action()
		if type(arg.on_ok) == 'function' then 
			arg.on_ok(get_matrix_data())
		end
		dlg_:hide()
	end
	
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
	
	function btn_add_:action()
		local str = txt_key_.value
		
		if not string.find(str,'%S+') then 
			local t = language_package_.message1[lan]
			iup.Message( t[1],t[2] ) 
			return
		end 
		local data = arg.data or {}
		if data[str] then 
			local t = language_package_.message2[lan]
			iup.Message( t[1],t[2] ) 
			return 
		end 
		matrix_add_line{key =str ,value = txt_val_.value,redraw = true}
		init_text()
	end
	
	
	function btn_edit_:action()
		local lin = get_selected_lin()
		if not lin or lin == 0 or lin > tonumber(matrix_num_) then return end 
		matrix_edit_line{key = txt_key_.value,value = txt_val_.value,lin = lin}
		init_text()
	end
	
	function btn_delete_:action()
		local lin = get_selected_lin()
		if not lin or lin == 0 or lin > tonumber(matrix_num_) then return end 
		matrix_info_.DELLIN = lin
		init_select_matrix(lin)
		matrix_num_ = matrix_num_ - 1
		if matrix_num_< 20 then 
			matrix_info_.numlin = 20
		end
		init_text()
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

local function init_data(data)
	clear_matrix()
	
	data = data or {}
	local data = sort(data)
	for k,v in ipairs(data) do 
		if type(v) == 'table' then 
			matrix_add_line{key = v.key,value = v.value}
		end
	end
	matrix_info_.redraw = 'all'
end



function pop(arg)
	arg = arg or {}
	local function init()
		init_title()
		init_callback(arg)
		dlg_:map()
		init_data(arg.data)
	end

	init()
	dlg_:popup()
end
