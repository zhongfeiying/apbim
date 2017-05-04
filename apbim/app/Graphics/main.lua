local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.Graphics.function'

function on_load()
	MENU.add{
		keyword='AP.Graphics.Darw.Line',
		action=Action.draw_line;
		view = true,
	}
end


