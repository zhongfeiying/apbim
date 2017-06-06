----[[
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local print = print
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local dlg_create_project_ =  require 'app.ProjectMgr.project.dlg_create_project'
local op_create_project_ =  require 'app.ProjectMgr.project.op_create_project'


function pop()
	local data;
	local f = function(arg)data = arg end
	dlg_create_project_.pop{
		data = op_create_project_.get();
		on_next = f;
		languagePack = op_create_project_.get_language_data();
		language = op_create_project_.get_cur_language();
	}
	return data;
end

function next_pop(file)
	return op_create_project_.next_pop(file) 
end





