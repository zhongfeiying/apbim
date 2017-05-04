_ENV = module(...,ap.adv)

-- local section_ = require "sys.section";
local tab_ = require "sys.table"
local class_ = require "sys.class"
local geo_ = require "sys.geometry"
local obj_ = require "sys.api.object"
local shape_ = require "sys.shape"

--
local function discretization(pt1, pt2, angle, stage)
	stage = type(stage)=="number" and stage>0 and stage or 10;
	pt1 = geo_.Point:new(pt1);
	pt2 = geo_.Point:new(pt2);
	local r1 = pt1:distance2d();
	local r2 = pt2:distance2d();
	local pts = {};
	local function add_pt(i)
		local increment = (r2-r1)*i/angle;
		local radian = i*geo_.PI/180;
		local x = (r1+increment)*math.cos(radian);
		local y = (r1+increment)*math.sin(radian);
		local z = pt1.z+(pt2.z-pt1.z)*i/angle;
		table.insert(pts,geo_.Point:new{x,y,z});
	end
	for i=0, angle, stage do
		add_pt(i);
	end
	add_pt(angle);
	return pts;
end
	

----mode----
Mode = {name="Mode"};
Mode.__index = Mode;

----color----
function Mode:set_color(cr)
	-- cr = cr or {r=0,g=1,b=0}
	cr = geo_.Color:new(cr);
	self.real_color = cr;
end

local function color_scale(cr,f)
	local newcr = {};
	newcr.r = cr.r*f;
	newcr.g = cr.g*f;
	newcr.b = cr.b*f;
	return newcr;
end

rand_ = 0;
local function rand_render(b)
	-- math.randomseed(os.time());
	rand_ = b and math.random(10) or 0;
	-- trace_out("solid.rand_render(),rand_="..rand_..'\n');
end

function color_rand(i)
	return ((i%4)+(i%2)*2)*4;
end
function color_default(i)
	return 0+rand_;
end
function color_section(i)
	return 22+rand_;
end
function color_outer_cirle(i)
	return 15+rand_;
end
function color_outer_side(i)
	i = color_rand(i);
	return i+rand_;
end
function color_inner_cirle(i)
	return 50+rand_;
end
function color_inner_side(i)
	i = color_rand(i)+50;
	return i+rand_;
end

function Mode:color_factor(i)
	self.color_pos = self.color_pos or color_default;
	i = self.color_pos(i);
	local denominator = 100;
	return (denominator-i)/denominator;
end 

function Mode:change_color(i)
	-- i=i+1;
	local f = self:color_factor(i);
	self.color = color_scale(self.real_color,f);
end


----loop----
local function loop_area_points(pts,f,args)
	if not pts then return end;
	for k,v in ipairs(pts) do
		f(v,args);
	end
end

local function loop_area_inners(area,f,args)
	if not area or area.inners then
		for k,v in ipairs(area.inners) do
			loop_area_points(v,f,args);
		end
	end
end

local function loop_area_outer(area,f,args)
--	if not area or not area.outer then return end;
	if not area then return end;
	area.outer = area.outer or {};
	loop_area_points(area.outer,f,args);
end

local function loop_area_base(area,f,args)
--	if not area then return end;
	area.base = area.base or {0,0,0};
	f(area.base,args)
end

local function loop_area_xyz(area,f,args)
	loop_area_base(area,f,args);
	loop_area_outer(area,f,args);
	loop_area_inners(area,f,args);
end

----adjust----
local function point_new_polarto(v,args)
	geo_.Point:new(v):polarto(args[1],args[2]);
end

local function point_new_rotate(v,args)
	geo_.Point:new(v):rotate_line(args[1],args[2]);
end
local function adjust_area(t, sd, area)
	if type(sd[area])~="table" then sd[area] = {} end;
	if type(sd[area].base)~="table" then sd[area].base = {0,0,0} end;
	if type(sd[area].outer)~="table" then t.mode = Line end;
end

