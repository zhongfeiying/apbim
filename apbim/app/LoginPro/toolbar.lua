

local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local toolbar_ = require 'sys.toolbar'

function on_load()
end


function on_unload()
end

function on_update()
end


