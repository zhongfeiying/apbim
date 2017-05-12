_ENV = module(...,ap.adv)

local function get_file()
	local file = require"sys.iup".save_file_dlg{extension="pdf"};
	if not file or file=="" then return end
	return file;
end

local function get_ents()
	local ents = require"sys.mgr".curs();
	if require"sys.table".count(ents) <=0 then ents = require"sys.mgr".get_all()end
	if require"sys.table".count(ents) <=0 then return end
	return ents;
end

local function add_idtf(idf,ent)
	if type(ent.on_draw_rendering)=="function" then ent:on_draw_rendering() end
	local obj = require"sys.Entity".Class.get_shape_rendering(ent);
	-- if type(obj)~="table" then obj = require"sys.Entity".Class.get_shape_diagram(ent) end
	if type(obj)~="table" then require'sys.str'.totrace("Warning: undefined Rendering: "..ent.Classname) return end
	-- obj.color = require"sys.Entity".Class.get_color_gl(ent);
	obj.color = ent.Color and require"sys.geometry".Color:new(ent.Color):get_gl();
	obj.index = require"sys.mgr.scene.index".get_objid(ent.mgrid);
	idf:add_obj(obj);
end

local function export(sc)
	local ents = get_ents() if require"sys.table".count(ents)<=0 then return end
	local pdf = get_file() if not pdf then return end
	
	local run = require"sys.progress".create{title="Export ... ",count=require"sys.table".count(ents),time=1};
	local idf = idtf:create();
	for k,v in pairs(ents) do
		v=require"sys.mgr".get_table(k,v);
		add_idtf(idf,v);
		run();
	end
	local run,close = require"sys.progress".create{title="Save PDF File ...",text=true,time=1}
	idf:save(pdf..".idtf");
	run("Save IDTF");
	idf:to_u3d(pdf..".u3d");
	idf = nil;
	run("Save U3D");
	require"app.PDF3D.u3d".to_pdf(pdf..".u3d",pdf);
	
	run("Open PDF");
	require"sys.api.dos".del(pdf..".idtf");
	require"sys.api.dos".del(pdf..".u3d");
	require"sys.api.dos".start(pdf);
	close();
end


function load()
	require"sys.menu".add{frame=true,view=true,app="PDF3D",name={"File","Export","PDF3D"},pos={"File","Close"},f=export};
end
