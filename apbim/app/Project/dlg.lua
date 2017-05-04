_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"


local id_lab_ = iup.label{title="ID:",rastersize="50X"};
local id_txt_ = iup.text{rastersize="350X",CANFOCUS="NO",value=""};
local name_lab_ = iup.label{title="Name:",rastersize="50X"};
local name_txt_ = iup.text{rastersize="350X",CANFOCUS="NO",value="NewProject"};
local name_mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol=1,numcol_visible=1,numlin_visible=16,widthdef=250};
local path_lab_ = iup.label{title="Folder:",rastersize="50X"};
local path_txt_ = iup.text{rastersize="250X",readonly="YES",BGCOLOR="200 200 200",CANFOCUS="NO"};
local path_btn_	= iup.button{title="..."	,rastersize="50X",CANFOCUS="NO"};
local update_btn_ = iup.button{title="Update",rastersize="50X",CANFOCUS="NO"}
local ok_ 		= iup.button{title="OK"		,rastersize="100X30"};
local cancel_ 	= iup.button{title="Cancel"	,rastersize="100X30"};

local color_overall = -1;
local cfg_file_ = "cfg\\project.lua";
local PATH_ = "Projects\\";

local dlg_ = iup.dialog{
	title = "Project";
	-- resize = "NO";
	rastersize = "472x";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{path_lab_,path_txt_,path_btn_,update_btn_};
				iup.hbox{name_lab_,name_txt_};
				-- iup.hbox{id_lab_,id_txt_};
				iup.hbox{name_mat_};
			};
		};
		iup.hbox{ok_,cancel_};
		alignment="aRight";
	};
};

local function cfg_path(path)
	local f = loadfile(cfg_file_);
	local t = nil;
	if type(f)=="function" then t = f() end
	if type(t)~="table" then t={} end
	if not path then return t.projects_pos end
	t.projects_pos = path;
	require"sys.api.table".tofile{src=t,file=cfg_file_};
	return t.projects_pos;
end

local function init_id_txt()
	path_txt_.value = "";
end

local function init_path_txt()
	path_txt_.value = cfg_path(path) or PATH_;
end

local function init_name_mat(t)
	local i = 0;
	name_mat_.numlin = i;
	name_mat_:setcell(i,1,"Name");
	-- name_mat_:setcell(i,2,"ID");
	local s = require"sys.table".sortk(require"sys.api.dir".get_filename_list(path_txt_.value));
	-- if type(s)~="table" then return end
	for k,v in pairs(s) do
		i = i+1;
		local name = string.sub(v,1,-1-string.len(t.exname));
		name_mat_.numlin = i;
		name_mat_:setcell(i,0,i);
		name_mat_:setcell(i,1,name);
		-- name_mat_:setcell(i,2,project_id);
	end
	name_mat_.numlin=math.max(i,20);
	name_mat_.redraw = "ALL";
end

local function init(t)
	dlg_.title = t and t.title or dlg_.title
	init_id_txt();
	init_path_txt();
	init_name_mat(t);
end

local function on_path_btn(t)
	local path = require"sys.iup".open_dir_dlg();
	if not path or path=="" then return end;
	path_txt_.value = path;
	init_name_mat(t);
	cfg_path(path);
end

local function on_name_mat(i)
	name_mat_["BGCOLOR" .. color_overall .. ":" .. "*"] = "255 255 255"; 
	local cell = name_mat_.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local prj = name_mat_:getcell(lin,1);
	name_mat_["BGCOLOR" .. lin .. ":" .. "*"] = "158 158 158";
	color_overall = lin;
	name_mat_.redraw = "ALL";
	name_txt_.value = prj;
end

local function is_there_name(name)
	local s = require"sys.api.dir".get_filename_list(path_txt_.value);
	return s[name]
end

local function on_ok(t)
	local id = id_txt_.value;
	local name = name_txt_.value;
	local path = path_txt_.value;
	if name=="" or path=="" then return end
	if not t.same and is_there_name(name..t.exname) then 
		local alarm = iup.Alarm("Warning","There is a same project name, Rename it, please!", "OK")
		return 
	end
	dlg_:hide();
	id = id~="" and id;
	name = name~="" and name;
	path = path~="" and path;
	if type(t.on_ok)=="function" then t.on_ok{id=id;name=name;path=path} end
end

local function on_cancel()
	dlg_:hide();
end

local k_any_={};
k_any_[iup.K_CR] = on_ok;
k_any_[iup.K_ESC] = on_cancel;

-- t={title=,new=nil,name=,exname=,on_ok=function}
function pop(t)
	if type(t)~="table" then trace_out("app.Project.dlg.pop(t), t isn't a table") return end
	-- if type(t.on_ok)~="function" then trace_out("app.Project.dlg.pop(t), t.on_ok isn't a function") return end

	function ok_:action()
		on_ok(t);
	end
	function cancel_:action()
		on_cancel();
	end
	function name_mat_:click_cb()
		on_name_mat();
	end
	function path_btn_:action()
		on_path_btn(t);
	end
	function update_btn_:action()
		init_name_mat(t);
	end
	function dlg_:k_any(n)
		if k_any_[n] then k_any_[n](t) end
	end

	init(t);
	dlg_:show();
	if t.name then name_txt_.value=t.name else on_name_mat(1) end
end


function get_path()
	return cfg_path() or PATH_;
end

function get_project_zipfile(id)
	local path = cfg_path(path) or PATH_;
	local s = require"sys.table".sortk(require"sys.api.dir".get_filename_list(path));
	for i,v in pairs(s) do
		local project_id = require"sys.zip".read{zip=path..v,file="Model\\__index.lua"}
-- require"sys.table".totrace{id=id,project_id=project_id,zip=path..v};
		local name = string.sub(v,1,-5);
		if id==project_id then return {file=path..v,path=path,name=name} end
	end
end
