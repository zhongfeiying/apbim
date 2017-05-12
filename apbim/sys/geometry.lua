_ENV = module(...,ap.adv)

local tab_ = require "sys.api.table"
local fmin_ = 0.000001;
PI = 3.14159265358979;

function get_radian(angle)
	return angle*PI/180;
end

function get_angle(radian)
	return radian*180/PI;
end

--float-----------------------------
function fmin(p)
	fmin_ = p or fmin_;
	return fmin_;
end

function flt(a,b,p)
	fmin(p);
	return b - a > fmin_;
end

function fmt(a,b,p)
	return flt(b,a,p);
end

function fle(a,b,p)
	return not fmt(a,b,p);
end

function fme(a,b,p)
	return not flt(a,b,p);
end

function feq(a,b,p)
	return fle(a,b,p) and fme(a,b,p);
end

function fue(a,b,p)
	return not feq(a,b,p);
end

function min(a,b)
	if type(a)=="number" and type(b)=="number" and a<b then return a else return b end
	if type(a)=="number" and type(b)~="number" then return a end
	if type(b)=="number" then return b end
	return nil;
end

function max(a,b)
	if type(a)=="number" and type(b)=="number" and a>b then return a else return b end
	if type(a)=="number" and type(b)~="number" then return a end
	if type(b)=="number" then return b end
	return nil;
end

function box_min_pt(pt1,pt2)
	if type(pt1)~="table" and type(pt2)~="table" then return {} end
	if type(pt1)~="table" then return pt2 end
	if type(pt2)~="table" then return pt1 end
	local pt = {};
	pt.x = require"sys.geometry".min(pt1.x,pt2.x);
	pt.y = require"sys.geometry".min(pt1.y,pt2.y);
	pt.z = require"sys.geometry".min(pt1.z,pt2.z);
	return pt;
end

function box_max_pt(pt1,pt2)
	if type(pt1)~="table" and type(pt2)~="table" then return {} end
	if type(pt1)~="table" then return pt2 end
	if type(pt2)~="table" then return pt1 end
	local pt = {};
	pt.x = require"sys.geometry".max(pt1.x,pt2.x);
	pt.y = require"sys.geometry".max(pt1.y,pt2.y);
	pt.z = require"sys.geometry".max(pt1.z,pt2.z);
	return pt;
end

--color-----------------------------

function color_index(id)
	local crs = require"sys.io".read_file{file="cfg/color_index.lua"};
	if type(crs)~="table" then return {r=0,g=255,b=0,id=id} end
	if type(crs[id])~="table" then return {r=0,g=0,b=255,id=id} end
	crs[id].id = id;
	return crs[id];
end

Color = {};
Color.__index = Color;
Color.Classname = "Color";

function Color:new(t)
	-- if type(t)=="number" then t = color_index(t) end
	-- if getmetatable(t)==Color then return t end;
	t = type(t)=="table" and t or type(t)=="number" and color_index(t) or type(t)=="string" and type(tonumber(t))=="number" and color_index(tonumber(t)) or {}
	-- self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

function Color:set(t)
	t = t or self;
	self.r = t.r or t[1] or self.r or 0;
	self.g = t.g or t[2] or self.g or 0;
	self.b = t.b or t[3] or self.b or 0;
	self[1],self[2],self[3] = self.r,self.g,self.b;
end

Color.__eq = function (a,b)
	if fue(a.r,b.r) then return false end;
	if fue(a.g,b.g) then return false end;
	if fue(a.b,b.b) then return false end;
	return true;
end

function Color:get_gl()
	if type(self)~="table" then return {0,0,0} end
	local r = self.r or self[1] or 0;
	local g = self.g or self[2] or 0;
	local b = self.b or self[3] or 0;
	local cr = Color:new{r/255,g/255,b/255};
	return cr;
end

--point-----------------------------
Point = {};
Point.__index = Point;
Point.Classname = "Point";

function Point:new(t)
	if getmetatable(t)==Point then return t end;
	t = t or {}
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

function Point:set(t)
	t = t or self;
	self.x = t.x or t[1] or self.x or 0;
	self.y = t.y or t[2] or self.y or 0;
	self.z = t.z or t[3] or self.z or 0;
	self.x = tonumber(self.x) or 0;
	self.y = tonumber(self.y) or 0;
	self.z = tonumber(self.z) or 0;
	self[1],self[2],self[3] = self.x,self.y,self.z;
