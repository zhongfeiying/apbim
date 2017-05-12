_ENV = module(...,ap.adv)


local cur_ = nil;
local max_ = 0;
local views_ = {};--{sc=View,...}
local sizes_ = {};--{sc={cx=,cy=},...}

function set_size(sc,cx,cy)
	sizes_[sc] = {cx=cx,cy=cy};
end

function get_size(sc)
	return sizes_[sc]
end

local function set_sn(s,name,view)
	local t = require"sys.View".Class:new(view);
	t.Name = name;
	views_[s] = t;
end

function init()
	require"sys.mgr.scene.object".init();
	require"sys.mgr.scene.index".init();
	require"sys.mgr.scene.item".init();
	close_all();
	max_ = 0;
	views_ = {};
	sizes_ = {};
end

--[[
-- t={name="",scene=,view=}
function new(t)
	if type(t)~="table" then t = {} end
	local name = t.name;
	if not name then max_=max_+1 name="New-"..max_ end
	sc = new_child(frm,name);
	to_scene(sc,t.scene);
	set_sn(sc,name);
	cur_ = sc;
	return sc;
end
--]]
-- t={name="",scene=,view=}
function new(t)
	if type(t)~="table" then t = {} end
	local name = t.name or t.view and t.view.Name;
	if not name then max_=max_+1 name="New-"..max_ end
	sc = new_child(frm,name);
	to_scene(sc,t.scene);
	set_sn(sc,name,t.view);
	cur_ = sc;
	return sc;
end

-- return {sc1,sc2,...}
-- t={name=""}
function find(t)
	if type(t)~="table" then t = {} end
	local scs = {};
	for k,v in pairs(views_) do
		if v.Name==t.name then table.insert(scs,k) end
	end
	return scs;
end

-- t={name=""}
-- function get(t)
	-- if type(t)~="table" then t = {} end
	-- local scs = find(t);
	-- if scs[1] then return scs[1] end
	-- return new(t);
-- end

function get_view(sc)
	return views_[sc];
end

function set_current(sc)
	cur_ = sc or cur_ or nil;
	views_[cur_] = views_[cur_] or {};
	return cur_;
end

function get_current()
	return cur_;
end

function close(sc)
	sc = sc or cur_;
	if not sc then return end
	require"sys.mgr.scene.object".clear(sc);
	scene_close(sc);
	views_[sc] = nil;
	sizes_[sc] = nil;
	cur_ = nil;
end

function close_s(s)
	for k,v in pairs(s) do
		close(k);
	end
end

function close_all()
	close_s(views_);
end

function get_all()
	return views_;
end

function scene_to(src,dst)
	if not src then return dst end;
	dst = dst or {};
	dst.clip = dst.clip or {};
	dst.clip.pt = dst.clip.pt or {};
	dst.clip.pt.x = src.clip.pt.x;
	dst.clip.pt.y = src.clip.pt.y;
	dst.clip.pt.z = src.clip.pt.z;
	dst.clip.x = dst.clip.x or {};
	dst.clip.x.x = src.clip.x.x;
	dst.clip.x.y = src.clip.x.y;
	dst.clip.x.z = src.clip.x.z;
	dst.clip.z = dst.clip.z or {};
	dst.clip.z.x = src.clip.z.x;
	dst.clip.z.y = src.clip.z.y;
	dst.clip.z.z = src.clip.z.z;
	dst.rotate = dst.rotate or {};
	dst.rotate.x = src.rotate.x;
	dst.rotate.y = src.rotate.y;
	dst.rotate.z = src.rotate.z;
	dst.cen = dst.cen or {};
	dst.cen.x = src.cen.x;
	dst.cen.y = src.cen.y;
	dst.cen.z = src.cen.z;
	dst.offset = dst.offset or {};
	dst.offset.x = src.offset.x;
	dst.offset.y = src.offset.y;
	dst.offset.z = src.offset.z;
	dst.scale = src.scale;
	dst.ortho = src.ortho;
	dst.matrix = dst.matrix or {};
	for k,v in pairs(src.matrix) do
		dst.matrix[k]=v;
	end
	return dst;
