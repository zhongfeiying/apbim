local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print = print
local table = table
local string = string
local pairs = pairs



local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local language_ = require 'sys.language'
local cur_language_ = 'English'
local project_ = require 'app.projectmgr.project'
-- local tree_ = require 'app.ProjectMgr.workspace.projects.tree'
local op_ = require 'app.ProjectMgr.workspace.projects.op'



-- local tree_ = require 'app.ProjectMgr.workspace.projects.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
local language_support_ = {English = 'English',Chinese = 'Chinese'}

--------------------------------------------------------------------------------------------------------
-- define project list menu






--------------------------------------------------------------------------------------------------------
local title_create_project_ = {English = 'Create',Chinese = '创建工程'}
local title_import_project_ = {English = 'Import',Chinese = '导入工程'}--导入的工程，有可能是一个id也可能是一个本地工程包
local title_sort_ = {English = 'Sort',Chinese = '排序'}
local title_sort_date_ = {English = 'Date',Chinese = '创建时间'}
local title_sort_name_ = {English = 'Name',Chinese = '工程名称'}
local title_statistics_ = {English = 'Statistics',Chinese = '统计'}
local title_manage_ = {English = 'Manage',Chinese = '管理工程'}

local title_property_ = {English = 'Properties',Chinese = '属性'}

local title_create_ = {English = 'Create',Chinese = '创建'}
local title_create_file_  = {English = 'File',Chinese = '文件'}
local title_create_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_project_create_ = {English  = 'Create Folder',Chinese = '创建文件夹'}

local title_cooperate_ = {English = 'Cooperate',Chinese = '协同控制'}
local title_cooperate_start_ = {English = 'Start',Chinese = '发起协同'}
local title_cooperate_transfer_ = {English = 'Transfer Update',Chinese = '转让更新权'}
local title_cooperate_cancel_ = {English = 'Cancel Transfer',Chinese = '收回更新权'}
local title_cooperate_manage_ = {English = 'Manage',Chinese = '管理协同'}

local title_import_ = {English = 'Import',Chinese= '导入'}
local title_import_folder_ = {English = 'Folder',Chinese= '文件夹'}
local title_import_file_ = {English = 'File',Chinese= '文件'}
local title_import_id_ = {English = 'Id',Chinese= 'Id'}

local title_hide_project_ = {English = 'Hide',Chinese = '隐藏'}
local title_delete_project_ = {English = 'Delete',Chinese = '删除'}
local title_edit_information_ = {English = 'Edit',Chinese = '编辑'}
local title_save_project_ = {English = 'Save',Chinese = '保存'}

local title_version_ = {English = 'Version Manage',Chinese = '版本管理'}
local title_version_commit_ = {Englist = 'Commit',Chinese = '提交版本'}
local title_version_last_ = {English = 'Get Last',Chinese = '获取最新版'}
local title_version_tag_ = {English = 'Create Tag',Chinese = '创建里程碑'}
local title_version_history_ = {English = 'Show History',Chinese = '历史记录'}
local title_version_get_history_ = {English = 'Get History',Chinese = '获取某版本'}

local title_workflow_ = {English = 'Workflow',Chinese = '工作流'}
local title_workflow_create_ = {English = 'Create',Chinese = '创建'}
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
local title_link_to_member_ = {English = 'Model',Chinese = '模型'}
local title_link_to_view_ = {English = 'View',Chinese = '视图'}

local title_move_ =  {English = 'Move To',Chinese = '移动到'}
local title_move_persional_ =  {English = 'Private Folder',Chinese = '私人文件夹'}
local title_move_recycle_ =  {English = 'Recycle ',Chinese = '回收站'}


local title_archive_ = {English = 'Export',Chinese = '导出'}
local title_open_ = {English = 'Open',Chinese = '打开'}
local title_run_ = {English = 'Run',Chinese = '运行'}
local title_show_ = {English = 'Show',Chinese = '显示'}
local title_create_tpl_ = {English = 'Create Template',Chinese = '创建模板'}
local title_load_tpl_ = {English = 'Load Template',Chinese = '加载模板'}
local title_delete_tpl_ = {English = 'Delete Template',Chinese = '删除模板'}
local title_add_member_ = {English = 'Add Member',Chinese = '添加成员'}
local title_add_group_ = {English = 'Add Group',Chinese = '添加组'}
local title_delete_member_ = {English = 'Delete Member',Chinese = '删除成员'}
local title_model_show_ = {English = 'Show Model',Chinese = '显示模型'}
local title_model_import_ = {English = 'Import Model',Chinese = '导入模型'}


