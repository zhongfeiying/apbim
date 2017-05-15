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
local language_pack_path_ =  'app.ProjectMgr.project.language_create_project'
local language_ = require 'sys.language'

local path = 'app/projectmgr/templateFiles/'
local db_ ;

local function require_data_file(file)
	package_loaded_[file] = nil
	return require (file)
end

function get_cur_language()
	return language_.get()
end

function get_language_data()
	return require_data_file(language_pack_path_)
end
------------------------------------------------------------------------------------------------
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

--arg = {name,location,data_tpl}
function on_next(arg)
	db_ = arg
	local t = arg.data_tpl 
	print(t,t.SettingBaseInformation)
	if type(t) == 'table' and t.SettingBaseInformation then 
		local dlg_base_info = require_data_file(t.SettingBaseInformation)
		db_.data = dlg_base_info.main()
	end
end