end

function to_scene(sc,src)
	sc = sc or get_current();
	sc = to_default(sc);
	if not src then return sc end
	set_scene_t(sc,get_scene_t(src));
	return sc;
end

function to_default(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.pt.x = 0;
	t.clip.pt.y = 0;
	t.clip.pt.z = 0;
	t.clip.x.x = 1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = 0;
	t.clip.z.z = 1;
	t.cen.x = 0;
	t.cen.y = 0;
	t.cen.z = 0;
	t.offset.x = 400;
	t.offset.y = 300;
	t.offset.z = 0;
	t.scale = 0.037;
	t.ortho = 0;
	t.rotate.x = nil;
	t.rotate.y = nil;
	t.rotate.z = nil;
	t.matrix = {0.9,-0.2,0.35,0,0.4,0.4,-0.8,0,0,0.9,0.5,0,0,0,0,1};
	set_scene_t(sc,t);
	scene_color(sc, 1/255,95/255,254/255, 1/255,95/255,254/255, 251/255,251/255,254/255, 251/255,251/255,254/255)
	return sc;
end

function to_3d(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = 0;
	t.clip.z.z = 1;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = {0.9,-0.2,0.35,0,0.4,0.4,-0.8,0,0,0.9,0.5,0,0,0,0,1};
	t.ortho = 0;
	set_scene_t(sc,t);
	return sc;
end

function to_top(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = 0;
	t.clip.z.z = 1;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

function to_bottem(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = 0;
	t.clip.z.z = -1;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

function to_front(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = -1;
	t.clip.z.z = 0;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

function to_back(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = -1;
	t.clip.x.y = 0;
	t.clip.x.z = 0;
	t.clip.z.x = 0;
	t.clip.z.y = 1;
	t.clip.z.z = 0;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

function to_left(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 0;
	t.clip.x.y = -1;
	t.clip.x.z = 0;
	t.clip.z.x = -1;
	t.clip.z.y = 0;
	t.clip.z.z = 0;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

function to_right(sc)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.clip.x.x = 0;
	t.clip.x.y = 1;
	t.clip.x.z = 0;
	t.clip.z.x = 1;
	t.clip.z.y = 0;
	t.clip.z.z = 0;
	t.rotate.x = 0;
	t.rotate.y = 0;
	t.rotate.z = 0;
	t.matrix = nil;
	t.ortho = 1;
	set_scene_t(sc,t);
	return sc;
end

---[[
function scale(sc,num)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.scale = num or 0.037;
	set_scene_t(sc,t);
	return sc;
end

function center(sc,pt)
	sc = sc or get_current();
	local t = get_scene_t(sc);
	t.cen.x = pt.x or pt[1] or 0;
	t.cen.y = pt.y or pt[2] or 0;
	t.cen.z = pt.z or pt[3] or 0;
	set_scene_t(sc,t);
	return sc;
end
--]]

function to_fit(sc,ents)
	sc = sc or get_current();
	local function set_scene_fit(sc,cpt,size,cx,cy)
		size = size>=10 and size or 10;
		local t = get_scene_t(sc);
		t.scale = cy/size;
		t.cen.x = cpt.x;
		t.cen.y = cpt.y;
		t.cen.z = cpt.z;
		t.offset.x = cx/2;
		t.offset.y = cy/2;
		set_scene_t(sc,t);
	end
	local box = require"sys.Entity".get_ents_box(ents);
	if type(box)~="table" then return end
	local cpt = box.center;
	local size = box[1]:distance(box[2]);
	-- local cx = 1920;
	-- local cy = 1080;
	local cx = sizes_ and sizes_[sc] and sizes_[sc].cx or 1920;
	local cy = sizes_ and sizes_[sc] and sizes_[sc].cy or 1080;
	set_scene_fit(sc,cpt,size,cx,cy);
end
