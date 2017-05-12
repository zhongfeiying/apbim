_ENV = module(...,ap.adv)

local geo_ = require"sys.geometry";

local DIS_ = 15;

local function snap_pt_by_pts(pts,sc,x,y,dis)
	dis = dis or DIS_;
	local pt = geo_.Point:new{x,y};
	if type(pts)~='table' then return end
	for i,v in ipairs(pts) do
		if pt:distance{world_2_client(sc,v.x or v[1],v.y or v[2],v.z or v[3])}<=dis then return v end 
	end
end


function snap_pt_by_scene_all(sc,x,y,dis)
	if not sc then trace_out("Error: sys.cmd.catch, get_ctrl_pt(sc,x,y,dis), sc is nil.") return end
	local pt = geo_.Point:new{client_2_world(sc,x,y)};
	
	local all = require'sys.mgr'.get_scene_all(sc);
	if type(all)~='table' then return pt end
	for k,v in pairs(all) do
		v = require'sys.mgr'.get_table(k,v);
		local result = snap_pt_by_pts(v.Points,sc,x,y,dis);
		if result then return result end
	end
	return pt
end


function Snap_Point(sc)
	require'sys.snap'.set_function(snap_pt_by_scene_all);
end

function load()
	require"sys.menu".add{app="Snap",frame=true,view=true,pos={"Window"},name={"Snap","Point"},f=Snap_Point};
end
