local print = print
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
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

local path = 'app/projectmgr/template/'

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
			local tab = require_data_file(str)
			t[file] = type(tab) == 'table' and tab
			table.insert(t,file)
		end
	end 
	return t
end


function get()
	local tempt = init_files()
	table.sort(tempt,function(a,b) return a<b end)
	return tempt
end




-- function next_pop(file)
		-- local dlg_base_info = require_data_file(file)
		-- return dlg_base_info.main()
-- end



