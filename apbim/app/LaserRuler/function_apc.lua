_ENV = module(...,ap.adv)

local function new()
	return require"sys.mgr".new_scene();
end

local function test(sc)
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/LaserRuler/Member.lua"} then return end
	local t =require"app.LaserRuler.Member".Class:new{Type="LaserRuler",Color={0,0,255}};
	t:add_pt{0,2000,0};
	t:add_pt{0,1000,0};
	t:set_mode_rendering();
	t:add_section{w1=500,w2=200,p=0};
	t:add_section{w1=500,w2=200,p=1000};
	t:add_section{w1=350,w2=200,p=1100};
	t:add_section{w1=280,w2=200,p=1200};
	t:add_section{w1=230,w2=200,p=1300};
	t:add_section{w1=210,w2=200,p=1400};
	t:add_section{w1=200,w2=200,p=1500};
	t:add_section{w1=200,w2=200,p=3500};
	t:add_section{w1=500,w2=200,p=4000};
	t:add_section{w1=500,w2=200,p=5000};
	t.Circle=true;
	-- t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	if not require"sys.io".is_there_file{file="app/LaserRuler/Member.lua"} then return end
	local t =require"app.LaserRuler.Member".Class:new{Type="LaserRuler",Color={0,0,255}};
	t:add_pt{1000,2000,0};
	t:add_pt{1000,1000,0};
	t:set_mode_rendering();
	t:add_section{w1=500,w2=200,p=0};
	t:add_section{w1=500,w2=200,p=1000};
	t:add_section{w1=350,w2=200,p=1100};
	t:add_section{w1=280,w2=200,p=1200};
	t:add_section{w1=230,w2=200,p=1300};
	t:add_section{w1=210,w2=200,p=1400};
	t:add_section{w1=200,w2=200,p=1500};
	t:add_section{w1=200,w2=200,p=3500};
	t:add_section{w1=500,w2=200,p=4000};
	t:add_section{w1=500,w2=200,p=5000};
	-- t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end

local function get_file()
	local f = require"sys.iup".open_file_dlg{directory="Sample/LaserRuler/",extension="apc"};
	if not f or f=="" then return end
	return f;
end

local function get_folder()
	local f = require"sys.iup".open_dir_dlg{directory="Sample/LaserRuler/"};
	-- local f = require"sys.iup".open_dir_dlg{directory="D:/ABC/"};
	if not f or f=="" then return end
	return f;
end

local function import_file(sc)
	sc = sc or require"sys.mgr".new_scene();
	local f = get_file();
	if not f then return end
	require"sys.mgr".import_file(f);
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
end

local function import_folder(sc)
	sc = sc or require"sys.mgr".new_scene();
	local f = get_folder();
	if not f then return end
	require"sys.mgr".import_folder(f);
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
end

function load()
	-- require"sys.menu".add{frame=true,view=true,app="LaserRuler",pos={"Window"},name={"LaserRuler","New"},f=new};
	-- require"sys.menu".add{frame=true,view=true,app="LaserRuler",pos={"Window"},name={"LaserRuler","Test"},f=test};
	require"sys.menu".add{frame=true,view=true,app="LaserRuler",pos={"File","Close"},name={"File","Import","File"},f=import_file};
	-- require"sys.menu".add{frame=true,view=true,app="LaserRuler",pos={"File","Close"},name={"File","Import","Folder"},f=import_folder};
end
