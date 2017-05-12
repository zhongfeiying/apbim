_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"
local cfg_file_ = "cfg/color_index.lua";

local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol=2,numcol_visible=2,numlin_visible=16,widthdef=125};
local color_lab_ = iup.label{title="Color:",rastersize="50X"};
local color_lst_ = iup.list{expand="Horizontal",rastersize="100X",DROPDOWN="Yes",VISIBLE_ITEMS=10};
local color_r_lab_ = iup.label{title="R="};
local color_r_txt_ = iup.text{rastersize="50X"};
local color_g_lab_ = iup.label{title="G="};
local color_g_txt_ = iup.text{rastersize="50X"};
local color_b_lab_ = iup.label{title="B="};
local color_b_txt_ = iup.text{rastersize="50X"};

local modify_ = iup.button{title="Modify",rastersize="100X30"};
local ok_ = iup.button{title="OK",rastersize="100X30"};
local cancel_ = iup.button{title="Cancel",rastersize="100X30"};

local dlg_ = iup.dialog{
	title = "Property";
	resize = "NO";
	rastersize = "465x";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{mat_};
				iup.hbox{color_lab_,color_lst_,color_r_lab_,color_r_txt_,color_g_lab_,color_g_txt_,color_b_lab_,color_b_txt_};
			};
		};
		iup.hbox{modify_,ok_,cancel_};
		alignment="aRight";
	};
};

--[[
local function init_mat(arg)
	local i = 0;
	mat_.numlin = i;
	mat_:setcell(i,1,"Key");
	mat_:setcell(i,2,"Value");
	local s = require"sys.Entity".Class.get_info_text(arg.src);
	if type(s)~="table" then s={} end
	for k,v in ipairs(s) do
		if type(v)~="table" then v={} end
		for m,n in pairs(v) do
			if type(m)~="number" and type(m)~="string" then m="" end
			if type(n)~="number" and type(n)~="string" then n="" end
			i = i+1;
			mat_.numlin = i;
			mat_:setcell(i,0,tostring(i));
			mat_:setcell(i,1,tostring(m));
			mat_:setcell(i,2,tostring(n));
		end
	end
	mat_.numlin=math.max(i,20);
	mat_.redraw = "ALL";
end
--]]

