
--package.cpath = "?53.dll;?.dll;" .. package.cpath -- 单独测试需要取消注释
_ENV = module(...,ap.adv)     --单独测试需要注释掉
require "iuplua"
require "iupluacontrols"
require "iupluaimglib"
--[[
接口函数：
	create(arg)  创建一个tree的句柄变量，参数为表用来设置tree的初始属性；
	add_branch(tree,tid,name) 在传入的节点下创建一个文件夹节点；如果该节点不是文件夹节点，则会在创建一个相邻文件夹节点
	add_leaf(tree,tid,name) 在传入的节点下创建一个文件节点；如果该节点不是文件夹节点，则会在创建一个相邻文件节点
	add_node(tree,tid,name,kind) 根据kind的值来确定创建的类型（文件或者文件夹），只有当kind的值为 "folder"时添加的是文件夹
	insert_branch(tree,tid,name) 在传入的节点同级目录下，在其下添加一个相邻的文件夹节点
	insert_leaf(tree,tid,name)  在传入的节点同级目录下，在其下添加一个相邻的文件节点
	insert_node(tree,tid,name,kind)   在传入的节点同级目录下，在其下添加一个相邻的节点，如果kind有值并且kind的值是“folder”则添加的是文件夹，否则默认添加文件
	delete_all_nodes(tree) 删除控件所有节点
	delete_selected_node(tree,tid) 删除控件中传入的节点和它的所有子节点
	delete_children_node(tree,tid) 删除控件传入的节的所有子节点，该节点不会删除
	delete_marked_nodes(tree) 删除所有mark的节点,
	delete_node(tree,tid,state)   在iup tree控件中根据传入的参数类型进行相应的删除操作， 当state不存在或者值与预定义不一致时，如果tid存在则默认以“SELECTED”方式删除，如果tid不存在则默认以“MARKED”方式删除--
	delete_ids(tree,tids) 删除多个节点 ，tids 节点集合，结构是{id = 1(要删除的节点号),state = （该节点以什么形式删除）;}
	set_folder_addexpanded(tree,str) 定义文件夹是否在创建时就展开显示子节点（全局控制）。无论是否设置，默认值均为“yes”。
	set_folder_expanded(tree,tid) 展开传入的文件夹节点(局部控制)
	set_folder_collapsed(tree,tid) 闭合传入的文件夹节点(局部控制)
	set_folder_state(tree,tid,state) 
	set_root(tree,str) 当tree被绘制（map）时，是否添加一个没有名字的文件夹放在第一个节点上。无论是否设置，默认值均为“yes”。
	set_autoredraw(tree,str) 设置自动更新，如果不想要自动更新，str 值设置为 “no”	set_title(tree,tid,name) 为一个节点设置title或者重命名
	set_node_attribute(tree,tid,t) 设置节点属性表
	set_color(tree,tid,color) 设置节点文字的颜色
	set_file_image_g(tree,image)
	set_file_image_l(tree,tid,image)
	set_file_image(tree,tid,image,str)
	set_folder_image_collapsed_l(tree,tid,image)
	set_folder_image_expanded_l(tree,tid,image)
	set_folder_image_collapsed_g(tree,ImageCollapsed )
	set_folder_image_expanded_g(tree,ImageExpand )
	set_folder_image_g(tree,ImageExpand,ImageCollapsed)
	set_folder_image_l(tree,tid,ImageExpand,ImageCollapsed)
	get_selected_nodes(tree) 获得tree中选中节点的id表集合。
	get_folder_count(tree,tid)
	get_folder_totalcount(tree,tid)
	get_tree_count(tree)
	get_count(tree,tid,str)
	get_node_attribute(tree,tid)
	get_parent_node(tree,tid)
	get_node_title(tree,tid)
	get_node_kind(tree,tid)
	get_node_depth(tree,tid)
	get_node_path_ids(tree,tid)
	get_name_id(tree,tid,name) --获得文件夹下某个名字的节点id
--回调的接口函数
	cb_lclick(tree,f,args) 处理鼠标左键点击tree中某个节点时响应的回调消息,传入tree和 函数f，触发时 会自动调用函数并传值 f(id,number) ,示例请看下方的cb_selection调用,args是用来传递外部数据表
	cb_rclick(tree,f,args) 处理鼠标右键点击tree中某个节点时，自动触发的函数。触发时自动调用函数f(id)。args 用来传递外部数据表
	cb_dlclick(tree,f,args)
	
	cb_branchopen(tree,f,args)
	cb_dragdrop(tree,f,args)
	
	set_tabtitle(tree,tabtitle)
	
	get_title(tree,id)

--]]


