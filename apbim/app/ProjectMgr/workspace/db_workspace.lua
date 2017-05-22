local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

function init()
	package_loaded_[file] = nil
	data_ = require (file) or {}
end

function get()
	return data_
end

local function get_root_attr(arg)
	return {
		kind = 'branch';
		title = arg.title or 'User';
		image = arg.image;
	}
end

function get_tree_data()
	return {
		{
			attributes = get_root_attr{};
			get_root_content();
		};
	}
end
