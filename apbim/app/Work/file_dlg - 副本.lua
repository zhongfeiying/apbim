_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local dlg_ = iup.dialog{
	title = "File";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "600x480";
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
		Width = 300;
		Head = "Value";
		Text = function(k,v,s)
			return tostring(v);
		end
	};
};


function pop(file)
	if string.upper(string.sub(file,-4,-1))~='.LUA' then trace_out(string.upper(string.gsub(file,-4,-1))..'\n') return end
	local str = string.sub(file,1,-5);

	_G.package.loaded[str] = nil;
	local dat = require(str);
	
	require'sys.api.iup.matrix'.init_head{mat=mat_,fields=mat_fields_};
	require'sys.api.iup.matrix'.init_list{mat=mat_,fields=mat_fields_,dat=dat,minlin=50,sortf=function(k) return tostring(k) end};
	
	dlg_:show();
end

