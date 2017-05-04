_ENV = module(...,ap.adv)

-------------------------------------------------

function update(scene)
	scene_onpaint(scene);
end

function show(obj, scene)
	if not obj or not scene then return end;
	add_obj(frm,obj);
	scene_addobj(scene,obj);	
end

function del(obj,scene)
	if not obj or not scene then return end;
	local id = obj.index;
	scene_delobj(scene,obj);
end

function add_drag(obj, scene)
	if not obj or not scene then return end;
	add_obj(frm,obj);
	scene_adddrag(scene,obj);
end

function add_drags(objs, scene)
	if not objs or not scene then return end;
	for k,v in pairs(objs) do
		add_drag(v,scene);
	end
end

function del_drag(obj, scene)
	if not obj or not scene then return end;
	scene_deldrag(scene,obj);
end

function del_drags(objs, scene)
	if not objs or not scene then return end;
	for k,v in pairs(objs) do
		del_drag(v,scene);
	end
end



local function split_outers_by_surface(obj,sur,tmps)
	if type(sur.surs)~="table" then return end;
	for k,v in pairs(sur.surs) do
		local tmp = require"sys.table".deepcopy(v);
		table.insert(tmps,tmp);
	end
end

function split_outers(obj)
	local tmps = {};
	for k,v in pairs(obj.surfaces) do
		split_outers_by_surface(obj,v,tmps);
	end
	for k,v in pairs(tmps) do
		table.insert(obj.surfaces,v);
	end
	for k,v in pairs(obj.surfaces) do
		if v.surs then obj.surfaces[k] = nil end;
	end
end

