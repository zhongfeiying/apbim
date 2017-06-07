
local require = require
local print = print

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local menu_ = require 'sys.menu'
local dlg_ = require 'app.bgcolor.dlg'

local function action()
	dlg_.pop()
end

function on_load()
	menu_.add{
		keyword = 'Ap.Bgcolor';
		name = 'Ap.Bgcolor';
		view = true;
		frame = true;
		action = action;
	}
end

function on_init()
end

function on_esc()


end

