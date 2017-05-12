_ENV = module(...,ap.adv)

local geo_ = require "sys.geometry"

local function get_section(szs,offset)
	if not szs[1] or not szs[2] or not szs[3] then return nil end;
	offset = offset or {};
	local x = (offset.x or offset.h or offset[1] or 0)*szs[2];
	local y = (offset.y or offset.v or offset[2] or 0)*szs[1];
	
	local outer = {};
	table.insert(outer,geo_.Point:new{x-szs[2]/2, y+szs[1]/2});
	table.insert(outer,geo_.Point:new{x-szs[2]/2, y-szs[1]/2});
	table.insert(outer,geo_.Point:new{x+szs[2]/2, y-szs[1]/2});
	table.insert(outer,geo_.Point:new{x+szs[2]/2, y+szs[1]/2});
	
	local inners = {{}};
	table.insert(inners[1],geo_.Point:new{x-szs[2]/2+szs[3], y+szs[1]/2-szs[3]});
	table.insert(inners[1],geo_.Point:new{x-szs[2]/2+szs[3], y-szs[1]/2+szs[3]});
	table.insert(inners[1],geo_.Point:new{x+szs[2]/2-szs[3], y-szs[1]/2+szs[3]});
	table.insert(inners[1],geo_.Point:new{x+szs[2]/2-szs[3], y+szs[1]/2-szs[3]});
	return outer,inners;
end

require"app.Steel.section".add_type("S",get_section);
require"app.Steel.section".add_type("TUB",get_section);
require"app.Steel.section".add_type("BCP",get_section);
require"app.Steel.section".add_type("BCR",get_section);
require"app.Steel.section".add_type("SHS",get_section);
require"app.Steel.section".add_type("Å†",get_section);
require"app.Steel.section".add_type("Å†P",get_section);
require"app.Steel.section".add_type("‰ª©P",get_section);
require"app.Steel.section".add_type("‰ª?",get_section);
