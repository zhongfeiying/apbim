_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"


local gid_lab_ = iup.label{title="ID:",rastersize="50X"};
local gid_txt_ = iup.text{expand="Horizontal",CANFOCUS="NO",READONLY="Yes"};
local name_lab_ = iup.label{title="Name:",rastersize="50X"};
local name_txt_ = iup.text{expand="Horizontal",CANFOCUS="NO",value="New"};
-- local name_mat_ = iup.matrix{expand="Yes",READONLY="Yes",resizematrix="YES",numcol=3,numcol_visible=3,numlin_visible=16,width1=100,width2=50,width3=200};
local name_mat_ = iup.matrix{expand="Yes",READONLY="Yes",resizematrix="YES",numcol=3,width1=100,width2=50,width3=200};
local update_ = iup.button{title="Update"	,rastersize="60X30"};
local all_ = iup.button{title="Update"	,rastersize="60X30"};
local add_ = iup.button{title="Add"	,rastersize="60X30"};
local del_ = iup.button{title="Delete"	,rastersize="60X30"};
local modify_ = iup.button{title="Modify"	,rastersize="60X30"};
local open_ = iup.button{title="Open"	,rastersize="100X30"};
local show_ = iup.button{title="Show"	,rastersize="60X30"};

local gid_col_ = 3;
local name_col_ = 1;
local count_col_ = 2;

local color_overall = 1;
local cfg_file_ = "cfg\\project.lua";

---[[
local page_ = iup.vbox{
	tabtitle = "Submodel";
	resize = "NO";
	margin = "5x5";
	-- expand="Yes";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_,name_txt_};
				iup.hbox{gid_lab_,gid_txt_};
				iup.hbox{update_,add_,del_,modify_,open_,show_};
				iup.hbox{name_mat_};
			};
		};
		alignment="aRight";
	};
};
--]]

local name_mat_fields_ = {
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
	{
		Width = 50;
		Head = "Name";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local name = type(v)=="table" and v.Name or "";
			return name;
		end
	};
	{
		Width = 150;
		Head = "Title";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local count = type(v)=="table" and require"sys.table".count(v.mgrids) or 0;
			return count;
		end
	};
};


--[[
local page_ = iup.dialog{
	title = "Submodel";
	rastersize = "460x";
	resize = "NO";
	margin = "5x5";
	expand="Yes";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_,name_txt_};
				iup.hbox{gid_lab_,gid_txt_};
				iup.hbox{iup.fill{},update_,add_,del_,modify_,open_};
				iup.hbox{name_mat_};
			};
		};
		alignment="aRight";
	};
};
--]]

local function init_name_mat()
	local smds = require"sys.mgr".get_class_all(require"sys.Group".Class);
	require'sys.api.iup.matrix'.init_head{mat=name_mat_,fields=name_mat_fields_};
	require'sys.api.iup.matrix'.init_list{mat=name_mat_,fields=name_mat_fields_,dat=smds,minlin=50,sortf=function(k) return smds[k].Name or "" end};
end

--[[
local function init_name_mat()
	local i = 0;
	name_mat_.numlin = i;
	name_mat_:setcell(i,gid_col_,"ID");
	name_mat_:setcell(i,name_col_,"Name");
	name_mat_:setcell(i,count_col_,"Count");
	local smds = require"sys.mgr".get_class_all(require"sys.Group".Class);
	for k,v in pairs(smds) do
		i = i+1;
		local smd = require"sys.mgr".get_table(k,v);
		local name = type(smd)=="table" and smd.Name or "";
		local gid = type(smd)=="table" and smd.mgrid or "";
		local count = type(smd)=="table" and require"sys.table".count(smd.mgrids) or 0;
		name_mat_.numlin = i;
		name_mat_:setcell(i,0,i);
		name_mat_:setcell(i,gid_col_,gid);
		name_mat_:setcell(i,name_col_,name);
		name_mat_:setcell(i,count_col_,count);
	end
	name_mat_.numlin=math.max(i,30);
	name_mat_.redraw = "ALL";
end

local function on_name_mat(i)
	name_mat_["BGCOLOR" .. color_overall .. ":" .. "*"] = "255 255 255"; 
	local cell = name_mat_.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = name_mat_:getcell(lin,gid_col_);
	local name = name_mat_:getcell(lin,name_col_);
	name_mat_["BGCOLOR" .. lin .. ":" .. "*"] = "158 158 158";
	color_overall = lin;
	name_mat_.redraw = "ALL";
	name_txt_.value = name;
	gid_txt_.value = gid;
end
--]]

local function on_update(t)
	pop();
end

local function on_all(t)
	for i,v in ipairs(require"sys.mgr".find_scene{name="Model"}) do require"sys.mgr".close_scene(v) end
	local sc = require"sys.mgr".new_scene{name="Model"};
	require"sys.mgr".draw_all(sc);
	require"sys.mgr".update(sc);
end

local function on_add(t)
	if name_txt_.value=="" then return end
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	-- local vw = require"sys.mgr".get_view(sc)
	-- local smd = require"sys.Group".Class:new(vw);
	local smd = require"sys.Group".Class:new();
	smd:set_name(name_txt_.value);
	smd:set_scene(sc);
	smd:add_scene_all();
	require"sys.mgr".add(smd);
	require"sys.statusbar".show_model_count();
	init_name_mat();
end

local function on_del(t)
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,gid_col_);
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
	local id = name_mat_:getcell(lin,gid_col_);
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
	local id = name_mat_:getcell(lin,gid_col_);
	local sdm = require"sys.mgr".get_table(id);
	if type(sdm)~="table" then return end
	sdm:open{name=sdm.Name};
end

local function on_show(t)
	local cell = name_mat_.focus_cell;
	local lin = string.match(cell,"%d+");
	local id = name_mat_:getcell(lin,gid_col_);
	local sdm = require"sys.mgr".get_table(id);
	if type(sdm)~="table" then return end
	sdm:show{name=sdm.Name};
end

local function init()
	init_name_mat();
end

function update_:action()on_update(t)end
function all_:action()on_all(t)end
function add_:action()on_add(t)end
function del_:action()on_del(t)end
function modify_:action()on_modify(t)end
function open_:action()on_open(t)end
function show_:action()on_show(t)end
function name_mat_:click_cb()--[[on_name_mat()--]]require'sys.api.iup.matrix'.select_lin{mat=name_mat_} end

function pop()
	init();
	page_:show();
	-- on_name_mat(1)
end

function get()
	init();
	return page_;
end