--_ENV=module_seeall(..., package.seeall)
local require = require;

_ENV = module(...)

require( "iuplua" )
require( "iupluacontrols" )

local sel_id_dir_ = nil;
local sel_path_ = nil;
local sever_path_ = nil;
--定义btn
local function init_buttons()
	show_btn = iup.button{title="Show",rastersize="70x28"};
	
	cancel_btn = iup.button{title=" Cancel",rastersize="70x28"};
	l_btn = iup.button{title=" . . . ",rastersize="35X22"};
	
	--测试
	save_btn = iup.button{title="Save",rastersize="70x28"};
	open_btn = iup.button{title="Open",rastersize="70x28"};
	del_btn = iup.button{title="Delete",rastersize="70x28"};
	edit_btn = iup.button{title="Edit",rastersize="70x28"};
	add_btn = iup.button{title="Add",rastersize="70x28"};
	clear_btn = iup.button{title="Clear",rastersize="70x28"};

	parent_id_lab= iup.label{title = "ParentID:",rastersize = "60x25"};
	parent_id_text = iup.text{rastersize = "100x",value="2"};
	value_text_lab= iup.label{title = "Value:",rastersize = "60x25"};
	value_text = iup.text{rastersize = "100x",value="text"};


end

--创建根节点(1)
local function add_root(tree, node)
	iup.TreeAddNodes(tree, node)
	tree = iup.tree{
		markmode = "multiple",
		map_cb = 
			function(self)
				iup.TreeAddNodes(self, node)
			end,
	}
	return tree
end

--定义控件属性
local function init_controls()
	lab_path_ = iup.label{title = "Path  :",rastersize = "36x25"};
	path_text = iup.text{rastersize = "320x",};
	tree_ = iup.tree{ADDEXPANDED  = "NO";};
	--node = {branchname = ""}
--	tree_ = require"app\\project\\set_tree_data".add_root(tree_, node)
	--tree_ = add_root(tree_, node)
	frm_tree = iup.frame {tree_ ; title = "Files";size = "75x100"}

	item_file_dir_ = iup.item{title = "Open File Dir"}	
	
	menu_file_ = iup.menu{
		item_file_dir_;
		iup.separator{};	
	}
end

--打开文件夹
local function open_file_dlg()
	local dlg_ = iup.filedlg{DIALOGTYPE = "dir" }
    local dir = "";
	dlg_:popup()
    if dlg_.status ~= "-1" then
        dir = dlg_.value;
    end
	return string.sub(dir,-1)=="\\" and dir or dir.."\\";
end

---------------------------------------------------------------------------------------------------------------------------------------------

