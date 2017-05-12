_ENV = module(...,ap.adv)

local scene_name_ = "Timer"

-- arg={scene=,msec=,f=}
function set(arg)
	local sc = arg.scene or require"sys.mgr".get_cur_scene() or require"sys.mgr".new_scene{name=scene_name_};
	local id = require"sys.interface.id".get_timer_id();
	require"sys.interface.id".set_timer{id=id,f=arg.f};
	if not sc then return nil end
	set_timer(sc,id,arg.msec or 1000);
	return id;
end

-- arg={scene=,id=}
function kill(arg)
	local sc = arg.scene or require"sys.mgr".get_cur_scene() or require"sys.mgr".new_scene{name=scene_name_};
	if not sc then return nil end
	kill_timer(sc,arg.id);
	require"sys.mgr".close_scene{name=scene_name_}
end

