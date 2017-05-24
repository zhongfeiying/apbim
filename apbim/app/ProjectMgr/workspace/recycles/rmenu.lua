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

-- local tree = tree_.get()
	-- local id = tree_.get_current_id()
local function action_clear()
	--
	local tree = tree_.get()
	local id = tree_.get_current_id()
end 
local function action_sort_date()
	--
end 
local function action_sort_name()
	--
end 
local function action_flush()
end 

local item_clear_ = {title = 'Clear',action = action_clear}
local item_sort_date_ = {title = 'Date',action = action_sort_date}
local item_sort_name_ = {title = 'Name',action = action_sort_name}
local function submenu_sort_by()
	return {
		item_sort_date_;
		item_sort_name_;
	}
end
local item_sort_ = {title = 'Srot by',submenu = submenu_sort_by}
local item_flush_ = {title = 'Flush',action = action_flush}
function get()
	return {
		item_clear_;
		item_flush_;
		'';
		item_sort_;
	}
end

----------------------------------------------------------------------------------------------------------------
local action_delete = function()
end
local action_delete = function()
end
local action_property = function()
end

local item_delete_ = {title = 'Delete',action = action_delete}--É¾³ý
local item_reduction_ = {title = 'reduction',action = action_delete} --»¹Ô­
local item_property_ = {title = 'Property',action = action_property} --ÊôÐÔ

function get_recycles_file_menu()
	return {
		item_delete_;
		'';
		item_reduction_;
		'';
		item_property_;
	}
end