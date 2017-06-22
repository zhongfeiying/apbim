local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_projects_file'
local user_ = require 'sys.user'
local default_path_ = 'app/projectmgr/data/'

local function init_data()
	local user = user_.get()
	local file = default_path_ .. user.gid
	local data = require"sys.io".read_file{file=file,key = 'db'};
	if not data or not data.projects then return {} end 
	return data.projects
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return data_
end

function add(arg)
end

function edit(arg)
end

function delete(arg)
end




