
local string = string
local require  = require 
local pairs = pairs
local print = print
local table = table
local ipairs = ipairs
local loadfile = loadfile
local type = type
local tostring = tostring
local io_open_ = io.open
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local os_remove_ = os.remove

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local dir_ = require 'sys.dir'
local zip_ = require 'app.Apmgr.zip'
local code_ = require 'sys.api.code'

function serialize_to_str(data,key,t)
	local t = t or {};
	local curkey = key or 'db'
	
	local tempt = {}
	for k,v in pairs(data) do 
		if type(k) == 'number' or type(k) == 'string'  then 
			table.insert(tempt,k)
		end
	end
	table.sort(tempt,function(a,b) return tostring(a) < tostring(b) end )
	
	for k,key in ipairs (tempt) do 
		if type(key) == 'number' then 
			str = curkey .. '[' .. key .. ']'
		elseif type(key) == 'string' then 
			str = curkey .. '[\'' .. key .. '\']'
		end
		local v =data[key]
		if type(v) == 'table' then 
			table.insert(t,str .. ' = {};\n')
			serialize_to_str(v,str,t)
		elseif type(v) == 'string' then 	
			table.insert(t, str .. ' = \'' .. v .. '\';\n')
		elseif type(v) == 'number' and type(v) == 'boolean' then 
			table.insert(t,str .. ' = ' .. v .. ';\n')
		end
	end
	if not key  then 
		table.insert(t,1,curkey .. ' = {};\n')
		return table.concat(t,'')
	end
end

function save_file(file,data)
	code_.save{key = 'db',file = file,data = data}
end

function delete_file(file)
	os_remove_(file)
end

--file = 'a/b/c.lua'
function file_is_exist(file)
	return dir_.is_there(file)
end

--file = 'a.b.c',suffix = '.lua'
function datafile_is_exist(file,suffix)
	local suffix = suffix or '.lua'
	local file = string.gsub(file,'%.','/') .. '.lua'
	return file_is_exist(file)
end


function get_folder_contents(path)
	return dir_.get_name_list(path)
end

function zip_file_data(zip,fileId,path)
	local path = path or 'Files\\'
	local file = path .. fileId
	return zip_.read{zip = zip,file = file,key = 'db'}
end

function zip_index(zip)
	return zip_file_data(zip,'__index.lua')
end

function create_project(zipfile,gid)
	zip_.create(zipfile,'db = {};\ndb[\'gid\'] = \'' .. gid .. '\';\n')
end

function save_to_zipfile(zipfile,id,str)
	if type(str) ~= 'string' then return end 
	if not zipfile or not id then return end 
	local file = 'Files/' .. id
	local ar,close = zip_.open(zipfile)
	zip_.add(ar,file,'string',str)
	close()
end

local function read_string_from_file(file)
	local f = io_open_(file,'r')
	if not f then return end 
	local str = f:read("*all");
	f:close()
	return str
end

local function read_table_from_file(file)
	if file_is_exist(file) then 
		local info = {}
		local f = loadfile(file,'bt',info)
		if f then 
			f()
		end
		return info.db
	end
end

function read_file(file,state)
	if state and state == 'string' then 
		return read_string_from_file(file)
	else 
		return read_table_from_file(file)
	end
end

function read_zipfile(zipfile,file,state)
	if state and state == 'string' then 
		return zip_.read{zip = zipfile,file = file}
	else 
		return zip_.read{zip = zipfile,file =file,key = 'db'}
	end
end

function read_project(zipfile)
	return zip_index(zipfile)
end


