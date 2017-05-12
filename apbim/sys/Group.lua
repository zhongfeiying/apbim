_ENV = module(...,ap.adv)

Class = {
	Classname = "sys/Group";
	-- mgrids = {[gid]=true,...};
};
require"sys.View".Class:met(Class);

------------------------------

function Class:add_id(id)
	if not id then return nil end
	if type(self)~="table" then return nil end
	if self.mgrid==id then return nil end
	if type(self.mgrids)~="table" then self.mgrids={} end
	-- if self.mgrids[id] then return self end
	self.mgrids[id] = require'sys.mgr.version'.get_hid(id) or true;
	self:modify()
	return self;
end

function Class:del_id(id)
	if not id then return nil end
	if type(self)~="table" then return nil end
	if type(self.mgrids)~="table" then self.mgrids={} self:modify() end
	if self.mgrids[id] then self.mgrids[id]=nil self:modify() end
	return self;
end

function Class:get_count()
	if type(self)~="table" then return nil end
	if type(self.mgrids)~="table" then return 0 end
	return require"sys.table".count(self.mgrids);
end

function Class:get_ids()
	if type(self)~="table" then return nil end
	if type(self.mgrids)~="table" then return {} end
	return self.mgrids;
end



----

function Class:add_curs()
	local ents = require"sys.mgr".curs();
	if type(ents)~="table" then return self end
	for k,v in pairs(ents) do
		self:add_id(k);
	end
	self:modify();
	return self;
end

function Class:add_scene_all()
	local ents = require"sys.mgr".get_scene_all();
	if type(ents)~="table" then return self end
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		self:add_id(k);
	end
	self:modify();
	return self;
end

function Class:add_model_all()
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return self end
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if require'sys.Entity'.Class:is_class(v) then self:add_id(k) end
	end
	self:modify();
	return self;
end

------------------------------




--t={group=,cbf=,arg=}
function loop(t)
	if type(t.group)~="table" then return end
	-- if not self.mgrid then return end
	if not Class:is_class(t.group) then return end
	local repeat_list = t.repeat_list or {};
	if t.group:check_repeat{list=repeat_list,id=t.group.mgrid} then return end
	
	if type(t.cbf)~="function" then return end
	if type(t.group)~="table" then return end
	if type(t.group.mgrids)~="table" then return end
	local run = require"sys.progress".create{title="Loop Group",count=require"sys.table".count(t.group.mgrids),time=0.1};
	for k,v in pairs(t.group.mgrids) do
		v = require"sys.mgr".get_table(k,v);
-- require'sys.str'.totrace(k);
		if v and not v:is_deleted() and not t.group:check_repeat{list=repeat_list,id=v.mgrid} then
			if Class:is_class(v) then 
				loop{group=v,cbf=t.cbf,arg=t.arg,repeat_list=repeat_list};
			end
			t.cbf(v,t.arg);
		end
		-- loop_group_item(k,v,t.cbf,t.arg);
		run();
	end
	-- t.cbf(self,t.arg);
end


function draw(gp,sc)
	require"sys.Group".loop{group=gp,cbf=function(it)require"sys.mgr".draw(it,sc)end};
end


------------------------------

function Class:select_marks(light)
	if type(self.Marks)~="table" then return end
	for k,v in pairs(self.Marks) do
		v = require'sys.mgr'.get_table(k,v);
		require'sys.mgr'.select(v,light);
		require'sys.mgr'.redraw(v);
	end
end

-- t={scene=}
function Class:show(t)
	if type(t)~="table" then t={} end
	local sc = t.scene or require"sys.mgr".get_cur_scene() or require"sys.mgr".new_scene{name=t.name};
	draw(self,sc);
	-- self:select_entities{light=true,redraw=true};
	local sct = get_scene_t(sc);
	require"sys.mgr.scene".scene_to(self.scene_data,sct);
	require'sys.mgr'.select_none{redraw=true};
	set_scene_t(sc,sct);
	self:select_marks(true);
	require"sys.mgr".update(sc);
end

-- t={name=}
function Class:open(t)
	if type(t)~="table" then t={} end
	local name = t.name or self.Name;
	require"sys.mgr".close_scene{name=name};
	local sc = require"sys.mgr".new_scene{name=name,view=self};
	self:show{scene=sc,name=t.name};