end

function Point:origin()
	return Point:new{0,0,0};
end

function Point:values()
	return self.x,self.y,self.z;
end

Point.__eq = function (a,b)
	if fue(a.x,b.x) then return false end;
	if fue(a.y,b.y) then return false end;
	if fue(a.z,b.z) then return false end;
	return true;
end

Point.__add = function(a,b)
	local t = Point:new();
	t.x = a.x+b.x;
	t.y = a.y+b.y;
	t.z = a.z+b.z;
	t:set();
	return t;
end

Point.__sub = function(a,b)
	local t = Point:new();
	t.x = a.x-b.x;
	t.y = a.y-b.y;
	t.z = a.z-b.z;
	t:set();
	return t;
end

Point.__unm = function(a)
	local t = Point:new();
	t = t-a;
	return t;
end

function Point:add(a)
	self.x = self.x+a.x;
	self.y = self.y+a.y;
	self.z = self.z+a.z;
	self:set();
	return self;
end

function Point:rotate_x(beta)
	if not beta then return self end
	local a = beta * PI/180.0;
	local pt = tab_.deepcopy(self);
	self.x = pt.x;
	self.y = pt.y * math.cos(a) - pt.z * math.sin(a);
	self.z = pt.y * math.sin(a) + pt.z * math.cos(a);
	self:set();
	return self;
end

function Point:rotate_y(beta)
	if not beta then return self end
	local a = beta *PI/180.0;
	local pt = tab_.deepcopy(self);
	self.x = pt.x * math.cos(a) + pt.z * math.sin(a);
	self.y = pt.y;
	self.z = -pt.x * math.sin(a) + pt.z * math.cos(a);
	self:set();
	return self;
end

function Point:rotate_z(beta)
	if not beta then return self end
	local a = beta *PI/180.0;
	local pt = tab_.deepcopy(self);
	self.x = pt.x * math.cos(a) - pt.y * math.sin(a);
	self.y = pt.x * math.sin(a) + pt.y * math.cos(a);
	self.z = pt.z;
	self:set();
	return self;
end

function Point:rotate_line(angle,ln)
	local coord = Coord:new():set_x_line(ln);
	local tmp = coord:g2l(self);
	tmp = tmp:rotate_x(angle);
	tmp = coord:l2g(tmp);
	self:set(tmp);
	return self;
end

function Point:scale(f)
	if not f then return self end;
	self.x = self.x*f;
	self.y = self.y*f;
	self.z = self.z*f;
	return self;
end

function Point:dot(pt)
	if not pt then return end;
	return ( self.x * pt.x+ self.y * pt.y + self.z * pt.z );
end

function Point:normalize()
	local len = math.sqrt(self:dot(self));
	if (len > 0.0) then
		self:scale(1/len);
		return self;
	end
	return self;
end

function Point:multi(pt)
	if not pt then return end;
	local t = Point:new();
	t.x = self.y * pt.z - pt.y * self.z;
	t.y = self.z * pt.x - pt.z * self.x;
	t.z = self.x * pt.y - pt.x * self.y;
	-- t:normalize();
	t:set();
	return t;
end

Point.__mul = function(a,b)
	if type(b)=="number" then return a:scale(b) end;
	if getmetatable(b)==Point then return a:multi(b) end;
end

function Point:distance(pt)
	pt = Point:new(pt);
	return math.sqrt( (self.x-pt.x)*(self.x-pt.x) + (self.y-pt.y)*(self.y-pt.y) + (self.z-pt.z)*(self.z-pt.z) );
end

function Point:distance2d(pt)
	pt = Point:new(pt);
	return math.sqrt( (self.x-pt.x)*(self.x-pt.x) + (self.y-pt.y)*(self.y-pt.y) );
end

function Point:distance_line(ln)
	local coord = Coord:new():set_x_line(ln);
	local tmp = coord:g2l(self);
	tmp.x = 0;
	return tmp:distance();
end

