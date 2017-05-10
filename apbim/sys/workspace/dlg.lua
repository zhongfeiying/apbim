local loaded = package.loaded;
local require = require;
local frm_hwnd = frm_hwnd
local add_dlgtree = add_dlgtree
local dlgtree_show = dlgtree_show
local frm = frm
local ipairs = ipairs
local type = type
local tonumber = tonumber
local table  = table
local print = print

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local iup = require 'iuplua'

local tabchange_cb_;
local rightclick_cb_;
local callback_list_;
local dlg_;
local tabs_;

local function init_tabs()
	tabs_ = iup.tabs{}
	tabs_.TABTYPE="BOTTOM"
	tabs_.expand="yes"
	tabs_.showclose = "NO"
	tabs_.rastersize = '300x'
	-- function tabs_:tabchange_cb(new, old)
	-- 	print(new.tabtitle)
	-- 	if callback_list_ and callback_list_[old] and type(callback_list_[old].tabchange_cb) == 'function' then 
	-- 		callback_list_[old].tabchange_cb(old)
	-- 	end 
	-- 	if callback_list_ and callback_list_[new] and type(callback_list_[new].tabchange_cb) == 'function' then 
	-- 		callback_list_[new].tabchange_cb(new)
	-- 	end 
	-- end
	-- function tabs_:rightclick_cb(pos)
		-- if callback_list_ and callback_list_[pos+1] then 
			-- local cur_callback = callback_list_[callback_list_[pos+1]].rightclick_cb
			-- if type(cur_callback) == 'function' then 
				-- cur_callback(pos)
			-- end
		-- end 
	-- end
end

local function set_by_pos( pos )
	local num = tonumber(tabs_.COUNT)
	if pos >= num then error('Pos is error ! Tips: the pos begins from 0 !') return end
	tabs_.VALUEPOS= pos
end

local function set_by_tabtitle( name )
	local num = tonumber(tabs_.COUNT)
	for i = 1,num do
		local title = tabs_["TABTITLE" .. (i-1)]
		if title == name then 
			tabs_.VALUEPOS = i-1
			return true 
		end
	end
end

local function set_by_hwnd( hwnd )
	tabs_.VALUE   = hwnd
end



function set_cur_page(keyIndex)
	if type(keyIndex) == 'string' then 
		return set_by_tabtitle( keyIndex )
	elseif type(keyIndex) == 'userdata' then 
		return set_by_hwnd( keyIndex )
	elseif type(keyIndex) == 'number' then 
		return set_by_pos( keyIndex )
	end
end

local function  init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			tabs_; 
			margin="5x5";
		}; 
	}
	dlg_.BORDER="NO"
	dlg_.MAXBOX="NO"
	dlg_.MINBOX="NO"
	dlg_.MENUBOX="NO"
	dlg_.CONTROL = "YES"
	dlg_.rastersize="320x"
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	-- function dlg_:show_cb(status)
		-- if status == 0 then
			
		-- end
	-- end
	function dlg_:map_cb()
		add_dlgtree(frm,dlg_.HWND)
	end
	dlg_:map()
end

function init()
	init_tabs()
	init_dlg()
	callback_list_ = {}
end

function add(v)
	if not v or not v.hwnd then return end 
	iup.Append(tabs_,v.hwnd)
	iup.Map(v.hwnd)
	-- iup.Refresh(dlg_)
	callback_list_[v.hwnd] = v
	-- table.insert(callback_list_,v.hwnd)
end

function delete(hwnd)
	if not hwnd then return end 
	iup.Detach(hwnd) 
	callback_list_[hwnd] = nil
end

function append(arg)
	add(arg)
	if arg.current then 
		set_cur_page(arg.hwnd)
	end 
end

local function  update_tabs(t)
	for k,v in ipairs(t) do 
		if type(v) == 'table' and v.hwnd then 
			append(v)
		end
	end
end

function display_state( state )
	dlgtree_show(frm,state)
end


function update(t)
	update_tabs(t)
	dlg_:show()
end