--功能： 创建一个tree的控件句柄并返回,可以在创建时为tree附加相应的属性，也可以在创建之后手动设置。
--参数： 
--		arg（参数设置表，tree会根据表内正确的key与值进行设置，未设置则采用默认）
--return ：tree 
--实现：
function create(arg)
	arg = type(arg) == "table" and arg or {}
	return iup.tree(arg) 
end


--功能： 在传入的文件夹节点下创建一个文件夹节点；如果该节点不是文件夹节点，则会在创建一个相邻文件夹节点
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（要添加的节点名称）

--实现：
function add_branch(tree,tid,name)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	tree["ADDBRANCH" .. tid] = name
end 

--功能： 在传入的文件夹节点下创建一个文件节点；如果该节点不是文件夹节点，则会在创建一个相邻文件节点
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（要添加的节点名称）
--实现：
function add_leaf(tree,tid,name)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	tree["ADDLEAF" .. tid] = name
end 

--功能： 根据kind的值来确定创建的类型（文件或者文件夹），只有当kind的值为 "folder"时添加的是文件夹
--参数：
--		tree（控件句柄）、
--		tid （节点id）、
--		name（要添加的节点名称）、
--		kind (要添加的节点类型，文件”file”or文件夹(“folder”),如果kind为nil默认设置添加文件)
--实现：
function add_node(tree,tid,name,kind)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	if kind and kind == "folder" then 
		return add_branch(tree,tid,name)
	else
		return add_leaf(tree,tid,name)
	end
end 

 
 
--功能： 在传入的节点同级目录下，在其下添加一个相邻的文件夹节点
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（要添加的节点名称）
--实现：
function insert_branch(tree,tid,name)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	tree["INSERTBRANCH" .. tid] = name
end 

--功能： 在传入的节点同级目录下，在其下添加一个相邻的文件节点
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（要添加的节点名称）
--return ：true or nil (成功或者失败) 
--实现：
function insert_leaf(tree,tid,name)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	tree["INSERTLEAF" .. tid] = name
end 


--功能： 在传入的节点同级目录下，在其下添加一个相邻的文件节点
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（要添加的节点名称）
--		kind（要添加的节点类型，文件”file”or文件夹(“folder”),如果kind为nil默认设置添加文件）
--实现：
function insert_node(tree,tid,name,kind)
	if not tree or not tid or not name then error("Missing parameter !") return end 
	if kind and kind == "folder" then
		return insert_branch(tree,tid,name)
	else
		return insert_leaf(tree,tid,name)
	end
end 


--功能： 删除控件所有节点
--参数：
--		tree（控件句柄）、
--实现：
function delete_all_nodes(tree)
	if not tree then error("Missing parameter !") return end 
	tree["DELNODE"] = "ALL"
end

--功能： 删除控件中传入的节点和它的所有子节点
--参数：
--		tree（控件句柄）、
--		tid  （节点id）;
--实现：
function delete_selected_node(tree,tid)
	if not tree or not tid  then error("Missing parameter !") return end 
	tree["DELNODE" .. tid] = "SELECTED"
end


--功能： 删除控件传入的节的所有子节点，该节点不会删除
--参数：
--		tree（控件句柄）、
--		tid  （节点id）;
--实现：
function delete_children_node(tree,tid)
if not tree or not tid  then error("Missing parameter !") return end 
	tree["DELNODE" .. tid] = "CHILDREN"
end

--功能： 删除所有mark的节点,
--参数：
--		tree（控件句柄）、
--实现：
function delete_marked_nodes(tree)
if not tree  then error("Missing parameter !") return end 
	tree["DELNODE"] = "MARKED"
end 

