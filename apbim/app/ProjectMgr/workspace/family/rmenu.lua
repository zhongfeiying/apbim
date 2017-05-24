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
local title_search_ = {English = 'Search',Chinese = '≤È—Ø'}
local title_save_ = {English = 'Save',Chinese = '±£¥Ê'}
local action_search_;
local action_save_;
local item_search_;
local item_save_;

--------------------------------------------------------------------------------------------------------
--item
item_search_ = {action = action_search_}
item_save_ = {action = action_save_}


--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_search_.title = title_search_[cur_language_]
	item_save_.title = title_save_[cur_language_]
end

function get()
	init()
	return {
		item_search_;
		'';
		item_save_;
	}
end
--------------------------------------------------------------------------------------------
--action function

action_search_ = function ()
	local tree = tree_.get()
	local id = tree_.get_current_id()
	--do something
end
 
action_save_ = function()
end
