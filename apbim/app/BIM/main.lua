local require = require

_ENV = module(...)

local MENU = require'sys.menu'
local Action = require'app.Report.function'

function on_load()
	MENU.add{
		keyword='AP.Report.Selection',
		action=Action.Link_Report_Selection;
		view = true,
	}
	MENU.add{
		keyword='AP.Report.View',
		action=Action.Link_Report_View;
		view = true,
	}
	MENU.add{
		keyword='AP.Report.All',
		action=Action.Link_Report_All;
		view = true,
		frame = true;
	}
end

function on_init()
end

