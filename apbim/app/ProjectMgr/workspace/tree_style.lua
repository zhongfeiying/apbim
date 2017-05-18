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
