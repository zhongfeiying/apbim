
local require  = require 
local g_load_ = load
local package_loaded_ = package.loaded
local load = nil
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local menu_ =  require 'sys.menu'
local project_ =  require 'app.projectmgr.project'

function on_load()
	menu_.add{
		keyword = 'AP.ProjectMgr.Project.New';
		action = project_.new;
		name = 'File.ProjectMgr.New';
		view = true;
		frame = true;
	}
end


	