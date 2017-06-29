local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local appMenu_ =require 'app.Apmgr.menu'
local appToolbar_ = require 'app.Apmgr.toolbar'
local appWorkspace_ = require 'app.Apmgr.workspace'


function on_load()
	appMenu_.on_load()
	appToolbar_.on_load()
	appWorkspace_.on_load()
end

function on_unload()
	appMenu_.on_unload()
	appToolbar_.on_unload()
	appWorkspace_.on_unload()
end
