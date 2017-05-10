--[[
Author:sjy
Date： 2017年2月23日
Description：

	调整菜单样式；
	可以将调整后的样式保存；
interface:

	pop(arg)
		Call example: require 'dlg_menu'.pop{data = InputDataTable,on_ok = function(AcceptDataTable) ... end}
			
--]]

---------------------------------------------------------------------
local require = require
local ipairs = ipairs
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local string = string
local table = table
local io = io
local os = os
local print = print
local type = type
local next_ = _G.next


---------------------------------------------------------------------
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
-- _ENV = module(...)
---------------------------------------------------------------------
-- require "iup_dev"
local iup = require "iuplua"
require "iupluaimglib"
local separator_ = '$(Separator)$'
local default_name_ = 'CURRENT_MENU_STYLE'
local loads_;

--------------------------------------------------------------------
-- init controls
local function set_button_attribute(arg)
	return {
		title = arg.title;
		rastersize = arg.wid or '100x';
		image = arg.image;
	}
end

local function set_text_attribute(arg)
	return {
		alignment = arg.alignment;
		rastersize = arg.wid or '150x';
		expand = arg.expand or 'HORIZONTAL';
		FILTER = arg.filter;
	}
end

local function set_filedlg_attribute(arg)
	return {
		dialogtype = arg.type or 'Open';
		rastersize = arg.wid or '400x400';
		DIRECTORY =arg.path or path_;
	}
end

local function set_item_attribute(arg)
	return {
		title = arg.title or 'Test';
	}
end 

local tree_right_ = iup.tree{rastersize = '250x400';SHOWDRAGDROP=  'yes';IMAGELEAF='IMGPAPER'}
local tree_left_ = iup.tree{rastersize = '250x400',IMAGELEAF='IMGPAPER'}

local btn_delete_ = iup.button(set_button_attribute{title = 'Delete',})
local btn_save_ = iup.button(set_button_attribute{title = 'SaveAs',})
local btn_ok_ = iup.button(set_button_attribute{title = 'Ok'})
local btn_help_ = iup.button(set_button_attribute{title = 'Help'})
local btn_cancel_ = iup.button(set_button_attribute{title = 'Cancel'})
local btn_left_ = iup.button(set_button_attribute{image = "IUP_ArrowLeft",wid = '30x'})
local btn_right_ = iup.button(set_button_attribute{image = "IUP_ArrowRight",wid = '30x'})

local list_ = iup.list{expand = 'HORIZONTAL',rastersize = 'x100',SHOWIMAGE='Yes';}

local txt_name_ = iup.text(set_text_attribute{filter = 'LOWERCASE',})

local filedlg_ = iup.filedlg(set_filedlg_attribute{title = 'Save File',type = 'Save'})

local item_list_delete_ = iup.item(set_item_attribute{title = 'Delete'})
local item_list_rename_ =  iup.item(set_item_attribute{title = 'Rename'})
local item_tree_add_ =  iup.item(set_item_attribute{title = 'Add Menu'})
local item_tree_insert_ =  iup.item(set_item_attribute{title = 'Insert Menu'})
local item_tree_rename_ =  iup.item(set_item_attribute{title = 'Rename'})
local item_tree_delete_ =  iup.item(set_item_attribute{title = 'Delete'})
local item_tree_add_sep_= iup.item(set_item_attribute{title = 'Add Separator'})
local item_turn_ = iup.item(set_item_attribute{title = 'Loading'})

local temp_btn_ok_ = iup.button(set_button_attribute{title = 'Ok'})
local temp_btn_cancel_ = iup.button(set_button_attribute{title = 'Cancel'})
local temp_txt_change_ = iup.text(set_text_attribute{})
--------------------------------------------------------------------
local menu_list_ = iup.menu{item_list_delete_;item_list_rename_;}
local menu_tree_right_ = iup.menu{
	item_tree_add_;
	item_tree_insert_;
	item_tree_add_sep_;
	iup.separator{},
	item_tree_rename_;
	item_tree_delete_;
}
local menu_tree_left_ = iup.menu{
	item_turn_;
}

local temp_dlg_ = iup.dialog{
	iup.vbox{
		iup.hbox{temp_txt_change_};
		iup.hbox{temp_btn_ok_,temp_btn_cancel_};
		margin = '0x2';
		alignment = 'ARIGHT';
	};
	rastersize = '400x';
	title = 'Change';
};

local frame_tree_ ;
local frame_list_ ;
local dlg_;

