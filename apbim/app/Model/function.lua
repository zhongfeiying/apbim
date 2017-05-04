_ENV = module(...,ap.adv)

--[[
local function all()
	for i,v in ipairs(require"sys.mgr".find_scene{name="Model"}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name="Model"};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require"sys.Entity".Class.is_hidden(v) then 
			require"sys.Entity".Class.show(v);
			-- require"sys.Entity".Class.set_color(v,{0,0,0});
		end
		require"sys.mgr".draw(v,sc);
		run();
	end
	require"sys.mgr".update(sc);
end
--]]

function Default()
	local name = "Model(Default)"
	for i,v in ipairs(require"sys.mgr".find_scene{name=name}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name=name};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=0.1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		-- require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Diagram);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	-- require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	-- require"sys.mgr".update(sc);
	local run,stop = require"sys.progress".create{title="Show ... ",text=true};
	run("The Window is updating ...")
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	run("The Window is updating ...")
	require"sys.mgr".update(sc);
	run("The Window is updating ...")
	stop();
end

function Diagram()
	local name = "Model(Diagram)"
	for i,v in ipairs(require"sys.mgr".find_scene{name=name}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name=name};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=0.1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Diagram);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	-- require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	-- require"sys.mgr".update(sc);
	local run,stop = require"sys.progress".create{title="Show ... ",text=true};
	run("The Window is updating ...")
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	run("The Window is updating ...")
	require"sys.mgr".update(sc);
	run("The Window is updating ...")
	stop();
end

function Wireframe()
	local name = "Model(Wireframe)"
	for i,v in ipairs(require"sys.mgr".find_scene{name=name}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name=name};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=0.1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Wireframe);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	-- require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	-- require"sys.mgr".update(sc);
	local run,stop = require"sys.progress".create{title="Show ... ",text=true};
	run("The Window is updating ...")
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	run("The Window is updating ...")
	require"sys.mgr".update(sc);
	run("The Window is updating ...")
	stop();
end

function Rendering()
	local name = "Model(Rendering)"
	for i,v in ipairs(require"sys.mgr".find_scene{name=name}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name=name};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=0.1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Rendering);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	local run,stop = require"sys.progress".create{title="Show ... ",text=true};
	run("The Window is updating ...")
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	run("The Window is updating ...")
	require"sys.mgr".update(sc);
	run("The Window is updating ...")
	stop();
end

local function Submodel(sc)
	-- dlgtree_show(frm,true);
	-- require"app.Model.submodel_page".pop();
	require'sys.dock'.add_page(require'app.Model.submodel_page'.pop());
	require'sys.dock'.active_page(require'app.Model.submodel_page'.pop());
end

local function close(sc)
	require"sys.mgr".close_scene(sc)
end

local function close_all(sc)
	local all = require"sys.mgr".get_all_scene();
	for k,v in pairs(all) do
		require"sys.mgr".close_scene(k);
	end
end

local function Test(sc)
	local scs = require"sys.mgr".find_scene{name="Model"}
	for k,v in pairs(scs) do
		sc = v;
		require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
		active_scene(sc)
		require"sys.mgr".update(sc);
	end
end

local function Show_Text(sc)
	show_text_ = not show_text_;
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return {} end
	local run = require"sys.progress".create{title="Text",count=require"sys.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if not require"sys.Entity".Class.is_show_text(v) then 
			require"sys.Entity".Class.show_text(v);
			require"sys.mgr".redraw(v,sc);
		end
		run();
	end
	require"sys.mgr".update();
end

local function Hide_Text(sc)
	show_text_ = not show_text_;
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return {} end
	local run = require"sys.progress".create{title="Text",count=require"sys.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require"sys.Entity".Class.is_show_text(v) then 
			require"sys.Entity".Class.hide_text(v);
			require"sys.mgr".redraw(v,sc);
		end
		run();
	end
	require"sys.mgr".update();
end



function load()
	require"sys.menu".add{name={"Model"},pos={"Window"}};
	-- require"sys.menu".add{app="Model",view=true,name={"Model","Test"},f=Test};
	require"sys.menu".add{app="Model",frame=true,view=true,name={"Model","Show","All"},f=Default};
	require"sys.menu".add{app="Model",frame=true,view=true,name={"Model","Show","Diagram"},f=Diagram};
	require"sys.menu".add{app="Model",frame=true,view=true,name={"Model","Show","Wireframe"},f=Wireframe};
	require"sys.menu".add{app="Model",frame=true,view=true,name={"Model","Show","Rendering"},f=Rendering};
	require"sys.menu".add{app="Model",frame=true,view=true,name={"Model","Submodel"},f=Submodel};
	-- require"sys.menu".add{view=true,pos={"Window"},name={"Model","Text","Show"},f=Show_Text};
	-- require"sys.menu".add{view=true,pos={"Window"},name={"Model","Text","Hide"},f=Hide_Text};
	require"sys.menu".add{app="Model",view=true,name={"Window","Close"},f=close};
	require"sys.menu".add{app="Model",view=true,name={"Window","Close All"},f=close_all};
	-- require'sys.dock'.add_page(require'app.Model.submodel_page'.pop());
	-- require'sys.dock'.add_page(require'app.Model.file_page'.pop());
	Submodel();
end


