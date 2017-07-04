local io_open_ = io.open
local package_loaded_ = package.loaded
local require  =require
local type = type
local print = print
local string = string
local loadfile = loadfile
local coroutine = coroutine
local trace_out = trace_out

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local code_ = require 'sys.api.code'
local lfs_ = require 'lfs'
local path_ = 'user/'

local user_ = {
	user = 'default';
	gid = '-1';
}
--arg = {user,gid}
function set(arg)
	user_ =  type(arg) == 'table' and arg or user_
	-- trace_out('set end = ')
	-- require 'sys.table'.totrace(user_)
end


function get()
	-- trace_out('get = ')
	-- require 'sys.table'.totrace(user_)
	return user_	
end

local function file_is_exist(file)
	local file = io_open_(file,'r')
	if file then file:close() return true end 
end

local function load_file(file)
		local info = {}
		local f = loadfile(file,'bt',info)
		if type(f) == 'function' then 
			f()
		end
		return info.db
end

function save_userinfo(db)
	if type(db) ~= 'table' or not db.gid then return end 
	local file = path_ .. db.gid .. '/'
	lfs_.mkdir(file)
	file = file  .. 'baseinfo.lua'
	db.pass = nil
	code_.save{file=file;data=db}
end

function get_userinfo()
	if not user_ then return end 
	local file = path_ .. user_.gid .. '/' .. 'baseinfo.lua'
	if  file_is_exist(file) then 
		return load_file(file)
	end
end
