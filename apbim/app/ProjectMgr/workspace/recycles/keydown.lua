

local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

function rbtn()

end

function lbtn()

end

function dlbtn()

end
