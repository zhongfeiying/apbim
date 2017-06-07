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
local dlg_add_ = require 'app.projectmgr.interface.dlg_add'
local sys_lfs_ = require 'sys.lfs'

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

--------------------------------------------------------
function project_create_folder()
	local title;
	dlg_add_.pop{set_data = function (str) title = str  end }
	if not title then return end 
	tree_.create_folder{name = title}
end

function project_save()
	print('save !')
end

function import_folder()
	local dlgfile = iup.filedlg{dialogtype = 'DIR'}
	dlgfile:popup()
	local val = dlgfile.value 
	if not val then return end 
	if string.sub(val,-1,-1) ~= '\\' then 
		val = val .. '\\'
	end
	val  = string.gsub(val,'\\','/')
	local t = sys_lfs_.get_folder_content(val,true,true)
	tree_.import_folder(t)
end

function import_id(id)
	if string.sub(id,-1,-1) == '1' then return end 
end

function export()
		print('export')
end

function project_edit()
	print('project_edit')
end

function project_delete()
	print('project_delete')
end

function version_commit()
	print('version_commit')
	-- check_all
	
end

