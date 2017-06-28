
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local dir_ = require 'sys.dir'
local zip_ = require 'app.Apmgr.zip'

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

function zip_save(arg)
	-- return zip_file_data('__index.lua',zip)
end

function zip_save_file(zip,src,dst)
	-- return zip_file_data('__index.lua',zip)
end

