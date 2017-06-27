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

local function init_tree()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
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
	local data = deal_data(data) or {}
	-- require 'sys.table'.totrace(data)
	return  data
end

-- function get_tree_data()
	-- return data_
-- end

function update(data)
	tree_:init_tree_data(data)
end

--------------------------------------------------------------------------------------------------
--op



function add_branch(arg)
	if not tree_  then return end 
	if type(arg) ~= 'table'  then return end 
	tree_:add_branch(arg.name,arg.id)
	local id = arg.id and (arg.id+1) or (tree_:get_tree_selected() +1)
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
	local id = arg.id and (arg.id+1) or (tree_:get_tree_selected() +1)
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
	local id = arg.id  or tree_:get_tree_selected()
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
	local id = arg.id  or tree_:get_tree_selected()
	id = id + tree_:get_totalchildcount(id) + 1
	if type(arg.attr) == 'table' then 
		tree_:set_node_status(arg.attr,id)
	end 
	if type(arg.cbf) == 'function' then 
		arg.cbf()
	end 
end


function add_root(arg)
	local id = 0
	local count = tree_:get_childcount(id)
	if count == 0 then
		tree_:add_branch(arg.title,id)
		id = id +1
		tree_:set_node_state('EXPANDED',0)
	else
		id = tree_:get_child_last_id(id)
		tree_:insert_branch(arg.title,id)
		id = id + 1+ tree_:get_totalchildcount(id)
	end
	tree_:set_node_status(arg,id)
	return id
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
