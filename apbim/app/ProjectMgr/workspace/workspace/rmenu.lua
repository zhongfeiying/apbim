local require  = require 
local package_loaded_ = package.loaded
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local project_ = require 'app.projectmgr.project'

local function active_show_property(tree,id)
	if tree and tree:get_node_depth() > 0 then 
		return 'hide'
	end
end 

local function show_property()
	project_.show_property()
end

local Property = {title = 'Property',action = show_property,active = active_show_property}

local menus_root = {
	Property;
}
function get(tree,id)
	return menus_root
end