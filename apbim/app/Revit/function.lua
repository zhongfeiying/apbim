--module(...,package.seeall)
local print = print
 -- _ENV = module_seeall(...,package.seeall)
local require = require

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local Menu = require'sys.menu'
local Toolbar = require'sys.toolbar'

function open_revit(sc)
	sc = sc or require"sys.mgr".new_scene();
	local file = require"app.Revit.iupex".open_file_dlg("*");
	print(file)
	if file and file ~= '' then 
		require"app.Revit.import".open_model(file);
	end 
end
function load()
	Menu.add{
		keyword='AP.Project.Import.Revit',
		action = open_revit;
		name='Project.Import.Revit',
		frame = true,
		view = true,
	}
	
end
