
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print  = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local db_control_ = require 'app.projectmgr.apps.projects.db'
local tree_control_ =  require 'app.projectmgr.apps.projects.tree'


function init()
	db_control_.init()
	tree_control_.init()
end


function init_tree_data(map)
	if not map then 
		tree_control_.init_root()
	end
	local data = db_control_.get()
	tree_control_.set_tree_data(tree_control_.turn_tree_data(data))
end


function main()
	init()
	local tree = tree_control_.get()
	if not tree.Map then 
		tree:reg_map_cb(init_tree_data)
	else 
		init_tree_data(true)
	end
end



