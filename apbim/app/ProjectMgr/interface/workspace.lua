
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
local tree_control_ = require 'app.projectmgr.workspace.tree_control'
local workspace_tree_ =  require 'app.projectmgr.workspace.tree_workspace'
local workspace_;


local function init_control_data()
	return {
		hwnd = iup_.frame{
			iup_.vbox{
				tree_control_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle = 'Project';
		}
	}
end

local function load_project_list()
	tree_control_.set(workspace_tree_)
	tree_control_.init()
	workspace_ = init_control_data()
	sys_workspace_.add(workspace_)
end 

local function unload_project_list()
	if workspace_ then 
		sys_workspace_.delete(workspace_.hwnd)
		workspace_ = nil
	end
	
end

function on_load()
	load_project_list()
end

function on_unload()
	unload_project_list()
end


