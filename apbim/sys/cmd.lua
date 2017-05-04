_ENV = module(...,ap.adv)

local drag_ = require"sys.drag";

local SELECT_ = require"sys.cmd.Select".Command;
local IDLE_ = require"sys.cmd.Idle".Command;
local cur_ = IDLE_;

----public----

function set_idle(sc)
	cur_ = IDLE_;
	sc = sc or require "sys.mgr" .get_cur_scene();
	if not sc then return end
	scene_cursor(sc,IDC_ARROW)
end

function set_select(sc)
	cur_ = SELECT_;
	sc = sc or require "sys.mgr" .get_cur_scene();
	if not sc then return end
	scene_cursor(sc,IDC_HELP)
end

local function set_other(cmd,sc)
	cur_ = cmd;
	sc = sc or require "sys.mgr" .get_cur_scene();
	if not sc then return end
	scene_cursor(sc,IDC_CROSS)
end

function init(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	if type(cur_)=="table" and type(cur_.init)=="function" then cur_:init(sc) end
	if drag_.is_running() then drag_.stop(sc) end;
	set_idle(sc);
end

function esc(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	if type(cur_)=="table" and type(cur_.init)=="function" then cur_:init(sc) end
	if drag_.is_running() then drag_.stop(sc) set_idle(sc) return end;
	if cur_ ~= IDLE_ then set_idle(sc) return end;
	require"sys.mgr".select_none{scene=sc,redraw=true};  
	require"sys.mgr".update(sc)
end

-- t={command=}
function set(t)
	if type(t.command)~="table" then trace_out("sys.cmd.set(cmd), it isn't a valid command") return end;
	init();
	set_other(t.command);
end


function on_paint(scene)
	drag_.update(scene);
	-- if type(cur_.on_paint)=="function" then cur_:on_paint(scene) end
end

function on_mousemove(scene,flags,x,y)
	if type(cur_.on_mousemove)=="function" then cur_:on_mousemove(scene,flags,x,y) end
end

function on_lbuttondown(scene,flags,x,y)
	if type(cur_.on_lbuttondown)=="function" then cur_:on_lbuttondown(scene,flags,x,y) end
end

function on_lbuttonup(scene,flags,x,y)
	if type(cur_.on_lbuttonup)=="function" then cur_:on_lbuttonup(scene,flags,x,y) end
end

function on_lbuttondblclk(scene,flags,x,y)
end

function on_mbuttondown(scene,flags,x,y)
end

function on_mbuttonup(scene,flags,x,y)
end

function on_mbuttondblclk(scene,flags,x,y)
end

function on_rbuttondown(scene,flags,x,y)
end

function on_rbuttonup(scene,flags,x,y)
end

function on_rbuttondblclk(scene,flags,x,y)
end