--[[
local function init_mat(arg)
	mat_.numlin = 0;
	mat_:setcell(0,1,"Key");
	mat_:setcell(0,2,"Value");
	local text = require"sys.Entity".Class.get_info_text(arg.src);
	local s = require"sys.Entity".Class.get_info_order(arg.src);
	if type(s)~="table" then s={} end
	for i,v in ipairs(s) do
		local m = v;
		local n = text[v];
		if type(m)~="number" and type(m)~="string" then m="" end
		if type(n)~="number" and type(n)~="string" then n="" end
		mat_.numlin = i;
		mat_:setcell(i,0,tostring(i));
		mat_:setcell(i,1,tostring(m));
		mat_:setcell(i,2,tostring(n));
	end
	mat_.numlin=math.max(#s,20);
	mat_.redraw = "ALL";
end
--]]

---[[
local function init_mat(arg)
	local i = 0;
	mat_.numlin = i;
	mat_:setcell(i,1,"Key");
	mat_:setcell(i,2,"Value");
	i = i+1;
	mat_.numlin = i;
	mat_:setcell(i,0,i);
	mat_:setcell(i,1,"Classname");
	mat_:setcell(i,2,arg.src.Classname);
	local text = require"sys.Entity".Class.get_info_text(arg.src);
	local s = require"sys.Entity".Class.get_info_order(arg.src);
	if type(s)~="table" then s={} end
	for k,v in ipairs(s) do
		local m = v;
		local n = text[v];
		if type(m)~="number" and type(m)~="string" then m="" end
		if type(n)~="number" and type(n)~="string" then n="" end
		i = i+1;
		mat_.numlin = i;
		mat_:setcell(i,0,tostring(i));
		mat_:setcell(i,1,tostring(m));
		mat_:setcell(i,2,tostring(n));
	end
	for k,v in ipairs(require"sys.Entity".Class.get_pts(arg.src)) do
		i = i+1;
		mat_.numlin = i;
		mat_:setcell(i,0,i);
		mat_:setcell(i,1,"Point"..k);
		mat_:setcell(i,2,require"sys.text".array(v));
	end
	i = i+1;
	mat_.numlin = i;
	mat_:setcell(i,0,i);
	mat_:setcell(i,1,"Date");
	mat_:setcell(i,2,require"sys.Item".Class.get_date_text(arg.src));
	mat_.numlin=math.max(#s,20);
	mat_.redraw = "ALL";
end
--]]

local function init_color_list(arg)
	local s = require"sys.io".readfile{file=cfg_file_};
	for i,v in ipairs(s) do
		color_lst_[i] = i.." : "..(v.name or "").."("..v[1]..", "..v[2]..", "..v[3]..")";
	end
end

local function init_color_text(r,g,b)
	color_lst_.value = nil;
	color_r_txt_.value = r;
	color_g_txt_.value = g;
	color_b_txt_.value = b;
	local s = require"sys.io".readfile{file=cfg_file_};
	for i,v in ipairs(s) do
		if r==v[1] and g==v[2] and b==v[3] then color_lst_.value = i end
	end
end

local function init_color(arg)
	local cr = require"sys.View".get_color(require"sys.mgr".get_cur_scene(),arg.src.mgrid);
	if type(cr)~="table" then init_color_text() return end
	local r = cr.r or cr[1] or 0;
	local g = cr.g or cr[2] or 0;
	local b = cr.b or cr[3] or 0;
	init_color_text(r,g,b);
end

local function init(arg)
	-- dlg_.title = arg.src.Classname or "Property";
	init_mat(arg);
	init_color(arg);
	init_color_list(arg);
end

local on_mat_pre_lin_ = 0;
local function on_mat(i)
	mat_["BGCOLOR" .. on_mat_pre_lin_ .. ":" .. "*"] = "255 255 255"; 
	local cell = mat_.focus_cell;
	local lin = i or string.match(cell,"%d+");
	mat_["BGCOLOR" .. lin .. ":" .. "*"] = "158 158 158";
	on_mat_pre_lin_ = lin;
	mat_.redraw = "ALL";
end

local function on_color()
	local i = tonumber(color_lst_.value);
	if not i then return end
	local s = require"sys.io".readfile{file=cfg_file_};
	color_r_txt_.value = s[i] and s[i][1] or 0;
	color_g_txt_.value = s[i] and s[i][2] or 0;
	color_b_txt_.value = s[i] and s[i][3] or 0;
end

local function on_modify(arg)
	local r = tonumber(color_r_txt_.value);
	local g = tonumber(color_g_txt_.value);
	local b = tonumber(color_b_txt_.value);
	if type(arg.dst)~="table" then return end
	for k,v in pairs(arg.dst) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.View".set_color(require"sys.mgr".get_cur_scene(),k,{r,g,b});
		-- require"sys.Entity".Class.set_color(v,{r,g,b});
		require"sys.mgr".redraw(v);
	end
	require"sys.mgr".update();
end

local function on_ok(arg)
	on_modify(arg);
	dlg_:hide();
end

local function on_cancel()
	dlg_:hide();
end

local k_any_={};
k_any_[iup.K_CR] = on_ok;
k_any_[iup.K_ESC] = on_cancel;

-- arg={src=ent,dst=ents}
function popup(arg)
	if type(arg)~="table" then trace_out("sys.interface.info_dlg.popup(t), t isn't a table") return end
	if type(arg.src)~="table" then return end
	if type(arg.src.mgrid)~="string" then return end

	function modify_:action()
		on_modify(arg);
	end
	function ok_:action()
		on_ok(arg);
	end
	function cancel_:action()
		on_cancel();
	end
	function mat_:click_cb()
		on_mat();
	end
	function color_lst_:valuechanged_cb()
		on_color();
	end
	function dlg_:k_any(n)
		if k_any_[n] then k_any_[n](arg) end
	end

	init(arg);
	dlg_:show();
	on_mat(1);
end
