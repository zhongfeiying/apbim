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
local iupTree_ = require 'sys.Workspace.tree.iuptree'

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local tree_;
local cmds_ = {}

function init()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
end

function get()
	return tree_
end

function update(data)
	tree_:init_tree_data(data)
	tree_:set_node_state('EXPANDED',0)
end

function get_control()
	if not tree_ then init()  end 
	return tree_:get_tree()
end

function get_id()
	if not tree_ then return end 
	return tree_:get_tree_selected()
end

local function tree_root_attributes()
	return {
		title = 'Projects';
		image = {
			open ='app/Apmgr/res/projects.bmp',
			close =  'app/Apmgr/res/projects.bmp'
		} ;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_root;
		};
		kind = 'branch';
		state = 'EXPANDED';
	}
end

local function branch_open()
end

local function tree_project_attributes(arg)
	return {
		title = arg.name;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_project;
			gid = arg.gid;
		};
		kind = 'branch';
		branchopen = branch_open;
	}
end

function turn_data(data)
	local t = {}
	table.insert(t,{attributes = tree_root_attributes(),{}})
	local next_data = t[1][1]
	local function  deal_data(data)
		for k,v in ipairs (data) do 
			local t = {}
			t.attributes = tree_project_attributes(v)
			table.insert(next_data,t)
		end
	end
	
	deal_data(data)
	return t
end

function set_data(data)
	if not tree_ then return end 
	if not tree_.Map then
		tree_:set_data(data)
	else 
		update(data)
	end
end



--------------------------------------------------------------------------------------------------
--op