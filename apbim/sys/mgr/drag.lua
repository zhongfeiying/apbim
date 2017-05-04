_ENV = module(...,ap.adv)

local gl_ = require"luaext.gl";
local shirr_index_ = 65536*65536/4;

local objs_ = {};
local start_ = nil;

local function add(sc,obj)
	objs_[obj.index] = makelist(sc,obj);
end

local function clear()
	for k,v in pairs(objs_) do
		gl_.glDeleteLists(v);
	end
	objs_ = {};
end

function get_shirr_index()
	shirr_index_ = shirr_index_+1;
	return shirr_index_;
end

function is_running()
	return start_ and true or false;
end

function on_draw(sc)
	if not is_running() then return end;
	for k,v in pairs(objs_) do
		gl_.glCallList(v);
	end
end

function update(sc)
	if not is_running() then return end;
	clear();
end

function start(sc)
	clear();
	start_  = true;
end

function stop(sc)
	if not is_running() then return end;
	draw_drag(sc);
	clear();
	start_ = nil;
end

function draw(sc,obj)
	if not is_running() then return end;
	draw_drag(sc);
	clear();
	add(sc,obj);
	draw_drag(sc)
end
