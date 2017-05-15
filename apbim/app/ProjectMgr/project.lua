
local require  = require 
local print = print
local type = type
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local tree_project_list_ =   require 'app.projectmgr.workspace.tree_project_list'
local control_create_project_ = require 'app.projectmgr.project.control_create_project'

function new(tree,id)
	local data =control_create_project_.main()
	require 'sys.table'.totrace(data)
	if type(data) ~= 'table' then return end
	
	local tree = tree_project_list_.get()
	tree:add_branch(data.name)
end

function open()
	
end

function save()
	
end


function close()
	
end


function recentlies()
	
end


function statistics()
	
end



