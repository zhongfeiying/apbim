--[[
function module_seeall(name)
	local M = {}
	setmetatable(M,{__index=_G})
	_G[name] = M
	package.loaded[name] = M
	return M
end
--]]

function module(name,up)
	local M = {}
	if type(up)=='table' then setmetatable(M,{__index=up}) end
	_G[name] = M
	package.loaded[name] = M
	return M
end

function reload(name)
	package.loaded[name]=nil;
	return require(name);
end

ap = {}
ap.sys = {
	dofile = dofile;
	getmetatable = getmetatable;
	ipairs = ipairs;
	load = load;
	loadfile = loadfile;
	pairs = pairs;
	require = require;
	setmetatable = setmetatable;
	tonumber = tonumber;
	tostring = tostring;
	type = type;
	math = math;
	string = string;
	table = table;
	-- ID = ID;
	frm = frm;
	-- MF_POPUP = MF_POPUP;
	-- MF_SEPARATOR;
	add_dlgtree = add_dlgtree;
	add_menu = add_menu;
	client_2_world = client_2_world;
	draw_drag = draw_drag;
	get_scene_t = get_scene_t;
	is_alt_down = is_alt_down;
	is_ctr_down = is_ctr_down;
	is_shf_down = is_shf_down;
	makelist = makelist;
	new_child = new_child;
	reload = reload;
	scene_close = scene_close;
	scene_color = scene_color;
	scene_cursor = scene_cursor;
	scene_onpaint = scene_onpaint;
	scene_select = scene_select;
	set_scene_t = set_scene_t;
	statusbar_set_parts = statusbar_set_parts;
	statusbar_set_text = statusbar_set_text;
	sub_menu = sub_menu;
	trace_out = trace_out;
	world_2_client = world_2_client;
}
ap.adv = {
	io = io;
	os = os;
}
ap.adv = {}
setmetatable(ap.adv,{__index=_G})