--功能： 在iup tree控件中根据传入的参数类型进行相应的删除操作， 当state不存在或者值与预定义不一致时，如果tid存在则默认以“SELECTED”方式删除，如果tid不存在则默认以“MARKED”方式删除--
--参数
--		tree （控件句柄）;
--		tid  （节点id）;
--		state (删除的方式);
--state: "MARKED"、"CHILDREN"、"ALL"、"SELECTED" 
--实现：
function delete_node(tree,tid,state)
	if not tree  then error("Missing parameter !") return end 
	local delete_node_ = {
		["MARKED"] = delete_marked_nodes,
		["CHILDREN"] = delete_children_node,
		["SELECTED"] = delete_selected_node,
		["ALL"] = delete_all_nodes,
	}
	if state and type(state) == "string" and delete_node_[string.upper(state)]  then
		delete_node_[string.upper(state)](tree,tid)
	else 
		if tid then 
			delete_node_.SELECTED(tree,tid)
		else 
			delete_node_.MARKED(tree)
		end
	end
end


--功能： 删除多个id集合的节点
--参数： 
--		tree （控件句柄变量）、
--		tids （要删除的节点id，结构是{id = 1(要删除的节点号),state = （该节点以什么形式删除）;}）
--实现：
function delete_ids(tree,tids)
	if not tree then error("Missing parameter !") return end 
	if type(tids) == "table" then 
		table.sort(tids,function(a,b) return tonumber(a.id) > tonumber(b.id) end) --删除时需要对节点进行从大到小排序，便于从高节点开始删。
		for k,v in ipairs (tids) do 
			delete_node(tree,v.id,v.state)
		end
	end
end


--功能： 定义文件夹是否在创建时就展开显示子节点（全局控制）。无论是否设置，默认值均为“yes”。
--参数：
--		tree（控件句柄）、
--		str（类型）、str的值如果不等于“no”，那么缺省为“yes”
--实现：
function set_folder_addexpanded(tree,str)
	if not tree  then error("Missing parameter !") return end 
	tree["ADDEXPANDED"] = (type(str) == "string" and string.upper(str) == "NO") and "NO" or "YES"
end


--功能： 展开传入的文件夹节点(局部控制)
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--实现：
function set_folder_expanded(tree,tid)
	if not tree or not tid   then error("Missing parameter !") return end 
	tree["STATE" .. tid] = "EXPANDED"	
end 


--功能： 闭合传入的文件夹节点(局部控制)

--参数：
--		tree（控件句柄）、
--		tid（节点id）、

--实现：
function set_folder_collapsed(tree,tid)
	if not tree or not tid   then error("Missing parameter !") return end 
	tree["STATE" .. tid] = "COLLAPSED"	
end


--功能： 在iup tree控件中展开某个文件夹节点，默认展开。(局部控制)
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		state（缺省展开，只有当值为“COLLAPSED”（大小写均可）,时才闭合文件夹节点）
--state : "EXPANDED"、"COLLAPSED";
--实现：
function set_folder_state(tree,tid,state)
	if not tree or not tid   then error("Missing parameter !") return end 
	local set_state_ = {
			["EXPANDED"] = set_folder_expanded;
			["COLLAPSED"] = set_folder_collapsed
		}
	if  type(state) == "string" and set_state_[string.upper(state)] then 
		tree["STATE" .. tid] = string.upper(state)
	else
		set_state_.EXPANDED(tree,tid)
	end
end 


--功能： 当tree被绘制（map）时，是否添加一个没有名字的文件夹放在第一个节点上。无论是否设置，默认值均为“yes”。
--参数：
--		tree（控件句柄）、
--		str（类型）、str的值如果不等于“no”，那么缺省为“yes”
--实现：
function set_root(tree,str) 
	if not tree  then error("Missing parameter !") return end 
	tree["ADDROOT"] = (type(str) == "string" and string.upper(str) == "NO") and "NO" or "YES"
end

--功能： 设置自动更新tree的节点变动。无论是否设置，默认值均为“yes”。
--参数：
--		tree（控件句柄）、
--		str（类型）、str的值如果不等于“no”，那么缺省为“yes”
--实现：
function set_autoredraw(tree,str)
	if not tree  then error("Missing parameter !") return end 
	tree["AUTOREDRAW"] =(type(str) == "string" and string.upper(str) == "NO")and "NO"or "YES"
end

function set_marked(tree,tid,kind)
	if not tree or not tid then  error("Missing parameter !")  return end 
	tree["MARKED" .. tid] = kind or "NO"
