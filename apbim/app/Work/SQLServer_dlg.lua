_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local dlg_ = iup.dialog{
	title = "Record";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "580x480";
	iup.vbox{
		iup.hbox{mat_};
	};
}

local mat_fields_ = {
	{
		Width = 100;
		Head = "Key";
		Text = function(k,v,s)
			return tostring(k);
		end
	};
	{
		Width = 200;
		Head = "Value";
		Text = function(k,v,s)
			return tostring(v);
		end
	};
};

function get_sql_row(name,id)
	local s = {};
	require'app.Work.sql';
	local db = open_sqlserver('BETTER-PC','master','sa','hello')
	db:exec("select * from "..name.." where id = "..id)
	t = db:row()
	while t ~= nil do
		-- trace_out(tostring(t.name).."\t"..tostring(t.phone)..'\n')
		s.Name = tostring(t.Name);
		s.No = t.No;
		s.Mat = t.Mat;
		s.Section = t.Section;
		s.Length = t.Length;
		t = db:row()
	end
	db:close()
	return s;
end


function pop(name,id)
	local s = get_sql_row(name,id);
	require'sys.api.iup.matrix'.init_head{mat=mat_,fields=mat_fields_};
	require'sys.api.iup.matrix'.init_list{mat=mat_,fields=mat_fields_,dat=s,minlin=50,sortf=function(k) return tostring(k) end};
	dlg_:show();
end

