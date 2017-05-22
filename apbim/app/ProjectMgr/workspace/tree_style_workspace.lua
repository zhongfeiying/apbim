local require  = require 
local package_loaded_ = package.loaded
local type = type
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M



function get_tree_data()
	return {
		{
			attributes = get_root_attr{};
			get_root_content();
		};
	}
end
