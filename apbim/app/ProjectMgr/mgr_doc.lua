
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

function add_file()
end
function add_files()
end

function add_folder()
end

function create_gid()
end

function create_hid()
end

function edit_file()
end
function edit_folder()
end




