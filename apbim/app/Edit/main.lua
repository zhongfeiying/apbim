local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Action = require'app.Edit.function'

function on_load()
	Menu.add{
		keyword = 'AP.Edit.Property';
		action = Action.Property;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Edit.Copy';
		action = Action.Copy;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Edit.Move';
		action = Action.Move;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Edit.Del';
		action = Action.Del;
		view = true;
	};
end

