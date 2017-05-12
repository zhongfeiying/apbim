local require = require
local type = type
local pairs = pairs
local string = string
local reload = reload

_ENV = module(...)

local Mgr = require'sys.mgr'
local Dlg = require'app.Report.dlg'

function Link_Report_Selection(sc)
	local s = Mgr.curs();
	Dlg.pop{src=s};
end

function Link_Report_View(sc)
	local s = Mgr.get_scene_all(sc);
	Dlg.pop{src=s};
end

function Link_Report_All(sc)
	local s = Mgr.get_all();
	-- Dlg.pop{src=s};
	reload'app.Report.dlg'.pop{src=s};
end

