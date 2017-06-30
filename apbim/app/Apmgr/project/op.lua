local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local pairs = pairs
local g_next_ = _G.next
local os_time_ = os.time
local print = print
local ipairs = ipairs

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
local luaext_ = require 'luaext'
local disk_ =  require 'app.Apmgr.disk'
local dlg_create_project_ =  require 'app.apmgr.dlg.dlg_create_project'
local dlg_info_ = require 'app.apmgr.dlg.dlg_info'
local project_db_ = require 'app.apmgr.project.db'
local tree_ =  require 'app.apmgr.project.tree'
local version_ = require 'app.Apmgr.version'
local temp_path_ = 'app/apmgr/temp/'
local caches_ = require 'app.Apmgr.project.caches'


local project_open_;

local function table_is_empty(t)
	return g_next_(t) == nil
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

local function get_project_data()
	local project_info;--{name,path,data,pop,open}
	local function on_next(warning,arg)
		local content = disk_.get_folder_contents('Projects/')
		for k,v in pairs(content) do 
			content[string.lower(k)] = true
		end
		local file = string.lower(arg.name) .. '.apc'
		if content[file] then warning() return end 
		project_info = arg
		return true
	end
	
	dlg_create_project_.pop{on_next = on_next,data = get_tpl_data()}
	if type(project_info) ~= 'table' then return end 
	project_info.data = project_info.data or {}
	local attributes,tpldata = project_info.data.attributes,project_info.data.structure
	if project_info.pop then 
		local function on_ok(arg)
			attributes = arg
		end
		dlg_info_.pop{data = attributes,on_ok = on_ok}
	end
	return project_info,tpldata,attributes
end

local function save_zipfile(zipfile,id,src)
	local file = src
	if type(src) == 'table' then 
		disk_.save_file(temp_path_ .. 'temp.lua',src)
		file = temp_path_ .. 'temp.lua'
	end
	disk_.create_project_file(zipfile,id,file)
end

local function save_hid_zipfile(zipfile,src)
	local file = temp_path_ .. 'temp.lua'
	disk_.save_file(file,src)
	local id = version_.hash_file(file)
	disk_.create_project_file(zipfile,id,file)
	return id
end
	
local function save_project_files(arg)
	if type(arg) ~= 'table' then return end 
	local zipfile = arg.zipfile
	local data = arg.data
	local function loop_data(data)
		for k,v in ipairs (data) do 
			if  v.id  then 
				save_zipfile(zipfile,v.id,v.data)
			else
				local hid = save_hid_zipfile(zipfile,v.data)
				if v.gid and data[v.gid] then 
					data[v.gid].data.hid = hid
				end
			end
		end
		for k,v in ipairs (data) do 
			if type(v) == 'table' and v.id and v.data then 
				save_zipfile(zipfile,v.id,v.data)
			end
		end
	end	
	loop_data(data)
end

local function get_gid_data(arg)
	return version_.gid_data(arg)
end

local function folder_hid_line(arg)
	return version_.folder_hid_data(arg)
end

local function project_turn_zipdata(arg)
	local saveData = {}
	saveData[arg.gid] = {id = arg.gid,data = get_gid_data{gid = arg.gid,name = arg.name,info = arg.info}}
	local data =arg.tpl or {}
	if type(data) == 'table' and not table_is_empty(data) then
		local function loop_structure_data(data,gid)
			local tempt = tempt or {}
			for k,v in ipairs(data) do 
				local attr = type(v) == 'table' and v.attributes
				if  type(attr) == 'table' then 
					local gid = luaext_.guid() 
					if #v  ~= 0  then 
						gid = gid .. '0'
						loop_structure_data(v,gid)
					else 
						gid = gid .. '1'
						-- table.insert(saveData,{data =tempt,gid = gid})
					end
					saveData[gid] = {id = gid,data = get_gid_data{gid = gid,name = attr.name,info = attr}}
					table.insert(tempt,folder_hid_line{name = attr.name,gid = gid})
				end
			end
			table.insert(saveData,{data =tempt,gid = gid})
		end
		loop_structure_data(data,arg.gid)
	end
	return saveData
end


function project_new()
	local project_info,tpldata,attributes = get_project_data()
	if type(project_info) ~= 'table' then return end 
	local gid = luaext_.guid() .. '0'
	local filename = project_info.name .. '.apc'
	local path = project_db_.get_project_path()
	local zipfile =  path.. filename
	disk_.create_project(zipfile,gid)
	tree_.add_project{name =  project_info.name,file = zipfile}
	local data = project_turn_zipdata{gid = gid,name = project_info.name,tpl = tpldata,info = attributes}
	save_project_files{zipfile = zipfile,data = data}
	if project_info.open then 
		-- project_open_()
	end
	
end

function project_open()
end
project_open_ = project_open

function project_save()
	
end

function project_delete()
end

function project_close()
end