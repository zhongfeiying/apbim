local loaded_ = package.loaded
local setmetatable = setmetatable
local require = require
local pairs = pairs
local ipairs = ipairs
local string = string
local open_ = io.open
local coroutine = coroutine

local M = {}
local modname = ...
_G[modname] = M
loaded_[modname] = M
_ENV = M
---------------------------------------------------------------------------------------------
local function require_file(file)
	loaded_[file] = nil
	return require (file)
end

function file_is_exist(file)
	local file = open_ (file,'r')
	if file then
		file:close()
		return true
	end 
end

function get_require_path(file)
	file = string.match(file,'(.+)%.')
	if string.find(file,'%.') then return  error (file .. ' path is error ! Unexpected "." in path ') end 
	return string.gsub(file,'/','.')
end 
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
Class = {
	--controlElement ;--控件对象
	--customData ;自定义数据表
	--elementData;系统定义元素
}

local function met(Class,t)
	t = t or {}
	setmetatable(t,Class)
	Class.__index = Class
	return t
end 
--------------------------------attributes-------------------------------------------------------------
function  Class:add_custom_data(key,data)
	if not self.customData[key] then self.customData[key] = data end 
end 

local function add_element_data(Element,data)
	for k,v in data do 
		if not Element[k] then  Element[k] =v end 
	end 
end 

function Class:branch(data)
	if not self.elementData.branch then 
		self.elementData.branch =data
	else 
		add_element_data(self.elementData.branch,data)
	end 
end

function Class:leaf(data)
	if not self.elementData.leaf  then 
		self.elementData.leaf =data
	else 
		add_element_data(self.elementData.leaf ,data)
	end 
end

--------------------------------set/get-------------------------------------------------------------

function Class:set_element(controlElement)
	self.controlElement = controlElement
end

function Class:get_element()
	return self.controlElement
end

function Class:set_loaded_file(arg)
	self.loadedFile = arg and arg.file
end

function Class:get_loaded_file()
	return self.loadedFile
end

function Class:set_loaded_data(arg)
	self.loadedData = arg and arg.data
end

function Class:get_loaded_file()
	return self.loadedData
end
--------------------------------op-------------------------------------------------------------

function Class:set_title(title,id)
	local ele = self:get_element()
	if not ele or not ele.set_title then return end 
	return ele:set_title(title,id)
end
--arg = {id = ,title = ,userdata = ,image = ,...}
function Class:add_branch(arg)
	local ele = self:get_element()
	if not ele or not ele.add_branch then return end 
	return ele:add_branch(arg)
end

--arg = {id = ,title = ,userdata = ,image = ,...}
function Class:add_leaf(arg)
	local ele = self:get_element()
	if not ele or not ele.add_leaf then return end 
	return ele:add_leaf(arg)
end

function Class:set_map_attributes(attributs)
	local ele = self:get_element()
	if not ele or not ele.add_leaf then return end 
	return ele:set_map_attributes(attributs)
end

--------------------------------init-------------------------------------------------------------

local turn_data;

local function  deal_turn_data(self,db,t)
	for k,v in pairs (db) do 
		if k~= 'data' and type(fun [k]) == 'function'  then 
			t[k] = fun [k]()
		end 
	end 
	if type(db.data) == 'table' then 
		t.data = {}
		turn_data(self,db.data,t.data)
	end 
end

turn_data = function (self,data,t)
	local t = t or {}
	for k,v in ipairs (data) do
		if type(v) == 'table' then 
			t[k] = {}
			deal_turn_data(self,v,t[k])
		else 
			t[k] = v
		end
	end 
	return t 
end


function Class:recursive_head_data(db,lev)
	if type(db) ~= 'table' then return end
	for k,v in pairs(db) do 
		if type(self[k]) == 'function' then 
			self[k](v)
		else 
			self:add_custom_data(k,v)
		end 
	end 
end

function Class:change_data(oldData,saveData)
	
end

function Class:recursive_body_data(db,data)
	if type(db) ~= 'table' then return end
	for k,v in ipairs(db) do
		if type(v) == 'table' then 
			data[k] = {}
			self:change_data(v,data[k])
			if v.data then 
				self:recursive_body_data(v.data,data[k])
			end 
		else 
			data[k] = v
		end 
	end 
end


function Class:deal_head(db)
	self:recursive_head_data(db)
end

function Class:deal_body(db)
	local data = {}
	self:recursive_body_data(db,data)
end

local function init_class_data(t)
	t.controlElement = require 'sys.tree.iupTree'.Class:new();
	t.elementData = {}
	t.customData = {}
end

function Class:new(t)
	local t = met(self,t)
	init_class_data(t)
	return t
end

function Class:init(db)
	local db = db or (self.loadedFile  and require_file(self.loadedFile))
	if type(db) ~= 'table'  then return end 
	self:deal_head(db.head)
	self:deal_body(db.data)
end

function Class:update()
	
end
-------------------------------------------------------------

