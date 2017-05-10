local loaded_ = package.loaded
local require = require 
local ipairs = ipairs

local M = {}
local modname = ...
_G[modname] = M
loaded_[modname] = M
_ENV = M

local classTree_ = require 'sys.tree.tree'

local dlgs_ = {}

function init()
	dlgs_ = {}
end

function add(src)
	local tree = classTree_.Class:new()
	tree:init()
	tree:set_loadedfile(file)
	tree:loaded()
end

function update(id)
	local tree = dlgs_[id]
	tree:loaded()
	tree:show()
end 

--arg = {id,file}
function show(id,file)
	if not dlgs_[id] then
		local tree = classTree_.Class:new()
		tree:loaded_file(file)
		dlgs_[id] = tree
	end 
	update(id)
end