local function adjust(t)
	if not t then error("solid, arg is a nil") return end;
	if not t.solid then error("solid, arg.solid is a nil") return end;
	if getmetatable(t.mode)~=Mode then t.mode = Line end;
	adjust_area(t,t.solid,"bottom");
	t.run = class_.new(t.mode);
	t.run.solid = t.solid;
	t.run.top = t.solid.top or tab_.deepcopy(t.solid.bottom);
	adjust_area(t,t.run,"top");
end

local function adjust_extrude(t)
	adjust(t);
	t.solid.length = t.solid.length or 0;
	if type(t.solid.direction)~="table" then t.solid.direction = {0,0,1} end;
	loop_area_xyz(t.run.top,point_new_polarto,{t.solid.direction,t.solid.length});
end

local function adjust_revolve(t)
	adjust(t);
	t.solid.angle = t.solid.angle or 0;
	if type(t.solid.axisline)~="table" then t.solid.axisline = {{0,0,0},{1,0,0}} end;
	loop_area_xyz(t.run.top,point_new_rotate,{t.solid.angle,t.solid.axisline});
end

----object----
function Mode:create_objcet(sd)
	local obj = {};
	obj.index = sd.id;
	return obj;
end

function Mode:object_add_surface(obj)
	obj.surfaces = obj.surfaces or {}
	local k = #obj.surfaces+1;
	local v = {textured=0};
	obj.surfaces[k] = v;
	self:change_color(k);
	return k,v;
end

function Mode:surface_add_point(sf, pt)
	pt = geo_.Point:new(pt);
	sf.points = sf.points or {};
	for k,v in ipairs(sf.points) do
		local it = geo_.Point:new{v[6],v[7],v[8]};
		if pt==it then return k end;
	end
	local k = #sf.points+1;
	local v = {self.color.r,self.color.g,self.color.b, 0,0, pt.x,pt.y,pt.z};
	sf.points[k] = v;
	return k;
end


function Mode:surface_add_points(sur, pts)
	local ids = {};
	for k,v in pairs(pts) do
		local id = self:surface_add_point(sur,v);
		table.insert(ids,id);
	end
	return ids;
end

----surface----
function Mode:surface_add_line(sf,id1,id2)
	if not id1 or not id2 then return end;
	sf.lines = sf.lines or {};
	table.insert(sf.lines,{id1,id2});
end

function Mode:surface_add_line_point(sf, pt1, pt2)
	local id1 = self:surface_add_point(sf, pt1);
	local id2 = self:surface_add_point(sf, pt2);
	self:surface_add_line(sf,id1,id2);
end

function Mode:surface_add_lines(sur, ids)
	local pre = nil;
	for k,v in pairs(ids) do
		if pre then self:surface_add_line(sur,pre,v) end;
		pre = v;
	end
end

function Mode:surface_add_outer(sf,ids)
	if type(ids)~="table" then return end;
	sf.outer = sf.outer or {};
	for k,v in pairs(ids) do
		table.insert(sf.outer,v);
	end
end

function Mode:surface_outers_add_outer(sf,ids)
	if type(ids)~="table" then return end;
	sf.outers = sf.outers or {};
	local outer = {};
	for k,v in pairs(ids) do
		table.insert(outer,v);
	end
	table.insert(sf.outers,outer);
end

function Mode:surface_add_outer_points(sf,pts)
	if type(pts)~="table" then return end;
	local ids = {};
	for k,v in pairs(pts) do
		local id = self:surface_add_point(sf,v);
		table.insert(ids,id);
	end
	self:surface_add_outer(sf,ids);
end

function Mode:side(sf,bs,ts,reorder)
	local b1 = bs[1] and self:surface_add_point(sf,bs[1]);
	local b2 = bs[2] and self:surface_add_point(sf,bs[2]);
	local t1 = ts[1] and self:surface_add_point(sf,ts[1]);
	local t2 = ts[2] and self:surface_add_point(sf,ts[2]);
	return b1,b2,t1,t2;
end