local function init_frame()
	frame_tree_ = iup.frame{
			iup.vbox{
				iup.hbox{
					tree_left_,
					iup.vbox{
						iup.fill{};
						btn_right_;
						iup.fill{};
						btn_left_;
						iup.fill{};
					};
					tree_right_;
				};
				alignment = 'ARIGHT';
				margin = '5x5';
			};
			title = 'Setting Menu Style';
		}
		
	frame_list_ = iup.frame{
		list_;
		title = 'Save History Style';
		alignment = 'ACENTER';
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{frame_tree_;};
				iup.hbox{txt_name_,btn_save_,btn_delete_,btn_ok_,btn_cancel_};
				iup.hbox{frame_list_;};
				alignment = 'ARIGHT';
				margin = "10x5";
			};
			title = 'Menu Data';
			resize = 'NO';
		}
end

--------------------------------------------------------------------
local function table_is_empty(t)
	return next_(t) == nil
end

--------------------------------------------------------------------
-- control base op

--arg = {id,name,tree}--添加
local function add_branch_node(arg)
	local tree = arg.tree or tree_right_
	tree['addbranch' .. arg.id] = arg.name
end
--arg = {tree,id,name}
local function add_leaf_node(arg)
	local tree = arg.tree or tree_right_
	tree['addleaf' .. arg.id] = arg.name
end
--arg = {tree,id,name} --插入
local function ins_branch_node(arg)
	local tree = arg.tree or tree_right_
	tree['insertbranch' .. arg.id] = arg.name
end
--arg = {tree,id,name}
local function ins_leaf_node(arg)
	local tree = arg.tree or tree_right_
	tree['insertleaf' ..  arg.id] = arg.name
end

--arg = {id,tree}
local function delete_node(arg)
	local tree = arg.tree or tree_right_
	tree['delnode' .. arg.id] = arg.type or 'SELECTED'
end

--arg= {tree,id,attribute}
local function set_node_attribute(arg)
	local tree = arg.tree or tree_right_
	iup.TreeSetUserId(tree,arg.id,arg.attribute)
end

--arg= {tree,id}
local function get_node_userdata(arg)
	local tree = arg.tree or tree_right_
	return iup.TreeGetUserId(tree,arg.id)
end

local function get_node_totalcount(arg)
	local tree = arg.tree or tree_right_
	return  tonumber(tree['totalchildcount' .. arg.id])
end 

local function get_node_count(arg)
	local tree = arg.tree or tree_right_
	return  tonumber(tree['childcount' .. arg.id])
end 

local function get_tree_count(tree)
	return tonumber(tree.count)
end

local function get_node_kind(arg)
	local tree = arg.tree or tree_right_
	return  string.lower(tree['kind' .. arg.id])
end 

local function get_node_parent_id(arg)
	local tree = arg.tree or tree_right_
	return  tonumber(tree['parent' .. arg.id])
end 

local function get_node_title(arg)
	local tree = arg.tree or tree_right_
	return  tree['title' .. arg.id]
end 

local function set_node_title(arg)
	local tree = arg.tree or tree_right_
	tree['title' .. arg.id] = arg.name
end 

local function get_node_attribute(arg)
	local data = get_node_userdata(arg)
	if not arg.key then return data end 
	return data[arg.key]
end 

local function set_node_color(arg)
	local tree = arg.tree or tree_right_
	tree['color' .. arg.id] = arg.color
end

local function get_node_depth(arg)
	local tree = arg.tree or tree_right_
	return tonumber(tree['depth' .. arg.id])
end

local function  get_node_states(arg)
	local tree = arg.tree or tree_right_
	return tree['STATE' .. arg.id]
end

local function  set_node_states(arg)
	local tree = arg.tree or tree_right_
	tree['STATE' .. arg.id] =arg.states or 'EXPANDED'
end

local function  set_node_marked(arg)
	local tree = arg.tree or tree_right_
	tree['marked' .. arg.id] =arg.states or 'yes'
end

local function move_node(arg)
	local tree = arg.tree or tree_right_
	tree['MOVENODE' .. arg.drag_id] =  arg.drop_id
end

local function  ins_list_item(arg)
	list_['INSERTITEM' .. arg.id] = arg.name
end

local function append_list_item(name)
	list_.appenditem = name
end

local function set_item_image(arg)
	list_['image' .. arg.id] =arg.image or 'IUP_MessageInfo'
end

