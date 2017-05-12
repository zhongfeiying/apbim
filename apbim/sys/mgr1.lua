_ENV = module(...,ap.adv)

local tab_ = require"sys.api.table"

-- local md_ = require"sys.mgr.model.db";
local md_ = require"sys.mgr.model";
local draw_ = require"sys.mgr.draw";
local scene_ = require"sys.mgr.scene";
local select_ = require"sys.mgr.select";

function get_zip_model() return 'Model\\'; end 
function get_zip_index() return '__index'; end 
function get_zip_exname() return '.apc'; end 
function get_db_exname() return '.lua'; end 
function get_db_path() return 'DB/'; end 
function get_db_key() return 'db'; end 



function init()
	md_.init();
	-- draw_.init();
	scene_.init();
	select_.init();
end

-----------------------------

function add(ent)
	if type(ent)~="table" then return end
	return md_.add_item(ent);
	-- draw(ent,sc);
	-- update(sc)
end

function push(ent)
	if type(ent)~="table" then return end
	md_.push_item(ent);
	-- draw(ent,sc);
	-- update(sc)
end

function del(ent)
	if type(ent)~="table" then return end
	select(ent,nil);
	if type(ent.del)=="function" then return ent:del() end
end

function copy(ent)
	if type(ent)~="table" then return end
	select(ent,nil);
	if type(ent.copy)=="function" then return ent:copy() end
end

-- function del(ent)
	-- if type(ent)~="table" then return end
	-- md_.del(ent);
-- end

-- function modified(ent)
	-- if type(ent)~="table" then return end
	-- md_.modified(ent);
-- end

-----------------------------

function get_table(k,v)
	return md_.get_item(k,v);
end

function get_item(k,v)
	return md_.get_item(k,v);
end

function get_all()
	return md_.get_undeleted();
end

function get_scene_all(sc)
	sc = sc or get_cur_scene();
	if not sc then return nil end
	return require"sys.mgr.scene.item".get_sc_id_ks(sc);
end

function get_class_all(class)
	local all = require"sys.mgr".get_all();
	if type(all)~="table" then return end
	local ts = {};
	for k,v in pairs(all) do
		if class:is_classname(v) then
			v = require"sys.mgr".get_table(k,v);
			if not v:is_deleted() then
				ts[k]=v;
			end
		end
	end
	return ts;
end

-- function get_unsaved()
	-- return md_.get_unsaved();
-- end

-- function get_uncommitted()
	-- return md_.get_uncommitted();
-- end

-- function get_modified()
	-- return md_.get_modified();
-- end

-----------------------------


function hide(ent,sc)
	if type(ent)~="table" then return end
	if type(ent.mgrid)~="string" then return end
	sc = sc or scene_.get_current();
	if not sc then return end;
	-- select(ent,nil);
	draw_.del(ent,sc);
end

function draw(ent,sc)
	if type(ent)~="table" then return end
	if type(ent.mgrid)~="string" then return end
	-- if type(ent.on_draw)~="function" then return end
	sc = sc or scene_.get_current();
	if not sc then return end;
	draw_.set(ent,is_light(ent),sc);
end

function redraw(ent,sc)
	if type(ent)~="table" then return end
	if type(ent.mgrid)~="string" then return end
	-- if type(ent.on_draw)~="function" then return end
	if sc then return draw(ent) end;
	draw_.reset(ent,is_light(ent));
end

function draw_s(ents,sc)
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = get_table(k,v);
		draw(v,sc);
		run();
	end
end

function draw_all(sc)
	local ents = get_all();
	draw_s(ents,sc);
end

-----------------------------

function update(sc)
	sc = sc or scene_.get_current();
	if not sc then return end
	scene_onpaint(sc);
end

function light_on()
	set_lighting(true);
end

function light_off()
	set_lighting(false);
end
-----------------------------

function get_view(sc)
	sc = sc or scene_.get_current();
	if not sc then return end
	return scene_.get_view(sc);
