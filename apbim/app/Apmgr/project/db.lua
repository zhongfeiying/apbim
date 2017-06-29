local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local ipairs = ipairs
local pairs = pairs
local print = print

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local cache_ = {}
local project_path_ = 'Projects/'
local disk_ =  require 'app.Apmgr.disk'

function init()
	cache_ = {}
end

function get_projectlist()
	local t = disk_.get_folder_contents(project_path_)
	local project_files = {}
	for k,v in pairs(t) do 
		if type(v) == 'string' and string.lower(v) == 'apc' then 
			local name = string.sub(k,1,-5)
			table.insert(project_files,{name = name,path = project_path_ .. k})
		end
	end
	table.sort(project_files,function(a,b) return string.lower(a.name) < string.lower(b.name) end)
	return project_files
end

function index_gid_data(zipfile,gidFile)
	local data = {}
	local t =  disk_.zip_file_data(zipfile,gidFile)
	if type(t.Libs) =='table' and #t.Libs ~= 0 then 
		local curid = #t.Libs
		data = disk_.zip_file_data(zipfile,curid) or {}
		data.info = t.Libs[curid]
	end	
	return data
end

function index_hid_data(zipfile,gidFile)
	local data = {}
	local t =  disk_.zip_file_data(zipfile,gidFile)
	if type(t.Libs) =='table' and #t.Libs ~= 0 then 
		local curid = #t.Libs
		data = disk_.zip_file_data(zipfile,curid) or {}
		data.info = t.Libs[curid]
	end	
	return data
end

local function index_project_data(data)
	local t = disk_.zip_index(data.path)
	if type(t) ~= 'table' or not t.gid then return end 
	-- data.gid = t.gid
	-- local child_data = index_gid_data(data.path,t.gid)
	-- table.insert(data,child_data)
end

function get_project_list()
	local listData =  get_projectlist()
	-- for k,v in ipairs(listData) do 
		-- index_project_data(v)	
	-- end
	return listData
end









