local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local os_time_ = os.time

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local server_ = require 'app.projectmgr.net.server'
local default_path_ = 'app/projectmgr/data/'
local user_ = require 'sys.user'


local function save_data(file,data)
	require 'sys.api.code'.save{file =file,data = data,key = 'db'}
end

local function get_data(file)
	return require 'sys.io'.read_file{file =file,key = 'db'}
end

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

--arg = {name,gid,info}
local function get_project_baseinfo(arg)
	local data = {}
	data.gid = arg.gid 
	data.createTime = os_time_()
	data.name = arg.name
	local user =  user_.get().user
	data.owner =user
	data.writer = user
	data.versions = {}
	data.info = arg.info
	return data
end
--arg = {name,gid;info}
function create_project(arg)
	local file = default_path_ .. arg.gid
	local data = get_project_baseinfo(arg)
	save_data(file,data)
end




