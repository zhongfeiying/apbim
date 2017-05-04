_ENV = module(...,ap.sys)


function Property(sc)
	require"sys.mgr".show_property(sc);
end

function Information(sc)
	require"app.Show.info_dlg".pop(sc);
end


function Diagram(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	-- local ents = require"sys.mgr".curs();
	local ents = require"sys.mgr".get_scene_selection();
	if not ents then return end
	local run = require"sys.progress".create{title="Diagram",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require"sys.View".get_mode(sc,v.mgrid) ~= require"sys.Entity".Diagram then
			require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Diagram);
			require"sys.mgr".redraw(v,sc);
		end
		-- if require"sys.Entity".Class.get_mode(v) ~= require"sys.Entity".Diagram then
			-- require"sys.Entity".Class.set_mode_diagram(v);
			-- require"sys.mgr".redraw(v);
		-- end
		run();
	end
	require"sys.mgr".update();
end

function Wireframe(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	local ents = require"sys.mgr".get_scene_selection();
	if not ents then return end
	local run = require"sys.progress".create{title="Wireframe",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require"sys.View".get_mode(sc,v.mgrid) ~= require"sys.Entity".Wireframe then
			require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Wireframe);
			require"sys.mgr".redraw(v,sc);
		end
		run();
	end
	require"sys.mgr".update();
end

function Rendering(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	local ents = require"sys.mgr".get_scene_selection();
	if not ents then return end
	local run = require"sys.progress".create{title="Rendering",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require"sys.View".get_mode(sc,v.mgrid) ~= require"sys.Entity".Rendering then
			require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Rendering);
			require"sys.mgr".redraw(v,sc);
		end
		run();
	end
	require"sys.mgr".update();
end

local function light_on(sc)
	require"sys.mgr".light_on();
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return end
	local run = require"sys.progress".create{title="All",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	require"sys.mgr".update();
end

local function light_off(sc)
	require"sys.mgr".light_off();
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return end
	local run = require"sys.progress".create{title="All",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	require"sys.mgr".update();
end
--[[
function load()
	require"sys.menu".add{view=true,pos={"Window"},name={"Show","Property"},f=property};
	-- require"sys.menu".add{view=true,pos={"Window"},name={"Show","Information"},f=Information};
	require"sys.menu".add{view=true,pos={"Window"},name={"Show","Diagram"},f=diagram};
	require"sys.menu".add{view=true,pos={"Window"},name={"Show","Wireframe"},f=wireframe};
	require"sys.menu".add{view=true,pos={"Window"},name={"Show","Rendering"},f=rendering};
	-- require"sys.menu".add{view=true,pos={"Window"},name={"Show","Light On"},f=light_on};
	-- require"sys.menu".add{view=true,pos={"Window"},name={"Show","Light Off"},f=light_off};
end
--]]


