
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
local tree_ = require 'app.ProjectMgr.apps.privates.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}
local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '添加日期'}
local title_sort_name_ = {English = 'Name',Chinese = '标题名称'}
local title_import_ = {English = 'Import',Chinese = '导入'}
local title_import_file_ = {English = 'File',Chinese = '文件'}
local title_import_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_import_id_ = {English = 'ID',Chinese = '文件ID'}
local title_add_ = {English = 'Add',Chinese = '添加'}
local title_add_file_  = {English = 'File',Chinese = '文件'}
local title_add_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_delete_project_ = {English = 'Delete',Chinese = '删除'}
local title_edit_information_ = {English = 'Edit',Chinese = '编辑'}
local title_server_ = {English = 'Server',Chinese = '服务器'}
local title_server_backup_ = {Englist = 'Backup',Chinese = '备份'}
local title_server_update_ = {English = 'Update',Chinese = '更新'}
local title_server_history_ = {English = 'Backup History',Chinese = '历史记录'}
local title_ins_ = {English = 'Insert',Chinese = '插入'}
local title_ins_file_  = {English = 'File',Chinese = '文件'}
local title_ins_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_link_to_ = {English = 'Link To ',Chinese = '链接到'} 
local title_link_to_file_ = {English = 'File',Chinese = '文件'} --可以链接到本地的文件、也可以链接到工程中的某个文件（变成快捷方式）
local title_link_to_folder_ = {English = 'Folder',Chinese = '文件夹'}-- 文件夹也一样
local title_link_to_exe_ = {English = 'Installable Program',Chinese = '可安装程序'}
local title_link_to_member_ = {English = 'Member',Chinese = '构件'}
local title_link_to_view_ = {English = 'View',Chinese = '视图'}
local title_save_ = {English = 'Save',Chinese = '保存'}


local item_sort_ = {};
local item_sort_date_ = {};
local item_sort_name_ = {};
local item_import_ = {};
local item_import_file_ = {};
local item_import_folder_ = {};
local item_import_id_ = {};
local item_add_ = {};
local item_add_file_ = {};
local item_add_folder_ = {};
local item_delete_project_ = {};
local item_edit_information_ ={};
local item_server_ = {};
local item_server_backup_ = {};
local item_server_update_ = {};
local item_server_history_ = {};
local item_save_ = {};
local item_ins_folder_ = {}
local item_ins_file_ = {}
local item_ins_ = {}
local item_link_to_ = {}
local item_link_to_folder_ = {}
local item_link_to_file_ = {};
local	item_link_to_member_ = {};
local	item_link_to_view_ = {};
local	item_link_to_exe_ = {};


--------------------------------------------------------------------------------------------------------
--item
local submenu_sort = function()
	return {
	item_sort_date_;
	item_sort_name_;
}
end
item_sort_ = {submenu = submenu_sort}
local function sub_add_items()
	return {
		item_add_folder_;
		item_add_file_;
	}
end
item_add_ = {submenu = sub_add_items}
local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
		'';
		item_import_id_;
	}
end
item_import_ = {submenu = sub_import_items}
local function sub_server_items()
	return {
		item_server_backup_;
		item_server_update_;
		'';
		item_server_history_;
	}
end
item_server_= {submenu = sub_server_items}
local function sub_ins_items()
	return {
		item_ins_folder_;
		item_ins_file_;
	}
end
item_ins_ = {submenu = sub_ins_items}

local function sub_link_to_items()
	return {
		item_link_to_folder_;
		item_link_to_file_;
		'';
		item_link_to_member_;
		item_link_to_view_;
		'';
		item_link_to_exe_;
	}
end
item_link_to_ = {submenu = sub_link_to_items}
--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_add_.title = title_add_[cur_language_]
	item_add_folder_.title = title_add_folder_[cur_language_]
	item_add_file_.title = title_add_file_[cur_language_]
	item_delete_project_.title = title_delete_project_[cur_language_]
	item_edit_information_.title = title_edit_information_[cur_language_]
	item_server_.title = title_server_[cur_language_]
	item_server_backup_.title = title_server_backup_[cur_language_]
	item_server_update_.title = title_server_update_[cur_language_]
	item_server_history_.title = title_server_history_[cur_language_]
	item_ins_.title = title_ins_[cur_language_]
	item_ins_folder_.title = title_ins_folder_[cur_language_]
	item_ins_file_.title = title_ins_file_[cur_language_]
	item_link_to_.title = title_link_to_[cur_language_]
	item_link_to_file_.title = title_link_to_file_[cur_language_]
	item_link_to_folder_.title = title_link_to_folder_[cur_language_]
	item_link_to_exe_.title = title_link_to_exe_[cur_language_]
	item_link_to_member_.title = title_link_to_member_[cur_language_]
	item_link_to_view_.title = title_link_to_view_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_import_file_.title = title_import_file_[cur_language_]
	item_import_folder_.title = title_import_folder_[cur_language_]
	item_import_id_.title = title_import_id_[cur_language_]
	item_save_.title = title_save_[cur_language_]
end

function get()
	init()
	return {
		item_save_;
		item_sort_;
		'';
		item_add_;
		item_import_;
		'';
		item_server_;
	}
end

function get_branch_menu()
	init()
	return {
		item_add_;
		item_ins_;
		item_import_;
		'';
		item_delete_project_;
		item_edit_information_;
		'';
		item_server_;
		'';
		item_link_to_;
	}
end

function get_leaf_menu()
	init()
	return {
		item_ins_;
		'';
		item_delete_project_;
		item_edit_information_;
		'';
		item_server_;
		'';
		item_link_to_;
	}
end
--------------------------------------------------------------------------------------------
--action function


