local require  = require 
local package_loaded_ = package.loaded
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local project_ = require 'app.projectmgr.project'

local function create_project_active(tree,id)
	if tree and tree:get_node_depth() > 0 then 
		return 'hide'
	end
end 

local function open_project_active(tree,id)
	if tree and tree:get_node_depth() ~= 1 then 
		return 'hide'
	end
end 

local function create_project_action(tree,id)
	project_.new()
end 


local function open_project_action(tree,id)
	project_.open()
end 

local function save_project_action(tree,id)
	project_.save()
end 


local create_project_ = {title = 'Create',action = create_project_action,active = create_project_active}
local open_project_ = {title = 'Open',action = open_project_action,active = open_project_active}
local save_project_ = {title = 'Save',action = save_project_action,active = open_project_active}
local menus_root = {
	create_project_;
}

local menu_level_1 = {
	open_project_;
	save_project_;
}

function get(tree,id)
	if tree and tree:get_node_depth() == 0 then 
		return menus_root
	elseif tree and tree:get_node_depth() == 1 then 
		return menu_level_1
	end
	
end