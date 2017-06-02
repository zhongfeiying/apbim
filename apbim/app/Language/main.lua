local require = require
local print = print

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local menu_ = require 'sys.menu'
local dlg_ = require 'app.language.dlg'

local function set_language()
	print('here')
	dlg_.pop()
end

function on_load()
	menu_.add{
		keyword = 'Ap.Language';
		name = 'Ap.Language';
		view = true;
		frame = true;
		action = set_language;
	}
end

function on_init()
end

function on_esc()


end

