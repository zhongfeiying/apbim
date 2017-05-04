_ENV = module(...,ap.adv)

local gl_ = require "luaext.gl"

local objs_ = {};--{index=makelist(sc,obj),...};
local sc2objs_ = {};--{sc={obj.index=true,...},...}

function init()
	clear_all();
	sc2objs_ = {};
end

function set(obj)
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	if type(obj)~="table" then return end
	if type(obj.index)~="number" then return end
	if objs_[obj.index] then gl_.glDeleteLists(objs_[obj.index],1) end
	objs_[obj.index] = makelist(sc,obj);
end

function add(sc,obj)
	if not sc then return end
	if type(obj)~="table" then return end
	if type(obj.index)~="number" then return end
	if not objs_[obj.index] then set(obj) end
	sc2objs_[sc] = sc2objs_[sc] or {};
	sc2objs_[sc][obj.index] = true;
end

function del(sc,obj)
	if not sc then return end
	if type(obj)~="table" then return end
	if type(obj.index)~="number" then return end
	if type(sc2objs_[sc])~="table" then return end
	sc2objs_[sc][obj.index] = nil;
end

function clear(sc)
	if not sc then return end
	if type(sc2objs_[sc])~="table" then return end
	sc2objs_[sc] = nil;
end

function clear_all()
	for k,v in pairs(objs_) do
		gl_.glDeleteLists(v,1);
	end
	objs_ = {};
	sc2objs_ = {};
end

local on_draw_progress_ = nil;
function begin_progress()
	on_draw_progress_ = true;
end
local function on_draw_lock(sc)
	if not sc then return end
	local ents = require"sys.table".deepcopy(sc2objs_[sc]);
	if type(ents)~="table" then return end
	local stime,ptime = os.clock(),0;
	local function run()end
	if on_draw_progress_ then run=require"sys.progress".create{title="Ready ... ",count=require"sys.table".count(ents),time=0.1,msg=false,dlg=false,update=false} end
	for k,v in pairs(ents) do
		v = objs_[k];
		gl_.glLoadName(k)
		gl_.glCallList(v)
		run();
	end
end

local on_draw_doing_ = nil;
local on_draw_again_ = 0;
function on_draw(sc)
	-- on_draw_lock(sc)
	-- on_draw_progress_ = nil;
	on_draw_again_=on_draw_again_+1 
	if on_draw_doing_ then return end
	on_draw_doing_ = true
	while on_draw_again_>0 do
		on_draw_again_ = on_draw_again_-1
		on_draw_lock(sc) 
	end
	on_draw_doing_,on_draw_progress_,on_draw_again_ = nil,nil,0
end

