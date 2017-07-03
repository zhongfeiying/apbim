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
			file = arg.file;
			gid = arg.gid;
		};
		image = {
			open ='app/Apmgr/res/project_open.bmp',
			close =  'app/Apmgr/res/project_close.bmp'
		} ;
		kind = 'branch';
		branchopen = branch_open;
	}
end

local function tree_branch_attributes(arg)
	return {
		title = arg.name;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_project;
			file = arg.file;
			gid = arg.gid;
			hid = arg.hid;
			name = arg.name;
		};
		-- image = {
			-- open ='app/Apmgr/res/project_open.bmp',
			-- close =  'app/Apmgr/res/project_close.bmp'
		-- } ;
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


function set_marked(id)
	tree_:set_node_marked(id)
end


--------------------------------------------------------------------------------------------------
--op

local function get_insert_pos(id,data)
	local count = tree_:get_childcount(id)
	local t = {}
	local cur_id = id + 1
	local posId = id;
	for i = 1,count do 
		local title = tree_:get_node_title(cur_id)
		if string.lower(title) > string.lower(data.name)  then 
				return posId
		end
		posId = cur_id
		cur_id = cur_id + 1+ tree_:get_totalchildcount(cur_id)
	end
	
	return posId
end

--arg = {name,file}
function add_project(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	local posid = get_insert_pos(0,arg)
	if posid == 0 then 
		tree_:add_branch(arg.name,posid)
		posid = posid + 1
	else 
		tree_:insert_branch(arg.name,posid)
		posid = posid + 1+ tree_:get_totalchildcount(posid)
	end
	tree_:set_node_status( tree_project_attributes(arg),posid)
	tree_:set_node_marked(posid)
end


--arg = {name,gid,hid}
function add_branch(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	local id = tree_:get_tree_selected()
	local count = tree_:get_childcount(id)
	if count  == 0 then
		tree_:add_branch(arg.name,id)
	else 
		id = tree_:get_child_last_id(id)
		tree_:insert_branch(arg.name,id)
		id = id + 1+ tree_:get_totalchildcount(id)
	end
	tree_:set_node_status( tree_branch_attributes(arg),id)
end