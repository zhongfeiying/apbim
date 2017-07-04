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

local project_ = require 'app.Apmgr.project.project'
local op_ = require 'app.Apmgr.project.op'

local tree_;
local cmds_ = {}

function branch_open(id)	
	local state = tree_:get_node_state(id)
	if state == 'EXPANDED' then return end 
	if tree_:get_node_depth(id) == 1  then 
		local data = tree_:get_node_data(id)
		if data and data.opened then return end 
		op_.project_open()
	else 
		op_.open_folder()
	end
end

function db_click(id)
	if id and id == 0 then return end 
	local kind = tree_:get_node_kind(id)
	if kind == 'BRANCH' then 
		-- branch_open(id)
	elseif kind == 'LEAF' then  
		-- op_.open_leaf()
	end
	
end

function init()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
	tree_:set_dlbtn(db_click)
	tree_:set_branchopen(branch_open)
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
			open ='app/Apmgr/res/user.bmp',
			close =  'app/Apmgr/res/user.bmp'
		} ;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_root;
		};
		kind = 'branch';
		state = 'EXPANDED';
	}
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
			open ='app/Apmgr/res/Project.bmp',
			close =  'app/Apmgr/res/Project.bmp'
		} ;
		-- image = {
			-- open ='app/Apmgr/res/Project.bmp',
			-- close =  'app/Apmgr/res/Project.bmp'
		-- } ;
		kind = 'branch';
		
	}
end

local function tree_branch_attributes(arg)
	return {
		title = arg.name;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_folder;
			gid = arg.gid;
			hid = arg.hid;
		};
		kind = 'branch';
	}
end

local function tree_leaf_attributes(arg)
	return {
		title = arg.name;
		data= {
			rmenu = require 'app.Apmgr.project.rmenu'.get_file;
			gid = arg.gid;
			hid = arg.hid;
		};
		kind = 'leaf';
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

function get_index_id(file)
	local count = tree_:get_childcount(0)
	local posid = 1
	for i = 1,count do 
		local data = tree_:get_node_data(posid)
		if data and data.file and data.file == file then 
			
			return posid
		end
		posid = posid + 1+ tree_:get_totalchildcount(posid)
	end
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
	-- tree_:set_node_marked(posid)
	return posid
end


--arg = {name,gid,hid}
function add_branch(arg,id,state)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	local id = id or tree_:get_tree_selected()
	local count = tree_:get_childcount(id)
	if count  == 0 or state then
		tree_:add_branch(arg.name,id)
		id = id+ 1
	else 
		id = tree_:get_child_last_id(id)
		tree_:insert_branch(arg.name,id)
		id = id + 1+ tree_:get_totalchildcount(id)
	end
	tree_:set_node_status( tree_branch_attributes(arg),id)
	return id
end

function add_leaf(arg,id)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	local id = id or tree_:get_tree_selected()
	local count = tree_:get_childcount(id)
	if count  == 0 then
		tree_:add_leaf(arg.name,id)
		id = id+ 1
	else 
		id = tree_:get_child_last_id(id)
		tree_:insert_leaf(arg.name,id)
		id = id + 1+ tree_:get_totalchildcount(id)
	end
	tree_:set_node_status( tree_leaf_attributes(arg),id)
	return id
end


function add_folder_list(data,id)
	local id = id or tree_:get_tree_selected()
	for k,v in ipairs (data) do 
		if v.gid and v.name then 
			if string.sub(v.gid,-1,-1) == '0' then 
				add_branch(v,id)
			elseif string.sub(v.gid,-1,-1) == '1' then 
				add_leaf(v,id)
			end
		end
	end
	
end

function open_folder(id)
	local id = id or tree_:get_tree_selected()
	
	local count = tree_:get_childcount(id)
	local cur_id = id+ 1
	for i = 1,count do 
		local data = tree_:get_node_data(cur_id)
		if data and data.gid and string.sub(data.gid,-1,-1) == '0' then 
			local nextIndexId = project_.get_hid_indexId(data.gid)
			local t = project_.get_id_data(nextIndexId)
			add_folder_list(t,cur_id)
		end
		cur_id = cur_id + 1 + tree_:get_totalchildcount(cur_id)
	end
	local state = 'EXPANDED'
	if count  == 0 then 
		state = 'COLLAPSED'
	end
	tree_:set_node_state(state,id)
end

function close_project(id)
	local id = id or get_index_id( project_.get())
	if not id then return end 
	local data = tree_:get_node_data(id)
	if not data then return end 
	data.opened = nil
	tree_:set_node_data(data,id)
	tree_:delete_nodes('CHILDREN',id)
	tree_:set_node_state('COLLAPSED',id)
end