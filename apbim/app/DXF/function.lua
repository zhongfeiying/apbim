_ENV = module(...,ap.adv)



function Import_DXF(sc)
	-- local sc = require"sys.mgr".new_scene();
	local file = require'sys.iup'.open_file_dlg{extension='dxf'};
	if not file or file=='' then return end
	require'apx.dxf.io'.Read{File=file,Index='tekla_id'};
	-- require'apx.dxf.io'.Read{file=file,index=function(k,v) return type(v)=='table' and v.tekla_id or k end};
	-- require"sys.mgr".update(sc);
	require'sys.statusbar'.update();
	require"sys.mgr".model_commit();
end


function load()
	require"sys.menu".add{app="DXF",frame=true,view=true,pos={"Window"},name={"File","Import","DXF"},f=Import_DXF};
end
