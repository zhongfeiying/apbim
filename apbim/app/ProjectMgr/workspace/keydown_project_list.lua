

local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local rmenu_ = require 'app.projectmgr.workspace.rmenu_control'
local project_list_rmenu_ = require 'app.projectmgr.workspace.rmenu_project_list'

function rbtn(tree,id)
	rmenu_.set(project_list_rmenu_)
	rmenu_.init(tree,id)
	rmenu_.pop(tree,id)
	-- rmenu_.pop(tree,id,project_list_rmenu_.get())
end

function lbtn(tree,id)

end

function dlbtn(tree,id)

end
