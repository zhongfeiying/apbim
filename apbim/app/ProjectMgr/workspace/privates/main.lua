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

local db_control_ = require 'app.projectmgr.workspace.privates.db'
local tree_control_ =  require 'app.projectmgr.workspace.privates.tree'

function set()
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
--[[
function get_control()
	return tree_control_.get_control()
end
--]]

function main()
	set()
	init()
	local tree = tree_control_.get()
	if not tree.Map then 
		tree:reg_map_cb(init_tree_data)
	else 
		init_tree_data()
	end
end



