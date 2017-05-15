_ENV = module(...,ap.adv)

require'luacom'

local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local Key = require'sys.api.iup.key'
local Mat = require'sys.api.iup.matrix'
local Iup = require'sys.iup'
local Dir = require'sys.dir'
local Tab = require'sys.table'

local Pos = 'D:\\demo\\apbim\\'
local Path = 'cfg/report/'
local Exname = 'xls'
local DotExname = '.'..Exname


local mat_ = iup.matrix{READONLY="YES",rastersize="350X480"};
local export_ = iup.button{title="Export",rastersize="60X"};

local Dlg = iup.dialog{
	title = "Report";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "480X620";
	iup.vbox{
		iup.frame{
			title = 'Template';
			iup.vbox{
				iup.hbox{mat_};
				iup.hbox{iup.fill{},export_};
			};
		};
	};
}

local fields_ = {
	{
		Width = 100;
		Head = "Excel";
		Text = function(k,v,s)
			return string.sub(k,1,-2-string.len(v));
		end
	};
	{
		Width = 150;
		Head = "Remark";
		Text = function(k,v,s)
			local name = string.sub(k,1,-2-string.len(v));
			-- return require(Path..name).Remark
			return ""
		end
	};
};

function pop(arg)

	local function init_list()
		local all = Dir.get_name_list(Path);
		if type(all)~='table' then return end
		dat = Tab.filter(all,function(k,v,t) if v==Exname then return true end end)
		Mat.init{mat=mat_,fields=fields_,dat=dat,minlin=20,sortv=function(k) return tostring(k) end};
		Dlg:show();
	end

	local function init()
		init_list();
		Dlg:show();
	end
--[[
	local function on_export()
		local dstfile = Iup.save_file_dlg{extension=Exname;directory='D:/';}
		if not dstfile or dstfile=='' then return end
		
	
		local name = Mat.get_selection_lin_text{mat=mat_,col=1};
		local xls = luacom.CreateObject("Excel.Application")
		xls.Visble = true;
		local book = xls.Workbooks:Open(Pos..Path..name..DotExname);
		local sheet = book.Sheets(1)
		
		local rule = reload(Path..name);
		local dat = arg.src;
		dat = Tab.filter(dat,function(k,v,t)return rule[1].Filter{k=k,v=v,t=dat} end);
		idat = Tab.sortk(dat,function(k1,k2)return rule[1].Sort{k1=k1,k2=k2,v1=dat[k1],v2=dat[k2],t=dat} end);
		local index = 1;
		for i,k in ipairs(idat) do
			local v = dat[k];
			for col,f in pairs(rule[1].Columns) do
				local row = rule[1].Row+index-1;
				local val = f{k=k,v=v,t=dat,i=row};
				-- trace_out('('..row..','..col..') = '..tostring(val)..'\n');
				sheet.Cells(row,col).Value2 = val;
			end
			index = index + 1;
		end
		-- sheet.Cells(3,3).Value2 = "abc"
		
		book:SaveAs(dstfile);
		book:Close(0)
		xls:Quit(0)
		os.execute('start " " '..dstfile..'\n');
	end
--]]
	local function on_export()
		local dstfile = Iup.save_file_dlg{extension=Exname;directory='D:/';}
		if not dstfile or dstfile=='' then return end
		
	
		local name = Mat.get_selection_lin_text{mat=mat_,col=1};
		local xls = luacom.CreateObject("Excel.Application")
		xls.Visble = true;
		local book = xls.Workbooks:Open(Pos..Path..name..DotExname);
		local sheet = book.Sheets(1)
		
		local tempf = reload(Path..name);
		local tbook = tempf(arg.src);
		
		for isheet,vsheet in ipairs(tbook) do
			for krow,vrow in pairs(vsheet) do
				if type(vrow)=='table' then
					for kcol,vcol in pairs(vrow) do
						trace_out(vcol..',');
						sheet.Cells(krow,kcol).Value2 = vcol;
					end
					trace_out('\n');
				else
					trace_out('copy from; '..vrow..'\n');
				end
			end
		end
		
		
		-- sheet.Cells(3,3).Value2 = "abc"
		
		book:SaveAs(dstfile);
		book:Close(0)
		xls:Quit(0)
		os.execute('start " " '..dstfile..'\n');
	end

	local function on_select_lin(i)
		Mat.select_lin{mat=mat_,lin=i}
	end

	function export_:action()on_export()end
	function mat_:click_cb(lin,col,str)on_select_lin()end
	
	init();
	on_select_lin(1);
	Key.register_k_any{dlg=Dlg,[iup.K_CR]=on_export};
end



