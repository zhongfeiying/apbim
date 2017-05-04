local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Toolbar = require'sys.toolbar'
local Action = require'app.Project.function'

function on_load()
	Menu.add{
		keyword='AP.Project.New',
		action = Action.New;
		name='New Project',
		frame = true,
		view = true,
	}
	Toolbar.add{
		keyword='AP.Project.New',
		action = Action.New;
		name='New Project',
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Project.Open',
		name = 'Project.Open',
		action = Action.Open;
		frame = true,
		view = true,
	}
	Toolbar.add{
		keyword='AP.Project.Open',
		name='Open Project',
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Project.Save',
		name = 'Project.Save',
		action = Action.Save;
		frame = true,
		view = true,
	}
	Toolbar.add{
		keyword='AP.Project.Save',
		name='Save Project',
		frame = true,
		view = true,
	}
end

