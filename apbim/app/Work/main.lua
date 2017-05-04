local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.Work.function'

function on_load()
	MENU.add{
		keyword='AP.Work.Import.Lua',
		action=Action.Import_Lua;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Export.Lua',
		action=Action.Export_Lua;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Database.Show',
		action=Action.Link_Show;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Database.Find',
		action=Action.Link_Find;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Database.Report.Section',
		action=Action.Link_Report;
		view = true,
	}
end

function on_init()
end

