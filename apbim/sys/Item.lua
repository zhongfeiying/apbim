_ENV = module(...,ap.adv)


Class = {
	Classname = "sys/Item";
	-- Date = os.date("*t");
	-- mgrid = guid();
	-- Saved = true;
	-- Deleted = true;
	-- Type = "Undefined";
};
-- Class.__index = Class;

function Class:get_classname()
	return self.Classname;
end

function Class:is_classname(t)
	if type(t)~="table" then return tostring(t)==self.Classname end
	while(t) do
		if t.Classname==self.Classname then return true end
		t = getmetatable(t);
	end
end

function Class:is_class(t)
	if type(t)~="table" then return nil end
	if type(t.get_classname)~="function" then return nil end
	while(t) do
		if t.Classname==self.Classname then return true end
		t = getmetatable(t);
	end
end

function Class:met(t)
	if self:is_class(t) then return t end
	setmetatable(t,self);
	self.__index = self;
	return t;
end

function Class:new(t)
	t = t or {};
	return self:met(t);
end

---------------------------------------------------

function Class:ask_id()
	if type(self)~="table" then return self end
	-- if type(self.mgrid)~="string" then self.mgrid = string.upper(require"luaext".guid()) end
	if type(self.mgrid)~="string" then self.mgrid = require"sys.gid".get() end
	return self;
end

function Class:set_id(id)
	if type(self)~="table" then return self end
	self.mgrid = id;
	return self;
end

function Class:get_id()
	if type(self)~="table" then return nil end
	return self.mgrid;
end

function Class:ask_time()
	if type(self)~="table" then return self end
	if type(self.Time)~="number" then self.Time = os.time() end
	return self;
end

function Class:get_time()
	if type(self)~="table" then return 0 end
	-- return tonumber(os.time(self.Date));
	return self.Time;
end

function Class:get_date_text()
	if type(self)~="table" then return end
	return require"sys.dt".date_text(self.Time);
end

---------------------------------------------------
function Class:is_committed()
	if type(self)~="table" then return true end
	return self.Committed;
end

function Class:set_committed()
	if type(self)~="table" then return end
	self.Committed = true;
	-- self.Saved = nil;
	return self;
end

function Class:is_saved()
	if type(self)~="table" then return true end
	return self.Saved;
end

function Class:set_saved()
	if type(self)~="table" then return end
	self.Saved = true;
	return self;
end

function Class:clear_saved()
	if type(self)~="table" then return end
	self.Saved = nil;
	return self;
end

function Class:modify()
	if type(self)~="table" then return self end
	self.Saved = nil;
	self.Committed = nil;
	-- self.Date = os.date("*t");
	self.Time = os.time();
	-- if type(self.on_write_info)=="function" then self:on_write_info() end
	return self;
end

---------------------------------------------------

function Class:is_deleted()
	if type(self)~="table" then return self==false or tostring(self)=="Deleted" or tostring(self)=="deleted" end
	return self.Deleted;
end

function Class:del()
	if type(self)~="table" then return false end
	self.Deleted = true;
	Class.modify(self);
	return self;
end

function Class:add()
	if type(self)~="table" then return self end
	self.Deleted = nil;
	Class.modify(self);
	return self;
end

---------------------------------------------------

function Class:copy()
	if type(self)~="table" then return end
	return require"sys.table".deepcopy(self);
end

--[[
--arg={file=,key=}
function Class:tofile(arg)
	if type(self)~="table" then return end
	if not self.mgrid then return end
	local f = io.open(arg.file,"a");
	if not f then return end
	local old_ = "Old"
	f:write(old_.." = "..arg.key.." or {}\n");
	f:write(arg.key.." = "..require"sys.table".tostr(self));
	f:write(old_..".Time = "..old_..".Time or 0\n");
	f:write(arg.key..".Time = "..arg.key..".Time or 0\n");
	f:write("if "..arg.key..".Time < "..old_..".Time then "..arg.key.." = "..old_.." end\n");
	f:write(old_.." = nil\n");
	f:close();
end
--]]


-- t={list=,id=,remark=}
function Class:check_repeat(t)
	-- if type(t.list)~="table" then return false end
	local result = t.list[t.id];
	t.list[t.id] = true;
	return result;
end


function callf(f,arg)
	if type(f)=="function" then return f(arg) end
end

--t={key=}
function Class:tostr(t)
	local str = t.key..' = '..require"sys.table".tostr(self)..t.key..'.Saved = true\n';
	return str;
