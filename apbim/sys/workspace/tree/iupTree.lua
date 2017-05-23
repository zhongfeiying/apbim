--[[
文件相关说明：
	引用资源：
		require "iuplua"（IUP LIB）
		require "iupluacontrols"（IUP LIB）
		require "iupluaimglib（IUP LIB）
	注意：
		本文件用于快速定制iup.tree,在本文件中提供了一些相对简单的接口（实质是转掉了iup.tree）用来操作tree控件，值的设置需要参考iup中对tree的相关属性设置方法。
		对于 iup.tree 元素的属性进行设置，请务必按照规范设置，否则属性不会发生作用或者出现未预期的结果。可以定位到相关接口查看使用示例。
		为了快速定制开发，本文件中也提供了一些简单的接口下面会对其进行分类介绍。
		为了便于理解使用，在每个具体接口实现函数的位置都会有一个简单的调用示例，方便学习。使用者也可借此与iup.tree中的属性进行验证学习。
	data数据结构：
		db = {
			{
				attributes = {title,kind,data,image,color,state,...};--该属性表控制节点的显示状态
				{--文件夹内子文件
					{attributes ={};};
					{attributes ={};};
					{	

						attributes ={};
						{
						
						}；
					};
				}
			};
		}

		
	对象包含的属性：
		tree （必有）：iup.tree 元素创建的对象
		data : 要显示在 iup.tree 中的数据（db结构）。也可以在界面绘制后使用Class:init_tree_data(data) 控制tree的显示内容。
		lbtn ： 处理单击左键操作
		dlbtn ： 处理双击左键操作
		rbtn ： 处理单击右键操作
		
	对象包含的方法：	
		封装的接口：（设置的值需要满足iup.tree的属性用法，获得的值同样如此。）
			
			Class:set_leaf_image(str)	
			--请参考iup.tree中 IMAGELEAF 属性。设置tree中所有 leaf（文件）节点的图片属性。
			
			Class:set_branch_image(arg) 
			--请参考iup.tree中 IMAGEBRANCHEXPANDED 和 IMAGEBRANCHCOLLAPSED 属性。设置tree中所有branch（文件夹）节点的展开、闭合时的图片属性。
			--arg 时一个表结构数据。arg = {expanded = ""，collapsed = ''}。expanded对应的值控制展开时的图片，collapsed对应的值则相反。
			
			Class:set_fgcolor(str)
			--请参考iup.tree中 FGCOLOR 属性。用来设置 iup.tree 的前景色
			
			Class:set_bgcolor(str)
			--请参考iup.tree中 BGCOLOR 属性。用来设置 iup.tree 的背景色
			
			Class:set_hlcolor(str) 
			--请参考iup.tree中 HLCOLOR 属性。用来设置 iup.tree 的被标记节点的颜色
				
			Class:set_rastersize(str) 
			--请参考iup.tree中 RASTERSIZE 属性。用来设置 iup.tree 的控件在像素上的大小（以像素为单位）。
			
			Class:set_size(str) 
			--请参考iup.tree中 SIZE 属性。用来设置 iup.tree 的控件大小（以字符为单位）。
			
			Class:set_tabtitle(str) 
			--请参考iup.tree 中 TABTITLE 属性。用来设置当tree控件所在页（iup.tab）的标题。	
			
			Class:set_node_data(data,id)
			--请参考iup.tree 中 TreeSetUserId 描述。用来处理节点绑定的数据。	
			
			Class:set_node_title(text,id)
			--请参考iup.tree 中 TITLE 属性。用来设置或者改变给定节点显示的文本。
			
			Class:set_node_color(color,id)
			--请参考iup.tree 中 COLOR 属性。用来设置节点的文本颜色。
			
			Class:set_node_state(state,id)
			--请参考iup.tree 中 STATE 属性。用来设置BRANCH（文件夹）节点的展开闭合状态。

			Class:set_node_image(image,id)
			--请参考iup.tree 中 IMAGE 属性。设置节点的image。
		
			Class:set_expanded_image(image,id)
			--请参考iup.tree 中 IMAGEEXPANDED 属性。设置branch（文件夹）节点展开状态下的图标。
			
			Class:set_node_top(id)
			--请参考iup.tree 中 TOPITEM 属性。显示节点（如果该节点id处于闭合文件夹下，闭合的文件夹也会逐级的展开）
			
			Class:set_node_marked(id)
			--请参考iup.tree 中 MARKED 属性。设置被选中的节点（鼠标左键点选效果）.

			Class:get_tree_ids()
			--请参考iup.tree 中 COUNT 属性。获得tree中所有节点的个数
			
			Class:get_node_ids(id,total)
			--请参考iup.tree 中 TOTALCHILDCOUNT 和 CHILDCOUNT 属性。
			-- 如果total 这个参数值不为nil，则认为想要获得的是节点下的所有子节点个数（包含子节点的节点）。也可以直接使用Class:get_totalchildcount(id)
			-- 如果total 这个参数值为nil，则认为想要获得的是节点下当前层级的节点个数。也可以直接使用Class:get_childcount(id)
			
			Class:get_node_depth(id)
			--请参考iup.tree 中 DEPTH 属性。获得节点当前的层级深度
			
			Class:get_node_kind(id)
			--请参考iup.tree 中 KIND 属性。获得指定节点的类型（'BRANCH' or 'LEAF'）
			
			Class:get_node_parent(id)
			--请参考iup.tree 中 PARENT 属性。获得指定节点的父节点id，
			
			Class:get_node_state(id)
			--请参考iup.tree 中 STATE 属性。获得指定branch节点的当前状态（展开or闭合）
			
			Class:get_node_title(id)
			--请参考iup.tree 中 TITLE 属性。获得指定节点的标题文本
			
			Class:get_tree_value()
			--请参考iup.tree 中 VALUE 属性。获得当前选中节点的id
			
			Class:get_node_data(id)
			--请参考iup.tree 中 iup.TreeGetUserId  描述。获取节点附着的数据
		
			Class:add_branch(name,id)
			--请参考iup.tree 中 ADDBRANCH 属性。添加一个branch（文件夹）节点
			
			Class:add_leaf(name,id)
			--请参考iup.tree 中 ADDLEAF 属性。添加一个leaf（文件）节点
			
			Class:insert_branch(name,id)
			--请参考iup.tree 中 INSERTBRANCH 属性。插入一个 branch（文件夹）节点
			
			Class:insert_leaf(name,id)
			--请参考iup.tree 中 INSERTLEAF 属性。插入一个 leaf（文件夹）节点
			
			Class:delete_nodes(status,id)
			--请参考iup.tree 中 DELNODE 属性。删除节点操作。
		
		自定义接口：
			Class:new(t) 
			-- 创建类对象，同时该对象包含了创建好的iup.tree元素
			--参数t接收的是一个表结构数据(没有任何参数也是可以的)，形如：t = {font = "Courier, 10";}
			--返回值是一个创建好的对象表。
			
			Class:init()
			--不需要主动调用，系统会在tree元素被绘制的时候自动调用此方法。
			--需要注意的是
			
			Class:set_data(data)
			--设置对象需要的数据
			
			Class:get_data()
			--获得对象中保存的数据
			
			Class:set_tree(data)
			--设置iup.tree控件。如果觉得默认的tree功能不够完整，用户可以根据iup.tree自己创建一个tree控件。
			
			Class:get_tree()
			--获得保存的tree元素对象。
			
			Class:set_lbtn(lbtn)
			--设置单击鼠标左键时触发的函数。 lbtn  的接收的类型是 function
			
			Class:set_dlbtn(dlbtn)
			--设置双击鼠标左键时触发的函数。 dlbtn  的接收的类型是 function
			
			Class:set_rbtn(rbtn)
			--设置单击鼠标右键时触发的函数。 rbtn  的接收的类型是 function
			
			Class:init_tree_data(data)
			-- 初始化 iup.tree 显示的数据。data数据须符合db结构，如果data为nil，则会查找对象包含的data属性。
			
			Class:init_node_data(data,id)
			-- 初始化 iup.tree 中某个文件夹节点显示的内容。data须符合db结构，id为指定节点的id。
			
			Class:init_path_data(path,rule,id)
			-- 给定磁盘路径，将该文件夹以及文件夹下的内容显示在tree中。
			
			Class:get_selected_path(id)
			--获取节点的title路径信息。
]]

