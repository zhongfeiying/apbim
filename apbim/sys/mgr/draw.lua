_ENV = module(...,ap.adv)


-- local max_index_ = 0;
-- local e2o_ = {};--
-- local o2e_ = {};

-- function init()
	-- max_index_ = 0;
	-- e2o_ = {};
	-- o2e_ = {};
-- end

---------------------------------------------

local function add_obj(frm,obj)
	-- require"sys.mgr.scene.object".set(obj);
end

local function scene_addobj(sc,obj)
	require"sys.mgr.scene.object".add(sc,obj);
end

local function scene_delobj(sc,obj)
	require"sys.mgr.scene.object".del(sc,obj);
end


---------------------------------------------

-- function get_objid(eid)
	-- if e2o_[eid] then return e2o_[eid] end
	-- max_index_ = max_index_ +1;
	-- e2o_[eid] = max_index_;
	-- o2e_[max_index_] = eid;
	-- return max_index_;
-- end

-- function get_mgrid(oid)
	-- return o2e_[oid];
-- end

---------------------------------------------

local dark_ceo_ = 0.5; --coefficient
local body_light_ = {1,1,1};
local side_light_ = {0,0,1};
local side_dark_ = {0.1,0.1,0.1};
local get_object_by_mode_ = {};

get_object_by_mode_.Diagram = function(ent,light,sc)
	local diagram = require"sys.Entity".Class.get_shape_diagram(ent);
	if type(diagram)~="table" then return end
	local obj = require"sys.api.table".deepcopy(diagram);
	
	local cr = require"sys.View".get_color(sc,ent.mgrid);
	if type(cr)=="table" then require"sys.api.shape".color_to(obj,require"sys.geometry".Color:new(cr):get_gl()) end
	-- require"sys.api.shape".color_scale(obj,dark_ceo_);
	if light then require"sys.api.shape".color_to(obj,body_light_) require"sys.api.shape".text_color_to(obj,body_light_) end
	return obj;
end

get_object_by_mode_.Wireframe = function(ent,light,sc)
	local wireframe = require"sys.Entity".Class.get_shape_wireframe(ent);
	if type(wireframe)~="table" then return get_object_by_mode_.Diagram(ent,light) end
	local obj = require"sys.api.table".deepcopy(wireframe);
	
	local cr = require"sys.View".get_color(sc,ent.mgrid);
	if type(cr)=="table" then require"sys.api.shape".color_to(obj,require"sys.geometry".Color:new(cr):get_gl()) end
	-- require"sys.api.shape".color_scale(obj,dark_ceo_);
	if light then require"sys.api.shape".color_to(obj,body_light_) end
	return obj;
end

get_object_by_mode_.Rendering = function(ent,light,sc)
	local rendering = require"sys.Entity".Class.get_shape_rendering(ent);
	if type(rendering)~="table" then return get_object_by_mode_.Diagram(ent,light) end
	local body = require"sys.api.table".deepcopy(rendering);

	local cr = require"sys.View".get_color(sc,ent.mgrid);
	if type(cr)=="table" then require"sys.api.shape".color_to(body,require"sys.geometry".Color:new(cr):get_gl()) end
	-- require"sys.api.shape".color_scale(body,dark_ceo_);
	if light then require"sys.api.shape".color_to(body,body_light_) end

	local wireframe = require"sys.Entity".Class.get_shape_wireframe(ent);
	if type(wireframe)~="table" then wireframe=require"sys.Entity".Class.get_shape_wireframe(ent) end
	if type(wireframe)~="table" then return body end
	local side = require"sys.api.table".deepcopy(wireframe);
	
	if light then require"sys.api.shape".color_to(side,side_light_) else require"sys.api.shape".color_to(side,side_dark_) end
	return require"sys.api.shape".merge{body,side};
end

--[[
local function get_text_obj(ent,light)
	local text = require"sys.Entity".Class.get_shape_text(ent);
	
	if type(text)~="table" then return nil end
	local obj = require"sys.api.table".deepcopy(text);
	if light then require"sys.api.shape".text_color_to(obj,side_dark_) end
	return obj;
end
--]]

