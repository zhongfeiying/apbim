local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local menu_ = require 'app.LoginPro.menu'
local toolbar_ = require 'app.LoginPro.toolbar'
function on_load()
	menu_.on_load()
	toolbar_.on_load()
end

function on_unload()
	menu_.on_unload()
	toolbar_.on_unload()
end

function on_update()
	menu_.on_update()
	toolbar_.on_update()
end

