_ENV = module(...,ap.adv)

local MGR = require'sys.mgr'
local Menu = require'sys.menu'

local function esc()
	-- require"sys.main".esc();
	require"sys.cmd".esc(sc or require"sys.mgr".get_cur_scene());
end

local function about(sc)
	require'sys.interface.about_dlg'.pop()
end

local function custom_app()
	-- require"sys.load.dlg".pop(require'sys.mgr'.get_user_path()..require'sys.mgr'.get_user().."__app_sulosion.lua","cfg/solution/");
	require"sys.load.dlg".pop("cfg/app.lua","cfg/solution/");
end

local function Reset_Password()
	require"sys.interface.password_dlg".pop();
end

local function Restart()
	require"sys.api.dos".start('gcad.exe');
	os.exit();
end

local function reload(sc)
	require"sys.main".reload();
end

local function import_apt(sc)
	local file = require'sys.iup'.open_file_dlg{extension='lua'};
	if not file or file=='' then return end
	require'sys.mgr'.start(file);
end

function load()
	-- require"sys.menu".add{app="sys",name={"Tools"},pos={"Window"}};
	require"sys.menu".add{frame=true,view=true,app="sys",pos={"Window"},name={"Tools","Custom","App Solution"},f=custom_app};
	require"sys.menu".add{frame=true,view=true,app="sys",pos={"Window"},name={"Tools","Reset Password"},f=Reset_Password};
	require"sys.menu".add{frame=true,view=true,app="sys",pos={"Window"},name={"Tools","Restart"},f=Restart};
	-- require"sys.menu".add{frame=true,view=true,app="sys",pos={"Window"},name={"Tools","Test"},f=require'sys.dlg'.show};
	-- require"sys.menu".add{frame=true,view=true,app="sys",pos={"File","Close"},name={"File","Import","KVADEL"},f=import_apt};
	-- require"sys.menu".add{frame=true,view=true,app="sys",name={"Tools","Custom","Reload"},f=reload};
	require"sys.menu".add{frame=true,view=true,app="sys",name={"Help","About"},f=about};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools","T"},f=custom_app};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools",""}};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools","T","T1"}};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools","B","B1"},f=custom_app};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools","B"},f=custom_app};
	-- require"sys.menu".add{app="sys",pos={"Window"},name={"Tools",""}};
	require"sys.msg.keydown".set{key=require"sys.api.ascii".Esc(),f=esc};
	-- require'sys.dock'.add_page(require'sys.net.progress'.show());
	
	Menu.add{
		keyword = 'AP.Tools.Restart',
		action = Restart;
		frame = true,
		view = true,
	}
	Menu.add{
		keyword = 'AP.Help.About',
		action = about;
		frame = true,
		view = true,
	}
	
end


