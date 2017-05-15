local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.BIM.function'

function on_load()
	MENU.add{
		keyword = 'AP.BIM.New';
		action = Action.New;
		view = true;
		frame = true;
	}
end