end

function get_scene_size(sc)
	sc = sc or scene_.get_current(sc);
	return scene_.get_size(sc);
end

-- t={name=,scene=};
function new_scene(t)
	local sc = scene_.new(t);
	set_cur_scene(sc);
	return sc;
end

function set_cur_scene(sc)
	return scene_.set_current(sc);
end

function get_cur_scene()
	return scene_.get_current();
end

function set_active_scene(sc)
	-- set_cur_scene(sc)
	active_scene(sc)
	set_cur_scene(sc)
end
-- t=scene/{scene=,name=}
function close_scene(t)
	if type(t)=="number" then scene_.close(t) return end
	if type(t)~="table" then return end
	if t.scene then scene_.close(t.scene) end;
	for i,v in ipairs(find_scene{name=t.name}) do 
		scene_.close(v);
	end
end

-- return {sc=name,...}
function get_all_scene()
	return scene_.get_all();
end

-- return {sc1,sc2...}
-- t={name=""}
function find_scene(t)
	return scene_.find(t);
end

-- t={scene=,ents=,update=true}
function scene_to_fit(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	require"sys.mgr.scene".to_fit(t.scene,t.ents);
	if t.update then update(t.scene) end
end


-- t={scene=,update=true}
function scene_to_default(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_default(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_3d(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_3d(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_top(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_top(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_bottom(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_bottem(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_front(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_front(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_back(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_back(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_left(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_left(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,update=true}
function scene_to_right(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.to_right(t.scene);
	if t.update then update(t.scene) end
end

-- t={scene=,scale=,update=true}
function scene_scale(t)
	t = t or {};
	t.scene = t.scene or scene_.get_current();
	scene_.scale(t.scene,t.scale);
	if t.update then update(t.scene) end
end

-----------------------------

function cur()
	return select_.cur();
end

function curs()
	return select_.curs();
end

function is_light(ent)
	return select_.get(ent) and true or false;
end

function select(ent,light)
	select_.set(ent,light);
	-- draw(ent,sc);
end

function get_scene_selection(sc)
	sc = sc or get_cur_scene();
	local ids = get_scene_all(sc);
	if type(ids)~="table" then return {} end
	local sels = curs();
	if type(sels)~="table" then return {} end
	local ents = {};
	for k,v in pairs(ids) do
		if sels[k] then ents[k]=true end
	end
	return ents;
end

-- t={scene=,redraw=true}
function select_all(t)
	local ents = get_scene_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Select",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = get_table(k);
		if type(v)=="table" and not is_light(v) then
			select(v,true);
			-- if t.redraw then redraw(v,t.scene) end
			if t.redraw then redraw(v) end
		end
		run();
	end
end

-- t={scene=,redraw=true}
function select_none(t)
	local ents = curs();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Select",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = get_table(k);
		if type(v)=="table" and is_light(v) then
			select(v,nil);
			-- if t.redraw then redraw(v,t.scene) end
			if t.redraw then redraw(v) end
		end
		run();
	end
end

-- t={scene=,redraw=true}
function select_reverse(t)
	local ents = get_scene_all();
	if type(ents)~="table" then return end
	local run = require"sys.progress".create{title="Select",count=require"sys.api.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = get_table(k);
		if type(v)=="table" then
			if is_light(v) then
				select(v,nil);
			else 
				select(v,true);
			end
			-- if t.redraw then redraw(v,t.scene) end
			if t.redraw then redraw(v) end
		end
		run();
	end
end

function copy_curs()
	local news = {};
	local olds = curs();
	if type(olds)~="table" then return end
	for k,v in pairs(olds) do
		if type(v.copy)=="function" then table.insert(news,v:copy()) end
		select(v,nil);
		redraw(v);
	end
	for k,v in pairs(news) do
		v.mgrid=nil;
		add(v);
		select(v,true);
		draw(v);
	end
end

function del_curs()
	local olds = curs();
	if type(olds)~="table" then return end
	for k,v in pairs(olds) do
		if type(v.del)=="function" then v:del()	end
		select(v,nil);
		redraw(v);
	end
end

-----------------------------

function get_user()
	return require"sys.interface.login_dlg".get_user() or "";
end

-----------------------------

function set_model_id(str)
	-- require"sys.mgr.model".set_id(str);
	require"sys.mgr.model".get():set_id(str);
end

function get_model_id()
	-- return require"sys.mgr.model".get_id();
	return require"sys.mgr.model".get():get_id();
end

function set_model_name(str)
	-- require"sys.mgr.model".set_name(str);
	require"sys.mgr.model".get():set_name(str);
end

function get_model_name()
	-- return require"sys.mgr.model".get_name();
	return require"sys.mgr.model".get():get_name();
end

function set_zip_name(str)
	require'sys.mgr.zip'.set_name(str);
end

function get_zip_name() 
	return require'sys.mgr.zip'.get_name(str);
end

function set_zip_path(str)
	require'sys.mgr.zip'.set_path(str);
end

function get_zip_path() 
	return require'sys.mgr.zip'.get_path(str);
end

function get_zip_file() 
	return require'sys.mgr.zip'.get_file(str);
end


function import_file(str)
	require"sys.mgr.model.loop".import_file(str);
end

function import_folder(str)
	require"sys.mgr.model.index".import_folder(str);
end

function import_group(str)
	require"sys.mgr.model".import_group(str);
end

function open_group(gid,cbf)
	require"sys.mgr.model".open_group(gid,cbf);
end

function open(arg)
	-- init();
	-- require"sys.mgr.model.index".open_folder(str);
	require"sys.mgr.model".open();
end

function save(arg)
	-- require"sys.mgr.model.index".save_folder(str);
	require"sys.mgr.model".save();
end

function model_commit(arg)
	require"sys.mgr.model".commit();
end

function model_update(arg)
	-- require"sys.mgr.model.index".save_folder(str);
	require"sys.mgr.model".update();
end

function upload(arg)
	require"sys.mgr.model".upload(arg);
end

function download(arg)
	require"sys.mgr.model".download(arg);
end

-----------------------------

-- function import_apt_file(arg)
	-- local ents = require'sys.io'.read_file{file=arg};
	-- if type(ents)~='table' then return end
	-- local all = get_all();
	-- local dxs = {};
	-- local run = require"sys.progress".create{title="Import APT File ",count=require"sys.table".count(ents),time=0.1,update=false,statusbar=false};
	-- for k,v in pairs(ents) do
		-- if type(v)=='table' and v.Index then
			-- if not dxs[v.Index] then dxs[v.Index] = require'sys.table'.index(all,function(k,t) return t[v.Index] end) end
			-- if type(all[dxs[v.Index][k]])=='table' then all[dxs[v.Index][k]].Shape = v.Shape else add(require'sys.Entity'.Class:new(v)) end
		-- end
	-- end
-- end

-----------------------------

function show_property(sc)
	if type(cur())~="table" then return end
	require"sys.interface.info_dlg".popup{scene=sc,src=cur(),dst=get_scene_selection()};
end

function edit_property(sc)
	if type(cur())~="table" then return end
	if type(cur().on_edit)~="function" then show_property(sc) return end
	cur():on_edit(sc);
end
 
-----------------------------

function start(file)
require"sys.table".totrace{file=file};
	dofile(file);
	-- file = string.sub(file,1,-5)
	-- require(file)

	-- require'apx.dxf.io'.Read{file=file,index='tekla_id'};
	-- local f=io.open(file,'r');
	-- if not f then return end
	-- local str = f:read('*all');
	-- f:close();
	-- local f = load(str,'sys.mgr.start','bt');
	-- if type(f)~="function" then require"sys.str".totrace("sys.net.msg.rcv(), load msg error:\n"..t.Code.."\n") return end
	-- local result = f();
end