function Mode:side_pt(bs,ts)
	local b1 = bs[1];
	local b2 = bs[2] or tab_.deepcopy(b1);
	local t1 = ts[1];
	local t2 = ts[2] or tab_.deepcopy(t1);
	return b1,b2,t1,t2;
end

function Mode:sides(obj,bs,ts,reorder)
	-- local bn,tn = table.getn(bs),table.getn(ts);
	local bn,tn = #bs,#ts;
	local bk,tk=1,1;
	while bk<=bn and tk<=tn do
		local bv,tv = {},{};
		bv[1],tv[1] = bs[bk],ts[tk];
		if bk/bn<=tk/tn then 
			bk = bk + 1;
			bv[2] = bs[bk] or bs[1];
		end
		if  bk/bn>=tk/tn then 
			tk = tk + 1;
			tv[2] = ts[tk] or ts[1];
		end
		local sk,sv = self:object_add_surface(obj);
		self:side(sv,bv,tv,reorder);
	end
end

function Mode:allsides(obj,sd)
	if type(sd.bottom.outer)~="table" or type(self.top.outer)~="table" then error("bottom or top's outer is wrong") end;
	self.color_pos = sd.bottom.outer.circle and color_outer_cirle or color_outer_side;
	self:sides(obj,sd.bottom.outer,self.top.outer);
	if type(sd.bottom.inners)~="table" or type(self.top.inners)~="table" then return end;
	-- local bn,tn = table.getn(sd.bottom.inners),table.getn(self.top.inners);
	local bn,tn = #(sd.bottom.inners),#(self.top.inners);
	local k=1;
	while k<=bn and k<=tn do
		local bv,tv = sd.bottom.inners[k],self.top.inners[k];
		self.color_pos = bv.circle and color_inner_cirle or color_inner_side;
		self:sides(obj,bv,tv,true);
		k = k+1;
	end
end

function Mode:surface_add_points_index(sf,tab,key,pts,reorder)
	if not pts then return end;
	tab[key] = tab[key] or {};
	for k,v in ipairs(pts) do
		local id = self:surface_add_point(sf,v);
		table.insert(tab[key],id);
	end
	if not reorder then return end;
	tab_.reverse_array(tab[key])
end

-- function surface_add_outer_point_id(v,args)
	-- local cr,sf = args.color,args.surface;
	-- local pt = {cr.r,cr.g,cr.b, 0,0, v.x,v.y,v.z};
	-- local id = surface_add_point(pt);
	-- sf.outer = sf.outer or {};
	-- table.insert(sf.outer,id);
-- end
function Mode:section(obj,sect,reorder)
	local sk,sv = self:object_add_surface(obj);
	if type(sv)~="table" then error("surface is a nil") end;	
	self:surface_add_points_index(sv,sv,"outer",sect.outer,reorder);
	if type(sect.inners)~="table" then return end;
	sv.inners = sv.inners or {};
	for k,v in pairs(sect.inners) do
		self:surface_add_points_index(sv,sv.inners,k,v,reorder);
	end
	-- self:loop_section_outer(sect.outer,surface_add_point_id_outer,{color=self.color,surface=sv});
end

function Mode:sections(obj,sd)
	self.color_pos = color_section;
	if not sd.bottom.nodraw then self:section(obj,sd.bottom,true) end
	if not self.top.nodraw then self:section(obj,self.top) end
end

----discretization----
function Mode:discretization_side_line(pt1,pt2,angle,ln)
	local coord = geo_.Coord:new():set_zline_xpoint(ln,pt1);
	local tmp1 = tab_.deepcopy(pt1);
	local tmp2 = tab_.deepcopy(pt2);
	tmp1 = coord:g2l(tmp1);
	tmp2 = coord:g2l(tmp2);
	local pts = discretization(tmp1,tmp2,angle);
	coord:l2g_pts(pts);
	return pts;
end


Line = {name="Line"};
Line.__index = Line;
setmetatable(Line,Mode);
function Line:extrude(sd)
	self:set_color(sd.color);
	local obj = self:create_objcet(sd);
	local k,v = self:object_add_surface(obj,sd.color);
	local id1 = self:surface_add_point(v,sd.bottom.base);
	local id2 = self:surface_add_point(v,self.top.base);
	self:surface_add_line(v,id1,id2);
	return obj;
