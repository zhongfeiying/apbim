local package_loaded_ = package.loaded
local require = require
local io_open_ =  io.open
local print = print
local type = type
local setmetatable = setmetatable
local loadfile = loadfile

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local lfs = require 'sys.lfs'
local code_ = require 'sys.api.code'
local crypto = require 'crypto'
local luaext_ = require 'luaext'
local server_ = require 'sys.net.main'
File = {
	--file 磁盘文件全路径
	--name 服务器存储文件名
	--data 要存储的数据表
}

--t = {name，file}
function File:new(t)
	t = type(t) == 'table' and t or {}
	setmetatable(t,self);
	self.__index = self;
	return t;
end

function File:set_file(file)
	self.file = file
end

function File:set_name(name)
	self.name = name
end

function File:get_data(data)
	self.data = data
end

function File:get_file()
	return self.file 
end

function File:get_name()
	return self.name
end

function File:get_data()
	return self.data
end

--arg = {file,name,data}
function File:init(arg)
	arg = type(arg) == 'table' and arg or {}
	self:set_file(arg.file)
	self:set_name(arg.name)
	self:set_data(arg.data)
end

function File:save(file,data)
	local file = file or self:get_file()
	local data = data or self.get_data()
	code_.save{file =file,data =data,key = 'db'}
end

function File:get(file)
	local file =file or self.file
	local info = {}
	local f = loadfile(file,'bt',info)
	if type(f) == 'function' then 
		f()
		if info.db then 
			return info.db
		end
	end
	return {}
end

function File:upload(name,file)
	local file = file or self:get_file()
	local name = name or self:get_name()
	if not file or not name then return end
	server_.send_file(name,file)
end


function File:download(name,file)
	local file = file or self:get_file()
	local name = name or self:get_name()
	if not file or not name then return end
	server_.get_file(name,file)
end