function Point:perpendicular_line(ln)
	local coord = Coord:new():set_x_line(ln);
	local tmp = coord:g2l(self);
	tmp.y,tmp.z = 0, 0;
	tmp = coord:l2g(tmp);
	return tmp;
end

function Point:polarto(nor,len)
	local norm = Point:new(tab_.deepcopy(nor)):normalize();
	if(norm)then
		self.x = self.x + len * norm.x;
		self.y = self.y + len * norm.y;
		self.z = self.z + len * norm.z;
		self:set();
		return self;
			
	else
		trace_out("Point:polarto's normal is empty!please check it.\n");
	end
end

function Point:move_by_offset(off)
	off = Point:new(off);
	self:add(off);
	return self;
end

function Point:move_by_line(ln)
	local off = Line:new(ln):get_offset();
	self:move_by_offset(off);
	return self;
end

function distance(pt1,pt2)
	pt1 = Point:new(pt1);
	return pt1:distance(pt2);
end

--line-----------------------------
Line = {};
Line.__index = Line;
Line.Classname = "Line";

function Line:new(t)
	if getmetatable(t)==Line then return t end;
	t = t or {}
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

function Line:set(t)
	t = t or self;
	self.pt1 = Point:new(t.pt1 or t[2] and t[1] or {0,0,0});
	self.pt2 = Point:new(t.pt2 or t[2] or  t[1] or {0,0,0});
	self[1],self[2] = self.pt1,self.pt2;
end

function Line:get_offset()
	return self.pt2 - self.pt1;
end


--coordinate-----------------------------
Coord = {};
Coord.__index = Coord;
Coord.Classname = "Coord";

function Coord:new(t)
--	if getmetatable(t)==Coord then return t end;
	t = t or {};
	self.__index = self;
	setmetatable(t,self);
	t:set();
	return t;
end

-- function Coord:init(t)
	-- self.base = Point:new(t and t.base or {0,0,0});
	-- self.beta = t and t.beta or 0;
	-- self.x = Point:new(t and t.x or {1,0,0});
	-- self.y = Point:new(t and t.y or {0,1,0});
	-- self.z = Point:new(t and t.z or {0,0,1});
	-- return self;
-- end

function Coord:set(t)
	t = t or self;
	self:set_base(t.base);
	self:set_beta(t.beta);
	if t.x and t.z then self:set_xz_normal(t.x,t.z) return end;
	if t.x and t.y then self:set_xy_normal(t.x,t.y) return end;	
	if t.y and t.z then self:set_yz_normal(t.y,t.z) return end;	
	if t.x then self:set_x_normal(t.x) return end;
	if t.y then self:set_y_normal(t.y) return end;
	self:set_default_normal();
	return self;
end

function Coord:set_default_normal()
	self.x = Point:new{1,0,0};
	self.y = Point:new{0,1,0};
	self.z = Point:new{0,0,1};
	return self;
end


function Coord:g()
	return
	luaaxis.new(
		luapt.new(self.base:values()),
		luapt.new(self.x:values()),
		luapt.new(self.y:values()),
		luapt.new(self.z:values()),
		self.beta
	);
end

-- function Coord:base_point(t)
	-- if not t then return self.base end;
	-- if type(t)=="table" then t = Point:new(t) end;
	-- self.base = t;
	-- return self.base;
-- end

-- function Coord:beta_degree(t)
	-- if not t then return self.beta end;
	-- self.beta = t;
	-- return self.beta;
-- end

function Coord:set_base(pt)
	self.base = Point:new(pt);
	return self;
end

--degree
function Coord:set_beta(degree)
	self.beta = degree or 0;
	return self;
end

function Coord:adjust_normal(t)
	for k,v in pairs(t) do
		if type(v)~="table" then return false end;
		t[k] = Point:new(t[k]):normalize();
		if t[k] == Point:new() then return false end;
	end
	if t[1] and t[2] and t[1] == t[2] then return false end;
	return true;
end

function Coord:set_xz_normal(x,z)
	-- if type(x)~="table" then return self:set_default_normal() end;
	-- if type(z)~="table" then return self:set_default_normal() end;
	-- x = Point:new(x);
	-- z = Point:new(z);
	if not self:adjust_normal{x,z} then return self:set_default_normal() end;
	self.x = x:normalize();
	self.z = z:normalize();
	self.y = (self.z*self.x):normalize();
	self.z = (self.x*self.y):normalize();
	return self;