end

function Class:get_hid(str)
	str = str or self:tostr();
	local hid = require"sys.hid".get_by_string(str);
	return hid;
end

--t={pos=,key=,exname=}
-- function Class:tofile(t)
	-- local str = t.key..' = '..require"sys.table".tostr(self)..t.key..'.Saved = true\n';
	-- local hid = require"sys.hid".get_by_string(str);
	-- require"sys.mgr.model".set_item_filename(self.mgrid,hid);
	
	-- local f = io.open(t.pos..hid..t.exname,"r");
	-- if f then f:close() return end
	-- f = io.open(t.pos..hid..t.exname,"w");
	-- if not f then return end
	-- f:write(str);
	-- f:close();
-- end

--[[
--t={db=,ar=,pos=,key=,exname=}
function Class:save(t)
	if type(self)~="table" then return end
	if not self.mgrid then return end
	if not Class:is_class(self) then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self.mgrid} then return end
	
	if self:is_saved() then 
		local hid = require"sys.mgr.model".get_item_filename(self.mgrid)
		if hid then
			local fdx = require'sys.zip'.get_fdx(t.ar,t.pos..hid..t.exname);
			if fdx then return end
			if require'sys.io'.is_there_file{file=t.db..hid..t.exname} then	require'sys.zip'.add(t.ar,t.pos..hid..t.exname,'file',t.db..hid..t.exname) return end
		end
	end
	
	-- self:tofile{pos=t.pos,key=t.key,exname=t.exname}	
	local str = self:tostr{key=t.key}
	local hid = self:get_hid(str);
	require'sys.zip'.add(t.ar,t.pos..hid..t.exname,"string",str);
	require"sys.mgr.model".set_item_filename(self.mgrid,hid);
	self:set_saved();
end



local committed_pos_ = 'cfg/committed/'
local function add_committed_list(hid)
	local f = io.open(committed_pos_..hid,'w');
	if f then f:close() end
end

--t={db=,zip=,pos=,exname=,cbf=}
function Class:upload(t)
	if type(self)~="table" then return end
	if not self.mgrid then return end
	if not Class:is_class(self) then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self.mgrid,remark="tofile"} then callf(t.cbf,self.mgrid) return end
	
	local hid = require"sys.mgr.model".get_item_filename(self.mgrid);
	if not hid then trace_out("Error: Item.upload(), not hid.") return end 
	-- if require'sys.io'.is_there_file{file=committed_pos_..hid} then callf(t.cbf,self.mgrid) return end
	
	require'sys.zip'.extract{zip=t.zip,file=t.pos..hid..t.exname,pos=t.db}
	require"sys.net.file".send{
		name=hid..t.exname,
		path=t.db,
		cbf=function() 
			-- add_committed_list(hid);
			callf(t.cbf,self.mgrid) 
		end
	}
end
--]]

--------------------------------------------------------

--t={}
function Class:commit(t)
	if not Class:is_class(self) then return end
	if not self:get_id() then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self:get_id()} then return end

	-- if self:is_committed() then return end
	require'sys.mgr.db'.push_item(self);
	-- self:set_committed();
	return true;
end


--t={archive=,}
function Class:save(t)
	if not Class:is_class(self) then return end
	if not self:get_id() then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self:get_id()} then return end
	
	if not t.archive then return end
	local hid = require'sys.mgr.version'.push_item(self);
	if self:is_saved() and require'sys.zip'.get_fdx(t.archive,require'sys.mgr'.get_zip_model()..hid..require'sys.mgr'.get_db_exname()) then return true end
	require'sys.zip'.add(t.archive,require'sys.mgr'.get_zip_model()..hid..require'sys.mgr'.get_db_exname(),'file',require'sys.mgr'.get_db_path()..hid..require'sys.mgr'.get_db_exname());
	self:set_saved();
	return true;
end

--t={}
function Class:upload(t)
	if not Class:is_class(self) then return end
	if not self:get_id() then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self:get_id()} then return end
	
	require'sys.mgr.version'.upload_item(self:get_id());
	return true
end

--t={}
function Class:download(t)
	if not Class:is_class(self) then return end
	if not self:get_id() then return end
	local repeat_list = t.repeat_list or {};
	if self:check_repeat{list=repeat_list,id=self:get_id()} then return end
	
	require'sys.mgr.model'.push_item(self);
	return true
end


