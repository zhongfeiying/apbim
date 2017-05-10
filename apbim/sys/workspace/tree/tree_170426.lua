
--[[

		
		
		
--]]

local loaded_ = package.loaded
local setmetatable = setmetatable
local require = require
local pairs = pairs
local ipairs = ipairs
local string = string
local open_ = io.open

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
	if type(file) ~= 'string' then return end 
	file = string.gsub(file,'\\','/')
	file = string.match(file,'(.+)%.')
	if string.find(file,'%.') then return  error (file .. ' path is error ! Unexpected "." in path ') end 
	return string.gsub(file,'/','.')
end 



---------------------------------------------------------------------------------------------
local recursion_func;

local caches_={}
caches_.env = {}
caches_.env.headEnv = {}
caches_.env.headEnv.filesEnv = {}
caches_.env.headEnv.attributesEnv = {}
caches_.env.linkFiles = {}
caches_.classAPI = {}
---------------------------------------------------------------------------------------------
--caches_.classAPI --class文件必须要有的函数
caches_.classAPI.new = function (require_)  
	if type(require_.Class) == 'table' and type(	require_.Class:new) == 'function' then 
		return require_.Class:new() --Class:new() --return class object
	end
end 
caches_.classAPI.update = function(Class)  
	if type(Class:update) == 'function' then 
		Class:update()  --Class:update()
	end
end 
caches_.classAPI.set_data = function(Class,data)
	if type(Class:set_data) == 'function' then 
		Class:set_data(data)  --Class:set_body()
	end
end
caches_.classAPI.set_attributes = function(Class)
	if type(Class:set_attributes) == 'function' then 
		Class:set_attributes(f) --Class:set_body()
	end
end 
caches_.classAPI.get_element = function(Class) 
	if type(Class:get_element) == 'function' then 
		return  Class:get_element() --Class:get_element() --return （例如）iup.tree
	end
end 

-- caches_.classAPI.attributes_set_font = function(Class) 
	
-- end 

-- caches_.classAPI.attributes_set_font = function(Class) 
	
-- end 

caches_.classAPI.map_attributes = function(Class) 
	if type(Class:map_attributes) == 'function' then 
		return  Class:map_attributes() --Class:map_attributes() 
	end
end 

caches_.classAPI.map_data= function(Class) 
	if type(Class:map_data) == 'function' then 
		return  Class:map_data(cbf) --Class:map_data()
	end
end 

caches_.classAPI.map_callback = function(Class) 
	if type(Class:map_callback) == 'function' then 
		return  Class:map_callback() --Class:map_callback()
	end
end 


---------------------------------------------------------------------------------------------
--caches_.env  --解析加载文件需要的共性函数
caches_.env.headEnv.files = function(env,self,data)
	recursion_func(env.filesEnv,self,data)
end 
 
caches_.env.head = function(env,self,data)
	recursion_func(env.headEnv,self,data)
end 

caches_.env.headEnv.filesEnv.class = function(env,self,data)
	if type(data) ~= 'table' then return end 
	caches_[self.__outLink].files.TreeClassFile = data.src and file_is_exist( data.src) and get_require_path(data.src)
end 

caches_.env.headEnv.filesEnv.style = function(env,self,data)
	if type(data) ~= 'table' then return end 
	caches_[self.__outLink].files.TreeStyleFile = data.src and file_is_exist( data.src) and get_require_path(data.src)
end 

caches_.env.headEnv.filesEnv.interaction = function(env,self,data)
	if type(data) ~= 'table' then return end 
	caches_[self.__outLink].files.TreeInteractionFile = data.src and file_is_exist( data.src) and get_require_path(data.src)
end 

caches_.env.headEnv.attributes = function(env,self,data)
	recursion_func(env.attributesEnv,self,data,caches_[self.__style].styles)
end 

caches_.env.headEnv.attributesEnv.bgcolor = function(env,self,data)
	if type(data) ~= 'table' then return end 
	caches_[self.__style].styles.bgcolor = (data.r and '') .. ' ' ..  (data.g or '') .. ' ' ..  (data.b or '')
end 

caches_.env.headEnv.attributesEnv.rastersize = function(env,self,data)
	if type(data) ~= 'string' then return end 
	caches_[self.__style].styles.rastersize = data
end 

caches_.env.headEnv.attributesEnv.font = function(env,self,font)
	if type(font) ~= 'string' then return end 
	caches_[self.__style].styles.font = font
end

caches_.env.body = function(env,self,data)
	if type(font) ~= 'string' then return end 
	caches_[self.__style].body = data