end

function Coord:set_xy_normal(x,y)
	-- if type(x)~="table" then return self:set_default_normal() end;
	-- if type(y)~="table" then return self:set_default_normal() end;
	-- x = Point:new(x);
	-- y = Point:new(y);
	if not self:adjust_normal{x,y} then return self:set_default_normal() end;
	self.x = x:normalize();
	self.y = y:normalize();
	self.z = (self.x*self.y):normalize();
	self.y = (self.z*self.x):normalize();
	return self;
end

function Coord:set_yz_normal(y,z)
	-- if type(y)~="table" then return self:set_default_normal() end;
	-- if type(z)~="table" then return self:set_default_normal() end;
	-- y = Point:new(y);
	-- z = Point:new(z);
	if not self:adjust_normal{y,z} then return self:set_default_normal() end;
	self.y = y:normalize();
	self.z = z:normalize();
	self.x = (self.y*self.z):normalize();
	self.z = (self.x*self.y):normalize();
	return self;
end

function Coord:set_zx_normal(z,x)
	-- if type(z)~="table" then return self:set_default_normal() end;
	-- if type(x)~="table" then return self:set_default_normal() end;
	-- z = Point:new(z);
	-- x = Point:new(x);
	if not self:adjust_normal{z,x} then return self:set_default_normal() end;
	self.z = z:normalize();
	self.x = x:normalize();
	self.y = (self.z*self.x):normalize();
	self.x = (self.y*self.z):normalize();
	return self;
end

function Coord:set_x_normal(x)
	if type(x)~="table" then return self:set_default_normal() end;
	local z = Point:new{0,0,1};
	x = Point:new(x):normalize();
	if x==z or x==-z then z = Point:new{0,1,0} end;
	self:set_xz_normal(x,z);
	return self;
end

function Coord:set_y_normal(y)
	if type(y)~="table" then return self:set_default_normal() end;
	local z = Point:new{0,0,1};
	y = Point:new(y):normalize();
	z = y==z or y==-z and Point:new{1,0,0} or z;
	self:set_yz_normal(y,z);
	return self;
end

function Coord:set_z_normal(z)
	if type(z)~="table" then return self:set_default_normal() end;
	local x = Point:new{1,0,0};
	z = Point:new(z):normalize();
	if z==x or z==-x then x = Point:new{0,1,0} end;
	self:set_zx_normal(z,x);
	return self;
end

function Coord:set_x_line(ln)
	if type(ln)~="table" then return self:set_default_normal() end;
	ln = Line:new(ln);
	self:set_base(ln.pt1);
	ln.pt2.x = ln.pt1==ln.pt2 and ln.pt1.x+1 or ln.pt2.x;
	self:set_x_normal(ln.pt2-ln.pt1);
	return self;
end

function Coord:set_y_line(ln)
	if type(ln)~="table" then return self:set_default_normal() end;
	ln = Line:new(ln);
	self:set_base(ln.pt1);
	ln.pt2.x = ln.pt1==ln.pt2 and ln.pt1.x+1 or ln.pt2.x;
	self:set_y_normal(ln.pt2-ln.pt1);
	return self;
end

function Coord:set_z_line(ln)
	if type(ln)~="table" then return self:set_default_normal() end;
	ln = Line:new(ln);
	self:set_base(ln.pt1);
	ln.pt2.z = ln.pt1==ln.pt2 and ln.pt1.z+1 or ln.pt2.z;
	self:set_z_normal(ln.pt2-ln.pt1);
	return self;
end

function Coord:set_xline_ypoint(xln,ypt)
	if type(xln)~="table" then return self:set_default_normal() end;
	if type(ypt)~="table" then return self:set_default_normal() end;
	local ln = Line:new(xln);
	local pt = Point:new(ypt);
	local base = pt:perpendicular_line(ln);
	self:set_base(base);
	local xnor = (ln.pt2-ln.pt1):normalize();
	local ynor = (pt-base):normalize();
	self:set_xy_normal(xnor,ynor);
	return self;
end

