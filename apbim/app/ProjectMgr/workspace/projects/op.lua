local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local pairs = pairs
local print = print
local string = string
local type = type
local os_time_ = os.time


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local tree_ = require 'app.projectmgr.workspace.projects.tree'
local control_create_project_ = require 'app.projectmgr.project.control_create_project'
local server_ =  require 'app.projectmgr.net.server'
local cache_db_ =   require 'app.projectmgr.net.cache_db'
local db_ =  require 'app.projectmgr.workspace.projects.db'
local iup = require 'iuplua'
local dlg_add_ = require 'app.projectmgr.interface.dlg_add'
local luaext_ = require 'luaext'
local sys_lfs_ = require 'sys.lfs'
local user_ = require 'sys.user'

--arg = {title,path,status}
local function create_baseinformation(arg)
	local data = {}
	data.gid = luaext_.guid() .. (status and status == 'leaf' and 1 or 0)
	data.createTime = os_time_()
	data.name = arg.title
	data.path = arg.path
	data.owner = user_.get().user
	return data
end


function create_project()
	local data = control_create_project_.pop()
	if type(data) ~= 'table' then return end 
	local tplData = data and data.tpl
	local defaultBaseInfoDlg=  'app.projectmgr.project.dlg_base_information'
	local dlgStr = tplData.dlg or defaultBaseInfoDlg
	local info = control_create_project_.next_pop(dlgStr)
	local t =create_baseinformation(data)
	server_.userlist_add_project{gid = t.gid,name = t.name}
	tree_.add_project{gid = t.gid,name = t.name}
	db_.create_project{}
	cache_db_.add(file,data)
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

