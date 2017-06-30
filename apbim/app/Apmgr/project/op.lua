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
	local attributes = project_info.data.attributes
	if project_info.pop then 
		local function on_ok(arg)
			attributes = arg
		end
		dlg_info_.pop{data = attributes,on_ok = on_ok}
	end
	return project_info,attributes
end

local function save_zip_file(zipfile,data,id)
	disk_.save_file(temp_path_ .. 'temp.lua',data)
	disk_.create_project_file(zipfile,id,temp_path_ .. 'temp.lua')
	disk_.delete_file(temp_path_ .. 'temp.lua')
end

local function create_folder_versions(gid,data)
	
end

local function project_import_tpl(arg)
	local data = arg.data
	local zipfile = arg.zipfile
	local db = {}
	for k,v in ipairs(data) do 
		if type(v) == 'table' then 
			local t = {}
			t.gid =  luaext_.guid() .. '0'
			t.name = v.title
			t.hid = '-1'
			table.insert(db,t)
			save_zip_file(zipfile,t.gid,data)
		end
	end
	disk_.save_file(temp_path_ .. 'temp.lua',db)
	local hash = version_.hash_file(temp_path_ .. 'temp.lua') .. '0'
	disk_.create_project_file(zipfile,hash,temp_path_ .. 'temp.lua')
	disk_.delete_file(temp_path_ .. 'temp.lua')
	
	local ver_data = version_.gid_version_data{hid = hash,name =arg.name }
	local gid_data = disk_.zip_file_data(zip,arg.gid)
	gid_data.versions = gid_data.versions or {}
	table.insert(gid_data.versions,hash)
	gid_data.versions[hash] = ver_data
	
	disk_.save_file(temp_path_ .. 'temp.lua',gid_data)
	disk_.create_project_file(zipfile,arg.gid,temp_path_ .. 'temp.lua')
	disk_.delete_file(temp_path_ .. 'temp.lua')
end

local function hid_line(arg)
	return {
		gid = arg.gid;
		hid = arg.hid or '-1';
		name =arg.name;
	}
end


--[[
	data = {
		{
			attributes = {gid,name,hid,gidinfo ={},};
		}
	}
--]]
local function save_project_files(arg)
	if type(arg) ~= 'table' then return end 
	local gid = arg.gid
	local zipfile = arg.zipfile
	local data = arg.data
	
	local waitting_save_files = {}
	local function loop_structure_data(data,gid)
		-- folder_hid_files[gid] = folder_hid_files[gid]  or {}
		-- folder_hid_files[gid].hid = folder_hid_files[gid].hid or {}
		-- for k,v in ipairs(data) do 
			-- local t = v.attributes or {}
			-- local data = folder_hid_line{gid = t.gid,name = t.name,hid = t.hid,state = t.state}
			-- table.insert( folder_hid_files[gid].hid,data)
			-- folder_hid_files[gid].info = t.gidinfo
			-- loop_structure_data(v,data.gid)
		-- end
		waitting_save_files[gid]  = {}
		waitting_save_files[gid].gidinfo = {}
		if string.sub(gid,-1,-1) == '0' then 
			waitting_save_files[gid].hid = {}
			for k,v in ipairs(data) do 
				-- local t = v.attributes or {}
				-- local data = folder_hid_line{gid = t.gid,name = t.name,hid = t.hid,state = t.state}
				-- table.insert( folder_hid_files[gid].hid,data)
				-- folder_hid_files[gid].info = t.gidinfo
				-- loop_structure_data(v,data.gid)
			end
		else 
			waitting_save_files[gid].hid = {}
		end
	end	
	loop_structure_data(arg.data,gid)
end



function project_new()
	local project_info,attributes = get_project_data()
	if type(project_info) ~= 'table' then return end 
	local gid = luaext_.guid() .. '0'
	local filename = project_info.name .. '.apc'
	local path = project_db_.get_project_path()
	local zipfile =  path.. filename
	disk_.create_project(zipfile,gid)
	tree_.add_project{name =  project_info.name,file = zipfile}
	if type(project_info.structure) == 'table' and not table_is_empty(project_info.structure) then
		-- save_project_files{gid = gid,zipfile = zipfile,data = project_info.structure}
		-- versions = project_import_tpl{name =project_info.name,zipfile=zipfile,data =project_info.structure,gid =  gid}
	end
	-- disk_.create_project_file(zipfile,gid,version_.gid_data{gid = gid,name = project_info.name,attributes = attributes,versions = versions})
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