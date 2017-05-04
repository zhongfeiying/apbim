_ENV = module(...,ap.adv)

local geo_ = require "sys.geometry"

function get_section()
	return {geo_.Point:new{-10,-10},geo_.Point:new{10,-10},geo_.Point:new{10,10},geo_.Point:new{-10,10}};
end

require"app.Steel.section".add_type("default",get_section);



