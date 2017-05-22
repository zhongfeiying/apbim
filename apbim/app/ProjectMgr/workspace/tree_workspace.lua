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
local keydown_project_list_ =require 'app.projectmgr.workspace.keydown_project_list'  
local db_ =  require 'app.projectmgr.workspace.db_control'
local db_project_list_ = require 'app.projectmgr.workspace.db_project_list'


local tree_;
local data_;

local function init_tree()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
end

local function init_keydown()
	keydown_.set(keydown_project_list_)
	tree_:set_rbtn(keydown_.rbtn)
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

local function init_other_attributes(attr,data)
	local image,color,lbtn,rbtn;
	if data.type == 'user' then 
		image_open = 'app/ProjectMgr/res/user_open.bmp'
		image_close = 'app/ProjectMgr/res/user_close.bmp'
	elseif data.type == 'projects' then 
	elseif data.type == 'contacts' then 
	elseif data.type == 'recycle' then 
	elseif data.type == 'private' then 
	end 
	attr.image ={open =image_open,close =  image_close} 
	attr.color = color
	attr.lbtn = lbtn
	attr.rbtn = rbtn
end

local function init_node_attributes(v,db)
	local data = db[v.index]
	local attr = {}
	attr.kind = #v == 0 and 'leaf' or 'branch'
	attr.title = data.name
	attr.data = data
	init_other_attributes(attr,data)
	return attr
end

function turn_tree_data(data)
	local function deal_data(db)
		local tempt = {}
		for k,v in ipairs (db) do 
			print(v.index)
			if type(v) == 'table' and type(v.index) == 'string' and type(data[v.index]) == 'table' then 
				print('=======true')
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
	require 'sys.table'.totrace(data)
	data_ = deal_data(data) or {}
	require 'sys.table'.totrace(data_)
end

function get_tree_data()
	return data_
end
