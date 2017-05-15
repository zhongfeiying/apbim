local print = print
local require  = require 
local package_loaded_ = package.loaded
local string = string
local pairs = pairs
local type = type
local table = table


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local lfs = require 'lfs'

local path = 'templateFiles/'
local db_ ;

local function require_data_file(file)
	package_loaded_[file] = nil
	return require (file)
end

local function init_files()
	local t = {}
	for file in lfs.dir(path) do 
		local fileAttr = lfs.attributes(path .. file) 
		if fileAttr and fileAttr.mode == 'file' and file ~= '__index.lua' then 
			local name,require_path = string.sub(file,1,-5),string.gsub(path,'/','.')
			if string.sub(require_path,-1,-1) ~= '.' then 
				require_path = require_path .. '.'
			end
			local str = require_path ..  name
			t[file] = require_data_file(str)
		end
	end 
	return t
end 

function init()
	db_ = {}
	local tempt = init_files()
	for k,v in pairs(tempt) do 
		if type(v) =='table' and v.name then 
			db_[v.name] = v
			table.insert(db_,v.name)
		end
	end
end

function get_data()
	return db_
end

function on_next()
	
end


