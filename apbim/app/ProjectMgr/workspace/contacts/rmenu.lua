
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
local tree_ = require 'app.ProjectMgr.workspace.contacts.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}
local title_add_contact_ = {English = 'Add',Chinese = '添加'}
local title_contact_manage_ = {English = 'Manage Contact',Chinese = '联系人管理'}
local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '日期'}
local title_sort_name_ = {English = 'Name',Chinese = '名称'}
local title_delete_project_ = {English = 'Delete',Chinese = '删除'}
local title_edit_information_ = {English = 'Edit',Chinese = '编辑'}


local item_add_contact_ = {};
local item_contact_manage_ = {};
local item_sort_ = {};
local item_sort_date_ = {};
local item_sort_name_ = {};
local item_delete_project_ = {};
local item_edit_information_ = {};

--------------------------------------------------------------------------------------------------------
--item
local submenu_sort = function()
	return {
	item_sort_date_;
	item_sort_name_;
}
end 

--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_contact_manage_.title = title_contact_manage_[cur_language_]
	item_add_contact_.title = title_add_contact_[cur_language_]
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_delete_project_.title = title_delete_project_[cur_language_]
	item_edit_information_.title = title_edit_information_[cur_language_]
end

function get()
	init()
	return {
		item_contact_manage_;
		'';
		item_add_contact_;
		item_sort_;
	}
end

function get_branch_menu()
	init()
	return {
		item_add_contact_;
		item_edit_information_;
		item_delete_project_;
	}
end

function get_leaf_menu()
	init()
	return {
		item_edit_information_;
		item_delete_project_;
	}
end
--------------------------------------------------------------------------------------------
--action function

item_add_contact_.action = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end