end
function Line:revolve(sd)
	-- trace_out("Line:revolve\n");
	self:set_color(sd.color);
	local obj = self:create_objcet(sd);
	local k,v = self:object_add_surface(obj,sd.color);
	local pts = self:discretization_side_line(sd.bottom.base,self.top.base,sd.angle,sd.axisline);
	local ids = self:surface_add_points(v, pts);
	self:surface_add_lines(v,ids);
	return obj;
end

Frame = {name="Frame"};
Frame.__index = Frame;
setmetatable(Frame,Mode);

function Frame:side_extrude(sf,bs,ts)
	local b1,b2,t1,t2 = Mode:side_pt(bs,ts);
	self:surface_add_line_point(sf,b1,b2);
	self:surface_add_line_point(sf,t1,t2);
	self:surface_add_line_point(sf,t1,b1);
	-- self:surface_add_line_point(sf,t2,b2);
end

function Frame:side_revolve(sf,bs,ts)
	local b1,b2,t1,t2 = Mode:side_pt(bs,ts);
	local pts1 = self:discretization_side_line(b1,t1,self.solid.angle,self.solid.axisline);
	local pts2 = self:discretization_side_line(b2,t2,self.solid.angle,self.solid.axisline);
	local ids1 = self:surface_add_points(sf, pts1);
	local ids2 = self:surface_add_points(sf, pts2);
	self:surface_add_lines(sf,ids1);
	self:surface_add_lines(sf,ids2);
	self:surface_add_line_point(sf,b1,b2);
	self:surface_add_line_point(sf,t1,t2);
end

function Frame:side(sf,bs,ts)
	if self.revolve_ then self:side_revolve(sf,bs,ts) else self:side_extrude(sf,bs,ts) end;
end

function Frame:object(sd)
	self:set_color(sd.color);
	local obj = self:create_objcet(sd);
	self:allsides(obj,sd);
	return obj;
end

function Frame:extrude(sd)
	return self:object(sd);
end

function Frame:revolve(sd)
	self.revolve_ = true;
	return self:object(sd);
end

Render = {name="Render"};
Render.__index = Render;
setmetatable(Render,Mode);

function Render:side_extrude(sf,bs,ts,reorder)
	local b1,b2,t1,t2 = Mode:side_pt(bs,ts);
	if reorder then self:surface_add_outer_points(sf,{t1,t2,b2,b1}) return end
	self:surface_add_outer_points(sf,{b1,b2,t2,t1});
end

function Render:side_revolve(sf,bs,ts)
	local b1,b2,t1,t2 = Mode:side_pt(bs,ts);
	local pts1 = self:discretization_side_line(b1,t1,self.solid.angle,self.solid.axisline);
	local pts2 = self:discretization_side_line(b2,t2,self.solid.angle,self.solid.axisline);
	sf.surs = sf.surs or {};
	for k,v in pairs(pts1) do
		local sur = {textured=0};
		local ids = self:surface_add_points(sur, {pts1[k],pts2[k],pts2[k+1],pts1[k+1]});
		self:surface_add_outer(sur,ids);
		table.insert(sf.surs,sur);
	end
end

function Render:side(sf,bs,ts,reorder)
	if self.revolve_ then self:side_revolve(sf,bs,ts) else self:side_extrude(sf,bs,ts,reorder) end;
end

function Render:object(sd)
	self:set_color(sd.color);
	local obj = self:create_objcet(sd);
	self:allsides(obj,sd);
	self:sections(obj,sd);
	obj_.split_outers(obj);
	return obj;
end

function Render:extrude(sd)
	return self:object(sd);
end

function Render:revolve(sd)
	self.revolve_ = true;
	return self:object(sd);
end

----private----
-- local function loop_object_surface(sur, f, args)
	-- for k,v in pairs(sur.points) do
		-- f(v,args);
	-- end