end


--功能： 在iup tree控件中修改节点名称
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		name（修改后的名称）
--实现：
function set_title(tree,tid,name)
	if not tree or not tid or not name   then error("Missing parameter !") return end 
	tree["TITLE" .. tid] = name
end


--功能：设置tree中当前节点属性表
--参数：
--		tree（控件句柄）、
--		tid  (节点id)、
--		t    (属性表)
--实现：
function set_node_attribute(tree,tid,t)
	if not tree or not tid then error("Missing parameter !") return end 
	iup.TreeSetUserId(tree,tid,t)
end

--功能： 在iup tree控件中修改节点title的颜色
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		color（修改后显示的颜色）
--color = {r = 0,g = 0,b = 0} or color = "R G B"(iup默认的是字符串形式的值)
--return ：true or nil (成功或者失败) 
--实现：
function set_color(tree,tid,color)
	if not tree or not tid or not color  then error("Missing parameter !") return end 
	local r,g,b;
	if type(color) == "table" then 
		r,g,b = color.r ,color.g ,color.b 
	elseif type(color) == "string" then 
		r,g,b = string.match(color,"(%d+)%s+(%d+)%s+(%d+)")
	end
	r,g,b = r or 0 ,g or 0,b or 0
	tree["COLOR" .. tid] = "" .. r .. " " .. g .. " " .. b
end


--功能： 在iup tree控件中修改所有的leaf节点的图片(全局控制)
--参数：
--		tree（控件句柄）、
--		image （leaf显示的图片）
--return ：true or nil (成功或者失败) 
--注意：如果某个节点单独的被设置了某个image，则在设置时略过被设置过的节点。
--实现：
function set_file_image_g(tree,image)
	if not tree  then error("Missing parameter !") return end 
	tree.IMAGELEAF = image or "IMGLEAF"
	return true 
end

function set_image(tree,id,image)
	tree["IMAGE" .. id] = image
end


--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image（需要借助相应的库）(局部控制)
--功能： 在iup tree控件中修改文件节点显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_file_image_l(tree,tid,image)
	if not tree or not tid  then error("Missing parameter !") return end 
	if image then tree["IMAGE" .. tid] = image end
end

--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image（需要借助相应的库）(局部控制)
--功能： 在iup tree控件中修改文件节点显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--		str（值存在并且首字母带g则调用全局控制图片函数，否则调用局部控制函数）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_file_image(tree,tid,image,str)
	if not tree then error("Missing parameter !") return end 
	if str and string.sub(string.lower(str),1,1) == "g"  then
		set_file_image_g(tree,image)
	else
		set_file_image_l(tree,tid,image)
	end
end


--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image.(局部控制)
--功能： 在iup tree控件中修改文件夹节点闭合时显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_folder_image_collapsed_l(tree,tid,image)
	if not tree or not tid  then error("Missing parameter !") return end 
	if image then tree["IMAGE" .. tid] = image end
end

--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image.(局部控制)
--功能： 在iup tree控件中修改文件节点展开时显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_folder_image_expanded_l(tree,tid,image)
	if not tree or not tid  then error("Missing parameter !") return end 
	if image then tree["IMAGEEXPANDED" .. tid] = image end
end

--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image.(全局默认设置)
--功能： 在iup tree控件中修改文件夹节点闭合时显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_folder_image_collapsed_g(tree,ImageCollapsed )
	if not tree  then error("Missing parameter !") return end 
	tree.IMAGEBRANCHCOLLAPSED = ImageCollapsed or "IMGCOLLAPSED"
end


--设置图片，既可以使用本地磁盘上的图片，也可以使用iup库中提供的image.(全局默认设置)
--功能： 在iup tree控件中修改文件节点展开时显示的图片
--参数：
--		tree（控件句柄）、
--		tid（节点id）、
--		image（修改后节点的图片）
--image参数除了可以接收本地路径文件，还可以调用iup中image库（首先需要加载想用的库）如下：
--	require "iupluaimglib"
--实现：
function set_folder_image_expanded_g(tree,ImageExpand )
	if not tree  then error("Missing parameter !") return end 
	tree.IMAGEBRANCHEXPANDED = ImageExpand or "IMGEXPANDED"
end


