_ENV = module(...,ap.adv)

local snap_ = require"sys.snap";
local shape_ = require"sys.shape";
local drag_ = require"sys.drag";
local mgr_ = require"sys.mgr";
local tab_ = require"sys.table";
local geo_ = require"sys.geometry";


local Entity = require"sys.Entity".Class;
function Entity:on_move(off)
	shape_.coords_move(self:get_shape(),off);
	for k,v in pairs(self:get_pts()) do
		v:move_by_offset(off);
	end
	self:modify();
	return self;
end

Command = {
	Classname = "sys/cmd/Create";
	-- copy = false;
	-- spt = ;
};

-- arg={class=,copy=false}
function new(t)
	t = require"sys.class".new(Command,t);
	return t;
end

local function run(copy,scene,pt1,pt2)
	if copy or is_ctr_down() then require"sys.mgr".copy_curs() end
	local off = geo_.Line:new{pt1,pt2}:get_offset();
	for k,v in pairs(mgr_.curs()) do
		if type(v.on_move)=="function" then v:on_move(off) else mgr_.select(v,nil) end
		mgr_.redraw(v);
	end
	mgr_.update();
	-- require"sys.statusbar".show_model_count()
end

function Command:on_lbuttondown(scene,flags,x,y)
	-- local pt = geo_.Point:new{client_2_world(scene,x,y)};
	local pt = snap_.get_world_pt(scene,x,y);
	if drag_.is_running() then
		drag_.stop(scene);
		run(self.copy,scene,self.spt,pt);
	else
		self.spt = pt;
		drag_.start(scene);
	end
end

function Command:on_mousemove(scene,flags,x,y)
	if not drag_.is_running() then return end;
	local pt = geo_.Point:new{client_2_world(scene,x,y)};
	drag_.draw_shirr_line{scene=scene,pt1=self.spt,pt2=pt};
end

