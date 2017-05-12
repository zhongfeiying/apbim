_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local list_ = iup.list{expand="Yes",READONLY="YES",resizematrix="YES"};
local add_ = iup.button{title="Add",rastersize="60x"};
local del_ = iup.button{title="Delete",rastersize="60X"};
local apply_ = iup.button{title="Apply",rastersize="60X"};
local analysis_ = iup.button{title="Analysis",rastersize="60X"};

local dlg = iup.dialog{
	title = "Link";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "480X600";
	iup.vbox{
		iup.frame{
			title = 'Files';
			iup.vbox{
				iup.hbox{list_};
				iup.hbox{iup.fill{},add_,del_,analysis_};
			};
		};
	};
}

local list_ids_ = nil;	
local function init_list()
	local cur = require'sys.mgr'.cur();
	if type(cur)~='table' then return end
	local s = require"sys.mgr".get_class_all(require"app.Work.Link".Class);
	s = require'sys.table'.filter(s,function(k,v) if v.dstid == cur.mgrid then return true else return false end end)
	list_ids_ = require'sys.api.iup.list'.init{list=list_,dat=s,textf=function(k,v,s) return v.src end,sortf=function(k) return s[k].Time end,linkf=function(k,v,s) return v.mgrid end};
end

local function init()
	init_list();
	dlg:show();
end

local function on_add()
	local str = require'sys.iup'.open_file_dlg{extension='*';directory='C:\\';}
	if not str or str=='' then return end
	local curs = require'sys.mgr'.curs();
	if type(curs)~='table' then return end
	for k,v in pairs(curs) do
		local it = require'app.Work.Link'.Class:new();
			if type(v)=='table' then
			it.dstid=v.mgrid;
			it.src = str;
			require'sys.mgr'.add(it);
		end
	end
	init_list();
end

local function on_del()
	local id = list_ids_[tonumber(list_.value)];
	local it = require'sys.mgr'.get_table(id);
	require'sys.mgr'.del(it);
	init_list();
end

local function on_analysis()
	local id = list_ids_[tonumber(list_.value)];
	local it = require'sys.mgr'.get_table(id);
	require'app.Work.file_dlg'.pop(it.src);
end

function add_:action()on_add()end
function del_:action()on_del()end
function analysis_:action()on_analysis()end
	
function pop(t)
	init();
	return dlg;
end

