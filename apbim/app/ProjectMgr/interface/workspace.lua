
local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup_ = require 'iuplua'
require 'iupluacontrols'

local workspace_ = require 'sys.workspace'
local tree_ = require 'app.projectmgr.workspace.tree_control'
local tree_project_list_ =  require 'app.projectmgr.workspace.tree_workspace'
local project_list_;


local function init_control_data()
	
	return {
		hwnd = iup_.frame{
			iup_.vbox{
				tree_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle = 'Project';
		}
	}
end

local function load_project_list()
	tree_.set(tree_project_list_)
	tree_.init()
	project_list_ = init_control_data()
	workspace_.add(project_list_)
end 

local function unload_project_list()
	if project_list_ then 
		workspace_.delete(project_list_.hwnd)
		project_list_ = nil
	end
	
end

function on_load()
	load_project_list()
end

function on_unload()
	unload_project_list()
end


