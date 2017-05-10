local loaded_ = package.loaded
local require = require 

local string = string
local error = error

local M = {}
local modname = ...
_G[modname] = M
loaded_[modname] = M
_ENV = M

--[[
	trees_ = {
		id = file;
		file = id;
		...
	}
--]]
local classTree_ = require 'sys.tree.tree'
local luaext_ = require 'luaext'
local trees_ = {}

function init()
	trees_ = {}
end

local function set_tree(id,tree,src)
	trees_[id] = {tree = tree,src = src}
end

function get_tree(id)
	return trees_[id] and trees_[id].tree
end

local function add_file(src,id)
	if not classTree_.file_is_exist(src) then return end 
	local file = classTree_.get_require_path(file)
	if type(file) ~= 'string' then return end 
	local tree = classTree_.Class:new()
	local id = id or  luaext_.guid()
	if trees_[id] then 
		tree = get_tree(id)
	end 
	tree:set_loaded_file{file = file}
	tree:init()
	set_tree(id,tree,src)
	return id
end 

local function add_data(src,id)
	local tree = classTree_.Class:new()
	local id = id or  luaext_.guid()
	if trees_[id] then 
		tree = get_tree(id)
	end 
	tree:init(src)
	set_tree(id,tree,src)
	return id
end 

--src 文件路径
function add(src,id)
	if  type(src) == 'string' then 
		src =string.lower( string.gsub(src,'\\','/'))
		return add_file(src,id)
	elseif type(src) == 'table' then 
		return add_data(src,id)
	end 
	return error('data error !')
end



function get_element(id)
	local tree =  get_tree(id)
	return tree and tree:get_element()
end

function change(id,src)
	add(src,id)
end

function update(id)
	local tree =  get_tree(id)
	if not tree then return end 
	tree:update()
end


