_ENV = module(...,ap.adv)

local iup = require"iup";

local pt1 = iup.label{title="Point1:"};
local pt1x = iup.toggle{title="X="};
local pt1y = iup.toggle{title="Y="};
local pt1z = iup.toggle{title="Z="};
local pt1x_ = iup.text{expand="horizontal"};
local pt1y_ = iup.text{expand="horizontal"};
local pt1z_ = iup.text{expand="horizontal"};
local pt2 = iup.label{title="Point2:"};
local pt2x = iup.toggle{title="X="};
local pt2y = iup.toggle{title="Y="};
local pt2z = iup.toggle{title="Z="};
local pt2x_ = iup.text{expand="horizontal"};
local pt2y_ = iup.text{expand="horizontal"};
local pt2z_ = iup.text{expand="horizontal"};
local ok = iup.button{title="OK",size="50x15"};
local cancel = iup.button{title="Cancel",size="50x15"};

local 

local dlg = iup.dialog{
	iup.vbox{
		iup.hbox{pt1,pt1x,pt1x_,pt1y,pt1y_,pt1z,pt1z_};
		iup.hbox{pt2,pt2x,pt2x_,pt2y,pt2y_,pt2z,pt2z_};
		iup.hbox{ok,cancel};
		alignment = "aRight";
	};
	title = "Line";
	margin = "5x5";
	size = "320x";
};

local function init_dlg()
	local cur = require"sys.mgr".cur();
	if type(cur)~="table" then return end
	pt1x_.value = cur.Points[1].x or cur.Points[1][1];
	pt1y_.value = cur.Points[1].y or cur.Points[1][2];
	pt1z_.value = cur.Points[1].z or cur.Points[1][3];
	pt2x_.value = cur.Points[2].x or cur.Points[2][1];
	pt2y_.value = cur.Points[2].y or cur.Points[2][2];
	pt2z_.value = cur.Points[2].z or cur.Points[2][3];
end

function ok:action()
	local curs = require"sys.mgr".curs();
	if type(curs)~="table" then return end
	for k,v in pairs(curs) do
		if type(v)=="table" then 
			-- if pt1x.value=="ON" then v.Points[1].x = pt1x_.value end
		end
	end
end

function pop()
	init_dlg();
	dlg:show();
end
