local require = require

_ENV = module(...)

local MGR = require'sys.mgr'
local Menu = require'sys.menu'
local Action = require'app.View.function'

function on_load()
	Menu.add{
		keyword = 'AP.View.New',
		action = Action.New;
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Show',
		action = Action.Show;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Hide',
		action = Action.Hide;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Fit',
		action = Action.Fit;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Default',
		action = function(sc)MGR.scene_to_default{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.3D',
		action = function(sc)MGR.scene_to_3d{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Top',
		action = function(sc)MGR.scene_to_top{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Front',
		action = function(sc)MGR.scene_to_front{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Back',
		action = function(sc)MGR.scene_to_back{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Left',
		action = function(sc)MGR.scene_to_left{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Right',
		action = function(sc)MGR.scene_to_right{scene=sc,update=true}end;
		view = true,
	}
	Menu.add{
		keyword = 'AP.View.Mode.Bottom',
		action = function(sc)MGR.scene_to_bottom{scene=sc,update=true}end;
		view = true,
	}
end


