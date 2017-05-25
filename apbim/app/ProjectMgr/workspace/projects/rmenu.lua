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
local language_support_ = {English = 'English',Chinese = 'Chinese'}

--------------------------------------------------------------------------------------------------------
-- define project list menu

local title_create_ = {English = 'Create',Chinese = '创建工程'}
local title_import_project_ = {English = 'Import',Chinese = '导入工程'}--导入的工程，有可能是一个id也可能是一个本地工程包
local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '添加时间'}
local title_sort_name_ = {English = 'Name',Chinese = '标题名称'}
local title_statistics_ = {English = 'Statistics',Chinese = '统计'}
local title_manage_ = {English = 'Manage',Chinese = '管理工程'}

local action_create_;
local action_import_project;
local action_sort_name_;
local action_sort_date_;
local action_statistics_;
local action_manage_;

local item_create_;
local item_import_project_;
local item_sort_;
local item_sort_date_;
local item_sort_name_;
local item_statistics_;
local item_manage_;

item_create_ = {action = action_create_}
item_import_project_ = {action = action_import_project}
item_sort_date_ = {action = action_sort_date_}
item_sort_name_ = {action = action_sort_name_}
item_statistics_ = {action = action_statistics_}
item_manage_ = {action = action_manage_}
local function submenu_sort()
	return {
		item_sort_date_;
		item_sort_name_;
	}
end
item_sort_ = {submenu = submenu_sort}

--------------------------------------------------------------------------------------------------------
local title_information_ = {English = 'Information',Chinese = '工程信息'}
local title_add_ = {English = 'Add',Chinese = '添加'}
local title_add_file_  = {English = 'File',Chinese = '文件'}
local title_add_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_chmod_ = {English = 'Cooperate',Chinese = '协同控制'}
local title_import_ = {English = 'Import',Chinese= '导入'}
local title_import_folder_ = {English = 'Folder',Chinese= '文件夹'}
local title_import_file_ = {English = 'File',Chinese= '文件'}
local title_import_id_ = {English = 'Id',Chinese= '文件Id'}
local title_hide_project_ = {English = 'Hide',Chinese = '隐藏'}
local title_delete_project_ = {English = 'Delete',Chinese = '删除'}
local title_edit_information_ = {English = 'Edit',Chinese = '编辑'}

local action_information_;
local action_add_file_;
local action_add_folder_;
local action_chmod_;
local action_import_folder_;
local action_import_file_;
local action_import_id_;
local action_hide_project_;
local action_delete_project_;
local action_edit_information_;

local item_information_;
local item_add_;
local item_add_file_;
local item_add_folder_;
local item_chmod_;
local item_import_;
local item_import_file_;
local item_import_folder_;
local item_import_id_;
local item_hide_project_;
local item_delete_project_;
local item_edit_information_;

item_information_ = {action = action_information_}
local function sub_add_items()
	return {
		item_add_folder_;
		item_add_file_;
	}
end
item_add_ = {submenu = sub_add_items}
item_add_folder_ = {action = action_add_folder_}
item_add_file_ = {action = action_add_file_}
item_chmod_ = {action = action_chmod_}
local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
		'';
		item_import_id_;
	}
end
item_import_ = {submenu = sub_import_items}
item_import_folder_ = {action = action_import_folder_}
item_import_file_ = {action = action_import_file_}
item_import_id_ = {action = action_import_id_}
item_hide_project_ = {action = action_hide_project_}
item_delete_project_ = {action = action_delete_project_}
item_edit_information_= {action = action_edit_information_}
--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_create_.title = title_create_[cur_language_]
	item_import_project_.title = title_import_project_[cur_language_]
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_statistics_.title = title_statistics_[cur_language_]
	
	item_information_.title = title_information_[cur_language_]
	item_add_.title = title_add_[cur_language_]
	item_add_folder_.title = title_add_folder_[cur_language_]
	item_add_file_.title = title_add_file_[cur_language_]
	item_chmod_.title = title_chmod_[cur_language_]
	item_hide_project_.title = title_hide_project_[cur_language_]
	item_delete_project_.title = title_delete_project_[cur_language_]
	item_edit_information_.title = title_edit_information_[cur_language_]
end

function get()
	init()
	return {
		item_create_;
		item_import_project_;
		'';
		item_manage_;
		item_sort_;
		'';
		item_statistics_;
	}
end

function get_project_menu()
	init()
	return {
		item_add_;
		item_import_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_chmod_;
		item_information_;
	}
end
--------------------------------------------------------------------------------------------
--action function

action_create_ = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end

action_import_project = function() end 
action_sort_name_ = function() end 
action_sort_date_ = function() end 
action_statistics_ = function() end 
action_manage_ = function() end 


action_information_ = function() end
action_add_file_ = function() end
action_add_folder_ = function() end
action_chmod_ = function() end
action_import_folder_ = function() end
action_import_file_ = function() end
action_import_id_ = function() end
action_hide_project_ = function() end
action_delete_project_ = function() end
action_edit_information_ = function() end