-- end
-- local function loop_objcet_coord(obj, f, args)
	-- for k,v in pairs(obj.surfaces) do
		-- loop_object_surface(v,f,args);
	-- end
-- end

function x_position()
	local pos = {
		base = {0,0,0};
		beta = 0;
		x = {0,1,0};
		y = {0,0,1};
		z = {1,0,0};
	};
	return pos;
end

-- local function l2g_object_surface_point(pt, args)
	-- local coord = geo_.Coord:new(args[1]);
	-- local coord = (args[1]);
	-- local tmp = {pt[6],pt[7],pt[8]};
	-- tmp = geo_.Point:new(tmp);
	-- tmp = coord:l2g(tmp);
	-- pt[6] = tmp.x;
	-- pt[7] = tmp.y;
	-- pt[8] = tmp.z;
-- end
-- function l2g_object(obj, pos)
	-- loop_objcet_coord(obj, l2g_object_surface_point, {pos});
-- end

-- function moveto_position(obj, pos)
	-- pos = geo_.Coord:new(pos or x_position());
	-- l2g_object(obj,pos or x_position());
	-- return obj;
-- end

--[[
function moveto(t,obj)
	shape_.coord_l2g(obj, t.solid.position or x_position());
	-- local coord = geo_.Coord:new();
	-- if type(t.placement)=="table" then coord:set(t.placement) end
	if type(t.placement)=="table" then
		local coord = geo_.Coord:new(t.placement);
		shape_.coord_l2g(obj, coord);
	end
	return obj;
end

function moveto_position(t,obj)
	shape_.coord_l2g(obj, t.solid.position or x_position());
	return obj;
end

function moveto_placement(t,obj)
	if type(t.placement)=="table" then
		local coord = geo_.Coord:new(t.placement);
		shape_.coord_l2g(obj, coord);
	end
	return obj;
end

--]]

function moveto_position(t,obj)
	if type(t.solid.position)=="table" then 
		local coord = geo_.Coord:new(t.solid.position);
		shape_.coord_l2g(obj, coord);
	end
	return obj;
end

function moveto_placement(t,obj)
	if type(t.placement)=="table" then
		local coord = geo_.Coord:new(t.placement);
		shape_.coord_l2g(obj, coord);
	end
	return obj;
end

function moveto(t,obj)
	moveto_position(t,obj)
	moveto_placement(t,obj)
	return obj;
end

----------main---------------------------------------------------
--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
	-- 		base=
--			outer={},
--			inters={{},{}};
		-- 	nodraw=true;
--		};
--		top={};
--		direction={};
--		length=10000;
--		position = {};
--	};
--	placement = {};
--};
function extrude(t)
	-- rand_render(t.mode==Render);--侧边随机变色
	adjust_extrude(t);
	local obj = t.run:extrude(t.solid);
	return moveto(t,obj);
end

--t={
--	index=;
--	mode=Line/Frame/Render;
--	solid={
--		color={r=1,g=0,b=0};
--		bottom={
-- 			base=
--			outer={},
--			inters={{},{}};
--		};
--		top={};
--		axisline={};
--		angle=10000;
--		position = {};
--	};
--};
function revolve(t)
	-- rand_render(t.mode==Render);--侧边随机变色
	adjust_revolve(t);
	local obj = t.run:revolve(t.solid);
	-- return obj;
	return moveto_placement(t,obj);
end

----------------------------
--[[
--arg = {
--	mode = ;
--	section = "";
--	section2 = "";
--	color = {r=,g=,b=};
--	pt1 = ;
--	pt2 = ;
--};
function member(arg)
	arg.section2 = arg.section2 or arg.section;
	local bouter,binners = section_.profile(arg.section,arg.alignment);
	local touter,tinners = section_.profile(arg.section2,arg.alignment);
	return extrude{
		mode = arg.mode;
		solid = {
			color = arg.color;
			length = geo_.Point:new(arg.pt1):distance(arg.pt2);
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = geo_.Coord:new():set_x_line{arg.pt1,arg.pt2};
	};
end
--]]

