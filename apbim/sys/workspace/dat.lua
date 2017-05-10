local type = type
local table = table
local error = error
local ipairs = ipairs

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

--[[
Tabs_ ={
	[1] = { 
		hwnd ;--userdata  --值是 iup.frame的返回值 
		rightclick_cb ;--function --值是一个函数，右键点击时触发
		pos ; -- number  --值是一个整形的数字，用来指定当前页面摆放的位置，默认尾追加
	}
}
--]]

local Tabs_ = {};

function init()
	Tabs_ = {};
end

function add(arg)
	if type(arg) ~= 'table' or not arg.hwnd then error('Data error !') return end 
	table.insert(Tabs_,arg)
end

function  delete(hwnd)
	for k,v in ipairs(Tabs_) do 
		if v.hwnd == hwnd then
			table.remove(Tabs_,k)
			break 
		end 
	end
end

function get_hwnd(pos)
	if not pos or not Tabs_[pos] then return end 
	return Tabs_[pos].hwnd;
end

function get()
	return Tabs_
end

