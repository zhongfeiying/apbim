local require  = require 
local package_loaded_ = package.loaded
local type = type
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local cmd_ = {};

function set(cmd)
	cmd_ = cmd
end

function init()
	if type(cmd_.init) == 'function' then 
		return cmd_.init()
	end
end

function get()
	if type(cmd_.get) == 'function' then 
		return cmd_.get()
	end
end

function get_control()
	if type(cmd_.get_control) == 'function' then 
		return cmd_.get_control()
	end
end

function get_current_id()
	if type(cmd_.get_current_id) == 'function' then 
		return cmd_.get_current_id()
	end
end

function get_current_id()
	if type(cmd_.get_current_id) == 'function' then 
		return cmd_.get_current_id()
	end
end

function add_branch(name,id)
	if type(cmd_.add_branch) == 'function' then 
		return cmd_.add_branch(name,id)
	end
end

function add_leaf(name,id)
	if type(cmd_.add_leaf) == 'function' then 
		return cmd_.add_leaf(name,id)
	end
end

function insert_branch(name,id)
	if type(cmd_.insert_branch) == 'function' then 
		return cmd_.insert_branch(name,id)
	end
end

function insert_leaf(name,id)
	if type(cmd_.insert_leaf) == 'function' then 
		return cmd_.insert_leaf(name,id)
	end
end

function delete(id,status)
	if type(cmd_.delete) == 'function' then 
		return cmd_.delete(id,status)
	end
end

function change(arg)
	if type(cmd_.change) == 'function' then 
		return cmd_.change(arg)
	end
end


function turn_tree_data(data)
	if type(cmd_.turn_tree_data) == 'function' then 
		return cmd_.turn_tree_data(data)
	end
end

function set_tree_data(data)
	if type(cmd_.set_tree_data) == 'function' then 
		return cmd_.set_tree_data(data)
	end
end

function get_tree_data()
	if type(cmd_.get_tree_data) == 'function' then 
		return cmd_.get_tree_data()
	end
end


