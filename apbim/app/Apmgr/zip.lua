local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs = ipairs
local pairs = pairs
local type = type
local table = table
local string = string
local print = print


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local zip_ = require 'luazip'
local sys_zip_ = require 'sys.zip'
--arg = {zip=,file=,key=}
function read(arg)
	return sys_zip_.read(arg)
end