local require = require
local type = type
local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local setmetatable = setmetatable
local error = error
local print = print
local string_gsub_ = string.gsub
local string_match_ = string.match
local string_upper_ = string.upper
local string_find_ = string.find
local table_insert_ = table.insert
local string_sub_ = string.sub

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local iup = require "iuplua"
require "iupluacontrols"
require "iupluaimglib"
local lfs = require 'lfs'
local RMenu_ = {}--require 'sys.workspace.tree.rmenu'
Class = {}

----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
--warning function 
--[[
函数名：map_warning
参数：无
返回值：
	类型：true or nil
说明：判断界面是否被绘制（有些操作需要界面绘制后方能执行）。如果还没有被绘制会弹出提示并返回nil值，否则返回true
]]
local function map_warning(self)
	if not self.Map then iup.Message('Notice','The tree has not been mapped !') return end 
	return true 
end


----------------------------------------------------------------------------------------------------------
--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_leaf_image('IMGPAPER') --该字符串由iup提供
	或者
	tree:set_leaf_image('c:\\image\\test.bmp') --本地文件，必须是windows的bmp格式的文件bmp格式的文件
	详情请看IMAGELEAF属性。
--]]
function Class:set_leaf_image(str)
	local tree = self.tree
	tree.IMAGELEAF = str 
