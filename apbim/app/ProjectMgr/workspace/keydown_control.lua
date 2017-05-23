

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

function rbtn(tree,id)
	if type(cmd_.rbtn) == 'function' then 
		return cmd_.rbtn(tree,id)
	end
end

function lbtn(tree,id)
	if type(cmd_.lbtn) == 'function' then 
		return cmd_.lbtn(tree,id)
	end
end

function dlbtn(tree,id)
	if type(cmd_.dlbtn) == 'function' then 
		return cmd_.dlbtn(tree,id)
	end
end

function init(tree,id)
	-- if tree
end
