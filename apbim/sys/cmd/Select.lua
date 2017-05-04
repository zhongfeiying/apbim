_ENV = module(...,ap.adv)

local function shirr(scene,pt1,pt2)
	local cx1,cy1 = world_2_client(scene,pt1[1],pt1[2],pt1[3]);
	local cx2,cy2 = world_2_client(scene,pt2[1],pt2[2],pt2[3]);
	local wx1,wy1,wz1 = client_2_world(scene,cx1,cy1);
	local wx2,wy2,wz2 = client_2_world(scene,cx2,cy2);
	local wx3,wy3,wz3 = client_2_world(scene,cx1,cy2);
	local wx4,wy4,wz4 = client_2_world(scene,cx2,cy1);
	return {
		index = require"sys.drag".get_shirr_index();
		surfaces = {
			{
				textured = 0;
				points = {
					{1,1,1,0,0,wx1,wy1,wz1};
					{1,1,1,0,0,wx2,wy2,wz2};
					{0.8,0.8,0.8,0,0,wx3,wy3,wz3};
					{0.8,0.8,0.8,0,0,wx4,wy4,wz4};
				};
				lines = {
					{1,3};{1,4};{2,3};{2,4};
				};
			};
		};
	};
end

local run_doing_ = nil;
local function run(scene,pt1,pt2)
	if run_doing_ then return else run_doing_=ture end
	if not pt1 or not pt2 then return end;
	local x1,y1 = world_2_client(scene,pt1[1],pt1[2],pt1[3]);
	local x2,y2 = world_2_client(scene,pt2[1],pt2[2],pt2[3]);
	local cx,cy = (x1+x2)/2,(y1+y2)/2;
	local w,h = math.abs(x1-x2),math.abs(y1-y2);
	local minsize = 3;
	-- require"sys.mgr.scene.object".begin_progress();
	if w>minsize or h>minsize then
		scene_select(scene,cx,cy,w,h,0);
	else	
		w,h=minsize,minsize;
		scene_select(scene,cx,cy,w,h,0);
	end	
	run_doing_=nil;
	----
	-- statusbar_set_text(frm,1,tostring(require"mgr".curs_count()));
	-- local cur = require"mgr".cur();
	-- if not cur then return end;
	-- local wpt = cur:on_get_center();
	-- local cpt = {world_2_client(scene,wpt:values())};
	-- scene_cen(scene,wpt:values());
	-- move_cen_2_pt(scene,cpt[1],cpt[2]);
end



Command = {
	Classname = "sys/cmd/Select";
	-- spt = ;
};

function Command:init(scene)
	self.spt = nil;
end

-- function Command:on_paint(scene)
	-- require"sys.drag".update(scene);
-- end

function Command:on_lbuttondown(scene,flags,x,y)
	local pt = {client_2_world(scene,x,y)};
	self.spt = pt;
	-- self.scene_spt = {x,y};
	require"sys.drag".start(scene);
end

function Command:on_lbuttonup(scene,flags,x,y)
	if not self.spt then return end;
	local pt = {client_2_world(scene,x,y)};
	require"sys.drag".stop(scene);
	run(scene,self.spt,pt);
	self.spt = nil;
end

function Command:on_mousemove(scene,flags,x,y)
	if not self.spt then return end;
	local pt = {client_2_world(scene,x,y)};
	local obj = shirr(scene,self.spt,pt);
	require"sys.drag".draw{scene=scene,object=obj};
end


