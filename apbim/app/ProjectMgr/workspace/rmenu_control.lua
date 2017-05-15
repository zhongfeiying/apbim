
local require  = require 
local package_loaded_ = package.loaded
local type = type
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local rmenu_ = require 'sys.workspace.tree.rmenu'

local cmd_ = {}
local menu_items_;

function set(cmd)
	cmd_ = cmd
end

function init(tree,id)
	if type(cmd_.get) == 'function' then 
		menu_items_ = cmd_.get(tree,id)
	end
end

function pop(tree,id)
	if menu_items_ then
		local rmenu = rmenu_.new()
		rmenu:set_data(menu_items_)
		rmenu:show(tree,id)
	end 
end

