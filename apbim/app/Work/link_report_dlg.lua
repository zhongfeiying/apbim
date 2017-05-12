_ENV = module(...,ap.adv)

require'luacom'

local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local Mat = require'sys.api.iup.matrix'
local Dir = require'sys.dir'
local Tab = require'sys.table'

local mat_ = iup.matrix{READONLY="YES"};
local name_lab_ = iup.label{title="Table",rastersize="60x"};
local name_txt_ = iup.text{expand="Horizontal"};
local id_lab_ = iup.label{title="Index",rastersize="60x"};
local id_txt_ = iup.text{expand="Horizontal"};
local export_ = iup.button{title="Export",rastersize="60X"};

local dlg = iup.dialog{
	title = "Report";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "320X600";
	iup.vbox{
		iup.frame{
			title = 'Template';
			iup.vbox{
				iup.hbox{mat_};
				iup.hbox{export_};
			};
		};
	};
}

local fields_ = {
	{
		Width = 150;
		Head = "Excel";
		Text = function(k,v,s)
			return k
		end
	};
	-- {
		-- Width = 100;
		-- Head = "Length";
		-- Text = function(k,v,s)
			-- local t = require'app.Work.SQLServer_dlg'.get_sql_row(v.src.Table,v.src.id)
			-- if type(t)=='table' then
				-- return t.Length;
			-- end
			-- return "";
		-- end
	-- };
};

local Excel_Pos = 'cfg/report/'

function pop(t)

	-- local function init_list()
		-- local all = t.src;
		-- if type(all)~='table' then return end
		-- local s = require"sys.mgr".get_class_all(require"app.Work.Link_SQLServer".Class);
		-- s = require'sys.table'.filter(s,function(k,v) if type(all[v.dstid])=='table' then return true else return false end end)
		-- Mat.init_head{mat=mat_,fields=fields_};
		-- Mat.init_list{mat=mat_,fields=fields_,dat=s,minlin=20,sortv=function(k) return tonumber(s[k].src.id) end};
		-- dlg:show();
		
	-- end
	local function init_list()
		local all = Dir.get_name_list(Excel_Pos);
		if type(all)~='table' then return end
		dat = Tab.filter(all,function(k,v,t) if v=='.xls' then return true end end)
		Mat.init_head{mat=mat_,fields=fields_};
		Mat.init_list{mat=mat_,fields=fields_,dat=dat,minlin=20,sortv=function(k) return tostring(k) end};
		dlg:show();
	end

	local function init()
		init_list();
		dlg:show();
	end

	-- local function on_add()
		-- local curs = require'sys.mgr'.curs();
		-- if type(curs)~='table' then return end
		-- for k,v in pairs(curs) do
			-- if type(v)=='table' then
				-- local it = require'app.Work.Link_SQLServer'.Class:new();
				-- it.dstid=v.mgrid;
				-- it.src = {Server='BETTER-PC',Database='master',Table=name_txt_.value,id=tonumber(id_txt_.value)};
				-- require'sys.mgr'.add(it);
			-- end
		-- end
		-- init_list();
	-- end

	-- local function on_del()
		-- local it = require'sys.mgr'.get_table(id);
		-- require'sys.mgr'.del(it);
		-- init_list();
	-- end

	-- local function on_analysis()
		-- local name = Mat.get_selection_lin_text{mat=mat_,col=1};
		-- local id = Mat.get_selection_lin_text{mat=mat_,col=2};
		-- require'app.Work.SQLServer_dlg'.pop(name,id);
	-- end
	
	local function on_export()
		local name = Mat.get_selection_lin_text{mat=mat_,col=1};
		local xls = luacom.CreateObject("Excel.Application")
		xls.Visble = true;
		local book = xls.Workbooks:Open("D:\\code\\3d\\apbim\\cfg\\report\\part_list.xls");
		local sheet = book.Sheets(1)
		sheet.Cells(3,3).Value2 = "abc"
		book:SaveAs("D:\\d1.xls");
		book:Close(0)
		xls:Quit(0)
	end

	local function on_select_lin()
		Mat.select_lin{mat=mat_}
	end

	function export_:action()on_export()end
	function mat_:click_cb(lin,col,str)on_select_lin()end
	
	init();
end