--------------------------------------------------------------------
--获取对话框右边的树控件上的数据
local function get_right_tree_data(id,data)
	local id  = id or 0
	local data = data or  {}
	local cur_id = id + 1
	for i=1,get_node_count{tree =tree_right_ ,id = id} do
		local t = {}
		t.name =  get_node_title{tree =tree_right_ ,id = cur_id}
		if get_node_kind{tree =tree_right_ ,id = cur_id} == 'branch' then 
			t.subs =  {}
			get_right_tree_data(cur_id,t.subs)
		else
			local cur_t = get_node_attribute{tree =tree_right_ ,id = cur_id}or {}
			t.keyword =  cur_t.keyword
			if not cur_t or  not cur_t.name or cur_t.name == '' then 
				t.name  = nil
			end 
		end
		table.insert(data,t)
		cur_id = cur_id + 1 + get_node_totalcount{tree =tree_right_ ,id = cur_id}
	end
	return data
end

-- 设置对话框右边树的数据
local function set_right_tree_data(tree,data,id)
	local cur_id = id
	for k,v in ipairs(data) do 
		local name,subs,keyword =v.name,  v.subs,v.keyword
		if not name or name == '' then name = separator_ end
		if k ==1  then 
			if subs then 
				add_branch_node{tree =tree,id =cur_id,name =  name}
				set_right_tree_data(tree, subs,cur_id+1)
			else 
				add_leaf_node{tree =tree,id =cur_id,name =  name}
				
				set_node_attribute{tree =tree,id = cur_id+1,attribute = v}
			end
			cur_id = cur_id + 1
		else 
			local tempid;
			if subs then 
				ins_branch_node{tree =tree,id = cur_id,name = name}
				tempid = cur_id + 1 +  get_node_totalcount{tree =tree,id = cur_id}
				set_right_tree_data(tree,subs,tempid)
			else 
				ins_leaf_node{tree =tree,id = cur_id,name = name}
				tempid = cur_id + 1 +  get_node_totalcount{tree =tree,id = cur_id}
				set_node_attribute{tree =tree,id = tempid,attribute = v}
			end
			cur_id = tempid;
		end
		
	end 
end

-- 设置对话框左边树的数据
local function set_left_tree_data(tree,data,id)
	local cur_id = id
	local num =0
	for k,v in pairs (data) do 
		num = num+1
		if num  == 1 then 
			add_leaf_node{tree =tree,id =cur_id,name = v.name}
		else 
			ins_leaf_node{tree =tree,id =cur_id,name = v.name}
		end 
		cur_id = cur_id + 1
		set_node_attribute{tree = tree,attribute = v,id = cur_id}
	end 
	
end

-- 对话框右边树的初始化：去除所有存在的节点，添加根节点，设置数据
local function init_right_tree_data(arg)
	local data = arg.data 
	if data then 
		delete_node{tree =tree_right_, id = 0}
		add_branch_node{tree =tree_right_,id = -1,name =  'Menus'}
		set_right_tree_data(tree_right_,data,0)
	end 
end

-- 获取右边树每个leaf节点上附着的属性keyword对应节点id的数据表. keys = {keword = {id = id},keword = {id = id},}
local function get_keyword_index(tree)
	local tree =tree or tree_right_
	local count =  get_tree_count(tree)  - 1
	local keys = {}
	for id = 1, count do 
		if get_node_kind{tree=tree,id = id} == 'leaf' then 
			local t = get_node_attribute{tree= tree,id = id} 
			if t and t.keyword then 
				keys[t.keyword] = {id = id}
			end 
		end 
	end 
	return keys
end 

-- 设置样式表中存在app已经被移除的节点项的状态
local function set_removed_states(keys)
	if table_is_empty(keys) then return end 
	for k,v in pairs (keys) do 
		set_node_color{tree = tree_right_,id = v.id,color = '100 100 100'}
	end 
end 

-- 初始化显示时，根据右边树（样式表中存在的keyword）的内容来区分已经加载的和未加载的数据表，用来处理左边树的数据。
local function get_loaded_data(data,keys)
	local loaded,unloaded= {},{};
	for k,v in pairs (data) do 
		if keys[k] then 
			loaded[k] = v
		else 
			unloaded[k] = v
		end
		keys[k] = nil
	end 
	set_removed_states(keys)
	return loaded,unloaded
end 

