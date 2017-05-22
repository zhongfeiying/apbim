local require  = require 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local iupTree_ = require 'sys.Workspace.tree.iuptree'
local keydown_ =require 'app.projectmgr.workspace.keydown_control'
local keydown_project_list_ =require 'app.projectmgr.workspace.keydown_project_list'  
local db_ =  require 'app.projectmgr.workspace.db_control'
local db_project_list_ = require 'app.projectmgr.workspace.db_project_list'


local tree_;

local function init_tree()
	tree_=  iupTree_.Class:new()
	tree_:set_rastersize('300x') 
end

local function init_keydown()
	keydown_.set(keydown_project_list_)
	tree_:set_rbtn(keydown_.rbtn)
end

local function init_data()
	db_.set(db_project_list_)
	db_.init()
	tree_:set_data(db_.get_tree_data())
end

function init()
	init_tree()
	init_keydown()
	init_data()
end

function get()
	return tree_
end

function get_control()
	if not tree_ then return end 
	return tree_:get_tree()
end

function get_current_id()
	if not tree_ then return end 
	return tree_:get_tree_selected()
end

function add_branch(name,id)
	if not tree_ then return end 
	tree_:add_branch(name,id)
end
