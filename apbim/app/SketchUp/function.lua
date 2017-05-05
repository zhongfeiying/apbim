--module(...,package.seeall)
local print = print
local require = require

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


local Menu = require'sys.menu'
local Toolbar = require'sys.toolbar'

function open_sketchup(sc)
	-- sc = sc or require"sys.mgr".new_scene();
	sc = sc or require"sys.mgr".new_scene();
	local file = require"app.sketchup.iupex".open_file_dlg("*");
	if  file then 
		require"app.sketchup.import".open_model(file);
	end 
	
end
function load()
	Menu.add{
		keyword='AP.Project.Import.SketchUp',
		action = open_sketchup;
		name='Project.Import.SketchUp',
		frame = true,
		view = true,
	}
end