local item_create_project_ = {};
local item_import_project_ = {};
local item_sort_ = {};
local item_sort_date_ = {};
local item_sort_name_ = {};

local item_statistics_ = {};
local item_manage_ = {};
local item_property_ = {};

local item_create_ = {};
local item_create_file_ = {};
local item_create_folder_ = {};

local item_cooperate_ = {};
local item_cooperate_start_ = {};
local item_cooperate_transfer_ = {};
local item_cooperate_cancel_ = {};
local item_cooperate_manage_ = {};

local item_import_ = {};
local item_import_file_ = {};
local item_import_folder_ = {};
local item_import_id_ = {};

local item_hide_project_ = {};
local item_project_delete_ = {};
local item_project_edit_ = {};
local item_project_save_ = {};

local item_version_ = {};
local item_version_commit_ = {};
local item_version_last_ = {};
local item_version_history_ = {};
local item_version_tag_ = {};
local item_version_get_history_ = {}

--local item_workflow_;
local item_workflow_create_ = {}
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

local item_export_ = {} ;
local item_open_ = {};
local item_run_ = {};
local item_show_ = {}
local item_project_create_ = {};
local item_project_import_ = {};

local item_move_ = {}
local item_move_persional_ = {}
local item_move_recycle_ = {}

local item_create_tpl_ = {}
local item_load_tpl_ = {};
local item_delete_tpl_ = {};

local item_model_show_ = {}
local item_import_model_ = {}

local item_add_member_ = {}
local item_delete_member_ = {}
local item_add_group_ = {}


local function submenu_sort()
	return {
		item_sort_date_;
		item_sort_name_;
	}
end
item_sort_ = {submenu = submenu_sort}
local function sub_add_items()
	return {
		item_create_folder_;
		item_create_file_;
	}
end
item_create_ = {submenu = sub_add_items}

local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
		'';
		item_import_id_;
	}
end
local function sub_project_import_items()
	return {
		item_import_folder_;
		item_import_id_;
	}
end
item_import_ = {submenu = sub_import_items}
item_project_import_ = {submenu =sub_project_import_items }

local function sub_server_items()
	return {
		item_version_commit_;
		item_version_get_history_;
		item_version_last_;
		item_version_tag_;
		'';
		item_version_history_;
	}
end
item_version_= {submenu = sub_server_items}

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

local function sub_cooperate_items()
	return {
		item_cooperate_start_;
		'';
		item_cooperate_transfer_;
		item_cooperate_cancel_;
		'';
		item_cooperate_manage_;
	}
end
item_cooperate_ = {submenu = sub_cooperate_items}

local function sub_move_items()
	return {
		item_move_persional_;
		item_move_recycle_;
	}
end
item_move_ = {submenu = sub_move_items}

--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_create_project_.title = title_create_project_[cur_language_]
	item_import_project_.title = title_import_project_[cur_language_]
	item_sort_.title = title_sort_[cur_language_]
	item_sort_date_.title = title_sort_date_[cur_language_]
	item_sort_name_.title = title_sort_name_[cur_language_]
	item_statistics_.title = title_statistics_[cur_language_]
	
	item_property_.title = title_property_[cur_language_]
	item_create_.title = title_create_[cur_language_]
	item_create_folder_.title = title_create_folder_[cur_language_]
	item_create_file_.title = title_create_file_[cur_language_]
	item_cooperate_.title = title_cooperate_[cur_language_]
	item_hide_project_.title = title_hide_project_[cur_language_]
	item_project_delete_.title = title_delete_project_[cur_language_]
	item_project_edit_.title = title_edit_information_[cur_language_]
	item_project_save_.title = title_save_project_[cur_language_]
	
	item_version_.title = title_version_[cur_language_]
	item_version_commit_.title = title_version_commit_[cur_language_]
	item_version_last_.title = title_version_last_[cur_language_]
	item_version_tag_.title =  title_version_tag_[cur_language_]
	item_version_history_.title = title_version_history_[cur_language_]
	item_version_get_history_.title = title_version_get_history_[cur_language_]
	
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
	item_export_.title = title_archive_[cur_language_]
	item_open_.title = title_open_[cur_language_]
	item_run_.title = title_run_[cur_language_]
	item_show_.title = title_show_[cur_language_]
	item_project_create_.title = title_project_create_[cur_language_]
	item_project_import_.title = title_import_[cur_language_]
	
	item_cooperate_start_.title =  title_cooperate_start_[cur_language_]
	item_cooperate_transfer_.title =  title_cooperate_transfer_[cur_language_]
	item_cooperate_cancel_.title =  title_cooperate_cancel_[cur_language_]
	item_cooperate_manage_.title =  title_cooperate_manage_[cur_language_]
	
	item_move_.title = title_move_[cur_language_]
	item_move_persional_.title = title_move_persional_[cur_language_]
	item_move_recycle_.title = title_move_recycle_[cur_language_]
	item_workflow_create_.title = title_workflow_create_[cur_language_]
	
	item_create_tpl_.title = title_create_tpl_[cur_language_]
	item_load_tpl_.title = title_load_tpl_[cur_language_]
	item_delete_tpl_.title = title_delete_tpl_[cur_language_]
	
	item_add_member_.title = title_add_member_[cur_language_]
	item_add_group_.title = title_add_group_[cur_language_]
	item_delete_member_.title = title_delete_member_[cur_language_]
	
	item_model_show_.title = title_model_show_[cur_language_]
	item_import_model_.title = title_model_import_[cur_language_]
	item_workflow_start_.title = title_workflow_start_[cur_language_]
	item_workflow_commit_.title = title_workflow_commit_[cur_language_]
	item_workflow_stop_.title = title_workflow_stop_[cur_language_]
	item_workflow_status_.title = title_workflow_status_[cur_language_]
