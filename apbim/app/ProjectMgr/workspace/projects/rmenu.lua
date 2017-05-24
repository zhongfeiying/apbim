local require  = require 
local package_loaded_ = package.loaded
local print = print
local table = table

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M


local language_ = require 'sys.language'
local cur_language_ = 'English'
local project_ = require 'app.projectmgr.project'
local tree_ = require 'app.ProjectMgr.workspace.projects.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_create_ = {English = 'Create',Chinese = '创建工程'}
local title_import_ = {English = 'Import',Chinese = '导入工程'}
local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '添加时间'}
local title_sort_name_ = {English = 'Name',Chinese = '标题名称'}
local action_create_;
local action_import_;
local action_sort_name_;
local action_sort_date_;
local item_create_;
local item_import_;
local item_sort_;
local item_sort_date_;
local item_sort_name_;

--------------------------------------------------------------------------------------------------------
--item
item_create_ = {action = action_create_}
item_import_ = {action = action_import_}
local function submenu_sort()
	return {
		item_sort_date_;
		item_sort_name_;
	}
end
item_sort_ = {submenu = submenu_sort}
--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_create_.title = title_create_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
end

function get()
	init()
	return {
		item_create_;
		item_import_;
		'';
		item_sort_;

	}
end
--------------------------------------------------------------------------------------------
--action function

action_create_ = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end

action_import_ = function() end 
action_sort_name_ = function() end 
action_sort_date_ = function() end 

