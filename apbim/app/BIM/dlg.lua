local ipairs = ipairs
local pairs = pairs
local reload = reload
local require = require
local string = string
local table = table
local type = type

_ENV = module(...)

require'luacom'

local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local Key = require'sys.api.iup.key'
local Mat = require'sys.api.iup.matrix'
local Iup = require'sys.iup'
local Dir = require'sys.dir'
local Tab = require'sys.table'

local Path = 'cfg/BIM/Project'
local Exname = 'lua'
local DotExname = '.'..Exname


local mat_ = iup.matrix{READONLY="YES",rastersize="350X480"};
local start_ = iup.button{title="Start",rastersize="60X"};

local Dlg = iup.dialog{
	title = "BIM";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "480X620";
	iup.vbox{
		iup.frame{
			title = 'Template';
			iup.vbox{
				iup.hbox{mat_};
				iup.hbox{iup.fill{},start_};
			};
		};
	};
}

local fields_ = {
	{
		Width = 100;
		Head = "Name";
		Text = function(k,v,s)
			return string.sub(k,1,-2-string.len(v));
		end
	};
	{
		Width = 150;
		Head = "Remark";
		Text = function(k,v,s)
			local name = string.sub(k,1,-2-string.len(v));
			return reload(Path..'/'..name).readme();
		end
	};
};

function pop(arg)

	local function init_mat()
		local all = Dir.get_name_list(Path);
		if type(all)~='table' then return end
		dat = Tab.filter(all,function(k,v,t) if v==Exname then return true end end)
		Mat.init{mat=mat_,fields=fields_,dat=dat,minlin=20,sortv=function(k) return tostring(k) end};
		Dlg:show();
	end

	local function init()
		init_mat();
		Dlg:show();
	end
	local function on_start()
		local name = Mat.get_selection_lin_text{mat=mat_,col=1};
		reload(Path..'/'..name).start();
		Dlg:hide();
	end

	local function on_select_lin(i)
		Mat.select_lin{mat=mat_,lin=i}
	end

	function start_:action()on_start()end
	function mat_:click_cb(lin,col,str)on_select_lin()end
	
	init();
	on_select_lin(1);
	Key.register_k_any{dlg=Dlg,[iup.K_CR]=on_start};
end



