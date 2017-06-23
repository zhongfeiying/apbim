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

local server_ = require 'app.projectmgr.net.server'
local user_ = require 'sys.user'


local function init_data()

	local data = server_.get_user_list()
	if not data or not data.projects then return {} end 
	return data.projects
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	-- package_loaded_[file] = nil
	-- data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
	data_ = init_data()
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

function add_project()
	local data = server_.get_user_list()
	data.projects = data.projects or {}
	table.insert(data.projects,{name = data.name,gid = data.gid})
	server_.save_user_list(data)
end




