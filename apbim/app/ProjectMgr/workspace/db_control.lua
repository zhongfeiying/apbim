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

function get_tree_data()
	if type(cmd_.get_tree_data) == 'function' then 
		return cmd_.get_tree_data()
	end
end

function get()
	if type(cmd_.get) == 'function' then 
		return cmd_.get()
	end
end
