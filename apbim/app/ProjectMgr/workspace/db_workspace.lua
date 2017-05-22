local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_file'
local user_ = 'Sjy' -- require 'user'.get()

function init()
	package_loaded_[file] = nil
	data_ = require (file) or {}
end

function get()
	return data_
end

function add()
end

function edit()
end

function delete()
end




