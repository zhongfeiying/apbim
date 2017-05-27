local require = require
local print = print
local g_next_ = _G.next
local os_execute_ = os.execute
local trace_out = trace_out
local string = string
local table = table
local ipairs = ipairs
local pairs = pairs
local type = type
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
local menu_ = require 'sys.menu'
local mgr_ = require 'sys.mgr'
local iup =require 'iuplua'
local dlg_ = require 'app.FamilyCreate.dlg'
local language_ = require 'sys.language'
local table_ = require 'sys.api.code'
local lfs = require 'lfs'
local default_path_ = 'cfg/family/lib/'


local function table_is_empty(t)
	return g_next_(t) == nil
end

local function mkdir(path)
	local str = default_path_
	for dir in string.gmatch(path,'[^/]+') do 
		str = str .. dir
		lfs.mkdir(str)
		str = str .. '/'
	end
end

local function init_readme(t)
	local data = {}
	data.title = t.title
	if t.icon then 
		local filename = string.match(t.icon,'.+/([^/]+)')
		local newpath = default_path_ .. t.path .. filename
		os_execute_('copy \"' .. t.icon .. '\" \"' .. newpath .. '\"')
		data.icon = newpath
	end
	data.tip = t.tip
	data.remark = t.remark
	return data
end


local function insert_surface(surfaces,old_surfaces)
	local t = type(old_surfaces) == 'table' and old_surfaces.surfaces or nil
	if not t then return end 
	for k,v in ipairs(t) do
		table.insert(surfaces,v)
	end
end

local function init_shape(entities)
	local shape = {}
	shape.Diagrame = {}
	shape.Diagrame.surfaces = {}
	shape.Wireframe = {}
	shape.Wireframe.surfaces = {}
	shape.Rendering = {}
	shape.Rendering.surfaces ={}
	for k,v in pairs(entities) do
		local ent = mgr_.get_table(k,v)
		if type(ent.on_draw) == 'function' then 
			insert_surface(shape.Diagrame.surfaces,ent:on_draw{mode = 'Diagrame'})
			insert_surface(shape.Wireframe.surfaces,ent:on_draw{mode = 'Wireframe'})
			insert_surface(shape.Rendering.surfaces,ent:on_draw{mode = 'Rendering'})
		end
	end 
	return shape
end

local function create_family_file(data,entities)
	mkdir(data.path)
	local t = {}
	t.Readme = init_readme(data)
	t.Shape = init_shape(entities)
	local filename =default_path_ ..  data.path .. data.title .. '.lua'
	table_.save{file = filename,returnKey = true ,data = t}
	require 'sys.table'.tofile{file = filename .. '.lua',returnKey = true ,src = t}
end

local function create_family()
	local cur = language_.get()
	
	local function on_ok(t)
		local sc = mgr_.get_cur_scene()
		if not sc then t.warning('sc') return end 
		local entities = mgr_.get_all() or {}
		if table_is_empty(entities) then t.warning('no') return	end
		if t.selected then 
			entities = mgr_.curs() or {}
			if table_is_empty(entities) then t.warning('no_selected') return end
		end
		create_family_file(t,entities)
		return true
	end
	dlg_.pop{
		language = cur;
		on_ok = on_ok;
	}
end

function on_load()
	menu_.add{
		keyword = 'REI.Ap.FamilyCreate';
		name = 'Family.Create System';
		view = true;
		frame = true;
		action = create_family;
	}
end

function on_init()
end

function on_esc()


end

