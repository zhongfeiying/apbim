--[[
local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
--]]
--local require_ = require 'app.ProjectMgr.require_file'
require 'iup_dev'
function pop()
--	local dlg =	require_.dlg_create_project()
--	local op_ = require_.op_create_project()
	local dlg =	require 'dlg'
	local op =	require 'op'
	local language = require 'language'
	op.init()
	dlg.pop{
		data = op.get_data();
		on_next = op.on_next;
		languagePack = language;
		language = 'English'
	}
end

pop()


