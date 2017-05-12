_ENV = module(...,ap.adv)

local function Wizard(sc)
	require"app.Develop.wizard_dlg".pop(sc);
end

function load()
	require"sys.menu".add{frame=true,view=true,pos={"Window"},name={"Tools","Develop","Wizard"},f=Wizard};
	-- require"sys.menu".add{frame=true,view=true,pos={"Window"},name={"Tools","Develop","New","App"},f=new_app};
	-- require"sys.menu".add{frame=true,view=true,pos={"Window"},name={"Tools","Develop","New","Class"},f=new_class};
end