end
 
recursion_func =  function (env,self,data,saveTable)
	if type(data) ~= 'table' then return end 
	for k,v in pairs(data) do 
		if type(env[k] == 'function') then 
			env[k](env,self,v)
		elseif string.sub(k,1,1) == '.'  and saveTable then 
			saveTable[k] = v
		end 
	end 
end

caches_.env.linkFiles.TreeClassFile = function (luapath)
	caches_[self.__outLink].caches.class = require_file (luapath)
end

caches_.env.linkFiles.TreeStyleFile = function (luapath)
	caches_[self.__outLink].caches.style = require_file (luapath)
end

caches_.env.linkFiles.TreeInteractionFile = function (luapath)
	caches_[self.__outLink].caches.interaction = require_file (luapath) --interaction 交互
end
----------------------------------------------------------------------------------
Class = {
}


local function met(Class,t)
	t = t or {}
	setmetatable(t,Class)
	Class.__index = Class
	return t
end 


function Class:new(t)
	return met(self,t)
end

----------------------------------------------------------------------------------
--init
function Class:set_base()
	self.__default = require 'luaext'.guid();
	self.__outLink =require 'luaext'.guid();
	self.__style = require 'luaext'.guid();
end 

function Class:set_caches()
	caches_[self.__defalut] = {TreeClassFile = 'sys.tree.iupTreeClassFile';}
	caches_[self.__outLink] = {}
	caches_[self.__outLink].files = {}
	caches_[self.__outLink].caches = {}
	caches_[self.__style] = {}
	caches_[self.__style].styles = {}
end 

function Class:set_loadedfile(file)
	self.__loadedfile = file or self.__loadedfile
end 

function Class:get_loadedfile()
	return self.__loadedfile 
end 

function Class:get_filedata()
	local file = self.get_loadedfile()
	if file then 
		return require_file(file)
	end 
end  

function Class:set_data(data)
	self.__data = data or self:get_filedata() or self.__data
end 

function Class:get_data()
	return self.__data 
end  
----------------------------------------------------------------------------------
-- function Class:get_body()
	-- return self.body
-- end
----------------------------------------------------------------------------------

function Class:init_tree_object(TreeClassFile)
	local dlgClass = caches_[self.__outLink].caches.class or require_file(caches_[self.__defalut].TreeClassFile )
	self.__tree =  caches_.classAPI.new(dlgClass) 
end

function Class:get_tree_obj()
	return self.__tree
end

function Class:parsing_loadedfile()
	local db = self:get_data()
	if type(db) ~= 'table' then return end 
	recursion_func(caches_.env,self,db)
end 


function Class:parsing_link_files()
	local fileList = caches_[self.__outLink].files
	local env = caches_.env.linkFiles
	for k,v in pairs(fileList) do 
		if type(env[k]) == 'function' then 
			env[k](v)
		end 
	end 
end

function obj_is_exist(obj)
	if not obj then error('Element is not exist !') return end 
	return true
end

function Class:map_attributes()
	local obj = self:get_tree_obj() 
	if obj_is_exist(obj) then 
		caches_.classAPI.map_attributes(obj)
	end
end

function Class:map_data()
	local obj = self:get_tree_obj() 
	if obj_is_exist(obj) then 
		caches_.classAPI.map_data(obj)
	end
end
function Class:map_callback()
	local obj = self:get_tree_obj() 
	if obj_is_exist(obj) then 
		caches_.classAPI.map_callback(obj)
	end
end
----------------------------------------------------------------------------------
-- 外部调用
function Class:set(arg)
	arg = type(arg) == 'table' and arg or {}
	self:set_base()
	self:set_caches()
	self:set_loadedfile(arg.file)
	self:set_data(arg.data)
end 

function Class:init()
	self:parsing_loadedfile() --分析文件中的数据
	self:parsing_link_files()
	self:init_tree_object()
end

function Class:map()
	self:map_attributes()
	self:map_data()
	self:map_callback()
end 

function Class:get_element()
	local obj = self:get_tree_obj()
	if obj_is_exist(obj) then 
		return caches_.classAPI.get_element(obj) 
	end
end

function Class:update()
	local obj = self:get_tree_obj()
	if obj_is_exist(obj) then 
		caches_.classAPI.update(obj)
	end
