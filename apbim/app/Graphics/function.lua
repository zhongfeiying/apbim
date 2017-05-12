_ENV = module(...,ap.adv)

function draw_rect(sc)
	require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Graphics.Rect".Class:new{Type="Assistant",Color={0,255,0}}}};
	require"sys.mgr".model_commit();
end

function draw_line(sc)
	require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Graphics.Line".Class:new{Type="Assistant",Color={0,255,0}}}};
	require"sys.mgr".model_commit();
end

local function add_line(sc)
	require"app.Graphics.add_line_dlg".pop(sc);
end

local function test(sc)
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/Graphics/Line.lua"} then return end
	local item =require"app.Graphics.Line".Class:new{Type="Assistant",Color={0,255,0}};
	item:add_pt{0,0,0};
	item:add_pt{4000,0,0};
	item:update_data();
	require"sys.mgr".add(item);
	require"sys.mgr".draw(item,sc);
	require"sys.mgr".update(sc);
	require"sys.mgr".model_commit();
end


function load()
	require"sys.menu".add{view=true,pos={"Window"},name={"Graphics","Line"},f=draw_line};
	require"sys.menu".add{view=true,pos={"Window"},name={"Graphics","Rect"},f=draw_rect};
	require"sys.menu".add{frame=true,view=true,pos={"Window"},name={"Graphics","Test"},f=test};
	require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('L'),f=draw_line};
	require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('R'),f=draw_rect};
end



