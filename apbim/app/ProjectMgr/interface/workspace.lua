
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
local workspace_ =  require 'app.projectmgr.workspace.workspace'
local var_workspace_;


local function init_control_data()
	return {
		hwnd = iup_.frame{
			iup_.vbox{
				workspace_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle = 'Project';
		}
	}
end

local function load_project_list()
	workspace_.set()
	workspace_.init()
	workspace_.init_tree_data()
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