end

function Class:set_imagebranchcollapsed(str) 
	local tree = self.tree
	tree.IMAGEBRANCHCOLLAPSED = str 
end

function Class:set_imagebranchexpanded(str) 
	local tree = self.tree
	tree.IMAGEBRANCHEXPANDED = str 
end

--arg = {expanded,collapsed}
--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_branch_image{expanded = ，collapsed = } --具体值与leaf image的设置方法类似
	详情请看 IMAGEBRANCHEXPANDED ， IMAGEBRANCHCOLLAPSED 属性。
--]]
function Class:set_branch_image(arg) 
	arg = arg or {}
	self:set_imagebranchexpanded(arg.expanded) 
	self:set_imagebranchcollapsed(arg.collapsed) 
end


--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_fgcolor('255 0 0') -- 字符串的含义是"R G B"，R、G、B的取值范围是0~255
	或者
	tree:set_fgcolor('#ff0000') -- 颜色16进制表示法。效果与上等同都是红色。
--]]
function Class:set_fgcolor(str)
	local tree = self.tree
	tree.FGCOLOR =  str
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_bgcolor('255 0 0') -- 字符串的含义是"R G B"，R、G、B的取值范围是0~255
	或者
	tree:set_bgcolor('#ff0000') -- 颜色16进制表示法。效果与上等同都是红色。
--]]
function Class:set_bgcolor(str) 
	local tree = self.tree
	tree.BGCOLOR =str
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_hlcolor('255 0 0') -- 字符串的含义是"R G B"，R、G、B的取值范围是0~255
	或者
	tree:set_hlcolor('#ff0000') -- 颜色16进制表示法。效果与上等同都是红色。
--]]
function Class:set_hlcolor(str)  
	local tree = self.tree
	tree.HLCOLOR  = str
end


--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_rastersize('100x100')
--]]
function Class:set_rastersize(str)
	local tree = self.tree
	tree.rastersize = str
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_size('100x100')
--]]
function Class:set_size(width,height) 
	local tree = self.tree
	tree.size = str
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_tabtitle('Project')
--]]
function Class:set_tabtitle(str)
	-- self.tabtitle = str
	self.tree.TABTITLE  = str
end

----------------------------------------------------------------------------------------------------------
--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_data({test = 'Test'},1)
	注意：
		data 接收的值只能是 table、userdata、nil 这三种类型（nil 删除数据）。
		如果没有设置id这个参数，则默认设置的是当前选中节点。
