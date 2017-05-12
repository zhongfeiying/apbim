local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.Work.function'

function on_load()
	MENU.add{
		keyword='AP.Work.Import.Lua',
		action=Action.Import_Lua;
		view = true,
		frame = true;
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
		keyword='AP.Work.Database.Report.Selection',
		action=Action.Link_Report_Selection;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Database.Report.View',
		action=Action.Link_Report_View;
		view = true,
	}
	MENU.add{
		keyword='AP.Work.Database.Report.All',
		action=Action.Link_Report_All;
		view = true,
		frame = true;
	}
end

function on_init()
end

