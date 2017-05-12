_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local Mat = require'sys.api.iup.matrix'

local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol_visible=2};
-- local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local name_lab_ = iup.label{title="Table",rastersize="60x"};
local name_txt_ = iup.text{expand="Horizontal"};
local id_lab_ = iup.label{title="Index",rastersize="60x"};
local id_txt_ = iup.text{expand="Horizontal"};
local add_ = iup.button{title="Add",rastersize="60x"};
local del_ = iup.button{title="Delete",rastersize="60X"};
local apply_ = iup.button{title="Apply",rastersize="60X"};
local analysis_ = iup.button{title="Analysis",rastersize="60X"};

local dlg = iup.dialog{
	title = "Database";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "480X600";
	iup.vbox{
		iup.frame{
			title = 'Records';
			iup.vbox{
				iup.hbox{mat_};
				iup.hbox{name_lab_,name_txt_,id_lab_,id_txt_,iup.fill{},add_,analysis_};
			};
		};
	};
}

local fields_ = {
	{
		Width = 150;
		Head = "Table";
		Text = function(k,v,s)
			return v.src.Table;
		end
	};
	{
		Width = 100;
		Head = "Index";
		Text = function(k,v,s)
			return v.src.id;
		end
	};
};

local function init_list()
	local cur = require'sys.mgr'.cur();
	if type(cur)~='table' then return end
	local s = require"sys.mgr".get_class_all(require"app.Work.Link_SQLServer".Class);
	s = require'sys.table'.filter(s,function(k,v) if v.dstid == cur.mgrid then return true else return false end end)
	Mat.init_head{mat=mat_,fields=fields_};
	Mat.init_list{mat=mat_,fields=fields_,dat=s,minlin=20,sortv=function(k) return tonumber(s[k].src.id) end};
	dlg:show();
	
end

local function init()
	init_list();
	dlg:show();
end

local function on_add()
	local curs = require'sys.mgr'.curs();
	if type(curs)~='table' then return end
	for k,v in pairs(curs) do
		if type(v)=='table' then
			local it = require'app.Work.Link_SQLServer'.Class:new();
			it.dstid=v.mgrid;
			it.src = {Server='BETTER-PC',Database='master',Table=name_txt_.value,id=tonumber(id_txt_.value)};
			require'sys.mgr'.add(it);
		end
	end
	init_list();
end

local function on_del()
	-- local id = list_ids_[tonumber(list_.value)];
	local it = require'sys.mgr'.get_table(id);
	require'sys.mgr'.del(it);
	init_list();
end

local function on_analysis()
	local name = Mat.get_selection_lin_text{mat=mat_,col=1};
	local id = Mat.get_selection_lin_text{mat=mat_,col=2};
	require'app.Work.SQLServer_dlg'.pop(name,id);
end

local function on_select_lin()
	require'sys.api.iup.matrix'.select_lin{mat=mat_}
end

function add_:action()on_add()end
function del_:action()on_del()end
function analysis_:action()on_analysis()end
function mat_:click_cb(lin,col,str)on_select_lin()end
	
	
function pop(t)
	init();
	return dlg;
end