--]]
function Class:set_node_data(data,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	iup.TreeSetUserId(tree,id,data)
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_title('TestText',1)
	注意：
		如果没有设置id这个参数，则默认设置的是当前选中节点。
--]]
function Class:set_node_title(text,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	tree['TITLE' .. id] = text
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_color('255 0 0',1)
	注意：
		如果没有设置id这个参数，则默认设置的是当前选中节点。
--]]
function Class:set_node_color(color,id) 
	if not map_warning(self) then return end 
	local id = id  or self:get_tree_selected()
	local tree = self.tree
	tree['COLOR' .. id] = color
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_state('EXPANDED',1)
	注意：
		如果没有设置id这个参数，则默认设置的是当前选中节点。
--]]
function Class:set_node_state(state,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	tree["STATE" .. id] = state or "COLLAPSED"
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_image('IMGPAPER',1)
	注意：
		如果没有设置id这个参数，则默认设置的是当前选中节点。
		如果设置的节点是branch,那么所设置的图标仅是其闭合状态下的图标样式。
--]]
function Class:set_node_image(image,id)
	if not map_warning(self) then return end 
	local id = id  or self:get_tree_selected()
	local tree = self.tree
	tree['IMAGE' .. id] = image
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_expanded_image('IMGPAPER',1)
	注意：
		如果没有设置id这个参数，则默认设置的是当前选中节点。
		这里设置branch节点展开状态下的图标
--]]
function Class:set_expanded_image(image,id)
	if not map_warning(self) then return end 
	local id = id and tonumber(id) or self:get_tree_selected()
	local tree = self.tree
	tree['IMAGEEXPANDED' .. id] = image
end


--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_top(5)
--]]
function Class:set_node_top(id)
	if not map_warning(self) then return end 
	local tree = self.tree
	local id = id  or self:get_tree_selected()
	tree.TOPITEM = id
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:set_node_marked(5)
--]]
function Class:set_node_marked(id)
	if not map_warning(self) then return end 
	local tree = self.tree
	tree['MARKED' .. id] = 'YES'
	-- self:set_node_top(id)
end



----------------------------------------------------------------------------------------------------------
--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local count = tree:get_tree_ids(5)
	print(type(count)) --> number
--]]
function Class:get_tree_ids()
	if not map_warning(self) then return end 
	local tree = self.tree
	return tonumber(tree.COUNT)
end


function Class:get_totalchildcount(id)
	if not map_warning(self) then return end 
	local tree = self.tree
	local id = id  or self:get_tree_selected()
	return tonumber(tree['TOTALCHILDCOUNT' .. id])
end

function Class:get_childcount(id)
	if not map_warning(self) then return end 
	local tree = self.tree
	local id = id  or self:get_tree_selected()
	return tonumber(tree['CHILDCOUNT' .. id])
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
		local count = tree:get_node_ids(1,true)
		print(count)
		或者 
		local count = tree:get_node_ids(1)
		print(count)
		
		print(type(count)) --> number
--]]
function Class:get_node_ids(id,total)
	if not map_warning(self) then return end 
	local tree = self.tree
	local id = id or self:get_tree_selected()
	if total then 
		return self:get_totalchildcount(id)
	end
	return self:get_childcount(id)
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local depth = tree:get_node_depth(1)
	print(type(depth)) --> number
	注意：
		根节点所在的层级是 0 。
--]]
function Class:get_node_depth(id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	return tonumber(tree["DEPTH" .. id])
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local kind = tree:get_node_kind(1)
	print(type(kind)) --> string
	注意：
		返回值是可能是："BRANCH"或者"LEAF"。
--]]
function Class:get_node_kind(id)	
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	return tree["KIND" .. id]
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local id = tree:get_node_parent(1)
	print(type(id)) --> number
	注意：
		根节点的id 是 0 。
--]]
function Class:get_node_parent(id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	return tonumber(tree["parent" .. id])
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local state = tree:get_node_state(1)
	print(type(state)) --> string
	注意：
		返回值是可能是："EXPANDED"或者"COLLAPSED"。
--]]
function Class:get_node_state(id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	local tree = self.tree
	return tree["STATE" .. id]
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local title = tree:get_node_title(1)
	print(type(title)) --> string
--]]
function Class:get_node_title(id)
	if not map_warning(self) then return end 
	local tree = self.tree
	return tree['TITLE' .. id]
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local id = tree:get_tree_value()
	print(type(id)) --> number
