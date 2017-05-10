local trace_out = trace_out
local require = require;
local add_menu = add_menu
local frm = frm
local ipairs = ipairs
local pairs = pairs
local table = table
local print = print
local string = string

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


local id_mgr_ = require "sys.id_mgr";
local menu_ = require 'sys.menu'
local menu_op_ = require 'sys.controls.menu.op'
local data_ = {}

local function init_data( ... )
	data_ = {}
	local t = menu_op_.get_style_files()
	for k,v in pairs(t) do 
		local temp = {
			name='MenuStyles.' .. v.name,
			frame = true,
			view = true,
			fixed = true,
			keyword='Apcad.MenuStyles.' ..  v.name,
			action=function()
				menu_op_.on_ok{data = menu_op_.on_dbclick_list{file = v.file}}
			end,
			id = id_mgr_.new_id(),
		}
		table.insert(data_,temp)
	end
end

function  init(  )
	init_data()
	for k,v in ipairs(data_) do 
		menu_.add(v)
	end
end

function  update(  )
	local t = {name = "	MenuStyles",items = {}}
	for k,v in ipairs(data_) do 
		id_mgr_.map(v.id,v.keyword)
		local temp = {name = string.match(v.name,'.+%.([^%.]+)'),id = v.id}
		table.insert(t.items,temp)
	end
	add_menu(frm,t)
end