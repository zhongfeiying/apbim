--wky 2015ƒÍ4‘¬24»’13:55:08
_ENV = module(...,ap.adv)

local geo_ = require "sys.geometry"

local function circle_pts_by_r(r,o_x,o_y,segment)
	segment = type(segment)=="number" and segment>0 and segment or 30;
	local pts = {circle=true;};
	for i=0,segment do
		local angle,x,y=0,0,0;
		angle = 2*geo_.PI*i/segment;
		x = o_x + r * math.cos(angle);
		y = o_y + r * math.sin(angle);
		table.insert(pts,geo_.Point:new{x,y});
	end
	return pts;
end

local function get_section(szs,offset)
	if not szs[1]  then return require"app.Steel.section.default".get_section() end;
	offset = offset or {};
	local x = (offset.x or offset.h or offset[1] or 0)*szs[1];
	local y = (offset.y or offset.v or offset[2] or 0)*szs[1];
	local outer = circle_pts_by_r(szs[1]/2,x,y,szs.segment)
	return outer;
end

require"app.Steel.section".add_type("M",get_section);
require"app.Steel.section".add_type("D",get_section);
require"app.Steel.section".add_type("ELD",get_section);
require"app.Steel.section".add_type("ROD",get_section);
require"app.Steel.section".add_type("É”",get_section);