
local require = require
local ipairs = ipairs
local table = table
local package_loaded_ = package.loaded
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
	table.insert(files,arg.gid)
end

local function add_project(t)
end
local function add_folder(t)
end
local function add_file(t)
end

function save()
	for k,v in ipairs(files) do 
		local t = files[v]
		if type(t) == 'table' then 
			if t.type == 'project' then 
				add_project(t)
			elseif t.type == 'folder' then 
				add_folder(t)
			elseif t.type == 'file' then 
				add_file(t)
			end
		end
	end
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













