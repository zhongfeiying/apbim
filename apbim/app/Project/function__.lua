_ENV = module(...,ap.adv)

-- local index_file_ = "__index.apc";
-- local MODEL_FOLDER_ = "Model\\";

-- local ZIP_EXNAME_ = '.apc'

-- local info_ = nil;--{name=,path=}

function init()
	-- info_ = nil;
end

-------------------------------------------------------------------------------------

function get_zip_by_path(id)
	if not id then return nil end
	local path = require'sys.mgr.zip'.get_path();
	local s = require"sys.table".sortk(require"sys.api.dir".get_filename_list(path));
	for i,v in pairs(s) do
		local zipid = require"sys.zip".read{zip=path..v,file="Model\\__index.lua"}
		local name = require'sys.str'.get_prename(v);
		if zipid and zipid==id then return {path=path,name=name} end
	end
end

-- t={name=,path=}
local function save(t)
	t = t or {};
	local name = t.name;
	local path = t.path;
	if name and not require'sys.mgr'.get_model_name() then require'sys.mgr'.set_model_name(name); end
	if name then require'sys.mgr'.set_zip_name(name); end
	if path then require'sys.mgr'.set_zip_path(path); end
	require'sys.mgr'.save();
	require"sys.statusbar".update();
end

-- arg={name=,path=}
function open_name(arg)
	local path = arg.path or require"app.Project.dlg".get_path();
	local name = arg.name;
	if not path then return end;
	if not name then return end;
	if not name == require"sys.mgr".get_zip_name() then return end;
	
	require"sys.main".init();
	require"sys.mgr".set_model_name(name);
	require"sys.mgr".set_zip_name(name);
	require"sys.mgr".set_zip_path(path);
	require"sys.mgr".open();
	require"sys.statusbar".update();
	require"sys.net.main".subscribe(require"sys.mgr".get_model_id());
end

-- t={id=,cbf=}
function open_id(t)
require"sys.str".totrace("Open Project:"..t.id..'\n');
	t = t or {};
	if not t.id then return end
	if require"sys.mgr".get_model_id()~=t.id then close() end
	require"sys.mgr".set_model_id(t.id);
	require"sys.mgr".download{open=true,update=false}
	require"sys.statusbar".update();
	-- require"sys.mgr".download{
		-- cbf=function()
			-- require"sys.statusbar".update();
			-- if type(t.cbf)=='function' then t.cbf() end
		-- end
	-- }
end

function close()
	require"sys.main".init();
	require"sys.statusbar".update();
end


local function New(sc)
	require"app.Project.dlg".pop{
		title="New Project";
		same=false;
		exname=require'sys.mgr'.get_zip_exname();
		on_ok=function(arg)
			open_name(arg);
			require'sys.mgr'.save();
		end
	};
end

local function Open(sc)
	require"app.Project.dlg".pop{
		title="Open Project";
		same=true;
		exname=require'sys.mgr'.get_zip_exname();
		on_ok=open_name;
	};
end

local function Save_as()
	local arg = get_zip_by_path(require"sys.mgr".get_model_id());
	if arg then save(arg) return; end

	require"app.Project.dlg".pop{
		title="Save Project";
		exname=require'sys.mgr'.get_zip_exname();
		same=false;
		on_ok=function(arg)
			local zipfile = arg.path..arg.name..require'sys.mgr'.get_zip_exname();
			os.remove(zipfile);
			save(arg)
		end
	};
end

local function Save()
	if not require"sys.mgr".get_zip_file() then Save_as() return end
	require"sys.mgr".save();
end

local function Upload()
	Save();
	require"sys.mgr".upload{};
	-- require'app.Project.gid_list_dlg'.add{id=require"sys.mgr".get_model_id(),Name=require"sys.mgr".get_model_name(),Remark=(require"sys.mgr".get_user()or '').."'s project."}
end

local function Download()
	require"sys.mgr".model_update{};
	require"sys.mgr".download{open=true,update=true};
	require"sys.statusbar".update();
end

local function Clear()
	require"sys.net.temp".clear{};
end

local function Show_ID(sc)
	require"app.Project.gid_dlg".pop{gid=require'sys.mgr'.get_model_id()};
end


local function Import_Group_ID()
	require"app.Project.gid_dlg".pop{
		on_ok = function(arg)
			require"sys.mgr".import_id{arg.gid};
		end
	};
end

local function Close(sc)
	close();
end


function load()
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","New"},f=New};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Open"},f=Open};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Save"},f=Save};
	-- require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Show ID"},f=Show_ID};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Submit"},f=Upload};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Update"},f=Download};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Clear"},f=Clear};
	require"sys.menu".add{frame=true,view=true,app="Project",pos={"File","Close"},name={"File","Project","Close"},f=Close};
	require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('S'),f=Save};
	require'sys.dock'.add_page(require'app.Project.gid_list_dlg'.pop());
end
