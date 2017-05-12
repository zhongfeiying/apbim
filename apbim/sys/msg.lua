
local action_ = require'sys.res.id_mgr'	

function create_dlgtree()
end

function frm_on_command(id)
	require"sys.msg.id".frm_on_command(id);
end
function frm_on_command(id)
	local f = action_.get_frame_action(id);
	if type(f)=='function' then f(id) end
end

function on_command(id,scene)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.msg.id".on_command(id,scene);
	require"sys.statusbar".update();
end
function on_command(id,sc)
	local f = action_.get_action(id);
	if type(f)=='function' then f(sc,id) else trace_out("msg: on_command, id = "..id.."\n") end
end

function on_timer(scene,id)
-- require'sys.table'.totrace{msg_on_timer=id};
	require"sys.mgr".set_cur_scene(scene);
	require"sys.msg.id".on_timer(scene,id);
	-- require"sys.statusbar".update();
end

function on_paint(scene)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_paint(scene)
	require"sys.statusbar".update();
end

function render_objs(scene)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.mgr.scene.object".on_draw(scene)
end

function render_drags(scene)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.mgr.drag".on_draw(scene)
end

function free_scene(scene)
	require"sys.mgr".close_scene(scene);
	require"sys.statusbar".update();
end

function begin_select()
	require"sys.msg.select".start();
end

function select_main(index)
	require"sys.msg.select".step(index);
end

function end_select()
	require"sys.msg.select".stop();
	require"sys.mgr".update();
	require"sys.statusbar".update();
end
function on_mousemove(scene,flags,x,y)
	require"sys.cmd".on_mousemove(scene,flags,x,y)
end
function on_lbuttondown(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_lbuttondown(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_lbuttonup(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_lbuttonup(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_lbuttondblclk(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.mgr".edit_property(scene);
	require"sys.cmd".on_lbuttondblclk(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_mbuttondown(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_mbuttondown(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_mbuttonup(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_mbuttonup(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_mbuttondblclk(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_mbuttondblclk(scene,flags,x,y)
	require"sys.mgr".scene_to_fit{scene=scene,ents=require"sys.mgr".get_scene_all(scene)};
	require"sys.statusbar".update();
end
function on_rbuttondown(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_rbuttondown(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_rbuttonup(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_rbuttonup(scene,flags,x,y)
	require"sys.statusbar".update();
end
function on_rbuttondblclk(scene,flags,x,y)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.cmd".on_rbuttondblclk(scene,flags,x,y)
	require"sys.statusbar".update();
end

function on_keydown(scene,key)
	require"sys.mgr".set_cur_scene(scene);
	require"sys.msg.keydown".call(scene,key);
	require"sys.statusbar".update();
end

function scene_onsize(scene,cx,cy)
	require"sys.mgr.scene".set_size(scene,cx,cy);
end


function onchat(send,msg)
end

function frmclose()
	os.exit()
end
 
