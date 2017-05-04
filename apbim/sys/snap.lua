_ENV = module(...,ap.adv)

local function_ = nil;

local function default(sc,x,y)
	return require"sys.geometry".Point:new{client_2_world(sc,x,y)}
end

function set_function(f)
	if type(f)=='function' then function_=f end
	if not f then function_=nil end
end

function get_world_pt(sc,x,y)
	if type(function_)=='function' then return function_(sc,x,y) end
	return default(sc,x,y);
end


