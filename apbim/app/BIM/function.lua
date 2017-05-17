local require = require
local type = type
local pairs = pairs
local string = string
local reload = reload

_ENV = module(...)

local Mgr = require'sys.mgr'
local Dlg = require'app.BIM.dlg'

function New()
	Dlg.pop();
end



