local require = require

_ENV = module(...)

local Menu = require'sys.menu'
local Action = require'app.Model.function'

function on_load()
	Menu.add{
		keyword = 'AP.Model.Show.All',
		action = Action.Default;
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Model.Show.Diagram',
		action = Action.Diagram;
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Model.Show.Wireframe',
		action = Action.Wireframe;
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Model.Show.Rendering',
		action = Action.Rendering;
		frame = true,
		view = true,
	}
end

--[[
_ENV = module(...,ap.sys)


local function add_all_group()
	local smd = require'sys.Group'.Class:new{Name="All"};
	smd:add_model_all();
	require'sys.mgr'.add(smd);
end

function on_load()
	require"app.Model.function".load();
end

function on_init()
	-- require"app.Model.submodel_page".pop();
	-- add_all_group();
end
--]]
