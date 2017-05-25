local require  = require 
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

-- local iupTree_ = require 'sys.Workspace.tree.iuptree'

local tree_workspace_ = require 'app.projectmgr.workspace.workspace.tree'

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

function add_branch(name,id)
	if not tree_ then return end 
	tree_:add_branch(name,id)
end


local function get_id()
	local id = tree_:get_index_id(0,'__title','Contacts') 
	return id
end

function set_tree_data(data)
	if not tree_ then return end 
	local data = data or data_
	tree_:init_node_data(data,get_id())
end

local function project_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get_project_menu;
			id = arg.id;
		};
		kind = 'branch';
		
	}
end
local function branch_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get_branch_menu;
			id = arg.id;
		};
		kind = 'branch';
		
	}
end
local function leaf_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get_leaf_menu;
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
			
			if #v ~= 0 then 
				t.attributes = branch_attr(v)
				t[1] = deal_data(v[1],lev+1) or {}
			else 
				t.attributes = leaf_attr(v)
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
