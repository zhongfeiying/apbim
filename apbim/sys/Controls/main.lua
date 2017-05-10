local trace_out = trace_out
local require = require;
local add_menu = add_menu
local frm = frm
local ipairs = ipairs
local string = string
local table = table
local print = print
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local str = 'sys.Controls.'
local app_main_ = require (str .. 'app.main')
local app_menu_ = require (str .. 'menu.main')
local app_toolbar_ = require (str .. 'toolbar.main')
local app_change_ = require (str .. 'change.main')
local id_mgr_ = require "sys.id_mgr";
local menu_ = require 'sys.menu'

local dat_ = {
	{
		name='Controls.App',
		frame = true,
		view = true,
		fixed = true,
		keyword='Apcad.Controls.App',
		action=function()
			app_main_.pop('cfg.app','cfg.solutions.')
		end,
		id = id_mgr_.new_id(),
	},
	{
		name='Controls.Menu',
		fixed = true;
		frame = true,
		view = true,
		keyword='Apcad.Controls.Menu',
		action=function()
			app_menu_.pop()
		end,
		id = id_mgr_.new_id(),
	},
	{
		name='Controls.Toolbar',
		frame = true,
		view = true,
		fixed = true,
		keyword='Apcad.Controls.Toolbar',
		action=function()
			app_toolbar_.pop()
		end,
		id = id_mgr_.new_id(),
	},
}

function init()
	for k,v in ipairs(dat_) do 
		menu_.add(v)
	end
	app_change_.init()
end

function update(  )
	local t = {name = "Controls";items = {}}
	for k,v in ipairs(dat_) do 
		id_mgr_.map(v.id,v.keyword)
		local temp = {name = string.match(v.name,'.+%.([^%.]+)'),id = v.id}
		table.insert(t.items,temp)

	end
	add_menu(frm,t)
	app_change_.update()
end
