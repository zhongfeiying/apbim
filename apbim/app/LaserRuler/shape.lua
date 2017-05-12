_ENV = module(...)

local geo_ = require"sys.geometry";
local shape_ = require"sys.shape";
local solid_ = require"sys.solid";

local modes_ = {diagram=solid_.Line,wireframe=solid_.Frame,rendering=solid_.Render}

local function get_outer_default()
	return {geo_.Point:new{-10,-10},geo_.Point:new{10,-10},geo_.Point:new{10,10},geo_.Point:new{-10,10}};
end

local function get_outer_rect(szs,alignment)
	if not szs.w1 or not szs.w2 then return get_outer_default() end;
	local x,y=0,0;
	
	local outer = {};
	if alignment then
		table.insert(outer,geo_.Point:new{x, y});
		table.insert(outer,geo_.Point:new{x+szs.w1, y});
		table.insert(outer,geo_.Point:new{x+szs.w1, y+szs.w2});
		table.insert(outer,geo_.Point:new{x, y+szs.w2});
	else
		table.insert(outer,geo_.Point:new{x-szs.w1/2, y+szs.w2/2});
		table.insert(outer,geo_.Point:new{x-szs.w1/2, y-szs.w2/2});
		table.insert(outer,geo_.Point:new{x+szs.w1/2, y-szs.w2/2});
		table.insert(outer,geo_.Point:new{x+szs.w1/2, y+szs.w2/2});
	end
	
	return outer;
end

local function circle_pts_by_r(r1,r2,o_x,o_y)
	local segment = 36;
	local pts = {circle=true;};
	for i=0,segment-1 do
		local seg = segment/4;
		local r = (r1+r2)/2;
		-- local r = (0<=i and i<segment/4 or segment/2<=i and i<segment*3/4) and r1*(i%seg)/seg + r2*(seg-i%seg)/seg or r2*(i%seg)/seg + r1*(seg-i%seg)/seg;
		local angle,x,y=0,0,0;
		angle = 2*geo_.PI*i/segment;
		x = o_x + r * math.cos(angle);
		y = o_y + r * math.sin(angle);
		table.insert(pts,geo_.Point:new{x,y});
	end
	return pts;
end

local function get_outer_circle(szs)
	if not szs.w2 or not szs.w1 then return get_outer_default() end;
	local x,y=0,0;
	local outer = circle_pts_by_r(szs.w1/2,szs.w2/2,x,y)
	return outer;
end
	
local function get_outer(sect,circle,alignment)
	return circle and get_outer_circle(sect) or get_outer_rect(sect,alignment);
end

-- arg={coord=,sect1={};sect2={};color={};circle=true;mode=,draw_section={bottom=true,top=true}}
local function draw_segment_by_xaxis(arg)
	local crd = geo_.Coord:new():set_x_line{{arg.sect1.p,0,0},{arg.sect2.p,0,0}};
	return solid_.extrude{
		mode = modes_[arg.mode];
		solid = {
			color = arg.color;
			length = arg.sect2.p-arg.sect1.p;
			position = solid_.x_position();
			bottom = {
				base = geo_.Point:new{0,0,0};
				outer = get_outer(arg.sect1,arg.circle,arg.alignment);
				nodraw = not arg.draw_section.bottom;
			};
			top = {
				base = geo_.Point:new{0,0,0};
				outer = get_outer(arg.sect2,arg.circle,arg.alignment);
				nodraw = not arg.draw_section.top;
			};
		};
		placement = crd;
	};
end

local function get_area(sect)
	return sect.w1*sect.w2;
end

local function get_min(sects)
	local ps = {};
	local min_area = nil;
	local n = table.getn(sects);
	for i=1,n do 
		local area = sects[i].w1 * sects[i].w2;
		if not min_area or min_area>area then min_area=area end
	end
	for i=1,n do 
		local area = sects[i].w1 * sects[i].w2;
		if geo_.fle(area,min_area) then ps[i]=true end
	end
	return ps;
end

local function do_min_area(sects)
	local min_area,min_pos = get_min(sects);
	local min_sect = {w1=sects[min_pos].w1,w2=sects[min_pos].w2,p=sects[min_pos].p+0};
	table.insert(sects,min_pos+1,min_sect);
end
local function do_min_area(sects)
	local n = table.getn(sects);
	local ps = get_min(sects);
	for i=n,1,-1 do 
		if ps[i] and not ps[i-1] and not ps[i+1] then 
			local min_sect = {w1=sects[i].w1,w2=sects[i].w2,p=sects[i].p+0.01};
			table.insert(sects,i+1,min_sect);
		end
	end
end

-- arg={spt={};ept={};sections={};color={};circle=true;alignment=true;mode=}
function draw(arg)
	local crd = geo_.Coord:new():set_x_line{arg.spt,arg.ept};
	local objs = {};
	local sects = arg.sections or {};
	do_min_area(sects);
	local n = table.getn(sects);
	local ps = get_min(sects);
	for i=2,n do
		local draw_section = {};
		if i==2 then draw_section.bottom = true end
		if i==n then draw_section.top = true end
		if ps[i]then draw_section.top = true end
		-- local body_cr,side_cr = geo_.fle(get_area(sects[i-1]),min_area) and geo_.fle(get_area(sects[i]),min_area) and {1,0,0},{0,1,0} or {0,0,1},{0.1,0.1,0.1};
		local body_cr,side_cr = nil,nil;
		if ps[i-1] and ps[i] then
			body_cr,side_cr = {1,0,0},{0,1,0}; 
		else 
			body_cr,side_cr = {0,0,1},{0.1,0.1,0.1};
		end
		local obj = draw_segment_by_xaxis{coord=crd,sect1=sects[i-1],sect2=sects[i],color=side_cr,alignment=arg.alignment,circle=arg.circle,mode="wireframe",draw_section=draw_section};
		shape_.coord_l2g(obj,crd);
		table.insert(objs,obj);
		local obj = draw_segment_by_xaxis{coord=crd,sect1=sects[i-1],sect2=sects[i],color=body_cr,alignment=arg.alignment,circle=arg.circle,mode="rendering",draw_section=draw_section};
		shape_.coord_l2g(obj,crd);
		table.insert(objs,obj);
	end
	return shape_.merge(objs);
end

