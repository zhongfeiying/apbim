
local require  = require 
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local appMenu_ =require 'app.projectmgr.interface.menu'
local appToolbar_ = require 'app.projectmgr.interface.toolbar'
local appWorkspace_ = require 'app.projectmgr.interface.workspace'

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
