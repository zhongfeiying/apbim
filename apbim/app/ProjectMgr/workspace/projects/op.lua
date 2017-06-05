local require  = _G.require 
local package_loaded_ = package.loaded
local pairs = pairs
local print = print
local string = string


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local tree_ = require 'app.projectmgr.workspace.projects.tree'
local control_create_project_ = require 'app.projectmgr.project.control_create_project'


function create_project()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	control_create_project_.main()
	local data = control_create_project_.get_data()
	if not data then return end 
	control_create_project_.next()
end