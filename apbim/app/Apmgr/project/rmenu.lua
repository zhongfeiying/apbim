

local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print = print
local table = table
local os_exit_ = os.exit
local pairs = pairs
local string = string

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M

_ENV = M

local language_ = require 'sys.language'
local cur_language_ = 'English'
local op_ = require 'app.apmgr.project.op'
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_create_project_ = {English = 'Create Project',Chinese = '创建工程'}
local title_properties_ = {English = 'Properties',Chinese = '属性'}
local title_create_ = {English = 'Create',Chinese = '创建'}
local title_file_  = {English = 'File',Chinese = '文件'}
local title_folder_ = {English = 'Folder',Chinese = '文件夹'}
local title_open_ = {English = 'Open',Chinese = '打开'}
local title_save_ = {English = 'Save',Chinese = '保存'}
local title_close_ = {English = 'Close',Chinese = '关闭'}
local title_delete_ = {English = 'Delete',Chinese = '删除'}
local title_edit_ = {English = 'Edit',Chinese = '编辑'}
local title_show_style_ = {English = 'Set Show Style',Chinese = '设置显示风格'}
local title_import_ = {English = 'Import',Chinese= '导入'}
local title_create_ = {English = 'Create',Chinese = '创建'}
local title_rename_ = {English = 'Rename',Chinese = '重命名'}
local title_link_to_ = {English = 'Link To ',Chinese = '链接到'} 
local title_link_to_exe_ = {English = 'Installable Program',Chinese = '可安装程序'}
local title_model_ = {English = 'Model',Chinese = '模型'}
local title_view_ = {English = 'View',Chinese = '视图'}
local title_submit_ = {English = 'Submit',Chinese = '提交'}
local title_load_ = {English = 'Loading',Chinese = '加载'}

local item_create_project_ = {}
local item_quit_ = {}
local item_open_project_ = {}
local item_save_project_ = {}
local item_close_project_ = {}
local item_delete_project_ = {}
local item_edit_project_ = {}
local item_show_style_ = {}
local item_import_ = {};
local item_import_file_ = {};
local item_import_folder_ = {};
local item_create_ = {};
local item_create_file_ = {};
local item_create_folder_ = {};
local item_properties_ = {}
local item_delete_= {}
local item_link_to_ = {};
local item_link_to_file_ = {};
local item_link_to_folder_ = {};
local item_link_to_exe_ = {};
local item_link_to_member_ = {};
local item_link_to_view_ = {};
local item_rename_ = {};
local item_edit_ = {};
local item_submit_project_ = {}
local item_open_ = {};

local function sub_import_items()
	return {
		item_import_folder_;
		item_import_file_;
	}
end
item_import_ = {submenu = sub_import_items}
local function sub_add_items()
	return {
		item_create_folder_;
		item_create_file_;
	}
end
item_create_ = {submenu = sub_add_items}

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
	item_close_project_.title = title_close_[cur_language_]
	item_create_project_.title = title_create_project_[cur_language_]
	item_open_project_.title = title_load_[cur_language_]
	item_save_project_.title = title_save_[cur_language_]
	item_quit_.title = title_close_[cur_language_]
	item_delete_project_.title = title_delete_[cur_language_]
	item_edit_project_.title = title_edit_[cur_language_]
	item_show_style_.title = title_show_style_[cur_language_]
	
	item_properties_.title = title_properties_[cur_language_]
	item_import_.title = title_import_[cur_language_]
	item_import_file_.title = title_file_[cur_language_]
	item_import_folder_.title = title_folder_[cur_language_]
	item_delete_.title = title_delete_[cur_language_]
	item_rename_.title = title_rename_[cur_language_]
	item_edit_.title = title_edit_[cur_language_]
	
	item_link_to_.title = title_link_to_[cur_language_]
	item_link_to_file_.title = title_file_[cur_language_]
	item_link_to_folder_.title = title_folder_[cur_language_]
	item_link_to_exe_.title = title_link_to_exe_[cur_language_]
	item_link_to_member_.title = title_model_[cur_language_]
	item_link_to_view_.title = title_view_[cur_language_]
	item_create_.title = title_create_[cur_language_]
	item_create_folder_.title = title_folder_[cur_language_];
	item_create_file_.title = title_file_[cur_language_];
	item_submit_project_.title = title_submit_[cur_language_];
	item_open_.title = title_open_[cur_language_];
end

function get_root()
	init()
	return {
		item_create_project_;
		'';
		item_quit_;
	}
end

function get_project()
	init()
	return {
		item_open_project_;
		'';
		item_save_project_;
		-- item_submit_project_;
		'';
		item_edit_project_;
		item_delete_project_;
		'';
		item_show_style_;
		item_properties_;
		'';
		item_close_project_;
	}
end

function get_folder()
	init()
	return {
		item_open_;
		'';
		item_create_;
		item_import_;
		'';
		item_rename_;
		item_edit_;
		item_delete_;
		'';
		item_properties_;
	}
end

function get_file()
	init()
	return {
		item_open_;
		'';
		item_rename_;
		item_edit_;
		item_delete_;
		'';
		item_link_to_;
		'';
		item_properties_;
	}
end
--------------------------------------------------------------------------------------------
--action function
item_quit_.action = op_.quit;
item_create_project_.action = op_.project_new;
item_open_project_.action = op_.project_open;
item_save_project_.action = op_.project_save;
item_submit_project_.action = op_.project_submit;
item_edit_project_.action = op_.edit_info;
item_delete_project_.action = op_.delete;
item_show_style_.action = op_.set_style;
item_properties_.action = op_.properties;
item_close_project_.action = op_.project_close;
