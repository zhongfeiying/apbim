

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

local item_create_project_ = {}
local item_open_project_ = {}
local item_save_project_ = {}
local item_close_ = {}

--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_close_.title = title_close_[cur_language_]
	item_create_project_.title = title_create_project_[cur_language_]
	item_open_project_.title = title_open_[cur_language_]
	item_save_project_.title = title_save_[cur_language_]
	
end

function get_root()
	init()
	return {
		item_create_project_;
		'';
		item_close_;
	}
end

function get_project()
	init()
	return {
		item_save_project_;
		'';
		item_open_project_;
	}
end
--------------------------------------------------------------------------------------------
--action function

item_create_project_.action = op_.project_new;
item_open_project_.action = op_.project_open;
item_save_project_.action = op_.project_save;
item_close_.action = op_.project_close;
