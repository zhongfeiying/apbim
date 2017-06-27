
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs =ipairs
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup_ = require 'iuplua'
require 'iupluacontrols'
local file_ =  require 'app.projectmgr.file'
function require_data_file(file)
	local file = string.lower(file)
	if  file_.datafile_is_exist(file) then 
		package_loaded_[file] = nil
		return require (file)
	end
end

local sys_workspace_ = require 'sys.workspace'
local workspace_ =  require 'app.projectmgr.workspace.main'
local app_file_ = 'app.projectmgr.app'
local app_path_ = 'app.projectmgr.apps.';
local server_ =  require 'app.projectmgr.net.server'


local var_workspace_;


local function init_control_data()
	return {
		hwnd = iup_.frame{
			iup_.vbox{
				workspace_.get_control();
				margin = '0x0';
				alignment = 'ALEFT';
			};
			tabtitle = 'Workspace';
		}
	}
end

local function init(cmd)
	cmd.set()
	cmd.init()
	cmd.init_tree_data()
end

local function load_project_list()
	workspace_.main()
	-- qinit(workspace_)
	
	var_workspace_ = init_control_data()
	sys_workspace_.add(var_workspace_)
end 

local function unload_project_list()
	if var_workspace_ then 
		sys_workspace_.delete(var_workspace_.hwnd)
		var_workspace_ = nil
	end
	
end

local function load_apps()
	local data = require_data_file(app_file_)
	for k,v in ipairs(data) do 
		local str = app_path_ .. v .. '.main'
		require (str).main()
	end
end

function on_load()
	load_project_list()
	server_.init_user_list{cbf = load_apps}
	
end

function on_unload()
	unload_project_list()
end


