_ENV = module(...,ap.adv)

local snap_ = require"sys.snap";
local drag_ = require"sys.drag";
local mgr_ = require"sys.mgr";
local geo_ = require"sys.geometry";


local Entity = require"sys.Entity".Class;
function Entity:on_create(pts)
	if type(self)~="table" then return self end
	self.Points = pts;
	return self;
end


Command = {
	Classname = "sys/cmd/Create";
	-- class = ;
	-- pts = ;
};

-- arg={class=}
function new(t)
	t = require"sys.class".new(Command,t);
	return t;
end

local function run(class,scene,pts)
	local ent = class:new();
	-- if ent.init then ent:init() end
	ent:on_create(pts);
	ent:update_data();
	mgr_.add(ent);
	mgr_.draw(ent);
	mgr_.update();
	require"sys.statusbar".show_model_count();
end

function Command:set_count(n)
	self.n = n;
	return self;
end

function Command:on_lbuttondown(scene,flags,x,y)
	-- local pt = geo_.Point:new{client_2_world(scene,x,y)};
	local pt = snap_.get_world_pt(scene,x,y);
	
	if type(self.pts)~='table' then self.pts = {} end
	table.insert(self.pts,pt);
	local n = self.n or 2;
	if #self.pts >= n then
		-- drag_.stop(scene);
		run(self.class,scene,self.pts);
		self.pts = nil;
	else
		drag_.start(scene);
	end
	
	-- if self.spt then
		-- drag_.stop(scene);
		-- run(self.class,scene,self.spt,pt);
		-- self.spt = nil;
	-- else
		-- self.spt = pt;
		-- drag_.start(scene);
	-- end
end

function Command:on_mousemove(scene,flags,x,y)
	if not self.pts then return end
	local pt = geo_.Point:new{client_2_world(scene,x,y)};
	drag_.draw_shirr_line{scene=scene,pt1=self.pts[#self.pts],pt2=pt};

	-- if not self.spt then return end;
	-- local pt = geo_.Point:new{client_2_world(scene,x,y)};
	-- drag_.draw_shirr_line{scene=scene,pt1=self.spt,pt2=pt};
end

