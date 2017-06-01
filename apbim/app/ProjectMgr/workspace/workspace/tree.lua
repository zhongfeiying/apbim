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
local cache_ = {}
local tree_;
local data_;

local function init_tree()
	cache_.tree_=  iupTree_.Class:new()
	tree_ = cache_.tree_
	cache_.tree_:set_rastersize('300x') 
end


local function init_data()
	data_ = nil
end

function init()
	init_tree()
	init_data()
end

function get()
	return cache_.tree_
end

function get_control()
	if not tree_ then return end 
	return tree_:get_tree()
end

function get_current_id()
	if not tree_ then return end 
	return tree_:get_tree_selected()
end


function set_tree_data(data)
	if not tree_ then return end 
	local data = data or data_
	tree_:set_data(data)
end

local function init_node_attributes(v,db)
	local data = db[v.index]
	local attr = {}
	attr.kind = #v == 0 and 'leaf' or 'branch'
	for k,v in pairs(data) do 
		attr[k] = v
	end 
	return attr
end

function turn_tree_data(data)
	local function deal_data(db)
		local tempt = {}
		for k,v in ipairs (db) do 
			if type(v) == 'table' and type(v.index) == 'string' and type(data[v.index]) == 'table' then 
				local t = {}
				t.attributes = init_node_attributes(v,data) 
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


--------------------------------------------------------------------------------------------------
--op


function add_branch(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:add_branch(arg.name,arg.id)
	local id = arg.id and (arg.id+1) or (self:get_tree_selected() +1)
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end

function add_leaf(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:add_leaf(arg.name,arg.id)
	local id = arg.id and (arg.id+1) or (self:get_tree_selected() +1)
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end


function insert_branch(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:insert_branch(arg.name,arg.id)
	local id = arg.id  or self:get_tree_selected()
	id = id + tree_:get_totalchildcount(id) + 1
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end

function insert_leaf(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:insert_leaf(arg.name,arg.id)
	local id = arg.id  or self:get_tree_selected()
	id = id + tree_:get_totalchildcount(id) + 1
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end


function delete(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:delete_nodes('SELECTED',arg.id)
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end


function edit(arg)
	
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 

end
