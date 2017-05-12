_ENV = module(...,ap.adv)

local tools_ = require"sys.api.table";
local geo_ = require"sys.geometry";

----loop----
local function loop_point_object_surface(sur, f, arg)
	if type(f)~="function" then return end
	if type(sur)~="table" then return end
	if type(sur.points)~="table" then return end
	for k,v in pairs(sur.points) do
		f(v, arg);
	end
end

local function loop_point_object(obj, f, arg)
	if type(obj)~="table" then return end
	if type(obj.surfaces)~="table" then return end
	for k,v in pairs(obj.surfaces) do
		loop_point_object_surface(v, f, arg);
	end
end

local function loop_point_object_array(objs, f, arg)
	if type(objs)~="table" then return end
	for k,v in pairs(objs) do
		loop_point_object(v, f, arg);
	end
end

local function loop_text_object_surface(sur, f, arg)
	if type(f)~="function" then return end
	if type(sur)~="table" then return end
	if type(sur.texts)~="table" then return end
	for k,v in pairs(sur.texts) do
		f(v, arg);
	end
end

local function loop_text_object(obj, f, arg)
	if type(obj)~="table" then return end
	if type(obj.surfaces)~="table" then return end
	for k,v in pairs(obj.surfaces) do
		loop_text_object_surface(v, f, arg);
	end
end

----callback----

local function rgb_scale(pt, cr)
	pt[1] = pt[1]*(cr.r or cr[1] or 1);
	pt[2] = pt[2]*(cr.g or cr[2] or 1);
	pt[3] = pt[3]*(cr.b or cr[3] or 1);
end

local function rgb_add(pt, cr)
	pt[1] = pt[1] + (cr.r or cr[1] or pt[1]);
	pt[2] = pt[2] + (cr.g or cr[2] or pt[2]);
	pt[3] = pt[3] + (cr.b or cr[3] or pt[3]);
end

local function rgb_to(pt, cr)
	pt[1] = cr.r or cr[1] or pt[1];
	pt[2] = cr.g or cr[2] or pt[2];
	pt[3] = cr.b or cr[3] or pt[3];
end

local function text_rgb_to(txt, cr)
	txt.r = cr.r or cr[1] or txt.r;
	txt.g = cr.g or cr[2] or txt.g;
	txt.b = cr.b or cr[3] or txt.b;
end

local function xyz_l2g(pt, crd)
	local p = {pt[6], pt[7], pt[8]};
	p = crd:l2g(p);
	pt[6] = p.x;
	pt[7] = p.y;
	pt[8] = p.z;
end

local function xyz_move(pt, off)
	pt[6] = pt[6]+off.x;
	pt[7] = pt[7]+off.y;
	pt[8] = pt[8]+off.z;
end

----------public--------------------------------------

function color_scale(obj, coe)
	if type(obj)~="table" then return end
	local cr = type(coe)=="table" and coe or {r=coe,g=coe,b=coe}
	loop_point_object(obj, rgb_scale, cr);
	return obj;
end

function color_add(obj, cr)
	if type(obj)~="table" then return end
	if type(cr)~="table" then return end
	loop_point_object(obj, rgb_add, cr);
	return obj;
end

function color_to(obj, cr)
	if type(obj)~="table" then return end
	if type(cr)~="table" then return end
	loop_point_object(obj, rgb_to, cr);
	return obj;
end

function text_color_to(obj, cr)
	if type(obj)~="table" then return end
	if type(cr)~="table" then return end
	loop_text_object(obj, text_rgb_to, cr);
	return obj;
end

function coord_l2g(obj, crd)
	if type(obj)~="table" then return end
	if type(crd)~="table" then return end
	geo_.Coord:new(crd);
	loop_point_object(obj, xyz_l2g, crd);
	return obj;
end

function coord_move(obj, off)
	if type(obj)~="table" then return end
	if type(off)~="table" then return end
	geo_.Point:new(off);
	loop_point_object(obj, xyz_move, off);
	return obj;
end

-------------------------------

function coords_move(objs, off)
	if type(objs)~="table" then return end
	for k,v in pairs(objs) do
		coord_move(v,off);
	end
	return objs;
end

-------------------------------

-- arg={point=;color=;}
function get_pt8(arg)
	return {
		arg.color.r,
		arg.color.g,
		arg.color.b,
		1,
		1,
		arg.point.x,
		arg.point.y,
		arg.point.z
	};
end

function merge(objs)
	local obj = {surfaces={}};
	for objk,objv in pairs(objs) do
		for surk,surv in pairs(objv.surfaces) do
			table.insert(obj.surfaces,surv);
		end
	end
	if #obj.surfaces == 0 then return nil end
	return obj;
end

-----

local function link_outer(sur)
	if type(sur)~="table" then return end
	if type(sur.outer)~="table" then return end
	sur.lines = {}
	for i=1,#sur.outer do
		table.insert(sur.lines,{sur.outer[i], i<#sur.outer and sur.outer[i+1] or sur.outer[1]});
	end
end

function get_outer_lines(obj)
	if type(obj)~="table" then return end
	local tmp = require"sys.api.table".deepcopy(obj);
	if type(tmp.surfaces)~="table" then return end
	for k,v in pairs(tmp.surfaces) do
		link_outer(v);
	end
	return tmp;
end