--获取被选中节点的ID
local function get_id_tab(tree)
	local sel_str = tree.MARKEDNODES
	local sel_id_tab,i = {},0
	while true do
		i = string.find(sel_str, "+", i+1)
		if i == nil then break end
		sel_id_tab[#sel_id_tab+1] = i -1
	end
	return sel_id_tab[1]
end
--查找所有文件（非目录）及子目录下文件路径
local function get_all_files(dir_name)
	local i, files, popen = 0, {}, io.popen;
	for file_path in popen('dir "'..dir_name..'" /s /b /a-d'):lines() do
		i = i + 1
		files[i] = file_path
	end
	return files
end

--根据文件路径取文件名
local function get_file_name(file_path)
	local addr = 0;
	for i = -1, -#file_path, -1 do
		addr = string.find(file_path,"\\",i)
		if addr ~= nil then
			return string.sub(file_path,addr+1,#file_path)
		end
	end
end

--查找所有目录及子目录
local function get_all_dirs(dir_name)
	local i, dirs, popen = 0, {z}, io.popen;
	for dirname in popen('dir "'..dir_name..'" /s /b /ad'):lines() do
		i = i + 1
		dirs[i] = dirname
	end
	return dirs
end

--获取文件服务器路径
local function get_file_serverpath(file_path, path)
	return string.sub(file_path,#path + 1,#file_path)
end

--根据绝对路径获取目录相对路径
local function get_dir_path(file_path, path)
	return string.sub(file_path,#path + 1,#file_path)
end

--获取文件及目录Table
function get_files_in_dir_sub(path)
	local files, dirs = {},{};
	local all_file = get_all_files(path);
	if all_file ~= nil then
		for i = 1,#all_file do
			local fname = get_file_name(all_file[i])
			local spath = get_file_serverpath(all_file[i],path)
			files[i] = {name = fname, path =  (string.gsub([=[]=]..all_file[i] ,[[\]],[[\\]])), server_path = (string.gsub([=[]=]..spath ,[[\]],[[\\]]))}
		end
	end
	local all_dirs = get_all_dirs(path)
	if all_dirs ~= nil then
		for i = 1 ,#all_dirs do
			local dir,path = (string.gsub([=[]=]..all_dirs[i] ,[[\]],[[\\]])),(string.gsub([=[]=]..path ,[[\]],[[\\]]))
			dirs[i] = get_dir_path(dir, path)
		end
		files.dirs = dirs
	end
	return files
end
-----------------------------------------------------------------------

--将表中路径改为单个目录为元素的表
local function get_dir_tab(str)
	str = string.gsub(str, "\\\\","\\")
	local tab,index,start_flag, end_flag = {},0,0,0;
	local tmp = index;
	for i = 1,#str do
		index = string.find(str,"\\",i)
		if index ~= tmp and index ~= nil then
			end_flag = index
			table.insert(tab, string.sub(str, start_flag+1, end_flag-1))
			tmp = index
		elseif index ~= tmp and index == nil then
			table.insert(tab, string.sub(str, start_flag+1, #str))
			tmp = index
		end
		start_flag = end_flag
	end
	return tab
end

--目录搜索
local function search_dir(handle, dir)
	for k,v in pairs(handle) do
		if type(k) == "number" and v.branchname == dir then
			return k  --重复返回true
		end
	end
end
--搜索重复目录
local function search_redir_true_false(handle, dir)
	for k,v in pairs(handle) do
		if type(k) == "number" and v.branchname == dir then
			return true, k  --重复返回true
		end
	end
	return false, k -- 不重复返回false
end
--添加文件
local function add_son_file(tree_node, son_file)
	local handle = tree_node
	for i = 1, #son_file do
		if i == #son_file then
			table.insert(handle, son_file[i])
		else
			local index = search_dir(handle, son_file[i])
			handle = handle[index]
		end
	end
	return tree_node
end
--添加子节点目录(3)
local function add_son_dir(tree_node, son_dir)
	local handle = tree_node
	for k,v in pairs(son_dir) do
		local flag, index = search_redir_true_false(handle, v)
		if flag then
			handle = handle[index]
		else
			table.insert(handle, {state= "COLLAPSED",branchname = v})
			handle = handle[#handle]
		end
	end
	return tree_node
end
--添加所有文件
local function add_all_files(tree_node, files)
	for i = 1, #files do
		local tab_dir = get_dir_tab(files[i].server_path)
		tree_node = add_son_file(tree_node, tab_dir)
	end
	return tree_node
end

--添加所有目录(2)
local function add_all_dirs(tree_node, dirs)
	for k,v in pairs(dirs) do
		local tab_dir = get_dir_tab(v)
		tree_node = add_son_dir(tree_node, tab_dir)
	end
	return tree_node
end


--设定树状图内容
local function set_tree_datas(node, files)	
	if files ~= nil then	
		node = add_all_dirs(node, files.dirs)
		node = add_all_files(node, files)
	end
	return node
end
--------------------------------------------------------------------------
--获取根节点名
local function get_root_name(file)
	for i = -1, -#file, -1 do
		add = string.find(string.sub(file,1,#file-1),[[\]],i)
		if add ~= nil then
			path = string.sub(file,add+1, #file)
			break
		end
	end
	return string.sub(path,1, #path-1)
end
-------------------------------------------------------------------------

---定义对话框
local function init_dlg()
	
	dlg = iup.dialog{
		iup.vbox{
			iup.hbox{lab_path_,gap = 10,path_text,l_btn};
			iup.hbox{frm_tree};
			iup.hbox{iup.fill{size = "1x"},show_btn,save_btn,open_btn,cancel_btn};
			iup.hbox{iup.fill{size = "1x"},parent_id_lab,parent_id_text,value_text_lab,value_text};
			iup.hbox{iup.fill{size = "1x"},add_btn,edit_btn,del_btn,clear_btn};
		},
	title = "Browser",
	alignment = "ARIGHT";
	resize = "NO", 
	margin="8x8",
	size = "300x264";
	}	
end
---根据选中结点id形成选文件路径
local function deal_find_dir(id,save_path_tab)

	if tonumber(tree_["DEPTH" .. id]) ~= 0 then 
		table.insert(save_path_tab,tree_["title" .. id])
		id = tree_["parent" .. id];
		deal_find_dir(id,save_path_tab)
	else 
		table.insert(save_path_tab,tree_["title" .. id])
	end
end
---获取选择结点名
local function get_dir(save_path_tab,status)
	sel_id_dir_ = "";
	for i = #save_path_tab , 1,-1 do 
		if i ~= #save_path_tab then 
			if i == 1 then 
				sel_id_dir_ = sel_id_dir_ .. save_path_tab[i];
			else 
				sel_id_dir_ = sel_id_dir_ .. save_path_tab[i] .. "\\\\";
			end
			
		end
	end
	sel_id_dir_ = save_path_tab[#save_path_tab] .. "\\\\" .. sel_id_dir_;
end

-----------------------------------------------
local controller_ = nil;
-----------------------------------------------
local function create_tree_controller()
	controller_ = require"app.control_tree.controller".create_controller();
	local model_db_ = require"app.control_tree.model_db".create_model_db();
	local tree_control_ = require"app.control_tree.tree".create_tree();

	tree_control_:set(model_db_:get_db());
	tree_control_:set_iuptree(tree_);
	tree_control_:show();
	
	controller_:set(model_db_,tree_control_);
end	
function get_tree_controller()
	return controller_;
end
----回调函数
local function msg()	
	function l_btn:action() --l_btn 回调函数
		path_text.value =  open_file_dlg()	
		sever_path_ = string.sub(path_text.value ,1,-2)
	end
	function save_btn:action() 
		controller_.model_db_:save();
	end
	function open_btn:action() 
		controller_.model_db_:open();
	end
	
	function show_btn:action() --show_btn 回调函数		
		create_tree_controller();		
	end
	
	function cancel_btn:action()--关闭对话框
		dlg:hide()
	end
	function edit_btn:action()
		controller_:db_edit(parent_id_text.value,{name=value_text.value});
	end
	function add_btn:action()
		controller_:db_add(parent_id_text.value,{name=value_text.value});
	end
	function del_btn:action()
		controller_:db_del(parent_id_text.value,{name=value_text.value});
	end
	function clear_btn:action()
		controller_:db_clear();
	end
	
	
	
	local save_sel_id = nil;
	
	function tree_:rightclick_cb(nid) --树的右键回调函数
		save_sel_id = nid;
		self["MARK"] = "CLEARALL"
		self["MARKED"..nid] = "YES"
		local save_path_tab = {};
		local status = tree_["KIND" .. nid];
		deal_find_dir(nid,save_path_tab);
		get_dir(save_path_tab,status)
		menu_file_:popup(iup.MOUSEPOS,iup.MOUSEPOS);
	end
	
	function item_file_dir_:action()--item回调函数
		if sel_id_dir_ then 
			local open_file_path = string.gsub(sel_id_dir_,"\\\\","\\");
			local i,j = string.find(open_file_path,"[\\]+");
			open_file_path = string.sub(open_file_path,j,-1);
			open_file_path = sever_path_ .. open_file_path ;
			os.execute("explorer " .. "\"" .. open_file_path .. "\"");--打开文件
		end 
	end
end
--显示对话框
local function show()
	dlg:show() 
end

local function init()
    init_controls();
	init_buttons();
	init_dlg();
	msg();
	dlg:show()
end


--弹出对话框
function pop()
	if dlg then 
		show()
	else
		init()
	end
	tree_.DELNODE0 = "SELECTED";
	
end