--功能： 在iup tree控件中修改所有的branch节点的图片
--参数：
--		tree（控件句柄）、
--		ImageExpand（展开branch节点显示的图片）
--		ImageCollapsed （闭合branch时显示的图片）
--return ：true or nil (成功或者失败) 
--注意：如果某个节点单独的被设置了某个image，则在设置时略过被设置过的节点。
--实现：
function set_folder_image_g(tree,ImageExpand,ImageCollapsed)
    if not tree  then error("Missing parameter !") return end 
    if ImageExpand then set_folder_image_expanded_g(tree,ImageExpand ) end
    if ImageCollapsed then set_folder_image_collapsed_g(tree,ImageCollapsed) end 
end

--功能： 在iup tree控件中修改所有的branch节点的图片
--参数：
--		tree（控件句柄）、
--		ImageExpand（展开branch节点显示的图片）
--		ImageCollapsed （闭合branch时显示的图片）
--return ：true or nil (成功或者失败) 
--注意：如果某个节点单独的被设置了某个image，则在设置时略过被设置过的节点。
--实现：
function set_folder_image_l(tree,tid,ImageExpand,ImageCollapsed)
    if not tree or not tid  then error("Missing parameter !") return end 
   	if ImageExpand then set_folder_image_expanded_l(tree,tid,ImageExpand ) end
    if ImageCollapsed then set_folder_image_collapsed_l(tree,tid,ImageCollapsed) end 
end


--功能：获得tree中选中的所有节点id
--参数：
--		tree（控件句柄）、
--return ：ids，返回值是一个id数组表,形如：ids = {1,4,9,...}
--实现：
function get_selected_nodes(tree)
	if not tree  then error("Missing parameter !") return end 
	local str = tree.MARKEDNODES
	local ids = {}
	for i = 1,#str do 
		if string.sub(str,i,i) == "+" then
			table.insert(ids,i-1)
		end
	end
	return ids
end

