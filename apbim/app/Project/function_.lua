_ENV = module(...,ap.adv)

local function draw_model(arg)
	local sc = require"sys.mgr".new_scene(arg.name);
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
end

--[[
local function Open_ID(sc)
	require"app.Project.gid_dlg".pop{
		on_ok = function(arg)
			require"sys.main".init();
			-- require"sys.mgr".open(require"app.Project.info".get_model_pos(),arg.name);
			-- require"sys.mgr".set_model_pos(require"app.Project.info".get_model_pos());
			require"sys.mgr".set_model_gid(arg.name);
			require"sys.mgr".open();
			require"sys.statusbar".show_model_count();
			require"sys.statusbar".show_selection_count();
		end
	};
end
--]]

local function Open(sc)
	require"app.Project.dlg".pop{
		on_ok=function(arg)
			require"sys.main".init();
			require"app.Project.info".set_name(arg.name);
			require"app.Project.info".set_pos(arg.path..arg.name.."\\");
			require"app.Project.info".set_gid(arg.gid);
			if not require"app.Project.info".get_pos() then return end;
			require"sys.api.dir".create_folder(require"app.Project.info".get_model_pos());
			require"sys.mgr".set_model_name(require"app.Project.info".get_name());
			require"sys.mgr".set_model_pos(require"app.Project.info".get_model_pos());
			require"sys.mgr".set_model_gid(require"app.Project.info".get_gid());
			require"sys.mgr".open();
			-- require"sys.mgr".open(require"app.Project.info".get_model_pos(),require"app.Project.info".get_gid());
			require"sys.statusbar".show_name(arg.name);
			require"sys.statusbar".show_model_count();
			require"sys.statusbar".show_selection_count();
		end
	};
end

local function Save_as(sc)
	require"app.Project.dlg".pop{
		on_ok=function(arg)
			require"app.Project.info".set_name(arg.name);
			require"app.Project.info".set_pos(arg.path..arg.name.."\\");
			if not require"app.Project.info".get_pos() then return end;
			require"sys.api.dos".rd(require"app.Project.info".get_model_pos());
			require"sys.api.dir".create_folder(require"app.Project.info".get_model_pos());
			-- require"sys.mgr".save(require"app.Project.info".get_model_pos(),require"app.Project.info".get_gid(),require"app.Project.info".get_name());
			require"sys.mgr".set_model_name(require"app.Project.info".get_name());
			require"sys.mgr".set_model_pos(require"app.Project.info".get_model_pos());
			require"sys.mgr".set_model_gid(require"app.Project.info".get_gid());
			require"sys.mgr".save();
			require"sys.statusbar".show_name(arg.name);
			require"sys.statusbar".show_model_count();
			require"sys.statusbar".show_selection_count();
		end
	};
end

local function Save(sc)
	if require"app.Project.info".get_model_pos() then 
		require"sys.mgr".set_model_name(require"app.Project.info".get_name());
		require"sys.mgr".set_model_pos(require"app.Project.info".get_model_pos());
		require"sys.mgr".set_model_gid(require"app.Project.info".get_gid());
		require"sys.mgr".save();
		return 
	end
	Save_as(sc);
end

local function import(sc)
	local pos = "D:\\Projects\\ABC\\Model\\";
	require"sys.mgr".import_folder(pos);
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
	require"sys.statusbar".show_model_count();
	require"sys.statusbar".show_selection_count();
end

local function Import_Group(sc)
	require"app.Project.gid_dlg".pop{
		on_ok = function(arg)
			if type(arg)~="table" or type(arg.name)~="string" or arg.name=="" then return end
			require"sys.mgr".import_group(arg.name);
			require"sys.statusbar".show_model_count();
			require"sys.statusbar".show_selection_count();
		end
	};
end

local function Show_gid(sc)
	require"app.Project.gid_dlg".pop{name=require"app.Project.info".get_gid()};
end

-- local function Push()
	-- if not require"app.Project.info".get_model_pos() then return end
	-- require"sys.mgr".push(require"app.Project.info".get_gid());
-- end

-- local function Pull()
	-- if not require"app.Project.info".get_model_pos() then return end
	-- require"sys.mgr".pull(require"app.Project.info".get_gid());
-- end


function load()
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","New"},f=Open};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Open"},f=Open};
	-- require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Open ID"},f=Open_ID};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Save"},f=Save};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Save as"},f=Save_as};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Show ID"},f=Show_gid};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Import","Submodel"},f=Import_Group};
	require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('S'),f=Save};
	-- require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Push"},f=Push};
	-- require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Pull"},f=Pull};
end