end

function get()
	init()
	return {
		item_create_project_;
		item_import_project_;
		'';
		item_sort_;
		'';
		item_show_;
		item_statistics_;
	}
end

function get_project_menu()
	init()
	return {
		item_project_create_;
		item_project_save_;
		'';
		item_project_import_;
		item_export_;
		'';
		item_project_edit_;
		item_project_delete_;
		item_hide_project_;
		'';
		item_version_;
		item_cooperate_;
		'';
		item_property_;
	}
end

function get_branch_menu()
	init()
	return {
		item_create_;
		-- item_ins_;
		item_import_;
		'';
		item_project_edit_;
		item_project_delete_;
		-- item_hide_project_;
		'';
		item_move_;
		-- item_link_to_;
		'';
		item_version_;
		item_cooperate_;
		'';
		item_property_;


	}
end

function get_leaf_menu()
	init()
	return {
		item_open_;
		-- '';
		-- item_ins_;
		'';
		item_project_edit_;
		item_project_delete_;
		-- item_hide_project_;
		'';
		item_move_;
		item_link_to_;
		'';
		item_version_;
		item_cooperate_;
		'';
		item_property_;
	}
end


function get_exe_menu()
	init()
	return {
		item_run_;
		'';
		item_project_edit_;
		item_project_delete_;
		'';
		item_version_;
		item_cooperate_;
		'';
		item_property_;
	}
end

function get_tpl_menu()
	init()
	return {
		item_create_tpl_;
		item_load_tpl_;
		item_delete_tpl_;
	}
end

function get_group_menu()
	init()
	return {
		item_add_member_;
		item_add_group_;
	}
end

function get_group_branch_menu()
	init()
	return {
		item_add_member_;
		item_delete_member_;
	}
end

function get_model_menu()
	init()
	return {
		item_model_show_;
		'';
		item_import_model_;
	}
end



function get_workstart_menu()
	init()
	return {
		item_workflow_create_;
		'';
		item_workflow_start_;
		item_workflow_commit_;
		item_workflow_stop_;
		'';
		item_workflow_status_;
	}
end
--------------------------------------------------------------------------------------------
--action function

item_create_.action = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end
-- root menu
item_create_project_.action = function() op_.create_project() end
item_import_project_.action = function() op_.import_project() end 
item_sort_name_.action = function() op_.sort_name() end 
item_sort_date_.action = function() op_.sort_time()  end 
item_statistics_.action = function() op_.statistics() end 
item_manage_.action = function() end 

-- project menu
item_project_create_.action = function() op_.project_create_folder()  end 
item_project_save_.action = function() op_.project_save()  end 
item_import_folder_.action = function() op_.import_folder()  end
item_import_id_.action = function() op_.import_id()  end
item_export_.action = function() op_.export()  end
item_project_edit_.action =  function() op_.project_edit()  end
item_project_delete_.action =  function() op_.project_delete()  end
item_version_commit_.action =  function() op_.version_commit()  end

item_property_.action = function() end
item_create_file_.action = function() end
item_create_folder_.action = function() end
item_cooperate_.action = function() end

item_import_file_.action = function() end
item_import_id_.action = function() end
item_hide_project_.action = function() end
item_project_delete_.action = function() end
item_project_edit_.action = function() end

item_version_commit_.action = function() end 
item_version_last_.action = function() end 
item_version_history_.action = function() end 
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
item_export_.action = function() print('item_export_') end


