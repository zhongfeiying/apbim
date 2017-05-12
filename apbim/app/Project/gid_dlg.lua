_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"


local name_lab_ = iup.label{title="ID:",rastersize="50X"};
local name_txt_ = iup.text{rastersize="350X",CANFOCUS="NO",value=""};
local ok_ 		= iup.button{title="OK"		,rastersize="100X30"};
local cancel_ 	= iup.button{title="Cancel"	,rastersize="100X30"};

local color_overall = 0;

local dlg_ = iup.dialog{
	title = "ID";
	resize = "NO";
	rastersize = "455x";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_,name_txt_};
			};
		};
		iup.hbox{ok_,cancel_};
		alignment="aRight";
	};
};

local function init(t)
	if type(t)~="table" or type(t.gid)~="string" then name_txt_.value = "" return end
	name_txt_.value = t.gid;
end

local function on_ok(t)
	if type(name_txt_.value)~="string" or name_txt_.value=="" then return end
	dlg_:hide();
	if type(t.on_ok)=="function" then t.on_ok{gid=name_txt_.value;} end
end

local function on_cancel()
	dlg_:hide();
end


-- t={on_ok=function,name=""}
function pop(t)

	function ok_:action()
		on_ok(t);
	end
	function cancel_:action()
		on_cancel();
	end

	init(t);
	dlg_:popup();
end