-- 初始化对话框中左面树
local function init_left_tree(arg)
	local data = arg.data
	if data then
		delete_node{tree =tree_left_, id = 0}
		add_branch_node{tree =tree_left_,id = -1,name =  'Keywords'}
		add_branch_node{tree =tree_left_,id = 0,name =  'Loaded'}
		add_branch_node{tree =tree_left_,id = 0,name =  'Waiting Load'}
		local loaded,unloaded = get_loaded_data(data,get_keyword_index())
		set_left_tree_data(tree_left_,loaded,2)
		set_left_tree_data(tree_left_,unloaded,1)
	end 
end

-- 初始化list 控件的显示内容
local function init_list_data(arg)
	list_[1] = nil
	append_list_item(default_name_)
	set_item_image{id = 1}
	local nums = 1 
	if arg.styleFiles then 
		for k,v in pairs (arg.styleFiles) do 
			nums = nums + 1
			list_.appenditem = v.name
			set_item_image{id = nums,image = "IUP_FileSave"}
		end
	end 
	list_.value =1
end

-- 初始化tree控件的数据（总控两棵树，必须先初始化右边的，这样才能根据右边的样式表数据判断左边的数据哪个是当前加载的哪些是未加载的）
local function init_tree_data(arg)
	init_right_tree_data{data = arg.menuStyle}
	init_left_tree{data = arg.menuData}
end

--初始化右键add rename时弹出的附加的对话框的按键功能
local function action_temp_dlg(arg)
	
	function temp_btn_cancel_:action()
		temp_dlg_:hide()
	end
		
	function temp_btn_ok_:action()
		local name = temp_txt_change_.value
		if name and name ~= ''  then 
			if type(arg.on_ok) == 'function' then 
				arg.on_ok(name)
			end
			temp_dlg_:hide()
		else 
			iup.Message('Notice','Please enter text !')
		end
	end
end

-- 弹出临时对话框
local function pop_temp_dlg(arg)
	action_temp_dlg(arg)
	temp_txt_change_.value = arg.name or ''
	temp_dlg_:popup()
end

-- 回掉处理右键rename操作 
local function on_tree_rename()
	local id = tree_right_.value
	local function on_ok(name)
		local id = tree_right_.value
		set_node_title{tree = tree_right_,id =id,name = name}
	end
	pop_temp_dlg{name = get_node_title{tree =tree_right_ ,id = id},on_ok = on_ok}
end

-- 处理当前节点下树种每个节点的title与id的对应关系
local function get_title_index(tree,id,title)
	local t = {}
	local id = id or 0 
	local curid = id + 1
	for i = 1,get_node_count{tree=tree,id = id} do 
		local title = get_node_title{tree = tree,id = curid}
		t[title] = curid
		curid = curid+1+get_node_totalcount{tree = tree,id = curid}
	end
	return t
end

-- 处理左边树右键操作load
local function on_loading(arg,id,waitUpdate)
	local t =  get_node_attribute{tree =tree_left_,id = id }
	if not t.name then return end 
	local posId = 0
	local tempTab = {}
	for name in string.gmatch(t.name,'[^%.]+') do 
		table.insert(tempTab,name)
	end
	if #tempTab == 1 then table.insert(tempTab,1,tempTab[1]) end 
	local go_on = true
	for k,v in ipairs(tempTab) do 
		if k ~= #tempTab then 
			local names_tab = get_title_index(tree_right_,posId)
			if names_tab[v] and go_on then 
				posId = names_tab[v]
			else 
				go_on = false
				add_branch_node{tree = tree_right_,id =posId ,name = v}
				posId = posId + 1
			end 
		else 
			add_leaf_node{tree = tree_right_,id =posId ,name = v}
			set_node_attribute{tree = tree_right_,id =posId +1 ,attribute = {name = v,keyword = t.keyword}}
			tree_right_['MARKED' .. (posId +1)] = "yes" 
		end 
	end
	if  not waitUpdate then 
		init_left_tree{data = arg.menuData}
	end 
end

-- 处理左边树右键操作load all
local function  on_loading_all(arg,id)
	local count =get_node_count{tree = tree_left_,id = id}
	local curid = id + 1
	for i = 1,count do 
		on_loading(arg,curid,'Waiting')
		curid = curid +1 
	end 
	init_left_tree{data = arg.menuData}
end


-- 处理左边树右键操作 unload
local function on_unload(arg,id,waitUpdate)
	local t =get_keyword_index()
	local cur_t = get_node_attribute{tree = tree_left_,id = id}
	if cur_t and  t[cur_t.keyword] then 
		delete_node{tree = tree_right_,id = t[cur_t.keyword].id}
	end
	if not  waitUpdate then 
		init_left_tree{data = arg.menuData}
	end 