--功能：获得tree中选中文件夹节点的子节点的数目（不包含更深层级）
--参数：
--		tree（控件句柄）、
--		tid  (节点id)、
--return : 返回值是一个number值，子节点的个数。 
--实现：
function get_folder_count(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return tonumber(tree["childcount" .. tid])
end


--功能：获得tree中选中文件夹节点所有子节点的数目（包含更深层级）
--参数：
--		tree（控件句柄）、
--		tid  (节点id)、
--return : 返回值是一个number值，子节点的个数。 
--实现：
function get_folder_totalcount(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return tonumber(tree["totalchildcount" .. tid])
end

--功能：获得tree中节点的总数
--参数：
--		tree（控件句柄）、
--return : 返回值是一个number值，节点的个数。 
--实现：
function get_tree_count(tree)
	if not tree then error("Missing parameter !") return end 
	return tonumber(tree.count)
end

--功能：获得tree中根据不同情况节点的个数
--参数：
--		tree（控件句柄）、
--return : 返回值是一个number值，节点的个数。 
--实现：
function get_count(tree,tid,str)
	if not tree then error("Missing parameter !") return end 
	if tid then 
		if str == "total" then 
			return get_folder_totalcount(tree,tid)
		else
			return get_folder_count(tree,tid)
		end
	else 
		return get_tree_count(tree)
	end
end

--功能：获得tree中当前节点属性表
--参数：
--		tree（控件句柄）、
--		tid  (节点id)、
--return ：该节点的所附带的属性表，值可能为nil（当前节点未被赋值过）。
--实现：
function get_node_attribute(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return iup.TreeGetUserId(tree,tid)
end

function get_parent_node(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return tonumber(tree["parent" .. tid])
end

function get_node_kind(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return (tree["KIND" .. tid])
end

function get_node_title(tree,tid)
	if not tree or not tid then error("Missing parameter !") return end 
	return tree["TITLE" .. tid]
end


function get_node_depth(tree,tid)
	return tonumber(tree["DEPTH" .. tid])
end

function get_node_path_ids(tree,tid,ids)
	local ids = ids or {}
	if tonumber(tid) == 0 then 
		table.insert(ids,1,tid)
		return ids
	else 
		table.insert(ids,1,tid)
		return get_node_path_ids(tree,get_parent_node(tree,tid),ids)
	end 
end

function get_name_id(tree,tid,name)
	local nums = get_folder_count(tree,tid)
	local curid = tid + 1
	for i =1,nums do 
		if get_node_title(tree,curid) == name then 
			return curid
		end 
		curid = curid + 1 + get_folder_totalcount(tree,curid)
	end
end

--功能：处理鼠标左键单击tree中某个节点时，自动触发的回调函数。
--参数：
--   	tree （控件句柄）
--		f    （自己想要处理的函数）
--		args   (数据表，向回调函数中传入想要处理的数据封装到一个表中自行处理)
--注意：
--		想要使用该函数需要在对话框弹出前，初始化调用。
--		该函数接收两个参数一个是tree（句柄），一个是用来处理自己程序的函数f
--		传入的函数f需要待接收两个参数，id（返回给你选中的节点id）、number（值是1 或者 0，选中和非选中状态）
--		在触发回调时，会自动调用函数f并传值id和number。
--实现：
function cb_lclick(tree,f,args)
	function tree:selection_cb(id,number)
		f(id,number,args);
	end
end

--功能：处理鼠标右键单击tree中某个节点时，自动触发的回调函数。
--参数：
--   	tree （控件句柄）
--		f    （自己想要处理的函数）
--		args   (数据表，向回调函数中传入想要处理的数据封装到一个表中自行处理)
--注意：
--		想要使用该函数需要在对话框弹出前，初始化调用。
--		该函数接收两个参数一个是tree（句柄），一个是用来处理自己程序的函数f
--实现：
function cb_rclick(tree,f,args)
	function tree:rightclick_cb(id)
		f(id,args)
	end
end

--功能：处理鼠标选中节点并双击鼠标左键时自动触发的回调函数。
--参数：
--   	tree （控件句柄）
--		f    （自己想要处理的函数）
--		args   (数据表，向回调函数中传入想要处理的数据封装到一个表中自行处理)
--注意：
--		想要使用该函数需要在对话框弹出前，初始化调用。
--		该函数接收两个参数一个是tree（句柄），一个是用来处理自己程序的函数f
--实现：
function cb_dlclick(tree,f,args)
	function tree:button_cb(button,pressed,x,y,str)
		if string.find(str,"1") and string.find(str,"D") then
			f(args)
		end
	end
end




function cb_branchopen(tree,f,args)
	function tree:branchopen_cb(id)
		f(id,args)
	end
end


function cb_dragdrop(tree,f,args)
	function tree:dragdrop_cb(drag_id, drop_id, isshift, iscontrol)
		drag_id = tonumber(drag_id)
		drop_id = tonumber(drop_id)
		f(drag_id,drop_id,args,isshift,iscontrol)
	end
end

--根据节点的title查找在传入tid下的节点id值
function get_tree_id(tree,tid,name)

end


function set_tabtitle(tree,tabtitle)
	tree.TABTITLE  = tabtitle
end


function get_title(tree,tid)
	if not tree or not tid   then error("Missing parameter !") return end 
	return tree["TITLE" .. tid]
end

function set_rastersize(tree,rastersize)
	tree.rastersize = rastersize
end



--[[

-- 测试用例
item_add_ = iup.item{title = "Add"}
item_add_branch_ = iup.item{title = "Add Branch"}
item_add_leaf_ = iup.item{title = "Add Leaf"}
item_insert_ = iup.item{title = "Insert"}
item_insert_branch_ = iup.item{title = "Insert Branch"}
item_insert_leaf_ = iup.item{title = "Insert Leaf"}
item_delete_ = iup.item{title = "Delete"}
item_delete_nodes_ = iup.item{title = "Delete Nodes"}
item_set_title_ = iup.item{title = "Set title"}
item_set_state_ = iup.item{title = "Set state"}
item_color_ = iup.item{title = "Color"}
item_set_image_ = iup.item{title = "Set Image"}
item_set_branches_ = iup.item{title = "set branches image"}
item_set_leaf_ = iup.item{title = "set leaves image"}
--iup.SetAttribute(item_add_, "IMAGE", "IUP_FileNew");
--item_test_ = iup.item{title = "&Test\tCtrl+N"}
item_get_select_nodes_ = iup.item{title = "Get Select Nodes"}
item_get_node_path_ = iup.item{title = "Get Node Path"}
item_get_son_count_ = iup.item{title = "Get Son Count"}
item_get_total_son_count_ = iup.item{title = "Get total Son Count"}
item_get_son_nodes_ = iup.item{title = "Get Son Nodes"}
item_get_total_son_nodes_ = iup.item{title = "Get total Son Nodes"}
menu_ = iup.menu{
	item_add_;
	item_add_branch_;
	item_add_leaf_;
	item_insert_;
	item_insert_branch_;
	item_insert_leaf_;
	iup.separator{};
	item_delete_;
	item_delete_nodes_;
	iup.separator{};
	item_set_title_;
	item_set_state_;
	iup.separator{};
	item_color_;
	iup.separator{};
	item_set_image_;
	item_set_branches_;
	item_set_leaf_;
	iup.separator{};
	item_get_select_nodes_;
	item_get_node_path_;
	iup.separator{};
	item_get_son_count_;
	item_get_total_son_count_;
	item_get_son_nodes_;
	item_get_total_son_nodes_;
--	item_test_;
} 

local tree = iup.tree{rastersize = "200x200"}
tree.title0 = "Test"
tree.MARKMODE="MULTIPLE"
local dlg = iup.dialog{
 		iup.vbox{
			tree;
		};
 }

local save_sel_id = 0
local function rightclick(id)
	menu_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end
local function deal_select(id,number)
	if number == 1 then
		save_sel_id = id
	end
end

cb_rightclick(tree,rightclick)
cb_selection(tree,deal_select)

function item_add_branch_:action()
	add_branch(tree,save_sel_id,self.title)
end
function item_add_leaf_:action()
	add_leaf(tree,save_sel_id,self.title)
end
function item_insert_leaf_:action()
	insert_leaf(tree,save_sel_id,self.title)
end

function item_insert_branch_:action()
	insert_branch(tree,save_sel_id,self.title)
end
function item_add_:action()
	add_node(tree,save_sel_id,self.title,"BRANCH")
	add_node(tree,save_sel_id,self.title)
end
function item_insert_:action()
	insert_node(tree,save_sel_id,self.title,"BRANCH")
	insert_node(tree,save_sel_id,self.title)
end

function item_delete_:action()
	delete_node(tree,save_sel_id)
end

function item_delete_nodes_:action()
	local t = {}
	local ids = get_select_nodes(tree)
	delete_nodes(tree,ids)
end

function item_set_title_:action()
	set_title(tree,save_sel_id,"Set Title")
end
function item_set_state_:action()
	set_state(tree,save_sel_id,"EXPANDED")
end

function item_color_:action()
	set_color(tree,save_sel_id,"10 200 140")
end

function item_set_image_:action()
	set_image(tree,save_sel_id,"D:\\image\\image\\File.bmp")
end

function item_set_branches_:action()
	set_branch_image(tree,nil,"D:\\image\\image\\folder.bmp")
end

function item_set_leaf_:action()
	--set_leaf_image(tree,"IMGBLANK")
	--set_leaf_image(tree,"IMGPAPER")
	--set_leaf_image(tree,"IUP_FileOpen")
	set_leaf_image(tree,"IUP_EditPaste")
	--set_leaf_image(tree,"D:\\image\\image\\File.bmp")
end


function item_get_select_nodes_:action()
	local ids = get_select_nodes(tree)
	for k,v in ipairs (ids) do
		print(v)
	end
end

function item_get_node_path_:action()
	print(save_sel_id)
	print(get_node_path(tree,save_sel_id,0))
end

function item_get_son_count_:action()
	print(get_son_count(tree,save_sel_id))
end
function item_get_total_son_count_:action()
	print(get_total_son_count(tree,save_sel_id))
end
function item_get_son_nodes_:action()
	local t = get_son_nodes(tree,save_sel_id)
	for k,v in ipairs (t) do 
		print(v)
	end
end
function item_get_total_son_nodes_:action()
	local t = get_total_son_nodes(tree,save_sel_id)
	for k,v in ipairs (t) do 
		print(v)
	end
end
--[==[
function item_test_:action()
	print("here")
end

function dlg:k_any(c)
	if c == iup.K_cN then 
		item_test_:action()
	end
end
--]==]
dlg:popup()
 
--]]
 
 
 
 
 
 
 
