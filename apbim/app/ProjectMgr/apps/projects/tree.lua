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
local tree_workspace_ = require 'app.projectmgr.workspace.tree'
local tree_;
local root_id_;

local function init_tree()
	tree_ = tree_workspace_.get()
end

function init_root()
	root_id_ = tree_workspace_.add_root{
		title = '¹¤³Ì',
		image = {open ='app/ProjectMgr/res/projects.bmp',close =  'app/ProjectMgr/res/projects.bmp'} ;
		data= {
			rmenu = require 'app.projectmgr.apps.projects.rmenu'.get;
		};
	};
end

function init()
	init_tree()
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
	local id = root_id_
	return id
end

function set_tree_data(data)
	if not tree_ then return end 
	local data = data 
	tree_:init_node_data(data,get_id())
end

function branch_open(id)
	local data = tree_:get_node_data(id)
	if not data or data.branchOpenStatus == true then return end 
	data.branchOpenStatus = true
	tree_:set_node_data(data,id)
	
	-- show_next_content()
end

function project_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.apps.projects.rmenu'.get_project_menu;
			branchopen = branch_open;
			gid = arg.gid;
			data = arg.data;
		};
		kind = 'branch';
	}
end
function branch_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.apps.projects.rmenu'.get_branch_menu;
			id = arg.id;
			data = arg.data;
		};
		kind = 'branch';
		
	}
end
function leaf_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.apps.projects.rmenu'.get_leaf_menu;
			id = arg.id;
			data = arg.data;
		};
		kind = 'leaf';
		
	}
end

function leaf_exe_attr(arg)
	return {
		title = arg.name;
		data = {
			rmenu = arg.rmenu or require 'app.projectmgr.apps.projects.rmenu'.get_exe_menu;
			id = arg.id;
		};
		kind = 'leaf';
		
	}
end
function turn_tree_data(data,init)
	local function deal_data(db,lev)
		if type(db) ~= 'table' then return end 
		local tempt = {}
		for k,v in ipairs(db) do 
			local t = {}
			t.attributes = project_attr(v)
			table.insert(tempt,t)
		end
		return tempt 
	end
	return deal_data(data,1) or {}
end


function add_project(data)
	local attr = project_attr(data)
	tree_workspace_.add_branch{name = data.name,attr = attr}
end

function import_project(data)
	local attr = project_attr{name = data.name}
	attr.basedata = data
	local t = {}
	t.name = data.name
	t.attr = attr
	tree_workspace_.add_branch(t)
end

function create_folder(data)
	local attr = branch_attr{name = data.name}
	attr.basedata = data
	local t = {}
	t.name = data.name
	t.attr = attr
	tree_workspace_.add_branch(t)
end


function import_folder(data)
	local data = turn_tree_data(data,true)
	tree_:set_tree_data(data,tree_:get_tree_selected())
end
