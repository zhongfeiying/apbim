local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Action = require'app.Show.function'

function on_load()
	Menu.add{
		keyword = 'AP.Show.Property';
		action = Action.Property;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Show.Diagram';
		action = Action.Diagram;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Show.Wireframe';
		action = Action.Wireframe;
		view = true;
	};
	Menu.add{
		keyword = 'AP.Show.Rendering';
		action = Action.Rendering;
		view = true;
	};
end

