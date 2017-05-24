local require  = require 
local package_loaded_ = package.loaded
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local project_ = require 'app.projectmgr.project'
local tree_ = require 'app.ProjectMgr.workspace.workspace.tree'

local function active_show_property(tree,id)
	
	local tree = tree_.get()
	if tree and tree:get_node_depth() > 0 then 
		return 'hide'
	end
end 

local function action_personal_info()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end

local function action_change_pwd()
end
local function action_logout()
end

local item_info_ = {title = 'Personal Information',action = action_personal_info}
local item_change_pwd_ = {title = 'Change Password',action = action_change_pwd}
local item_quit_ = {title = 'Logout',action = action_logout}
local menus_root = {
	item_info_;
	item_change_pwd_;
	'';
	item_quit_;
}
function get()
	return menus_root
end
