_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"


local gid_lab_ = iup.label{title="ID:",rastersize="50X"};
local gid_txt_ = iup.text{rastersize="300X",READONLY="YES",CANFOCUS="NO",value=""};
local name_lab_ = iup.label{title="Name:",rastersize="50X"};
local name_txt_ = iup.text{rastersize="300X",CANFOCUS="NO",value="NewProject"};
local name_mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol=2,numcol_visible=2,numlin_visible=16,widthdef=120};
local create_btn_ = iup.button{title="Create",rastersize="50X",CANFOCUS="NO"}
local clear_btn_ = iup.button{title="Clear",rastersize="50X",CANFOCUS="NO"}
local ok_ 		= iup.button{title="OK"		,rastersize="100X30"};
local cancel_ 	= iup.button{title="Cancel"	,rastersize="100X30"};

local color_overall = 0;
local cfg_file_ = "cfg\\Project_List.lua";
local cfg_list_ = {};

local dlg_ = iup.dialog{
	title = "Project";
	resize = "NO";
	rastersize = "455x";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_,name_txt_,create_btn_};
				iup.hbox{gid_lab_,gid_txt_,clear_btn_};
				iup.hbox{name_mat_};
			};
		};
		iup.hbox{ok_,cancel_};
		alignment="aRight";
	};
};

local function init_cfg_list()
	cfg_list_ = require"sys.io".read_file{file=cfg_file_} or {};
end

local function init_name_mat()
	local i = 0;
	name_mat_.numlin = i;
	name_mat_:setcell(i,1,"Name");
	-- local s = require"sys.table".sortk(require"sys.api.dir".get_subfolder_list(path_txt_.value));
	local s = cfg_list_;
	if type(s)~="table" then return end
	for k,v in pairs(s) do
		i = i+1;
		name_mat_.numlin = i;
		name_mat_:setcell(i,0,i);
		name_mat_:setcell(i,1,tostring(v));
		name_mat_:setcell(i,2,tostring(k));
	end
	name_mat_.numlin=math.max(i,20);
	name_mat_.redraw = "ALL";
end

local function init()
	gid_txt_.value = "";
	init_cfg_list();
	init_name_mat();
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

local function on_ok(t)
	if name_txt_.value=="" or gid_txt_.value=="" then return end
	local name,gid = name_txt_.value,gid_txt_.value;
	cfg_list_[gid] = name;
	require"sys.table".tofile{file=cfg_file_,src=cfg_list_};
	dlg_:hide();
	if type(t.on_ok)=="function" then t.on_ok{name=name;gid=gid} end
end

local function on_cancel()
	dlg_:hide();
end

local function on_create_gid()
	if name_txt_.value=="" then return end
	if gid_txt_.value~="" then return end
	local gid = string.upper(require"luaext".guid()); 
	gid_txt_.value = gid;
end

local function on_clear_gid()
	gid_txt_.value = "";
end

local k_any_={};
k_any_[iup.K_CR] = on_ok;
k_any_[iup.K_ESC] = on_cancel;

-- t={on_ok=function}
function pop(t)
	if type(t)~="table" then trace_out("app.Project.dlg.pop(t), t isn't a table") return end
	-- if type(t.on_ok)~="function" then trace_out("app.Project.dlg.pop(t), t.on_ok isn't a function") return end

	function ok_:action()
		on_ok(t);
	end
	function cancel_:action()
		on_cancel();
	end
	function create_btn_:action()
		on_create_gid();
	end
	function clear_btn_:action()
		on_clear_gid();
	end
	function name_mat_:click_cb()
		on_name_mat();
	end
	function dlg_:k_any(n)
		if k_any_[n] then k_any_[n](t) end
	end

	init();
	dlg_:show();
	on_name_mat(1);
end
