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

local iupTree_ = require 'sys.Workspace.tree.iuptree'
local keydown_ =require 'app.projectmgr.workspace.keydown_control'
local keydown_workspace_ =require 'app.projectmgr.workspace.workspace.keydown'  
-- local keydown_private_ =require 'app.projectmgr.workspace.keydown_private'  
-- local keydown_workspace_ =require 'app.projectmgr.workspace.keydown_projects'  
-- local keydown_workspace_ =require 'app.projectmgr.workspace.keydown_contact'  

-- local keydown_workspace_ =require 'app.projectmgr.workspace.keydown_workspace'  


local tree_;
local data_;

local function init_tree()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
end

local function init_keydown()
	keydown_.set(keydown_workspace_)
	-- tree_:set_rbtn(keydown_.rbtn)
end

local function init_data()
	data_ = nil
end

function init()
	init_tree()
	init_keydown()
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

function set_tree_data(data)
	if not tree_ then return end 
	local data = data or data_
	tree_:set_data(data)
end

local function get_attributes(attr)
	attr.image_open = data.image_open or 'app/ProjectMgr/res/user_open.bmp'
	attr.image_close =  data.image_close or  'app/ProjectMgr/res/user_close.bmp'
	-- attr.rmenu = data.rmenu or 
end

local function init_other_attributes(attr,data)
	local color,lbtn,rbtn,rmenu,state;
	local image_open,image_close;
	if data.type == 'user' then 
		image_open = data.image_open or 'app/ProjectMgr/res/user_open.bmp'
		image_close =  data.image_close or  'app/ProjectMgr/res/user_close.bmp'
		state = 'expanded'
		rbtn = function (tree,id) keydown_.set(keydown_workspace_) keydown_.rbtn(tree,id) end ;
	elseif data.type == 'projects' then 
		image_open = 'app/ProjectMgr/res/project_open.bmp'
		image_close = 'app/ProjectMgr/res/project_close.bmp'
		rbtn = function (tree,id) keydown_.set(keydown_projects_) keydown_.rbtn(tree,id) end ;
	elseif data.type == 'contacts' then 
		image_open = 'app/ProjectMgr/res/contacts_close.bmp'
		image_close = 'app/ProjectMgr/res/contacts_close.bmp'
		rbtn = function (tree,id) keydown_.set(keydown_contacts_) keydown_.rbtn(tree,id) end ;
	elseif data.type == 'recycle' then 
		image_open = 'app/ProjectMgr/res/recycle_have.bmp'
		image_close = 'app/ProjectMgr/res/recycle_have.bmp'
		rbtn = function (tree,id) keydown_.set(keydown_recycle_) keydown_.rbtn(tree,id) end ;
	elseif data.type == 'private' then 
		image_open = 'app/ProjectMgr/res/private_open.bmp'
		image_close = 'app/ProjectMgr/res/private_close.bmp'
		rbtn = function (tree,id) keydown_.set(keydown_private_) keydown_.rbtn(tree,id) end ;
		-- keydown_.set(keydown_workspace_)
		-- rbtn = keydown_.rbtn;
	end 
	attr.image ={open =image_open,close =  image_close} 
	attr.color = color
	attr.data.lbtn = lbtn
	attr.data.rbtn = rbtn
	attr.state = state
	-- attr.rmenu = rmenu
end

local function init_user_attr(attr)
	attr.image ={open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} 
	attr.data = {}
	attr.data.rbtn =  function (tree,id) keydown_.set(keydown_workspace_) keydown_.rbtn(tree,id) end ;
	attr.state = 'expanded'
end 

local function init_other_attr(attr,data)
	if data.entrance then 
		require (data.entrance).main()
		attr.data.rbtn = 
	end 
	attr.image ={open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} 
	attr.data = {}
	attr.data.rbtn =  function (tree,id) keydown_.set(keydown_workspace_) keydown_.rbtn(tree,id) end ;
	
end 

local function init_node_attributes(v,db)
	local data = db[v.index]
	local attr = {}
	attr.kind = #v == 0 and 'leaf' or 'branch'
	attr.title = data.name
	if data.type == 'user' then 
		init_user_attr(attr)
	else 
		init_other_attr(attr,data)
	end 
	return attr
end

function turn_tree_data(data)
	local function deal_data(db)
		local tempt = {}
		for k,v in ipairs (db) do 
			if type(v) == 'table' and type(v.index) == 'string' and type(data[v.index]) == 'table' then 
				local t = {}
				t.attributes = init_node_attributes( v , data)
				if #v ~= 0 then 
					table.insert(t,deal_data(v[1]))
				end 
				table.insert(tempt,t)
			end 
		end 
		return tempt 
	end
	data_ = deal_data(data) or {}
end

function get_tree_data()
	return data_
end