end

-- 处理左边树右键操作 unload_all
local function on_unload_all(arg,id)
	local count =get_node_count{tree = tree_left_,id = id}
	local curid = id + 1
	for i = 1,count do 
		on_unload(arg,curid,'Waiting')
		curid = curid +1 
	end 
	init_left_tree{data = arg.menuData}
end

loads_ = {
	['Loading'] = on_loading;
	['Loading ALL'] =  on_loading_all;
	['Unload'] =   on_unload;
	['Unload ALL'] =  on_unload_all;
	'Loading';
	'Loading ALL';
	'Unload';
	'Unload ALL';
}

--  初始化 左边树的右键弹出菜单
local function init_left_tree_menu(id)
	tree_left_['MARKED' .. id] = "yes" 
	item_turn_.title =  loads_[1]
	item_turn_.id = id
	if id == 0 then 
		return 
	elseif id == 1 then 
		item_turn_.title =  loads_[2]
	elseif get_node_kind{tree=  tree_left_,id = id} == 'branch' then 
		item_turn_.title =loads_[4]
	elseif  get_node_kind{tree=  tree_left_,id = id} == 'leaf' then 
		if get_node_parent_id{tree = tree_left_,id = id } == 1 then 
			item_turn_.title = loads_[1]
		else
			item_turn_.title = loads_[3]
		end
	end 
	return true 
end

-- 右边树邮件delete删除操作
local function on_tree_delete(arg)
	local id = tree_right_.value
	if tonumber(id) == 0 then 
		delete_node{tree = tree_right_,id = id,type = 'CHILDREN'}
	else 
		delete_node{tree = tree_right_,id = id}
	end 		
	init_left_tree{data = arg.menuData}
end

--获取特殊的title的节点位置
local function  get_title_pos(tree,dragtitle)
	local count = get_tree_count(tree)
	for i = 1,(count -1) do 
		local title = get_node_title{tree = tree,id = i}
		if title == dragtitle then 
			return i
		end
	end
end

--响应拖拽回掉函数
local function on_drag_drop(tree,drag_id,drop_id)
	local dragtitle = get_node_title{tree= tree,id = drag_id} .. '.dragTemp'
	set_node_title{tree =tree,id = drag_id,name = dragtitle}
	move_node{tree = tree,drag_id=drag_id,drop_id=drop_id }
	local idDrag = get_title_pos(tree,dragtitle)
	if not idDrag then return end 
	dragtitle = string.sub(dragtitle,1,-10)
	set_node_title{tree =tree,id = idDrag,name = dragtitle}
	set_node_marked{tree = tree,id = idDrag,states = 'yes'}
end

--------------------------------------------------------------------
-- 初始化 按键button函数
local function action_button(arg)
	local styleFiles = arg.styleFiles
	function btn_cancel_:action()
		dlg_:hide()
	end
	
	function btn_delete_:action()
		local item = tonumber(list_.value)
		if  item == 0  then return iup.Message('Notice','Please select a item for delete  firstly !') end
		if  item == 1  then return iup.Message('Notice','You can not delete the default item  !') end 
		local str = list_[item]
		local file = styleFiles[str] and styleFiles[str].file
		if file then 
			file = string.gsub(file,'%.','\\') .. '.lua'
			os.remove(file)
			styleFiles[str] = nil
		end 
		list_.REMOVEITEM = item
	end
	
	function btn_ok_:action()
		if type(arg.on_ok) == 'function' then 
			arg.on_ok{data =get_right_tree_data()}
		end 
		dlg_:hide()
	end
	
	function btn_save_:action()
		local name = txt_name_.value 
		if name and name ~= '' then  
			if type(arg.on_save) == 'function' then 
				local file = arg.on_save{name = name,data =get_right_tree_data()}
				if  file  then 
					if not styleFiles[name] then 
						ins_list_item{name = name,id =2}
						set_item_image{id = 2,image = "IUP_FileSave"}
						list_.value =2
					end
					styleFiles[name] = {name = name,file = file}
				end
				
			end
			txt_name_.value = ''
		else 
			iup.Message('Notice','Please set name firstly !')
		end
	end
	
	function btn_left_:action()
		on_tree_delete(arg)
	end

	
	function btn_right_:action()
		local id = tonumber(tree_left_.value)
		if init_left_tree_menu(id) then 
			if type(loads_[item_turn_.title]) == 'function' then 
				loads_[item_turn_.title](arg,id)
			end 
		end
	end
end


