local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.Steel.function'

function on_load()
	MENU.add{
		keyword='AP.Steel.Darw.Beam',
		action=Action.draw_beam;
		view = true,
	}
	MENU.add{
		keyword='AP.Steel.Model.CGB',
		action=Action.add_model;
		frame = true,
		view = true,
	}
end



