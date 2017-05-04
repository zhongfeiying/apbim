_ENV = module(...,ap.adv)

local tab_ = require"sys.api.table";
local obj_ = require"sys.api.object";


local pre_ = nil;
local running_ = nil;
local drag_id_ = 100000000;

local function set_ents_index(arg)
	local i = 50000000;
	if not arg.entity then return end;
	arg.entity.mgrid=i;
	if not arg.entities then return end;
	for k,v in pairs(arg.entities) do
		i=i+1;
		v.mgrid = i;
	end
end

local function drag_add_entity(ent,scene)
	if not ent or not scene then return end;
	local obj = ent:on_object();
	-- obj_.scale_color(obj,2);
	obj.index = ent.mgrid+index();
	obj_.add_drag(obj,scene);
end
local function drag_add_entities(ents,scene)
	if not ents or not scene then return end;
	for k,v in pairs(ents) do
		drag_add_entity(v,scene);
	end
end

local function drag_del_entity(ent,scene)
	if not ent or not scene then return end;
	local obj = ent:on_object();
	-- obj_.scale_color(obj,2);
	obj.index = ent.mgrid+index();
	obj_.del_drag(obj,scene);
end
local function drag_del_entities(ents,scene)
	if not ents or not scene then return end;
	for k,v in pairs(ents) do
		drag_del_entity(v,scene);
	end
end

local function drag_add(arg,scene)
	if not arg or not scene then return end;
	obj_.add_drag(arg.object,scene);
	obj_.add_drags(arg.objects,scene);
	drag_add_entity(arg.entity,scene);
	drag_add_entities(arg.entities,scene);
end

local function drag_del(arg,scene)
	if not arg or not scene then return end;
	obj_.del_drag(arg.object,scene);
	obj_.del_drags(arg.objects,scene);
	drag_del_entity(arg.entity,scene);
	drag_del_entities(arg.entities,scene);
end

----public----
function is_running()
	return running_;
end

function update(scene)
	if not running_ then return end;
	drag_del(pre_,scene);
end

function start(scene)
	running_ = true;
end

function stop(scene)
	if not running_ then return end;
	draw_drag(scene);
	drag_del(pre_,scene);
	pre_ = nil
	running_ = nil;
end

-- t = {
	-- scene = ;
	-- object = ;
	-- objects = ;
	-- entity = ;
	-- entities = ;
-- }
function draw(t)
	if not running_ then return end;
	local sc = t.scene or require"sys.mgr".get_cur_scene();
	set_ents_index(t);
	draw_drag(sc);
	drag_del(pre_,sc);
	drag_add(t,sc);
	draw_drag(sc);
	pre_ = tab_.deepcopy(t);
end

function index()
	return drag_id_;
end