function Coord:set_zline_xpoint(zln,xpt)
	if type(zln)~="table" then return self:set_default_normal() end;
	if type(xpt)~="table" then return self:set_default_normal() end;
	local ln = Line:new(zln);
	local pt = Point:new(xpt);
	local base = pt:perpendicular_line(ln);
	self:set_base(base);
	local znor = (ln.pt2-ln.pt1):normalize();
	local xnor = (pt-base):normalize();
	self:set_zx_normal(znor,xnor);
	return self;
end

function Coord:set_oxy_point(o,x,y)
	if type(o)~="table" then return self:set_default_normal() end;
	if type(x)~="table" then return self:set_default_normal() end;
	if type(y)~="table" then return self:set_default_normal() end;
	o = Point:new(o);
	x = Point:new(x);
	y = Point:new(y);
	self:set_base(o);
	self:set_xy_normal(x-o,y-o);
	return self;
end


function Coord:offset(off)
	if type(off)~="table" then return self end;
	self.base = Point:new(self.base);
	off = Point:new(off);
	self.base=self.base+off;
	return self;
end
-- function Coord:set_local_offset(off)
	-- if type(off)~="table" then return self end;
	-- self.base = Point:new(self.base);
	-- off = Point:new(off);
	-- local goff = self:l2g_normal(off);
	-- self.base=self.base+goff;
	-- return self;
-- end
-- function Coord:set_offset_line(ln)
	-- if type(ln)~="table" then return self:set_default_normal() end;
	-- ln = Line:new(ln);
	-- self:set_base(ln.pt2-ln.pt1);
	-- return self;
-- end

function Coord:check()
	if not tab_.ismet(Point,self.base) then error("base isn't a Point") return false end;
	if not tab_.ismet(Point,self.x) then error("x isn't a Point") return false end;
	if not tab_.ismet(Point,self.y) then error("y isn't a Point") return false end;
	if not tab_.ismet(Point,self.z) then error("z isn't a Point") return false end;
	if not type(self.beta)=="number" then error("beta isn't a number") return false end;
	return true;
end

function Coord:g2l(pt)
	self:check();
	local rt = Point:new();
	pt = Point:new(pt);
	pt = pt - self.base;
	rt.x = pt.x * self.x.x + pt.y * self.x.y + pt.z * self.x.z;
	rt.y = pt.x * self.y.x + pt.y * self.y.y + pt.z * self.y.z;
	rt.z = pt.x * self.z.x + pt.y * self.z.y + pt.z * self.z.z;
	rt:rotate_x(-self.beta);
	return rt;
end

function Coord:l2g(pt)
	self:check();
	local rt = Point:new();
	pt = Point:new(pt);
	pt = pt:rotate_x(self.beta);
	rt.x = pt.x * self.x.x + pt.y * self.y.x + pt.z * self.z.x;
	rt.y = pt.x * self.x.y + pt.y * self.y.y + pt.z * self.z.y;
	rt.z = pt.x * self.x.z + pt.y * self.y.z + pt.z * self.z.z;
	rt = rt + self.base;	
	return rt; 
end

function Coord:g2l_normal(nor)
	self:check();
	nor = Point:new(nor);
	nor = nor + self.base;
	nor = self:g2l(nor);
	return nor;
end

function Coord:l2g_normal(nor)
	self:check();
	nor = Point:new(nor);
	nor = self:l2g(nor);
	nor = nor - self.base;
	return nor;
	
end

function Coord:g2l_pts(pts)
	for k,v in pairs(pts) do
		pts[k]=self:g2l(pts[k]);
	end
end

function Coord:l2g_pts(pts)
	for k,v in pairs(pts) do
		pts[k]=self:l2g(pts[k]);
	end
end


function x_axis()
	local coord = {
		base = {0,0,0};
		beta = 0;
		x = {0,1,0};
		y = {0,0,1};
		z = {1,0,0};
	};
	return Coord:new(coord);
end

--calculate-----------------------------

function get_angle_by_3pt(o,s,e)
	local crd = Coord:new():set_oxy_point(o,s,e);
	local pt = crd:g2l(e);
	local x = pt.x;
	local y = pt.y;
	local l = math.sqrt(x*x+y*y)
	local a = math.asin(y/l)*180/PI;
	if x<0 then a=a+180 end
	return a;
end























