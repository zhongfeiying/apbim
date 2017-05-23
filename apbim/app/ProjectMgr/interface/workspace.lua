
local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup_ = require 'iuplua'
require 'iupluacontrols'

local sys_workspace_ = require 'sys.workspace'
local workspace_ =  require 'app.projectmgr.workspace.workspace.main'

-- local projectlist_ =  require 'app.projectmgr.workspace.projects.main'
-- local contacts_ =  require 'app.projectmgr.workspace.contacts.main'
-- local recycle_ =  require 'app.projectmgr.workspace.recycles.main'
-- local private_ =  require 'app.projectmgr.workspace.privates.main'

local var_workspace_;


local function init_control_data()
	return {
		hwnd = iup_.frame{
			iup_.vbox{
				workspace_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle = 'Workspace';
		}
	}
end

local function init(cmd)
	cmd.set()
	cmd.init()
	cmd.init_tree_data()
end

local function load_project_list()

	-- qinit(workspace_)
	workspace_.main()
	-- init(private_)
	-- init(recycle_)
	-- init(contacts_)
	-- init(projectlist_)
	var_workspace_ = init_control_data()
	sys_workspace_.add(var_workspace_)
end 

local function unload_project_list()
	if var_workspace_ then 
		sys_workspace_.delete(var_workspace_.hwnd)
		var_workspace_ = nil
	end
	
end

function on_load()
	load_project_list()
end

function on_unload()
	unload_project_list()
end


