
local require = require

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local files={};

--arg = {gid,data,path,...}
function add(arg)
	if not arg or arg.gid then return end 
	files[arg.gid] = arg
end
function save()
end
function open()
end
function save_local()
end
function open_local()
end
function save_server()
end
function open_server()
end













