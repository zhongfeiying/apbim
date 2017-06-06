

local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local tree_ = require 'app.ProjectMgr.workspace.workspace.tree'

function rbtn()
	local tree = tree_.get()
	local id = tree_.get_current_id()
end

function lbtn()

end

function dlbtn()

end


