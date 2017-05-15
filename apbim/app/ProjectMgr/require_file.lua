local require  = require 
local print = print
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M



local iup_ = require 'iuplua'
require 'iupluacontrols'

function app_project()
	return  require 'app.projectmgr.project'
end

function app_menu()
	return require 'app.projectmgr.interface.menu'
end

function app_toolbar()
	return require 'app.projectmgr.interface.toolbar'
end

function app_workspace()
	return require 'app.projectmgr.interface.workspace'
end
-------------------------------------------------------------------------------
function app_tree_control()
	return require 'app.projectmgr.workspace.tree_control'
end

function app_rmenu_control()
	return  require 'app.projectmgr.workspace.rmenu_control'
end

function app_db_control()
	return  require 'app.projectmgr.workspace.db_control'
end

function app_keydown_control()
	return  require 'app.projectmgr.workspace.keydown_control'
end

-------------------------------------------------------------------------------

function app_tree_projectlist()
	return  require 'app.projectmgr.workspace.tree_project_list'
end

function app_rmenu_projectlist()
	return  require 'app.projectmgr.workspace.rmenu_project_list'
end

function app_keydown_projectlist()
	return  require 'app.projectmgr.workspace.keydown_project_list'
end

function app_db_projectlist()
	return  require 'app.projectmgr.workspace.db_project_list'
end


function dlg_create_project()
	return  require 'app.projectmgr.project.CreateProject.dlg'
end
function op_create_project()
	return  require 'app.projectmgr.project.CreateProject.op'
end

function control_create_project()
	return  require 'app.projectmgr.project.CreateProject.main'
end

-------------------------------------------------------------------------------






function sys_menu()
	return require 'sys.menu'
end

function sys_toolbar()
	return require 'sys.toolbar'
end

function sys_workspace()
	return require 'sys.workspace'
end

function sys_tree()
	return require 'sys.workspace.tree.iuptree'
end

function sys_rmenu()
	return require 'sys.workspace.tree.rmenu'
end

function iup()
	return iup_
end
