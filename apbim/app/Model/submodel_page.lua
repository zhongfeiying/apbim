_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local gid_lab_ = iup.label{title="ID:",rastersize="50X"};
local gid_txt_ = iup.text{expand="Horizontal",CANFOCUS="NO",READONLY="Yes"};
local name_lab_ = iup.label{title="Name:",rastersize="50X"};
local name_txt_ = iup.text{expand="Horizontal",CANFOCUS="NO",value="New"};
local name_mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local update_ = iup.button{title="Update",expand="Horizontal"};
local add_ = iup.button{title="Add"	,rastersize="60x"};
local del_ = iup.button{title="Delete"	,rastersize="60X"};
local modify_ = iup.button{title="Modify"	,rastersize="60X"};
local open_ = iup.button{title="Open"	,rastersize="60X"};
local show_ = iup.button{title="Show"	,rastersize="60X"};

local dlg = iup.vbox{
	title = "Submodel";
	tabtitle = "Submodel";
	margin = "5x5";
	alignment = "aRight";
	-- size = "800x800";
	iup.vbox{
		iup.hbox{name_lab_,name_txt_};
		iup.hbox{gid_lab_,gid_txt_};
		iup.hbox{update_,add_,del_,open_};
		iup.hbox{name_mat_};
	};
}

local name_mat_fields_ = {
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
	{
		Width = 180;
		Head = "Name";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and v.Name or "";
			return str;
		end
	};
	{
		Width = 50;
		Head = "Count";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and require"sys.table".count(v.mgrids) or 0;
			return str;
		end
	};
	{
		Width = 0;
		Head = "Remark";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and v.Remark or "";
			return str;
		end
	};
	{
		Width = 100;
		Head = "Time";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and require'sys.dt'.time_text(v.Time) or 0;
			return str;
		end
	};
};


-- t={filter=}
function pop(t)
	t = t or {};
	require"sys.statusbar".show_user(require"sys.mgr".get_user());
	-- dlg.title =  require"sys.mgr".get_user()..' - '..require'app.Msg.linkman'.get_selection_user().name;
	

	
	function init_name_mat()
		-- local smds = require"sys.mgr".get_class_all(require"sys.Group".Class);
		local smds = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
		require'sys.api.iup.matrix'.init_head{mat=name_mat_,fields=name_mat_fields_};
		require'sys.api.iup.matrix'.init_list{mat=name_mat_,fields=name_mat_fields_,dat=smds,minlin=50,sortf=function(k) return smds[k].Send_Time end};
	end

	local function init()
		init_name_mat();
		dlg:show();
	end

	local function on_add()
		if name_txt_.value=="" then return end
		local sc = require"sys.mgr".get_cur_scene();
		if not sc then return end
		-- local smd = require"sys.Group".get_view{Name=name_txt_.value};
		local smd = require"app.Model.Submodel".Class:new{Name=name_txt_.value}:set_view();
		require"sys.mgr".add(smd);
		require"sys.statusbar".show_model_count();
		init_name_mat();
	end

	local function on_del()
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=name_mat_,col=1};
		local smds = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
		if not smds[id] then return end
		local sdm = require"sys.mgr".get_table(id);
		if type(sdm)~="table" then return end
		require"sys.mgr".del(sdm);
		require"sys.statusbar".show_model_count();
		init_name_mat();
	end

	-- local function on_modify()
		-- if name_txt_.value=="" then return end
		-- local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=name_mat_,col=1};
		-- if not id then on_add() end
		-- if not smds[id] then return end
		-- local sdm = require"sys.mgr".get_table(id);
		-- local sc = require"sys.mgr".get_cur_scene();
		-- if not sc then return end
		-- sdm.Name = name_txt_.value;
		-- sdm:set_scene(sc);
		-- sdm:clear_items();
		-- sdm:add_scene_all();
		-- require"sys.statusbar".show_model_count();
		-- init_name_mat();
	-- end

	local function on_open()
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=name_mat_,col=1};
		local smds = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
		if not smds[id] then return end
		local sdm = require"sys.mgr".get_table(id);
		if type(sdm)~="table" then return end
		sdm:open{name=sdm.Name};
	end

	local function on_show()
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=name_mat_,col=1};
		local smds = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
		if not smds[id] then return end
		local sdm = require"sys.mgr".get_table(id);
		if type(sdm)~="table" then return end
		sdm:show{name=sdm.Name};
	end

	local function on_select_lin()
		require'sys.api.iup.matrix'.select_lin{mat=name_mat_}
	end
	
	local function on_name_mat()
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=name_mat_,col=1};
		local smds = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
		if not smds[id] then return end
		local smd = require'sys.mgr'.get_table(id,smd);
		gid_txt_.value = id;
		name_txt_.value = smd.Name or "";
	end

	
	function name_mat_:click_cb(lin,col,str)
		-- if string.find(str,"1") and string.find(str,"D") then on_look() end
		on_select_lin();
		on_name_mat();
	end
	
	function update_:action()init()end
	function add_:action()on_add()end
	function del_:action()on_del()end
	function modify_:action()on_modify()end
	function open_:action()on_open()end
	function show_:action()on_show()end

	init();
	-- require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_look};
	-- require'sys.net.msg'.resgister_rcvf(init);
	return dlg;
end

