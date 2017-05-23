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
local keydown_ =require 'app.projectmgr.workspace.keydown_control'

local keydown_private_ =require 'app.projectmgr.workspace.privates.keydown'  
local tree_workspace_ = require 'app.projectmgr.workspace.workspace.tree'

local tree_;
local data_;

local function init_tree()
	-- tree_=  iupTree_.Class:new()
	-- tree_:set_rastersize('300x') 
	tree_ = tree_workspace_.get()
end

local function init_keydown()
	keydown_.set(keydown_private_)
	-- tree_:set_rbtn(keydown_.rbtn)
end

local function init_data()
	data_ = nil
end

function init()
	init_tree()
	-- init_keydown()
	init_data()
end

function get()
	return tree_
end

-- function get_control()
	-- if not tree_ then return end 
	-- return tree_:get_tree()
-- end

-- function get_current_id()
	-- if not tree_ then return end 
	-- return tree_:get_tree_selected()
-- end

-- function add_branch(name,id)
	-- if not tree_ then return end 
	-- tree_:add_branch(name,id)
-- end

function set_tree_data(data)
	if not tree_ then return end 
	local data = data or data_
	-- tree_:set_data(data)
	-- tree_:init_node_data(data,1)
	tree_:init_node_data(data)
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
