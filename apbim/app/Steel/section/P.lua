--SJY 2015ƒÍ4‘¬24»’13:54:00
_ENV = module(...,ap.adv)

local geo_ = require "sys.geometry"

local function circle_pts_by_r(r,lx,ly,segment)
	segment = type(segment)=="number" and segment>0 and segment or 30;
	local pts = {circle=true;};
	for i=0,segment do
		local angle,x,y=0, 0 , 0 ;
		angle = 2*geo_.PI*i/segment;
		x = lx + r * math.cos(angle);
		y = ly + r * math.sin(angle);
		table.insert(pts,geo_.Point:new{x,y});
	end
	return pts;
end

local function get_section(szs,offset)
	if not szs[1] or not szs[2]   then return require"app.Steel.section.default".get_section() end;
	offset = offset or {};
	local x = (offset.x or offset.h or offset[1] or 0)*szs[1];
	local y = (offset.y or offset.v or offset[2] or 0)*szs[1];
	
	local outer = circle_pts_by_r(szs[1]/2,x,y,szs.segment);
	local inners = {circle_pts_by_r(szs[1]/2-szs[2],x,y,szs.segment);};
	return outer,inners;
end
require"app.Steel.section".add_type("P",get_section);
require"app.Steel.section".add_type("°",get_section);
require"app.Steel.section".add_type("SGP",get_section);
require"app.Steel.section".add_type("STKN",get_section);
require"app.Steel.section".add_type("STK",get_section);
require"app.Steel.section".add_type("PIPE",get_section);
require"app.Steel.section".add_type("SPD",get_section);
require"app.Steel.section".add_type("Åõ",get_section);
require"app.Steel.section".add_type("CHS",get_section);
require"app.Steel.section".add_type("EPD",get_section);
require"app.Steel.section".add_type("PD",get_section);
require"app.Steel.section".add_type("TUBE",get_section);
require"app.Steel.section".add_type("PIP",get_section);
