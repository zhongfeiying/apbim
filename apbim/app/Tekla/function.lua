--module(...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
local require = require
local os_execute_ = os.execute

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local Menu = require'sys.menu'
local Toolbar = require'sys.toolbar'

function open_tekla(sc)
--[[
	require "app.Tekla.dlg_import_tekla".pop();
	local version = require "app.Tekla.dlg_import_tekla".return_select_tekla_version();
	
	trace_out(version .. "\n");
	if(version == "Tekla 17.0") then
		os_execute_("app\\Tekla\\soft\\TeklaIO_17.0\\TeklaIO.exe");
	elseif(version == "Tekla 18.0")	then	
		os_execute_("app\\Tekla\\soft\\TeklaIO_18.0\\TeklaIO.exe");
	elseif(version == "Tekla 19.0")	then	
		os_execute_("app\\Tekla\\soft\\TeklaIO_19.0\\TeklaIO.exe");
	end
	]]--
	os_execute_("app\\Tekla\\soft\\TeklaIO_19.0\\TeklaIO.exe");
	-- sc = require"sys.mgr".new_scene();	
	
	--local file = require"app.Tekla.iupex".open_file_dlg("*");
	local file = "model.lua";
	require"app.Tekla.import".open_model(file);
	for i=1,123456 do
-- require'sys.str'.totrace(i);
	end
	-- require"app.Model.function".Rendering();
	require'sys.statusbar'.update();
end
function open_tekla_file(sc)
	-- sc = sc or require"sys.mgr".new_scene();
	local file = require"app.Tekla.iupex".open_file_dlg("*");
	if  file then 
	require"app.Tekla.import".open_model(file);
	end 
end
function load()
	Menu.add{
		keyword='AP.Project.Import.Tekla',
		action = open_tekla;
		name='Project.Import.Tekla',
		frame = true,
		view = true,
	}
	Menu.add{
		keyword='AP.Project.Import.Tekla From File',
		action = open_tekla_file;
		name='Project.Import.Tekla From File',
		frame = true,
		view = true,
	}
end
