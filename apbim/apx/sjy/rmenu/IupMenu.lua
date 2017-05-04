
--package.cpath = "?53.dll;?.dll;" .. package.cpath
_ENV = module(...,ap.adv)     --单独测试需要注释掉
require "iuplua"
require "iupluacontrols"
require "imlua"
require "iupluaimglib"
require "iupluaim"
--[[
接口函数：
	create(arg) 创建一个menu的句柄变量，参数是一个数组表用来设置menu中的item；
	create_item(arg) 创建一个item,
	create_submenu(arg) 创建一个多级菜单
	separator() 分隔不同类型item
--]]


--功能： 创建一个menu菜单（一般是右键功能）
--参数：
--		arg （是一个item的数组表）
--return ：所创建的元素的标识符，如果发生错误为空
--arg = {item_1_,item_2_,...} 
function create(arg)
	if type(arg) ~= "table" then return end 
	return iup.menu(arg)
end

--功能： 为菜单创建一个子item
--参数：
--		arg ：是一个表结构，key值title对应的value作为item的title。image可以设置该item显示的图片
--return ：所创建的元素的标识符，如果发生错误为空
--arg = {title = ...,image = ...,...}
--注意：菜单中的每个item也可以设置快捷方式，item的title要显示关联的快捷键如：item_test_ = iup.item{title = "&test\tCtrl+N"} 想要真正的实现快捷功能，需要回调dlg:k_any(c) 如下：
--		function dlg:k_any(c)
--			if c == iup.K_cN then 
--				item_test_:action()
--			end
--		end
function create_item(arg)
	if type(arg) ~= "table" then return end 
	return iup.item(arg)
end

--功能： 为菜单创建一个子级菜单
--参数：
--		arg ：是一个表结构，key值title对应的value作为当前菜单显示的title，数组item作为该菜单的子集菜单项。
--return ：所创建的元素的标识符，如果发生错误为空
--arg = {title = ...,iup.menu{...}}
function create_submenu(arg)
	if type(arg) ~= "table" then return end 
	return iup.submenu(arg);
end

--功能： 一条横线显示的分隔菜单中的item
--参数： 无
--return ：所创建的元素的标识符，如果发生错误为空
function separator()
	return iup.separator{}
end

function refresh_menu(menu)
	iup.Refresh(menu)
end

----------------------------------------------------------------------------------
--














--[[
--测试
item_test_ =  create_item{title = "&test\tCtrl+N",image = "IUP_ActionOk"}
submenu_ =  create_submenu{title = "save",image = "IUP_NavigateRefresh",create{item_test_}}
item_test3_ =  create_item{title = "test3",image = "IUP_NavigateHome"}
local t = {}
menu_ = create{
		submenu_,
		separator();
		item_test3_;
	}

local tree = iup.tree{rastersize = "200x200"}
tree.title0 = "Test"
local dlg = iup.dialog{
	iup.vbox{
		tree;
	};
}


local save_sel_id = 0
function tree:rightclick_cb()
	menu_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end

function tree:selection_cb(id,number)
	if number == 1 then 
		save_sel_id = id
	end
end

function item_test_:action()
	print("item_test_")
end
function item_test3_:action()
	print("item_test3_")
end

function dlg:k_any(c)
	if c == iup.K_cN then 
		item_test_:action()
	end
end
dlg:popup()
--]]