end
--]]

function get_view(t)
	t = t or {}
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	local smd = require"sys.Group".Class:new();
	smd:set_name(t.Name);
	smd:set_scene(sc);
	smd:set_marks(sc);
	smd:set_states(sc);
	smd:add_scene_all();
	require"sys.mgr".add(smd);
	return smd
end
function Class:set_view(sc)
	local sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return end
	-- local smd = require"sys.Group".Class:new();
	-- self:set_name(t.Name);
	self:set_scene(sc);
	self:set_marks(sc);
	self:set_states(sc);
	self:add_scene_all();
	-- require"sys.mgr".add(smd);
	return self
end

function open_group_by_str(str) 
	str=str or 'nil';
	str='return '..str;
	local id=require'sys.mgr'.add(require'sys.str'.toifo{str=str}); 
	local item=require'sys.mgr'.get_table(id); 
	if not require'sys.Group'.Class:is_class(item) then return end
	item:open() 
end

-------------------------------------------------------------------------------------


--t={}
function Class:commit(t)
	if not require'sys.Item'.Class.commit(self,t) then return end

	local run,close = require"sys.progress".create{title="Commit Group",count=require"sys.table".count(self:get_ids())+1,time=0.1};
	for k,v in pairs(self:get_ids()) do
		local it = require'sys.mgr.db'.get_item(k,v);
		if require'sys.Item'.Class:is_class(it) then it:commit{repeat_list=repeat_list}; end
		run();
	end
	-- require'sys.mgr.db'.push_item(self)
	close()
	return true;
end

--t={}
function Class:update(t)
	if not require'sys.Item'.Class.update(self,t) then return end

	local run,close = require"sys.progress".create{title="Update Group",count=require"sys.table".count(self:get_ids())+1,time=0.1};
	for k,v in pairs(self:get_ids()) do
		local it = require'sys.mgr'.get_item(k,v);
		if require'sys.Item'.Class:is_class(it) then it:commit{repeat_list=repeat_list}; end
		run();
	end
	-- require'sys.mgr.db'.push_item(self)
	close()
	return true;
end

--t={archive=}
function Class:save(t)
	if not require'sys.Item'.Class.save(self,t) then return end

	local run,close = require"sys.progress".create{title="Save Group",count=require"sys.table".count(self:get_ids())+1,time=0.1};
	for k,v in pairs(self:get_ids()) do
		local it = require'sys.mgr.db'.get_item(k,v);
		if require'sys.Item'.Class:is_class(it) then it:save{archive=t.archive,repeat_list=repeat_list}; end
		run();
	end
	close()
	return true;
end

--t={}
function Class:upload(t)
	if not require'sys.Item'.Class.upload(self,t) then return end

	local run,close = require"sys.progress".create{title="Upload Group",count=require"sys.table".count(self:get_ids())+1,time=0.1};
	for k,v in pairs(self:get_ids()) do
		local it = require'sys.mgr.db'.get_item(k,v);
		if require'sys.Item'.Class:is_class(it) then it:upload{repeat_list=repeat_list}; end
		run();
	end
	-- require'sys.mgr.db'.push_item(self)
	close()
	return true;
end


--t={update=true}
function Class:download(t)
	if not require'sys.Item'.Class.download(self,t) then return end

	local run,close = require"sys.progress".create{title="Download Group",count=require"sys.table".count(self:get_ids())+1,time=0.1};
	for k,v in pairs(self:get_ids()) do
		require'sys.mgr.model'.download_item{
			update = t.update;
			gid = k;
			hid = v;
			cbf = function(hid)
				if not hid then return end
				local it = require'sys.io'.read_file{file=require'sys.mgr'.get_db_path()..hid..require'sys.mgr'.get_db_exname()}
				it = require'sys.mgr.ifo'.new(it);
				if require'sys.Item'.Class:is_class(it) then it:download{update=t.update;repeat_list=repeat_list} end
			end
		};
		run();
	end
	-- require'sys.mgr.model'.push_item(self);
	close()
	return true;
end
