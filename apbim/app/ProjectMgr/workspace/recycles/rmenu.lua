


local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
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
local tree_ = require 'app.ProjectMgr.workspace.recycles.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '删除日期'}
local title_sort_name_ = {English = 'Name',Chinese = '标题名称'}
local title_clear_ = {English = 'Clear',Chinese = '清空'}
local title_del_ = {English = 'Delete',Chinese = '删除'}
local title_restore_ = {English = 'Restore',Chinese = '还原'}
local title_info_ = {English = 'Information',Chinese = '信息'}


local item_sort_ = {};
local item_sort_date_ = {};
local item_sort_name_ = {};
local item_clear_ = {};
local item_del_ = {};
local item_restore_ = {};
local item_info_ = {};

--------------------------------------------------------------------------------------------------------
--item
local submenu_sort = function()
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
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_clear_.title = title_clear_[cur_language_]
	item_del_.title = title_del_[cur_language_]
	item_restore_.title = title_restore_[cur_language_]
	item_info_.title = title_info_[cur_language_]
end

function get()
	init()
	return {
		item_clear_;
		'';
		item_sort_;
	}
end

function get_branch_menu()
	init()
	return {
		item_clear_;
		'';
		item_sort_;
	}
end

function get_leaf_menu()
	init()
	return {
		item_del_;
		'';
		item_restore_;
		'';
		item_info_;
	}
end
--------------------------------------------------------------------------------------------
--action function

