_ENV = module(...,ap.adv)

local gl_ = require "luaext.gl"

local objs_ = {};--{sc={index=makelist(sc,obj),...},...}

function init()
	clear_all();
	objs_ = {};
end

function add(sc,obj)
	if not sc then return end
	if type(obj)~="table" then return end
	if type(obj.index)~="number" then return end
	local id = obj.index;
	objs_[sc] = objs_[sc] or {};
	if objs_[sc][id] then gl_.glDeleteLists(objs_[sc][id],1) end
	objs_[sc][id] = makelist(sc,obj);
end

function del(sc,obj)
	if not sc then return end
	if type(obj)~="table" then return end
	if type(obj.index)~="number" then return end
	local id = obj.index;
	objs_[sc] = objs_[sc] or {};
	if objs_[sc][id] then gl_.glDeleteLists(objs_[sc][id],1) end
	objs_[sc][id] = nil;
end

function clear(sc)
	if not sc then return end
	if type(objs_[sc])~="table" then return end
	for k,v in pairs(objs_[sc]) do
		gl_.glDeleteLists(v,1);
	end
	objs_[sc] = nil;
end

function clear_all()
	for k,v in pairs(objs_) do
		clear(k);
	end
	objs_ = {};
end

local on_draw_progress_ = nil;
function begin_progress()
	on_draw_progress_ = true;
end

---[[
local function on_draw_lock(sc)
	if not sc then return end
	if type(objs_[sc])~="table" then return end
	local ents = require"sys.table".deepcopy(objs_[sc]);
	local function run()end
	if on_draw_progress_ then run=require"sys.progress".create{title="Ready ... ",count=require"sys.table".count(ents),time=0.1,msg=false,dlg=false,update=false} end
	for k,v in pairs(ents) do
		gl_.glLoadName(k)
		gl_.glCallList(v)
		run();
	end
end

local on_draw_doing_ = nil;
local on_draw_again_ = 0;
function on_draw(sc)
	on_draw_again_=on_draw_again_+1 
	if on_draw_doing_ then return end
	on_draw_doing_ = true
	while on_draw_again_>0 do
		on_draw_again_ = on_draw_again_-1
		on_draw_lock(sc) 
	end
	on_draw_doing_,on_draw_progress_,on_draw_again_ = nil,nil,0
end
--]]

