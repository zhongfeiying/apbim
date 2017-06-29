local string = string
local require  = require 
local pairs = pairs
local print = print
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local project_;
local saves_;

function init()
	saves_ = {};
	project_ = nil;
end
--arg = {name,path,gid}
function set(arg)
	project_ = arg
	saves_[gid] = {}
end

function get()
	return project_
end

--arg = {gid,link,}
function add(gid,arg)
end
