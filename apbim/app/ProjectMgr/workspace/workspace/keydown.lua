

local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local rmenu_ = require 'app.projectmgr.workspace.rmenu_control'
local rmenu_workspace_ = require 'app.projectmgr.workspace.workspace.rmenu'

function rbtn(tree,id)
	rmenu_.set(rmenu_workspace_)
	rmenu_.init(tree,id)
	rmenu_.pop(tree,id)
	-- rmenu_.pop(tree,id,project_list_rmenu_.get())
end

function lbtn(tree,id)

end

function dlbtn(tree,id)

end