end
--[[
----------------------------------Class attribute--------------------------------------------------

--[[ 
src 属性： 指定数据或者函数的文件。src 的值应该符合lua语法的路径
	示例： (view 元素的src 属性)
		view = {src = 'sys.tree.iuptree'};
--]]
function Class:src(file,var) 
	loaded_[file] = nil
	return require (file)
end


----------------------------------node attribute--------------------------------------------------
--[[
--font 字体
--color 颜色
--image 图片
--userdata 附着数据
--state 状态
-- title  
-- kind 
--]]
function Class:title(title,id)
	if not self.__tree then return end 
	self.__tree:title(title,id)
end 
function Class:image(image,id)
	if not self.__tree then return end 
	self.__tree:image(image,id)
end 
function Class:userdata(data,id)
	if not self.__tree then return end 
	self.__tree:userdata(data,id)
end 

function Class:state(state)
	if not self.__tree then return end 
	self.__tree:state(state,id)
end 

-- function  Class:show()
-- end

function Class:update_node_attribute(attrs)
	for k,v in pairs(attrs) do 
		if type(self[k]) == 'function' then 
			self[k](self,v)
		end 
	end 
end 
--------------------------------------element----------------------------------------------
local function element_warning(ele,data)
	if type(data) ~= 'table' then  return error(ele .. ' element\'s value is error !') end 
end

local function get_src_data(self,src)
	local rev = self:src(src ) 
	if type(rev) == 'function' then 
		rev = rev()
		return type(rev) == 'table' and rev
	elseif type(rev) == 'table' then 
		return rev
	end 
end


	
function Class:tree(data) -- 设置gui 的源文件
	if element_warning('view',data) then return end
	if data.src then 
		caches_[self.__outLink].tree = get_src_data(self,data.src ) or get_src_data(self,self.__default.tree)
	end
end

function Class:style(data) -- 设置gui 的源文件
	if element_warning('style',data) then return end 
	if data.src then 
		caches_[self.__outLink].style = get_src_data(self,data.src ) or caches_[self.__outLink].style  or {}
	end 
end

function Class:interaction(data) -- 设置gui 的源文件
	if element_warning('interaction',data) then return end 
	if data.src then 
		caches_[self.__outLink].op =  get_src_data(self,data.src ) or caches_[self.__outLink].op  or {}
	end 
end
--]]

-- function Class:set_tree(file)
	-- self:init_tree(file)
-- end

-- function Class:set_data(file)
	-- self:init_data(file)
-- end

-- function Class:set_loadedfile(file)
	-- self:init_loadedfile(file)
-- end

-- function Class:set(arg)
	-- arg = type(arg) == 'table' and arg or {}
	-- self:set_tree(arg.tree)
	-- self:set_data(arg.data)
	-- self:set_loadedfile(arg.file)
-- end 
----------------------------------------------------------------------------------
--[[
function Class:preloaded_file(data)
	for k,v in pairs(data) do 
		if type(self[k]) == 'function' then 
			self[k](self,v)
		end 
	end 
end

function Class:preloaded_attributes(data)
	caches_[self.__style] =data
end

function Class:preloaded(data)
	if type(data.file) == 'table'  then self:preloaded_file(data.file) end 
	if type(data.attributes) == 'table'  then self:preloaded_attributes(data.attributes)  end 
end

function Class:loaded_data(data)
	self.__data  = data
end



function Class:loaded()
	if not self.loadedFile then return end 
	local db = require (self.loadedFile)
	if type(db) == 'table' then
		if type(db.preloaded) == 'table' then 	self:preloaded(db.preloaded) end
		if  type(db.tree) == 'table' then self:loaded_data(db.data) end
	end 
end

function Class:delete_nodes(state,id)
	if self.__tree and type(self.__tree.delete_nodes) == 'function' then 
		self.__tree:delete_nodes(state,id)
	end
end

function Class:set_tree_data(data,id)
	if self.__tree and type(self.__tree.set_tree_data) == 'function' then 
		self.__tree:set_tree_data(data,id)
	end 
end


function Class:init_tree_data(data,id)
	local states = (id == -1 and 'ALL') or 'CHILDREN' 
	self:delete_nodes('CHILDREN',id)
	self:set_tree_data(self,data,id)
end

function Class:show(data) --xianshi
	self.__tree = caches_[self.__outLink].tree
	if type(self.__tree) ~= 'table' then self.__tree=nil return error('You need to create a tree-control firstly!') end 
	local data = data or  self.__data
	if type(self.__data) ~= 'table' then self.__data=nil return error('You need to provide the data !') end 
	self:init_tree_data(self.__data,-1)
end

function Class:update(data,id) --gengxin
	if not self.__tree then return error('You need show firstly!') end 
	local data = data or self.__data
	local id = id or  -1
	self:init_tree_data(data,id)
end
--]]


