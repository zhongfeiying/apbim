
local loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
loaded_[modname] = M
_ENV = M

local db_ = require 'sys.tree.db'
-- local dlg_ = require 'sys.tree.dlg'

function init()
	db_.init()
end

function loaded(src)
	if not src then return end 
	return db_.add(src)
end

function get_tree(id)
	if not id then return end 
	return db_.get_tree(id)
end

function get_element(id)
	if not id then return end 
	return db_.get_element(id)
end

function change(id,src)
	if not id then return end 
	db_.change(src,id)
end

function update(id)
	if not id then return end 
	db_.update(id)
end





