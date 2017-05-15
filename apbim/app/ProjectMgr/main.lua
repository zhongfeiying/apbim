
local require  = require 
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local require_ =  require 'app.projectmgr.require_file'
local appMenu_ = require_.app_menu() 
local appToolbar_ = require_.app_toolbar() 
local appWorkspace_ = require_.app_workspace() 

function on_load()
	appMenu_.on_load()
	appToolbar_.on_load()
	appWorkspace_.on_load()
end

function on_unload()
	-- appMenu_.on_load()
	-- appToolbar_.on_load()
	-- appWorkspace_.on_load()
end
