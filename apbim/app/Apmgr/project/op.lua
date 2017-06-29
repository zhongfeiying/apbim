local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local pairs = pairs

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M


local function require_data_file(file)
	package_loaded_[file] = nil
	return require (file)
end

local lfs = require 'lfs'
local disk_ =  require 'app.Apmgr.disk'
local dlg_create_project_ =  require 'app.apmgr.dlg.dlg_create_project'
local dlg_info_ = require 'app.apmgr.dlg.dlg_info'





function get()
	local tempt = init_files()
	table.sort(tempt,function(a,b) return a<b end)
	table.insert(tempt,1,'Null')
	tempt['Null'] = {}
	return tempt
end

local function get_tpl_data()
	local path = 'app/apmgr/tpl/'
	local require_path = string.gsub(path,'/','.')
	local t = disk_.get_folder_contents(path)
	local data = {}
	for k,v in pairs(t) do 
		local name = string.sub(k,1,-5)
		local str = require_path ..  name
		local t = require_data_file(str)
		table.insert(data,t)
	end
	table.sort(data,
		function (a,b)
			if a.name and b.name then
				return string.lower(a.name) < string.lower(b.name)
			end
		end
	)
	table.insert(data,1,{name = 'Null'})
	return data
end

function project_new()
	local data;
	local function on_next(arg)
		data = arg
	end
	dlg_create_project_.pop{on_next = on_next,data = get_tpl_data()}
	if type(data) ~= 'table' then return end 
	-- dlg_info_.pop{}
	-- local gid = luaext_.guid() .. '0'
	-- tree_.add_project{gid = gid,name = data.name}
end

function project_open()
end

function project_save()
end

function project_delete()
end

function project_close()
end