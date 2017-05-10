local require = require;

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local dlg_ = require 'sys.workspace.dlg'
local dat_ = require 'sys.workspace.dat'
local update_ = false

-- 显示工作区
function display()
	dlg_.display_state( true )
end

-- 取消显示
function undisplay()
	dlg_.display_state( false )
end

function init()
	dat_.init()
	dlg_.init()
end

function update()
	update_ = true
	local t = dat_.get()
	dlg_.update(t)
	if #t == 0 then return undisplay() end 
	display()
end

--arg = {hwnd = '',current = true} --hwnd：iup元素，current 当前显示页面
function add(arg)
	dat_.add(arg)
	if update_ then 
		dlg_.append(arg)
	end
end

function delete(hwnd)
	dlg_.delete(hwnd)
	dat_.delete(hwnd)
end

function set_cur_page(keyIndex)
	if not keyIndex then return end 
	dlg_.set_cur_page(keyIndex)
end

