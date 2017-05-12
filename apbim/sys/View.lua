_ENV = module(...,ap.adv)

Class = {
	Classname = "sys/View";
	-- Name = "";
	-- Remark = "";
	-- scene_data = ;
	-- States = {[gid]={Mode="Rendering",Color={r=255,g=255,b=255}},...};
	-- Marks = {[gid]=true,...};
};
require"sys.Item".Class:met(Class);

-----------------------------------------------------------

function Class:set_name(name)
	self.Name = name;
	self:modify();
	return self;
end

function Class:get_name()
	return self.Name;
end

function Class:set_scene(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	self.scene_data = require"sys.mgr.scene".scene_to(get_scene_t(sc));
	self:modify();
	return self;
end

function Class:set_states(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	local view = require"sys.mgr.scene".get_view(sc);
	self.States = require'sys.table'.deepcopy(view.States);
	-- if type(view.States)~="table" then return self end
	-- for k,v in pairs(view.States) do
		-- self:add_state(require'sys.table'.deepcopy(v));
	-- end
	self:modify();
	return self;
end


function Class:add_mark(id)
	if not id then return nil end
	if type(self)~="table" then return nil end
	if self.mgrid==id then return nil end
	if type(self.Marks)~="table" then self.Marks={} end
	if self.Marks[id] then return self end
	self.Marks[id] = true;
	self:modify()
	return self;
end

function Class:set_marks(sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	local ents = require"sys.mgr".get_scene_selection(sc);
	if type(ents)~="table" then return self end
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		self:add_mark(k);
	end
	self:modify()
	return self;
end

-----------------------------------------------------------

function Class:add_state(id)
	if not id then return nil end
	if type(self)~="table" then return nil end
	if type(self.States)~="table" then self.States={} self:modify() end
	if type(self.States[id])~="table" then self.States[id]={} self:modify() end
	return self;
end

function Class:del_state(id)
	if not id then return nil end
	if type(self)~="table" then return nil end
	if type(self.States)~="table" then self.States={} self:modify() end
	if self.States[id] then self.States[id]=nil self:modify() end
	return self;
end

function Class:get_state(id)
	if type(self)~="table" then return nil end
	if type(self.States)~="table" then return nil end
	return self.States[id];
end

-----------------------------------------------------------

function Class:set_mode(id,mode)
	self:add_state(id);
	self.States[id].Mode = mode;
	return self;
end

function Class:get_mode(id)
	self:add_state(id);
	return  self.States[id].Mode;
end

function set_mode(sc,id,mode)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.set_mode)=="function" and view:set_mode(id,mode) -- or require"sys.Entity".Class.set_mode(require"sys.mgr".get_table(id),mode);
end

function get_mode(sc,id)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.get_mode)=="function" and view:get_mode(id) -- or require"sys.Entity".Class.get_mode(require"sys.mgr".get_table(id));
end

-----------------------------------------------------------
--[[
function Class:set_hidden(id,hidden)
	self:add_state(id);
	self.States[id].Hidden = hidden;
	return self;
end

function Class:get_hidden(id)
	self:add_state(id);
	return  self.States[id].Hidden;
end

function set_hidden(sc,id,hidden)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.set_hidden)=="function" and view:set_hidden(id,hidden)
end

function get_hidden(sc,id)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.get_hidden)=="function" and view:get_hidden(id);
end
--]]
-----------------------------------------------------------

function Class:set_color(id,color)
	self:add_state(id);
	self.States[id].Color = color;
	return self;
end

function Class:get_color(id)
	self:add_state(id);
	return self.States[id].Color;
end

function set_color(sc,id,color)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.set_color)=="function" and view:set_color(id,color);
end

function get_color(sc,id)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and type(view.get_color)=="function" and view:get_color(id);
end

-----------------------------------------------------------

--[[
function Class:set_hide(id,hide)
	if type(self)~="table" then return nil end
	if type(self.States)~="table" then self.States={} end
	if type(self.States[id])~="table" then self.States[id]={} end
	self.States[id].Hide = hide;
	return self;
end

function Class:get_hide(id)
	if type(self)~="table" then return nil end
	if type(self.States)~="table" then return nil end
	if type(self.States[id])~="table" then return nil end
	return  self.States[id].Hide;
end

function set_hide(sc,id,hide)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and view:set_hide(id,hide) or require"sys.Entity".Class.set_hide(require"sys.mgr".get_table(id),hide);
end

function get_hide(sc,id)
	local view = require"sys.mgr.scene".get_view(sc);
	return type(view)=="table" and view:get_hide(id) or require"sys.Entity".Class.get_hide(require"sys.mgr".get_table(id));
end
--]]

-- t={ents=,scene=,name=}
function new_view(t)
	t = t or {};
	local ents = t.ents;
	local old_sc = t.scene;
	local name = t.name;
	old_sc = old_sc or require'sys.mgr'.get_cur_scene();
	local new_sc = require"sys.mgr".new_scene{scene=old_sc,name=name};
	-- require"sys.mgr".get_view(new_sc):set_states(old_sc);
	for k,v in pairs(ents) do
		v = require'sys.mgr'.get_table(k,v)
		require"sys.mgr".get_view(new_sc):add_state(k);
		require"sys.mgr".get_view(new_sc).States[k] = require'sys.table'.deepcopy(require"sys.mgr".get_view(old_sc):get_state(k));
		require"sys.mgr".draw(v,new_sc);
	end
	-- require"sys.mgr".update(new_sc);
	return new_sc;
end
