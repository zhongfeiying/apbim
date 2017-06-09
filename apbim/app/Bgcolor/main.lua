

local require = require
local print = print
local pairs = pairs
local new_child = new_child
local scene_color = scene_color
local type = type

local frm = frm
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local menu_ = require 'sys.menu'
local dlg_ = require 'app.bgcolor.dlg'
local mgr_ = require 'sys.mgr'

local function action()

	--arg = {leftbottom = {r = ,g = ,b = }}
	local function close_pre()
		local scs = mgr_.get_all_scene()
		for k,v in pairs(scs) do 
			if type(v) == 'table' and v.Name and v.Name == 'Preview Bgcolor' then
				mgr_.close_scene{scene = k}
				break;
			end
		end
	end
	
	local function on_ok(arg)
		arg  = arg  or {}
		close_pre()
		
		local leftbottom =  arg.leftbottom and {r = arg.leftbottom.r/255,g=arg.leftbottom.g/255,b =arg.leftbottom.b/255} or {r = 1,g = 1,b = 1}
		local rightbottom =  arg.rightbottom and {r = arg.rightbottom.r/255,g=arg.rightbottom.g/255,b =arg.rightbottom.b/255} or {r = 1,g = 1,b = 1}
		local rightup =  arg.rightup and {r = arg.rightup.r/255,g=arg.rightup.g/255,b =arg.rightup.b/255} or {r = 1,g = 1,b = 1}
		local leftup =  arg.leftup and {r = arg.leftup.r/255,g=arg.leftup.g/255,b =arg.leftup.b/255} or {r = 1,g = 1,b = 1}
		local sc =mgr_.get_cur_scene() or mgr_.new_scene{name = "Bgcolor"}
		scene_color(sc,
			leftbottom.r,
			leftbottom.g,
			leftbottom.b,
			
			rightbottom.r,
			rightbottom.g,
			rightbottom.b,
			
			rightup.r,
			rightup.g,
			rightup.b,
			
			leftup.r,
			leftup.g,
			leftup.b
		) 
	end
	local function on_preview(arg)
		close_pre()
		sc = mgr_.new_scene{name = "Preview Bgcolor"}
		local leftbottom =  arg.leftbottom and {r = arg.leftbottom.r/255,g=arg.leftbottom.g/255,b =arg.leftbottom.b/255} or {r = 1,g = 1,b = 1}
		local rightbottom =  arg.rightbottom and {r = arg.rightbottom.r/255,g=arg.rightbottom.g/255,b =arg.rightbottom.b/255} or {r = 1,g = 1,b = 1}
		local rightup =  arg.rightup and {r = arg.rightup.r/255,g=arg.rightup.g/255,b =arg.rightup.b/255} or {r = 1,g = 1,b = 1}
		local leftup =  arg.leftup and {r = arg.leftup.r/255,g=arg.leftup.g/255,b =arg.leftup.b/255} or {r = 1,g = 1,b = 1}
		scene_color(sc,
			leftbottom.r,
			leftbottom.g,
			leftbottom.b,
			
			rightbottom.r,
			rightbottom.g,
			rightbottom.b,
			
			rightup.r,
			rightup.g,
			rightup.b,
			
			leftup.r,
			leftup.g,
			leftup.b
		) 
	end
	dlg_.pop{on_ok = on_ok,on_preview = on_preview,on_close = close_pre}
end

function on_load()
	menu_.add{
		keyword = 'Ap.Bgcolor';
		name = 'Ap.Bgcolor';
		view = true;
		frame = true;
		action = action;
	}
end

function on_init()
end

function on_esc()


end

