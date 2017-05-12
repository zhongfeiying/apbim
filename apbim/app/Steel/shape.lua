_ENV = module(...,ap.sys)

local geo_ = require"sys.geometry";
local shape_ = require"sys.shape";
local solid_ = require"sys.solid";
-- local section_ = require"sys.section";
local section_ = require"app.Steel.section";

local modes_ = {diagram=solid_.Line,wireframe=solid_.Frame,rendering=solid_.Render}

local function move_base(base,dis)
	dis = dis or 0;
	if type(base)~="table" then return end
	base.y = base.y + dis;
end

local function move_outer(outer,dis,beta)
	dis = dis or 0;
	beta = beta or 0;
	if type(outer)~="table" then return end
	for k,v in pairs(outer) do
		if type(v)=="table" then
			geo_.Point:new(v);
			v:rotate_z(beta);
			outer[k].y = outer[k].y + dis;
		end
	end
end

local function move_inner(inner,dis)
	if type(inner)~="table" then return end
	dis = dis or 0;
	for k,v in pairs(inner) do
		if type(v)=="table" then
			inner[k].y = inner[k].y + dis;
		end
	end
end

local function move_inners(inners,dis)
	if type(inners)~="table" then return end
	dis = dis or 0;
	for k,v in pairs(inners) do
		if type(v)=="table" then
			move_inner(inners[k],dis);
		end
	end
end

local function move_bottom(t)
	move_base(t.base,t.ydis);
	move_outer(t.outer,t.ydis,t.beta);
	move_inners(t.inners,t.ydis);
	return t;
end


local function draw_sline(mem,mode,s,e)
	local cr = require"sys.geometry".Color:new(mem.Color):get_gl()
	local pt1 = mem:get_pt(s);
	local pt2 = mem:get_pt(e);
	local l = pt1:distance(pt2);
	local crd = geo_.Coord:new():set_x_line{pt1,pt2}:set_beta(mem.Beta);
	local outer,inners = section_.profile(mem.Section,mem:get_alignment());
	return solid_.extrude{
		mode = modes_[mode or mem:get_mode()];
		solid = {
			color = cr;
			length = l;
			position = solid_.x_position();
			bottom = {
				base = geo_.Point:new{0,0,0};
				outer = outer;
				inners = inners ;
			};
		};
		placement = crd;
	};
end

local function draw_line(mem,mode)
	local objs = {};
	local pts = mem:get_pts();
	for i,v in pairs(pts) do
		if i>1 then table.insert(objs,draw_sline(mem,mode,i-1,i)) end;
	end
	return shape_.merge(objs);
end

local function draw_arc(mem,mode)
	local cr = require"sys.geometry".Color:new(mem.Color):get_gl()
	local opt = mem:get_pt(1);
	local npt = mem:get_pt(2);
	local spt = mem:get_pt(3);
	local r = spt:distance_line{opt,npt};
	local angle = mem.Angle;
	local crd = geo_.Coord:new():set_oxy_point(opt,npt,spt);
	-- local alignment = mem.Alignment or {};
	-- alignment.h = alignment.h or alignment[1] or 0;
	-- alignment.v = alignment.v or alignment[2] or 0;
	local outer,inners = section_.profile(mem.Section,mem:get_alignment());
	return solid_.revolve{
		mode = modes_[mode or mem:get_mode()];
		solid = {
			color = cr;
			angle = angle;
			bottom = move_bottom{
				ydis = r;
				beta = mem.Beta;
				base = geo_.Point:new{0,0,0};
				outer = outer;
				inners = inners ;
			};
		};
		placement = crd;
	};
end


function draw_member(mem,mode)
	return type(mem.Angle)=="number" and draw_arc(mem,mode) or draw_line(mem,mode);
end

local function get_plate_outer(crd,pts,dis)
	crd:g2l_pts(pts);
	for k,v in pairs(pts) do
		v.z=v.z+dis;
	end
	return pts;
end

function draw_plate(pl,mode)
	local pts = require"sys.table".deepcopy(pl:get_pts());
	if #pts<3 then return end
	local crd = geo_.Coord:new():set_oxy_point{pts[1],pts[2],pts[3]};
	local cr = require"sys.geometry".Color:new(pl.Color):get_gl()
	local alignment = pl:get_alignment();
	local bottom_dis = pl.Thick*(alignment-0.5)
	return solid_.extrude{
		mode = modes_[mode or pl:get_mode()];
		solid = {
			color = cr;
			length = pl.Thick;
			bottom = {
				base = geo_.Point:new{0,0,0};
				outer = get_plate_outer(crd,pts,bottom_dis);
				-- inners = inners ;
			};
		};
		placement = crd;
	};
end

