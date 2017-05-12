local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Action = require'app.Select.function'

function on_load()
	Menu.add{
		keyword = 'AP.Select.Cursor';
		action = Action.Cursor;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Select.All';
		action = Action.All;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Select.Cancel';
		action = Action.Cancel;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Select.Reverse';
		action = Action.Reverse;
		view = true;
	};
end

