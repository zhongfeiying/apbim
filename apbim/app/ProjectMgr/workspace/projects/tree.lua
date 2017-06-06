local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs = ipairs
local pairs = pairs
local type = type
local table = table
local string = string
local print = print


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local tree_workspace_ = require 'app.projectmgr.workspace.workspace.tree'

-- local iupTree_ = require 'sys.Workspace.tree.iuptree'
local tree_;
local data_;

local function init_tree()
	-- tree_=  iupTree_.Class:new()
	-- tree_:set_rastersize('300x') 
	tree_ = tree_workspace_.get()
end



local function init_data()
	data_ = nil
end

function init()
	init_tree()

	init_data()
end

function get()
	return tree_
end

function get_control()
	if not tree_ then return end 
	return tree_:get_tree()
end

function get_current_id()
	if not tree_ then return end 
	return tree_:get_tree_selected()
end

-- function add_branch(name,id)
	-- if not tree_ then return end 
	-- tree_:add_branch(name,id)
-- end
--
local function get_id()
	local id = tree_:get_index_id(0,'__title','ProjectList') 
	return id
end

function set_tree_data(data)
	if not tree_ then return end 
	local data = data or data_
	tree_:init_node_data(data,get_id())
end

function project_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.workspace.projects.rmenu'.get_project_menu;
			id = arg.id;
		};
		kind = 'branch';
		
	}
end
function branch_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.workspace.projects.rmenu'.get_branch_menu;
			id = arg.id;
		};
		kind = 'branch';
		
	}
end
function leaf_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.workspace.projects.rmenu'.get_leaf_menu;
			id = arg.id;
		};
		kind = 'leaf';
		
	}
end

function leaf_exe_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.workspace.projects.rmenu'.get_exe_menu;
			id = arg.id;
		};
		kind = 'leaf';
		
	}
end
function turn_tree_data(data)
	local function deal_data(db,lev)
		if type(db) ~= 'table' then return end 
		local tempt = {}
		for k,v in ipairs(db) do 
			local t = {}
			if lev == 1 then
				t.attributes = project_attr(v)
				t[1] = deal_data(v[1],lev+1) or {}
			elseif #v ~= 0 then 
				t.attributes = branch_attr(v)
				t[1] = deal_data(v[1],lev+1) or {}
			else 
				if not v.exe then 
				t.attributes = leaf_attr(v)
				else 
				t.attributes = leaf_exe_attr(v)
				end
			end
			table.insert(tempt,t)
		end
		return tempt 
	end
	data_ = deal_data(data,1) or {}
end

function get_tree_data()
	return data_
end

function init_tree_data()
end


function add_project(data)
	local attr = project_attr{name = data.name}
	attr.basedata = data
	local t = {}
	t.name = data.name
	t.attr = attr
	tree_workspace_.add_branch(t)
end
function import_project(data)
	local attr = project_attr{name = data.name}
	attr.basedata = data
	local t = {}
	t.name = data.name
	t.attr = attr
	tree_workspace_.add_branch(t)
end
