_ENV = module(...,ap.adv)



local function Add_File(sc)
	local t =require"app.Wise.File".Class:new{Type="File"};
	t.Name = 'gcad.exe';
	t.hid = require'sys.hid'.get_by_file(t.Name);
	require"sys.api.dos".copy(t.Name,require"sys.mgr".get_db_path()..t.hid);
	require"sys.mgr".add(t);
end

local function Add_Folder(sc)
	local t1 =require"app.Wise.File".Class:new{Type="File"};
	t1.Name = 'main.lua';
	t1.hid = require'sys.hid'.get_by_file(t1.Name);
	require"sys.api.dos".copy(t1.Name,require"sys.mgr".get_db_path()..t1.hid);
	require"sys.mgr".add(t1);

	local t2 =require"app.Wise.File".Class:new{Type="File"};
	t2.Name = 'gcad.exe';
	t2.hid = require'sys.hid'.get_by_file(t2.Name);
	require"sys.api.dos".copy(t2.Name,require"sys.mgr".get_db_path()..t2.hid);
	require"sys.mgr".add(t2);
	
	local t =require"app.Wise.Folder".Class:new{Type="Folder"};
	t.Name = 'sys';
	t:add_id(t1:get_id());
	t:add_id(t2:get_id());
	require"sys.mgr".add(t);
	
	require'sys.dock'.add_page(require'app.Wise.file_page'.pop{});
	require'sys.dock'.active_page(require'app.Wise.file_page'.get());
end


function load()
	require"sys.menu".add{app="Wise",frame=true,view=true,pos={"Window"},name={"Wise","Add","File"},f=Add_File};
	require"sys.menu".add{app="Wise",frame=true,view=true,pos={"Window"},name={"Wise","Add","Folder"},f=Add_Folder};
end

