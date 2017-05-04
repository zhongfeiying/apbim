_ENV = module(...,ap.adv)

function draw_beam(sc)
	-- require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Steel.Member".Class:new{Type="Beam",Color={0,0,255},Mode=require"sys.Entity".Rendering,Section="H200*100*5*12",Beta=0}}};
	require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Steel.Member".Class:new{Type="Beam",Color={0,0,255},Section="H200*100*5*12",Beta=0}:set_mode_rendering()}};
	require"sys.mgr".model_commit();
end

local function draw_joint(sc)
	require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Steel.Joint".Class:new{Type="Joint",Color={255,255,0},Mode=require"sys.Entity".Rendering}}};
	require"sys.mgr".model_commit();
end

local function add_model(sc)
	require"app.Steel.add_model_dlg".pop(sc);
end

local function add_beam(sc)
	if not require"sys.io".is_there_file{file="app/Steel/Member.lua"} then return end
	local t =require"app.Steel.Member".Class:new{Type="Girder",Color=require"sys.geometry".color_index(1),Section="H-200*100*5*15"};
	t:add_pt{0,0,0};
	t:add_pt{0,0,3000};
	t:set_mode_rendering();
	t:align_bottom();
	t:align_center_v();
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	return t;
end

local function add_line(sc)
	if not require"sys.io".is_there_file{file="app/Graphics/Line.lua"} then return end
	local t =require"app.Graphics.Line".Class:new{Type="Assistant",Color={0,255,0}};
	t:add_pt{0,0,0};
	t:add_pt{0,2000,0};
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	return t;
end

local function add_group(ts)
	if not require"sys.io".is_there_file{file="sys/Group.lua"} then return end
	local t =require"sys.Group".Class:new{Name="Test"};
	for k,v in pairs(ts) do
		t:add_id(v.mgrid);
	end
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	return t;
end

local function add_joint(sc)
	-- require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Steel.Joint".Class:new{Type="Joint",Color={255,255,0},Mode=require"sys.Entity".Rendering}}};
	-- require"sys.mgr".model_commit();
	if not require"sys.io".is_there_file{file="app/Steel/Joint.lua"} then return end
	local t =require"app.Steel.Joint".Class:new{Type="Joint",Color={0,255,0}};
	t:add_pt{0,0,0};
	t:add_part('123');
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	return t;
end

local function test(sc)
	sc = sc or require"sys.mgr".new_scene();
	local t1 = add_beam(sc);
	local t2 = add_line(sc)
	local t = add_group{t1,t2};
	add_joint();
	-- require"sys.Group".add(t);
-- require"sys.mgr.model".totrace();
	require"sys.mgr".update(sc);
	require"sys.mgr".model_commit();
end

function load()
	require"sys.menu".add{view=true,app="Steel",pos={"Window"},name={"Steel","Beam"},f=draw_beam};
	-- require"sys.menu".add{view=true,app="Steel",pos={"Window"},name={"Steel","Joint"},f=draw_joint};
	require"sys.menu".add{frame=true,view=true,app="Steel",pos={"Window"},name={"Steel","Add","Model"},f=add_model};
	require"sys.menu".add{frame=true,view=true,app="Steel",pos={"Window"},name={"Steel","Test"},f=test};
	-- require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('T'),f=test};
end

