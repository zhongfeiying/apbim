local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Action = require'app.Snap.function'

function on_load()
	Menu.add{
		keyword = 'AP.Snap.Point';
		action = Action.Snap_Point;
		view = true;
	};
end


