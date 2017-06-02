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



local item_create_ = {};
local item_import_project_ = {};
local item_sort_ = {};
local item_sort_date_ = {};
local item_sort_name_ = {};
local item_statistics_ = {};
local item_manage_ = {};

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
local title_save_project_ = {English = 'Save',Chinese = '保存'}
local title_server_ = {English = 'Server',Chinese = '服务器'}
local title_server_backup_ = {Englist = 'Backup',Chinese = '备份'}
local title_server_update_ = {English = 'Update',Chinese = '更新'}
local title_server_history_ = {English = 'Backup History',Chinese = '历史记录'}
local title_workflow_ = {English = 'Workflow',Chinese = '工作流'}
local title_workflow_start_ = {English = 'Start',Chinese = '启动'}
local title_workflow_stop_ = {English = 'Stop',Chinese = '停止'}
local title_workflow_commit_ = {English = 'Commit',Chinese = '提交'}
local title_workflow_status_ = {English = 'Status',Chinese = '状态'}
local title_personal_folder_ = {English = 'Personal Folder',Chinese = '私人文件夹'}
local title_add_to_ = {English = 'Add To ',Chinese = '添加到'}
local title_ins_ = {English = 'Insert',Chinese = '插入'}
local title_ins_file_  = {English = 'File',Chinese = '文件'}
local title_ins_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_link_to_ = {English = 'Link To ',Chinese = '链接到'} 
local title_link_to_file_ = {English = 'File',Chinese = '文件'} --可以链接到本地的文件、也可以链接到工程中的某个文件（变成快捷方式）
local title_link_to_folder_ = {English = 'Folder',Chinese = '文件夹'}-- 文件夹也一样
local title_link_to_exe_ = {English = 'Installable Program',Chinese = '可安装程序'}
local title_link_to_member_ = {English = 'Member',Chinese = '构件'}
local title_link_to_view_ = {English = 'View',Chinese = '视图'}

local title_archive_ = {English = 'Archive',Chinese = '归档'}

local item_information_ = {};
local item_add_ = {};
local item_add_file_ = {};
local item_add_folder_ = {};
local item_chmod_ = {};
local item_import_ = {};
local item_import_file_ = {};
local item_import_folder_ = {};
local item_import_id_ = {};
local item_hide_project_ = {};
local item_delete_project_ = {};
local item_edit_information_ = {};
local item_save_project_ = {};
local item_server_ = {};
local item_server_backup_ = {};
local item_server_update_ = {};
local item_server_history_ = {};
--local item_workflow_;
local item_workflow_start_ = {};
local item_workflow_stop_ = {};
local item_workflow_status_ = {};
local item_workflow_commit_ = {};
local item_personal_folder_ = {};
local item_ins_ = {};
local item_ins_folder_ = {};
local item_ins_file_ = {};
local item_link_to_ = {};
local item_link_to_file_ = {};
local item_link_to_folder_ = {};
local item_link_to_exe_ = {};
local item_link_to_member_ = {};
local item_link_to_view_ = {};
local item_archive_ = {} ;

item_information_ = {action = item_information_.action}
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

local function sub_workflow_items()
	return {
		item_workflow_start_;
		item_workflow_commit_;
		item_workflow_stop_;
		'';
		item_workflow_status_;
	}
end
item_workflow_ = {submenu = sub_workflow_items}

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
	item_save_project_.title = title_save_project_[cur_language_]
	item_server_.title = title_server_[cur_language_]
	item_server_backup_.title = title_server_backup_[cur_language_]
	item_server_update_.title = title_server_update_[cur_language_]
	item_server_history_.title = title_server_history_[cur_language_]
	item_personal_folder_.title = title_personal_folder_[cur_language_]
	item_ins_.title = title_ins_[cur_language_]
	item_ins_folder_.title = title_ins_folder_[cur_language_]
	item_ins_file_.title = title_ins_file_[cur_language_]
	item_link_to_.title = title_link_to_[cur_language_]
	item_link_to_file_.title = title_link_to_file_[cur_language_]
	item_link_to_folder_.title = title_link_to_folder_[cur_language_]
	item_link_to_exe_.title = title_link_to_exe_[cur_language_]
	item_link_to_member_.title = title_link_to_member_[cur_language_]
	item_link_to_view_.title = title_link_to_view_[cur_language_]
	item_manage_.title = title_manage_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_import_file_.title = title_import_file_[cur_language_]
	item_import_folder_.title = title_import_folder_[cur_language_]
	item_import_id_.title = title_import_id_[cur_language_]
	item_archive_.title = title_archive_[cur_language_]
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
		item_save_project_;
		'';
		item_add_;
		item_import_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_archive_;
		item_information_;
	}
end

function get_branch_menu()
	init()
	return {
		item_add_;
		item_ins_;
		item_import_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_personal_folder_;
		item_link_to_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_information_;


	}
end

function get_leaf_menu()
	init()
	return {
		item_ins_;
		'';
		item_edit_information_;
		item_delete_project_;
		item_hide_project_;
		'';
		item_personal_folder_;
		item_link_to_;
		'';
		item_server_;
		'';
		item_chmod_;
		item_information_;
	}
end
--------------------------------------------------------------------------------------------
--action function

item_create_.action = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end

item_import_project_.action = function() end 
item_sort_name_.action = function() end 
item_sort_date_.action = function() end 
item_statistics_.action = function() end 
item_manage_.action = function() end 


item_information_.action = function() end
item_add_file_.action = function() end
item_add_folder_.action = function() end
item_chmod_.action = function() end
item_import_folder_.action = function() end
item_import_file_.action = function() end
item_import_id_.action = function() end
item_hide_project_.action = function() end
item_delete_project_.action = function() end
item_edit_information_.action = function() end
item_save_project_.action = function() end
item_server_backup_.action = function() end 
item_server_update_.action = function() end 
item_server_history_.action = function() end 
item_workflow_start_.action = function() end 
item_workflow_stop_.action = function() end 
item_workflow_commit_.action = function() end 
item_workflow_status_.action = function() end 
item_ins_file_.action = function() end 
item_ins_folder_.action = function() end 
item_link_to_file_.action= function() end 
item_link_to_folder_.action = function() end 
item_link_to_exe_.action = function() end 
item_link_to_member_.action = function() end 
item_link_to_view_.action = function () end 
item_personal_folder_.action = function() end 
item_archive_.action = function() print('item_archive_') end