-- 初始化菜单item相关的回调函数
local function action_menu(arg)
	
	function item_tree_add_:action()
		local function on_ok(name)
			local id = tree_right_.value
			add_branch_node{tree= tree_right_,id =id,name = name}
		end
		pop_temp_dlg{on_ok = on_ok}
	end
	
	function item_tree_insert_:action()
		local function on_ok(name)
			local id = tree_right_.value
			ins_branch_node{tree= tree_right_,id =id,name = name}
		end
		pop_temp_dlg{on_ok = on_ok}
	end
	
	function item_tree_rename_:action()
		on_tree_rename()
	end
	
	function item_tree_delete_:action()
		on_tree_delete(arg)
	end
	
	function item_tree_add_sep_:action()
		local id = tree_right_.value
		add_leaf_node{tree = tree_right_,id =id,name = separator_}
	end
	
	function item_turn_:action()
		if type(loads_[self.title]) == 'function' then 
			loads_[self.title](arg,tonumber(self.id))
		end 
	end

end

--初始化操作 tree相关的回调 函数
local function action_tree()

	local function init_tree_right_menu(id)
		tree_right_['MARKED' .. id] = "yes" 
		item_tree_add_.active = 'yes'
		item_tree_insert_.active = 'yes'
		item_tree_rename_.active = 'yes'
		item_tree_delete_.active = 'yes'
		item_tree_add_sep_.active = 'yes'
		if id == 0 then 
			item_tree_rename_.active = 'NO'
			item_tree_insert_.active = 'NO'
			item_tree_add_sep_.active = 'NO'
		end 
		if get_node_kind{tree = tree_right_,id = id}== 'leaf' then 
			item_tree_add_.active = 'NO'
			local t = get_node_attribute{tree = tree_right_,id  = id}
			if not t or not t.name then 
				item_tree_rename_.active = 'NO'
			end 
		end 
	end
	
	function tree_right_:rightclick_cb(id)
		init_tree_right_menu(id)
		menu_tree_right_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
	end
	
	function tree_left_:rightclick_cb(id)
		local id = tonumber(id)
		if init_left_tree_menu(id) then 
			menu_tree_left_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
		end
	end
	
	function tree_right_:dragdrop_cb(drag_id, drop_id, isshift, iscontrol)
		if get_node_count{tree = self,id =drop_id} == 0  then 
			set_node_states{tree = self,id = drop_id,states = 'COLLAPSED'}
		end
		if drop_id == 0 then 
			if get_node_kind{tree = self,id = drag_id} == 'leaf' then 
				return
			end
		elseif get_node_depth{tree = self,id = drop_id} == 1 then
			if get_node_states{tree = self,id =drop_id} == 'COLLAPSED' and get_node_kind{tree = self,id = drag_id} == 'leaf' then 
				return 
			end
		end
		
		on_drag_drop(self,drag_id,drop_id)
	end
		
end 

-- 初始化 list 相关回调函数
local function action_list(arg)
	local styleFiles = arg.styleFiles or {}
	function list_:button_cb(button, pressed, x, y, status)
		if string.find(status,'1') and string.find(status,'D') then 
			local item = tonumber(list_.value)
			if item == 1 then 
				local data = arg.menuStyle
				init_right_tree_data{data = data}
				init_left_tree{data = arg.menuData}
				return 
			end 
			local name = list_[item]
			local file =styleFiles[name] and styleFiles[name].file
			if type(arg.on_dbclick_list) == 'function' then 
				local data = arg.on_dbclick_list{file= file}
				init_right_tree_data{data = data}
				init_left_tree{data = arg.menuData}
			end 
			
		elseif string.find(status,'3') and not string.find(status,'D') then 
			--local item = tonumber(list_.value)
		end 
	end
end




--------------------------------------------------------------------
-- 外部借口pop 需要关键key有：menuData,menuStyle,styleFiles,on_ok,on_save ...
--arg = {menuData,menuStyle,styleFiles,on_ok,on_save}
function pop(arg)
	local arg = arg or {}
	local function init_data(arg)
		init_list_data(arg)
		init_tree_data(arg)
	end
	
	local function init_callback(arg)
		action_button(arg)
		action_tree(arg)
		action_list(arg)
		action_menu(arg)
	end
	
	local function show()
		init_callback(arg)
		dlg_:map()
		init_data(arg)
		dlg_:show()
	end
	
	local function init()
		init_frame()
		init_dlg()
	end

	if not dlg_ then  init() end
	show()
end


