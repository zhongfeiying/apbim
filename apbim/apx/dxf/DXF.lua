_ENV = module(...,ap.adv)


Class = {
	-- HEADER = {};
	-- CLASSES = {};
	-- TABLES = {};
	-- BLOCKS = {};
	-- ENTITIES = {};
	-- OBJECTS = {};
	-- Model = {
		-- [key] = {
			-- Index = key;
			-- ...
		-- };
		-- ...
	-- };
};

function Class:met(t)
	-- if self:is_class(t) then return t end
	setmetatable(t,self);
	self.__index = self;
	return t;
end

function Class:new(t)
	t = t or {};
	return self:met(t);
end

function Class:Add_Model_Item_Shape(id,shape)
	local item = self:Get_Item_By_Key(id) or require'sys.Entity'.Class:new();
	item.Shape = shape;
	require'sys.mgr'.add(item);
	return self;
end

function Class:Get_Color_ID_By_Layer(name)
	if type(self.TABLES)~='table' then return nil end
	if type(self.TABLES.LAYERS)~='table' then return nil end
	if type(self.TABLES.LAYERS[name])~='table' then return nil end
	return tonumber(self.TABLES.LAYERS[name].COLORID)
end

function Class:Get_Item_By_Key(k)
	if type(self.IDs)~='table' then return nil end
	local id = self.IDs[k]
	if not id then return nil end
	if type(self.Model)~='table' then return nil end
	if type(self.Model[id])~='table' then return nil end
	return self.Model[id];
end
