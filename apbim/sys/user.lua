local io_open_ = io.open
local package_loaded_ = package.loaded
local require  =require
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local code_ = require 'sys.api.code'

local file_ = 'cfg/user.lua'
local require_file_ = 'cfg.user'
local default_ = 'Default'
local user_ = {}

local function save(file,t)
	code_.save{file=file;src=t}
end

local function get_data(file,require_file)
	local file =io_open_(file,'r')
	if file then 
		file:close()
		package_loaded_[require_file] = nil
		return   require (require_file) 
	end
end

function init(arg)
	if type(arg) == 'table' then 
		save(file_,arg)
	end 
end

function get()
	local file,require_file = file_,require_file_;
	local t =  get_data(file,require_file)
	if type(t) == 'table' and t.name then 
		return t.name
	end
	return default_
end

--arg = {user,gid}
function set(arg)
	user_ = arg
end

function get()
	return user_	
end