--]]
function Class:get_tree_value()
	if not map_warning(self) then return end 
	local tree = self.tree
	return tonumber(tree.VALUE )
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	local data = tree:get_node_data(3)
	print(type(id)) --> userdata or table or nil
--]]
function Class:get_node_data(id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	return iup.TreeGetUserId(self.tree,id)
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:add_branch('name',1)
	注意：
		添加的位置如果是文件夹节点，则成为该文件夹的首节点，否则会添加在文件节点下方，类似于插入操作。
--]]
function Class:add_branch(name,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected() 
	self.tree["ADDBRANCH" .. id] = name
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:add_leaf('name',1)
	注意：
		添加的位置如果是文件夹节点，则成为该文件夹的首节点，否则会添加在文件节点下方，类似于插入操作。
--]]
function Class:add_leaf(name,id)
	if not map_warning(self) then return end
	local id = id or self:get_tree_selected()	
	self.tree["ADDLEAF" .. id] = name
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:insert_branch('name',1)
--]]
function Class:insert_branch(name,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	self.tree["INSERTBRANCH" .. id] = name
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:insert_leaf('name',1)
--]]
function Class:insert_leaf(name,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	self.tree["INSERTLEAF" .. id] = name
end

--[[
使用示例：
	local tree = require '...'.Class:new(t)
	tree:delete_nodes('SELECTED',1)
	注意：	
		status 的值可能为：
			"ALL": deletes all nodes, id is ignored (Since 3.1)
			"SELECTED": deletes the specified node and its children
			"CHILDREN": deletes only the children of the specified node
			"MARKED": deletes all the selected nodes (and all their children), id is ignored
--]]
function Class:delete_nodes(status,id)
	if not map_warning(self) then return end 
	local id = id or self:get_tree_selected()
	self.tree["DELNODE" .. id] = status
end

local function get_selected_nodes(tree)
	if not tree  then error("Missing parameter !") return end 
	local str = tree.MARKEDNODES
	local ids = {}
	for i = 1,#str do 
		if string_sub_(str,i,i) == "+" then
			table_insert_(ids,i-1)
		end
	end
	return ids
end

function Class:get_tree_selected()
	return self:get_tree_value() or get_selected_nodes(self.tree)[1]
end

--------------------------------------------------------------------------------------------------
--t = {font,root,size,data}
local function create_tree(t)
	t = t or {}
	return iup.tree{
		font = t.font or "Courier, 10"; --设置字体
		addexpanded = "NO"; --默认不展开全部有子节点的分支
		expand=   "YES"; --设置当容器的大小大于设置tree控件的大小时，使tree的大小自动扩展到该容器允许的最大值。
		showrename = "NO"; --不允许在交互状态下修改tree中节点显示的文本，仅允许通过命令来修改。
		MARKMODE =  "SINGLE"; --设置该tree的选择模式为单选.
		IMAGELEAF = "IMGPAPER";--设置该tree默认的leaf（叶子）节点的图标是"IMGPAPER"（看起来像文件图标）
		ADDROOT = 'YES'; --设置该tree有一个默认的节点。
		title0 = t.root or 'Project'; --设置该默认的节点的默认显示文本。
		rastersize = t.rastersize;
		map_cb =  function() --设置tree在显示的时候的回调函数
			t.Map = true --初始化Map变量为true
			t:init()
		end;
	};
end

function Class:new(t)
	local t = t or {}
	setmetatable(t,self)
	self.__index = self;
	t.tree = create_tree(t);
	return t
end

function Class:init()
	if not map_warning(self) then return end  
	self:init_lbtn() --初始化鼠标左键操作
	self:init_dlbtn() --初始化双击鼠标左键操作
	self:init_rbtn() --初始化鼠标右键操作
	self:init_tree_data() --如果有数据则初始化界面中的显示内容。
end

function Class:set_data(data)
	self.data = data or {}
end

function Class:get_data()
	return self.data
end

function Class:set_tree(iupTree)
	self.tree = iupTree or  create_tree();
end

function Class:get_tree()
	return self.tree 
end

function Class:set_lbtn(f)
	self.lbtn = type(f) == 'function' and f
end


function Class:set_dlbtn(f)
	self.dlbtn = type(f) == 'function' and f 
end

function Class:set_rbtn(f)
	self.rbtn = type(f) == 'function' and f 
end

function Class:set_rmenu(menu)
	self.Rmenu = type(menu) == 'table' and menu 
end


-----------------------------------------------------------------------------------------
--op callback
function Class:init_lbtn()
	local tree = self.tree
	local function deal_callback(id,number)
		if  type(self.lbtn) == 'function' then 
			self.lbtn(self,id)
		end
	end
	
	function tree:selection_cb(id,number)
		if number == 1 then 
			deal_callback(id,number);
		end
	end
end



function Class:init_dlbtn()
	if not self.tree then return error('Please create tree firstly !') end 
	local tree = self.tree
	local function deal_callback(id)
		local id = self:get_tree_selected() 
		if  type(self.dlbtn) == 'function' then 
			self.dlbtn(self,id)
		end
		
	end

	function tree:button_cb(button,pressed,x,y,str)
		if string_find_(str,"1") and string_find_(str,"D") then
			deal_callback(args)
		end
	end
end

function Class:init_rbtn()
	if not self.tree then return error('Please create tree firstly !') end 
	local tree = self.tree
	local function deal_callback(id)
		self:set_node_marked(id)
		if self.Rmenu then 
			local rmenu = RMenu_.new()
			rmenu:set_data(self.Rmenu)
			return rmenu:show(self,id)
		elseif type(self.rbtn) == 'function' then 
			self.rbtn(self,id)
		end
	end
	function tree:rightclick_cb(id)
		deal_callback(id,args)
	end
end

function Class:set_node_tip(str,id)
	if not self.tree then return error('Please create tree firstly !') end 
	local tree = self.tree
	tree.tip = str
end

		
local cmds_ = {}
cmds_.image = function (self,id,image)  
	if type(image) == 'table' then 
		if image.open then  self:set_expanded_image(image.open,id) end
		if image.close then  self:set_node_image(image.close,id) end
	else 
		self:set_node_image(image,id) 
	end 
end
cmds_.imageExpanded = function (self,id,image)  self:set_expanded_image(image,id) end
cmds_.color = function (self,id,color)  self:set_node_color(color,id) end
cmds_.title = function (self,id,title)   self:set_node_title(title,id) end
cmds_.state = function (self,id,state)  self:set_node_state(state,id) end
cmds_.data = function (self,id,data)  self:set_node_data(data,id) end
cmds_.tip = function (self,id,str)  self:set_node_tip(str,id) end


		
local function set_node_status(self,id,attributes)
	attributes = attributes or {}
	for k,v in pairs(attributes) do 
		if type(cmds_[k]) == 'function' then
			cmds_[k](self,id,v)
		end
	end
end


function Class:set_tree_data(data,id)
	if type(data) ~= 'table' or #data == 0 then return end
	local cur_id = id
	for k,v in ipairs (data) do 
		if not v.attributes then error('Please check data !') return end 
		local t =  v.attributes
		if k == 1 then
			if t.kind and t.kind == 'branch' then
				self:add_branch('',cur_id)
				cur_id = cur_id + 1
				self:set_tree_data(v[1],cur_id)
			else 
				self:add_leaf('',id)
				cur_id = cur_id + 1
			end 
		else 
			if t.kind and t.kind == 'branch' then
				self:insert_branch('',cur_id)	
				cur_id = cur_id + self:get_node_ids(cur_id) + 1
				self:set_tree_data(v[1],cur_id)
			else 
				self:insert_leaf('',cur_id)
				cur_id = cur_id + self:get_node_ids(cur_id) + 1
			end
		end
		set_node_status(self,cur_id,t)
	end
end

function Class:get_tree_datas(id)
	
end


function Class:init_tree_data(data)
	local data = data or self.data
	self:delete_nodes('ALL')
	self:set_tree_data(data,-1)
end

function Class:init_node_data(data,id)
	self:delete_nodes('CHILDREN',id)
	self:set_tree_data(data,id)
end
--]]

