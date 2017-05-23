
local require  = require 
local package_loaded_ = package.loaded
local print  = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local tree_control_ = require 'app.projectmgr.workspace.tree_control'
local db_control_ = require 'app.projectmgr.workspace.db_control'

local db_workspace_ = require 'app.projectmgr.workspace.workspace.db'
local workspace_tree_ =  require 'app.projectmgr.workspace.workspace.tree'

function set()
	db_control_.set(db_workspace_)
	tree_control_.set(workspace_tree_)
end

function init()
	db_control_.init()
	tree_control_.init()
end

function init_tree_data()
	local data = db_control_.get()
	tree_control_.turn_tree_data(data)
	tree_control_.set_tree_data()
end

function get_control()
	return tree_control_.get_control()
end

function main()
	set()
	init()
	init_tree_data()
end

