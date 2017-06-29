
local string = string
local require  = require 
local pairs = pairs
local print = print
local table = table
local ipairs = ipairs
local type = type
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

local function serialize_to_str(data,key,t)
	local t = t or {};
	local curkey = key or 'db'
	
	for k,v in pairs(data) do 
		local str;
		if type(k) == 'number' then 
			str = curkey .. '[' .. k .. ']'
		elseif type(k) == 'string' then 
			str = curkey .. '[\'' .. k .. '\']'
		end
		if str then 
			if type(v) == 'table' then 
				table.insert(t,str .. ' = {};\n')
				serialize_to_str(v,str,t)
			elseif type(v) == 'string' then 	
				table.insert(t, str .. ' = \'' .. v .. '\';\n')
			elseif type(v) == 'number' and type(v) == 'boolean' then 
				table.insert(t,str .. ' = ' .. v .. ';\n')
			end
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
	return zip_.read{zip = zip,file = file}
end

function zip_index(zip)
	return zip_file_data(zip,'__index.lua')
end

function create_project(zipfile,gid)
	zip_.create(zipfile,'db = {};\ndb[\'gid\'] = \'' .. gid .. '\';\n')
end



function create_project_file(zipfile,id,src)
	local ar,close = zip_.open(zipfile)
	local mode = 'file'
	if type(src) == 'table' then 
		mode = 'string'
		src = serialize_to_str(src)
	end
	local file = 'Files/' .. id
	zip_.add(ar,file,mode,src)
	close()
end

function copy_file(OldFile,NewFile) 
	-- return file_op_.copy_file(OldFile,NewFile) 
end 

