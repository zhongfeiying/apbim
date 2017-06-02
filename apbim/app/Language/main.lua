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
local dlg_ = require 'app.language.dlg'
local language_ = require 'sys.language'
local default_file_ = 'cfg/language.lua'

local function set_language()
	
	dlg_.pop{
		language = cur;
		on_ok = on_ok;
	}
end

function on_load()
	menu_.add{
		keyword = 'Ap.Language';
		name = 'Language';
		view = true;
		frame = true;
		action = set_language;
	}
end

function on_init()
end

function on_esc()


end