---------------------2017年5月22日 update ---------------------------------------------------------
local function get_path_data(path,rule)
	local data =  {}
	function add_data(path)
		local tempt = {}
		tempt.attributes = {title = string_match_(path,'.+/([^/]+)'),kind = 'branch',data = {file = path}}
		tempt[1] = {}
		local pos = 1
		for line in lfs.dir(path) do 
			if line ~= '.' and line ~= '..' then 
				local name = path .. '/' .. line
				local mode = lfs.attributes(name,'mode')
				local status = true
				local t = {}
				if mode == 'directory' then 
					t = add_data(name)
					if status then table_insert_(tempt[1],pos,t) pos = pos +1 end
				else 
					t.attributes = {title = line,kind = 'leaf' ,data = {file = name}}
					 if type(rule) =='function' then 
						status = rule(line,path .. '/',1)
						--print(status)
						if type(status) == 'table' then 
							
							t.attributes.image = status.icon
							t.attributes.tip = status.tip
							t.attributes.title = status.title or t.attributes.title
							for k,v in pairs (status) do
								t.attributes.data[k] = v
							end
						end
					end 
					if status then table_insert_(tempt[1],t) end
				end 
			end
		end 
		return tempt
	end
	table_insert_(data,add_data(path))
	return data
end

--[[
 Class:init_path_data(path,rule,id)
使用示例：
	local tree = require '...'.Class:new(t)
	tree:init_path_data('e:/a/b/c',function(name,path,status) ... end ,	-1	)
	参数说明：
		path： 指定的路径
		rule：函数规则，过滤函数。缺省全部添加（非隐藏文件和文件夹）。
			rule 接受的参数：
				name : 文件或者文件夹的名称。例如：文件：test.lua、文件夹：test
				path ： 文件或者文件夹所在的路径。例如：e:/a/b/c/d/
					path .. name : 该文件的全路径。
				status ： status 值是 1（文件），或者  0（文件夹）。
				rule函数的返回值:
					当函数的返回值非nil和false则认为需要添加该文件到tree中，否则不添加。
					如果返回值是table,table中如果有icon属性，则会定义该节点显示的图标，table中如果有tip属性，则会定义该节点的tip信息。
			id ： 指定某个节点下添加该文件夹。缺省添加在根部。
说明：
	如果对话框没有弹出（界面尚未绘制），则默认作为tree的初始化数据存在。
	如果对话框已经弹出，则根据第三个参数来决定添加新的节点的位置。（如果为nil或者为-1，则认为清空原有数据显示新的数据）
	显示的结果默认按照文件名排序。
--]]
function Class:init_path_data(path,rule,id)
	if type(path) ~= 'string' then return error('Please pass path !') end 
	path = string_gsub_(path,'\\','/')
	if string_sub_(path,-1,-1) == '/' then
		path = string_sub_(path,1,-2)
	end
	if not lfs.attributes(path) then return error('Local folder not exist !') end
	local data = get_path_data(path,rule)
	if self.Map then 
		if not id or id < 0 then 
			self:init_tree_data(data)
		else 
			self:init_node_data(data,id)
		end 
	else
		self.data  = data
	end
end
---------------------------2017年5月23日---------------------------------------------------
--[[
Class:get_selected_path(id)
功能：
	获得选中节点到根节点之间的title 路径信息。
使用示例：
	local tree = require '...'.Class:new(t)
	print(tree:get_selected_path(id))
	参数说明：
		id ： 指定选中节点，缺省会自动获得选中的节点。
	返回值：
		返回一个字符串。示例 : a/b/c.lua
--]]
function Class:get_selected_path(id)
	if not map_warning(self) then return end
	local id = id or self:get_tree_selected()	
	local function get_path(id,str)
		if self:get_node_depth(id) == 0 then 
			return str
		end
		local str = str and ('/' .. str) or ''
		str =  self:get_node_title(id) ..str
		return get_path(self:get_node_parent(id),str)
	end
	return get_path(id)
end

