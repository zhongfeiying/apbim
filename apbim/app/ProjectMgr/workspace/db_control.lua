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

function add(arg)
	if type(cmd_.add) == 'function' then 
		return cmd_.add(arg)
	end
end

function edit(arg)
	if type(cmd_.edit) == 'function' then 
		return cmd_.edit(arg)
	end
end

function delete(arg)
	if type(cmd_.delete) == 'function' then 
		return cmd_.delete(arg)
	end
end