local function get_text_obj(ent,light)
	local cr = require"sys.Entity".Class.get_color_gl(ent);
	local pt = type(ent.get_foucs_pt)=="function" and ent:get_foucs_pt() or require"sys.Entity".Class.get_foucs_pt(ent);
	if type(pt)~="table" then return {surfaces={}} end
	local obj = {
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x,pt.y,pt.z};
				};
				texts = {
					{ptno=1,r=cr.r,g=cr.g,b=cr.b,str="123456"};
				};
			};
		};
	};
	local text = require"sys.Entity".Class.get_info_text(ent);
	local show = require"sys.Entity".Class.get_info_show(ent);
	local str = "";
	for k,v in pairs(show) do
		if v and text[k] then str = str..k..'='..text[k]..';' end
	end
	obj.surfaces[1].texts[1].str = str;
	if light then require"sys.api.shape".text_color_to(obj,body_light_) end
	return obj;
end

local function get_object(ent,light,sc)
	-- if ent.hide then return end
	-- if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw(ent): ent.mgrid isn't a string\n") return end
	-- local view = require"sys.mgr.scene".get_view(sc);
	-- local mode = type(view)=="table" and view:get_mode(ent.mgrid) or require"sys.Entity".Class.get_mode(ent);
	local mode = require"sys.View".get_mode(sc,ent.mgrid) or require"sys.Entity".Class.get_mode(ent);
	if type(get_object_by_mode_[mode])~="function" then mode = "diagram" end
	local obj = get_object_by_mode_[mode](ent,light,sc);
	-- if require"sys.Entity".Class.is_show_text(ent) then  obj = require"sys.api.shape".merge{obj,get_text_obj(ent,light)}; end
	-- obj = require"sys.api.shape".merge{obj,get_text_obj(ent,light)};
	return obj;
end

local function add(ent,light,sc)
	if not sc then return end;
	if type(ent)~="table" then trace_out("sys.mgr.draw.set(ent,sc): ent isn't a table\n") return end
	if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw.del(ent,sc): ent.mgrid isn't a string\n") return end
	local obj = get_object(ent,light,sc);
	if type(obj)~="table" then return end
	obj.index = require"sys.mgr.scene.index".get_objid(ent.mgrid,sc);
	if type(obj.index)~="number" then return end
	add_obj(frm,obj);
	-- if not sc then return end
	scene_addobj(sc,obj);
	require"sys.mgr.scene.item".add(sc,ent.mgrid);
end

--[[
local function hide(ent,sc)
	if type(ent)~="table" then trace_out("sys.mgr.draw.set(ent,sc): ent isn't a table\n") return end
	if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw.del(ent,sc): ent.mgrid isn't a string\n") return end
	local obj = {}
	obj.index = require"sys.mgr.scene.index".get_objid(ent.mgrid);
	if type(obj.index)~="number" then return end
	add_obj(frm,obj);
	if not sc then return end
	scene_delobj(sc,obj)
	require"sys.mgr.scene.item".del(sc,ent.mgrid);
end
--]]
function del(ent,sc)
	if not sc then return end;
	if type(ent)~="table" then trace_out("sys.mgr.draw.set(ent,sc): ent isn't a table\n") return end
	if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw.del(ent,sc): ent.mgrid isn't a string\n") return end
	local obj = {}
	obj.index = require"sys.mgr.scene.index".get_objid(ent.mgrid,sc);
	if type(obj.index)~="number" then return end
	add_obj(frm,obj);
	-- if not sc then return end
	scene_delobj(sc,obj)
	require"sys.mgr.scene.item".del(sc,ent.mgrid);
end

function set(ent,light,sc)
	if not sc then return end;
	if type(ent)~="table" then trace_out("sys.mgr.draw.set(ent,sc): ent isn't a table\n") return end
	if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw.del(ent,sc): ent.mgrid isn't a string\n") return end
	if require"sys.Item".Class.is_deleted(ent) then
		del(ent,sc);
	elseif require"sys.Entity".Class.is_hidden(ent) then
		-- hide(ent,sc);
		del(ent,sc);
	else
		add(ent,light,sc);
	end
end

function reset(ent,light)
	-- set(ent,light,sc);
	-- require"sys.mgr.scene.item".reset(ent);
	if type(ent)~="table" then trace_out("sys.mgr.draw.reset(ent,sc): ent isn't a table\n") return end
	if type(ent.mgrid)~="string" then trace_out("sys.mgr.draw.del(ent,sc): ent.mgrid isn't a string\n") return end
	local scs = require"sys.mgr.scene.item".get_id_sc_ks(ent.mgrid);
	if type(scs)~="table" then return end
	for k,v in pairs(scs) do
		set(ent,light,k);
	end
end

