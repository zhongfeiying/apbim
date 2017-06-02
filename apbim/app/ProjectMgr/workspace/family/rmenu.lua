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
local tree_ = require 'app.ProjectMgr.workspace.family.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}
local title_search_ = {English = 'Search',Chinese = '²éÑ¯'}
local title_create_ = {English = 'Create',Chinese = '´´½¨'}
local title_edit_ = {English = 'Edit',Chinese = '±à¼­'}
local title_delete_ = {English = 'Delete',Chinese = 'É¾³ý'}

local item_search_ = {};
local item_create_ = {};
local item_edit_ = {};
local item_delete_ = {};

--------------------------------------------------------------------------------------------------------
--item


--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_search_.title = title_search_[cur_language_]
	item_create_.title = title_create_[cur_language_]
	item_delete_.title = title_delete_[cur_language_]
	item_edit_.title = title_edit_[cur_language_]
end

function get()
	init()
	return {
		item_search_;
		'';
		item_create_;
	}
end

function get_branch_menu()
	init()
	return {
		item_create_;
		'';
		item_edit_;
		item_delete_;
	}
end

function get_leaf_menu()
	init()
	return {
		item_edit_;
		item_delete_
	}
end
--------------------------------------------------------------------------------------------
--action function

