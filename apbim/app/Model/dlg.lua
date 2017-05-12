_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"


local gid_lab_ = iup.label{title="ID:",rastersize="50X"};
local gid_txt_ = iup.text{rastersize="350X",CANFOCUS="NO",READONLY="Yes",};
local name_lab_ = iup.label{title="Name:",rastersize="50X"};
local name_txt_ = iup.text{rastersize="350X",CANFOCUS="NO",value="New"};
local name_mat_ = iup.matrix{expand="Yes",READONLY="Yes",resizematrix="YES",numcol=2,numcol_visible=2,numlin_visible=16,width1=125,width2=125};
local all_ = iup.button{title="All"	,rastersize="60X30"};
local add_ = iup.button{title="Add"	,rastersize="60X30"};
local del_ = iup.button{title="Delete"	,rastersize="60X30"};
local modify_ = iup.button{title="Modify"	,rastersize="60X30"};
local open_ = iup.button{title="Open"	,rastersize="60X30"};
local show_ = iup.button{title="Show"	,rastersize="60X30"};

local color_overall = 1;
local cfg_file_ = "cfg\\project.lua";

local dlg_ = iup.dialog{
	title = "Submodel";
	resize = "NO";
	rastersize = "455x";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_,name_txt_};
				iup.hbox{gid_lab_,gid_txt_};
				iup.hbox{name_mat_};
			};
		};
		iup.hbox{add_,del_,modify_,open_,show_};
		alignment="aRight";
	};
};

local function init_name_mat()
	local i = 0;
	name_mat_.numlin = i;
	name_mat_:setcell(i,1,"Name");
	name_mat_:setcell(i,2,"ID");
	local smds = require"sys.mgr".get_class_all(require"sys.Group".Class);
	for k,v in pairs(smds) do
		i = i+1;
		local smd = require"sys.mgr".get_table(k,v);
		local name = type(smd)=="table" and smd.Name;
		local mgrid = type(smd)=="table" and smd.mgrid;
		name_mat_.numlin = i;
		name_mat_:setcell(i,0,i);
		name_mat_:setcell(i,1,name);
		name_mat_:setcell(i,2,mgrid);
	end
	name_mat_.numlin=math.max(i,20);
	name_mat_.redraw = "ALL";
end

local function on_name_mat(i)
	name_mat_["BGCOLOR" .. color_overall .. ":" .. "*"] = "255 255 255"; 
	local cell = name_mat_.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local name = name_mat_:getcell(lin,1);
	local gid = name_mat_:getcell(lin,2);
	name_mat_["BGCOLOR" .. lin .. ":" .. "*"] = "158 158 158";
	color_overall = lin;
	name_mat_.redraw = "ALL";
	name_txt_.value = name;
	gid_txt_.value = gid;
end

local function on_all(t)
	for i,v in ipairs(require"sys.mgr".find_scene{name="Model"}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name="Model"};
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
end

local function on_add(t)
	if name_txt_.value=="" then return end
	local smd = require"sys.Group".Class:new{Name=name_txt_.value};
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	smd:set_scene(sc);
	smd:add_scene_all();
	require"sys.mgr".add(smd);
	require"sys.statusbar".show_model_count();
	init_name_mat();
end

local function on_del(t)
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,2);
	local sdm = require"sys.mgr".get_table(id);
	if type(sdm)~="table" then return end
	require"sys.mgr".del(sdm);
	require"sys.statusbar".show_model_count();
	init_name_mat();
end

local function on_modify(t)
	if name_txt_.value=="" then return end
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,2);
	if id=="" then on_add(t) end
	local sdm = require"sys.mgr".get_table(id);
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	sdm.Name = name_txt_.value;
	sdm:set_scene(sc);
	sdm:clear_items();
	sdm:add_scene_all();
	require"sys.statusbar".show_model_count();
	init_name_mat();
end

local function on_open(t)
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,2);
	local sdm = require"sys.mgr".get_table(id);
	if type(sdm)~="table" then return end
	sdm:open{name=sdm.Name};
end

local function on_show(t)
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,2);
	local sdm = require"sys.mgr".get_table(id);
	if type(sdm)~="table" then return end
	sdm:show{name=sdm.Name};
end

local function init()
	init_name_mat();
end

function all_:action()on_all(t)end
function add_:action()on_add(t)end
function del_:action()on_del(t)end
function modify_:action()on_modify(t)end
function open_:action()on_open(t)end
function show_:action()on_show(t)end
function name_mat_:click_cb()on_name_mat()end

function pop()
	init();
	dlg_:show();
	on_name_mat(1)
end
