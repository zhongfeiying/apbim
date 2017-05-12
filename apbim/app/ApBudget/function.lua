--module(...,package.seeall)
 _ENV = module(...,ap.adv)

function open_apbudget(sc)
	local file = require"app.ApBudget.iupex".open_file_dlg("*");	
	require"app.ApBudget.import".open_model(file);
end

function load()
	require"sys.menu".add{frame=true,view=true,app="ApBudget",name={"File","Import","ApBudget"},pos={"File","Close"},f=open_apbudget};
	
end
