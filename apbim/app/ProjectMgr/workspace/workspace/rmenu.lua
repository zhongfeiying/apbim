

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
local tree_ = require 'app.ProjectMgr.workspace.workspace.tree'
--[[
	local tree = tree_.get()
	local id = tree_.get_current_id()
--]]
--------------------------------------------------------------------------------------------------------
-- define var
local language_support_ = {English = 'English',Chinese = 'Chinese'}

local title_property_ = {English = 'Persional Information',Chinese = '个人信息'}
local title_change_pwd_ = {English = 'Change Password',Chinese = '修改密码'}
local title_logout_ = {English = 'Logout',Chinese = '登出'}
local title_change_user_ = {English = 'Change User',Chinese = '切换用户'}
local action_property_;
local action_change_pwd_;
local action_logout_;
local action_change_user_;
local item_property_;
local item_change_pwd_;
local item_logout_;
local item_change_user_;


--------------------------------------------------------------------------------------------------------
--item
item_property_ = {action = action_property_}
item_change_pwd_ = {action = action_change_pwd_}
item_change_user_ = {action = action_change_user_}
item_logout_ = {action = action_logout_}
--------------------------------------------------------------------------------------------------------
--api
local function init()
	local lan = language_.get()
	cur_language_=  lan and language_support_[lan] or 'English'
	item_property_.title = title_property_[cur_language_]
	item_change_pwd_.title = title_change_pwd_[cur_language_]
	item_change_user_.title = title_change_user_[cur_language_]
	item_logout_.title = title_logout_[cur_language_]
end

function get()
	init()
	return {
		item_property_;
		'';
		item_change_user_;
		item_change_pwd_;
		'';
		item_logout_;
	}
end
--------------------------------------------------------------------------------------------
--action function
local dlg_reg_ = require 'app.loginpro.dlg_register'
local dlg_login_ = require 'app.loginpro.dlg_login'
local dlg_cg_pwd_ = require 'app.loginpro.dlg_change_password'
action_property__ = function ()
	local function get_user_info()
		return {name = 'Sjy',Phone = '123'}
		--[[
		local file = 'a.lua'
		package_loaded_[file] = nil
		return require (file)
		--]]
	end
	local tree = tree_.get()
	local id = tree_.get_current_id()
	local userdata = tree:get_node_data()
	dlg_reg_.pop{data = get_user_info()}
end

action_change_pwd_ = function() 
	dlg_cg_pwd_.pop()
end 

action_change_user_ = function() 
	-- local lan = language_.get() 
	local lan ='Chinese'
	local function on_ok()
		require 'sys.main'.login_ok()
	end
	dlg_login_.pop{on_ok = on_ok,on_cancel = on_cancel,language = lan}
end 
action_logout_ = function() 
	-- save()
	-- close()
end 
