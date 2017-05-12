 _ENV = module(...,ap.adv)

function run_apsteel(sc)
	sc = sc or require"sys.mgr".new_scene();
	
	
	--trace_out("sdfsdf\n");
end
function run_cutplane_manage()
	require "app.ApSteel.dlg_cutplane".pop();

end
function run_tekla_import_manage()
	require "app.ApSteel.dlg_tekla_import".pop();
end


function load()
	require"sys.menu".add{frame=true,view=true,app="ApSteel",name={"Tools","ApSteel"},pos={"Tools","Develop"},f=run_apsteel};
	require"sys.menu".add{frame=true,view=true,app="ApSteel",name={"Model","CutPlane Manage"},pos={"Model"},f=run_cutplane_manage};
	require"sys.menu".add{frame=true,view=true,app="ApSteel",name={"Model","Tekla Import Manage"},pos={"Model"},f=run_tekla_import_manage};
end