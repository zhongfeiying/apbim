local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local pairs = pairs
local print = print
local string = string
local type = type


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local tree_ = require 'app.projectmgr.workspace.projects.tree'
local control_create_project_ = require 'app.projectmgr.project.control_create_project'
local iup = require 'iuplua'

function create_project()
	local data = control_create_project_.pop()
	local t = data and data.data_tpl
	if type(t) == 'table' and t.SettingBaseInformation then 
		data.BaseInformation  = control_create_project_.next_pop(t.SettingBaseInformation)
		tree_.add_project(data)	
	end

end

function import_project()
	local dlgfile = iup.filedlg{dialogtype = 'OPEN',extfilter = 'APC File|*.apc|'}
	dlgfile:popup()
	local val = dlgfile.value 
	if not val then return end 
	local data = {name = 'test'}
	tree_.import_project{name = data.name}
end

function sort_time()
	local tree = tree_.get()
	local id = tree:get_tree_selected()
end

function sort_name()
	print('sort_name')
end

function statistics()
end


