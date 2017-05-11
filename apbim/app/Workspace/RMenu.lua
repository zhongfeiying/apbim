--module(...,package.seeall)

_ENV = module(...,ap.adv)
local lfs = require "lfs"
local cur_id_ = nil;
local file_op_ = require "app.workspace.ctr_require".file_op()
local rmenu_op_ = require "app.workspace.ctr_require".rmenu_op()
local workspace_ = require "app.workspace.ctr_require".Workspace()
local tree_op_ = require "app.workspace.ctr_require".tree_op()


local function init_controls()	
	
	file_dlg_ = iup.filedlg{}
	open_file_dlg_ = iup.filedlg{
	rastersize = "800x800";
	SHOWPREVIEW = "YES";
	NOCHANGEDIR = "YES";
	}
	item_add_folder_ = iup.item{title = "Folder"};
	item_add_file_ = iup.item{title = "File"}
	item_add_resource_ = iup.item{title = "Resource"}
	item_add_ = iup.submenu{
		iup.menu{
			item_add_folder_;
			item_add_file_;
			item_add_resource_;
		};
		title = "Add";
	}
	item_ins_folder_ = iup.item{title = "Folder"}
	item_ins_file_ = iup.item{title = "File"}
	item_ins_resource_ = iup.item{title = "Resource"}
	item_ins_ = iup.submenu{
		iup.menu{
			item_ins_folder_;
			item_ins_file_;
			item_ins_resource_;
		};
		title = "Insert";
	};
	item_import_folder_ = iup.item{title = "Folder"}
	item_import_files_ = iup.item{title = "Files"}
	item_import_tpl_ = iup.item{title = "Template"}
	item_import_ = iup.submenu{
		iup.menu{
			item_import_folder_;
			item_import_files_;
			item_import_tpl_;
		};
		title = "Import";
	}
	item_rename_ = iup.item{title = "Rename"}
	item_replace_ = iup.item{title = "Replace"}
	item_del_ = iup.item{title = "Delete"}; 

	item_property_ = iup.item{title = "Property"}
	item_assign_view_ = iup.item{title = "View"}
	item_assign_entity_ = iup.item{title = "Entity"}
	item_assign_files_ = iup.item{title = "Disk Files"}
	item_assign_ = iup.submenu{
		iup.menu{
			item_assign_view_;
			item_assign_entity_;
			iup.separator{};
			item_assign_files_;
		};
		title = "Assigning";
	}
	item_show_links_ = iup.item{title = "Links"}
	item_show_model_ = iup.item{title = "Model"}
	item_show_ = iup.submenu{
		iup.menu{
			item_show_links_;
			item_show_model_;
		};
		title = "Show";
	}

	item_setting_ = iup.item{title = "Setting"}
	item_export_tpl_ = iup.item{title = "Template"}
	item_export_ = iup.submenu{
		iup.menu{
			item_export_tpl_;
		};
		title = "Export";
	}

	--item_save_
	
	item_version_create_ = iup.item{title = "Create"}
	item_version_submit_ = iup.item{title = "Submit"}
	item_version_show_ = iup.item{title = "Show History"}
	item_version_ = iup.submenu{
		iup.menu{
			item_version_create_;
			item_version_submit_;
			item_version_show_;
		};
		title = "Version";
	}

	item_save_= iup.item{title = "Save"}
	item_upload_ = iup.item{title = "Upload"}
	item_download_ = iup.item{title = "Download"}
	item_open_ = iup.item{title = "Open"}
	item_update_ = iup.item{title = "Update"}
	--item_update_ = iup.item{title = "Upload"}
	item_get_id_ = iup.item{title = "Get Project Id"}
	item_send_to_ = iup.item{title = "Send To"}
	item_projects_ = iup.submenu{
		title = "Server";
		iup.menu{
			--item_open_;
			--item_save_;
			--item_upload_;
			
			item_upload_;
			item_update_;
			--item_get_id_;
			iup.separator{};
			item_send_to_;
		}
	}
	
	
	

end

function init_menu()
	menu_ = iup.menu{
		item_add_;
		item_ins_;
		item_import_;
		iup.separator{};
		item_rename_;
	--	item_replace_;
		item_del_;
		iup.separator{};
		item_assign_;
		item_show_;
		iup.separator{};
	--	item_export_;
	--	iup.separator{};
		--item_update_;
		--item_upload_;
		item_projects_;
		--item_projects_;
		--	item_setting_;
	}
	iup.Refresh(menu_)
end 

-------------------------------------------------------------------------------------------
--pop_file_dlg(dlgtype,cur_type) 参数dlgtype 值只接收 "OPEN", "SAVE" or "DIR".第二个参数控制的是打开文件对话框是否需要多选，cur_type有值（除了nil和false以外的任意值）则多选，否则为单选。
function pop_file_dlg(dlgtype,cur_type)
	file_dlg_.DIALOGTYPE = dlgtype
	if dlgtype == "OPEN" and cur_type then 
		file_dlg_.MULTIPLEFILES = "YES"
	else 
		file_dlg_.MULTIPLEFILES = "NO"
	end 
	file_dlg_:popup()
end


--回调函数 中被调用处理函数

local function msg_set_version_path()
	pop_file_dlg("DIR")
	local val = file_dlg_.value;
	if not val then return end 
	if not (string.sub(val,-1,-1) == "\\") then 
		val = val .. "\\"
	end
	local cur_path = "data"
	local file = io.open("version_path.lua","r")
	if file then 
		file:close()
		dofile("version_path.lua")
		if path_ then
		cur_path = string.gsub(path_,"/","\\") .. "data"
		end 
	end
	local file = io.open("version_path.lua","w+")
	file:write("path_ = \"" .. string.gsub(val,"\\","/") .. "\"")
	file:close()
	os.execute("if not exist " .. "\"" .. val .. "data" .. "\"" .. " mkdir " .. "\"" .. val .. "data" .. "\"");
	
	os.execute("xcopy /y  /E \"" .. cur_path  .. "\" \"" .. val .. "data\" ")
	os.execute("rd /s /q  \"" .. cur_path  .. "\" ")
	local t = iup.TreeGetUserId(tree_,0)
	if not t then return end 
	file_op_.set_cur_user(t.gid,tree_["title0"])
end

local function init_open_filedlg()
	open_file_dlg_.DIALOGTYPE = "OPEN";
	open_file_dlg_.EXTFILTER = "Project File|*.apc";
	open_file_dlg_.DIRECTORY = "data\\bca.tpl\\"
	open_file_dlg_:popup();
end

function init_save_filedlg()
	open_file_dlg_.DIALOGTYPE = "SAVE";
	open_file_dlg_.EXTFILTER = "Project File|*.apc";
	open_file_dlg_.DIRECTORY = "data\\bca.tpl\\"
	open_file_dlg_:popup();
end



function get_save_filedlg_val()
	return open_file_dlg_.value
end




--init_callback 回调函数
local function init_callback()
	function item_add_folder_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_add_folder(tree,tid)
	end
	function item_add_file_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_add_file(tree,tid)
	end
	function item_add_resource_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_add_resource(tree,tid)
		
	end
	function item_ins_folder_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_ins_folder(tree,tid)
	end
	function item_ins_file_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_ins_file(tree,tid)
	end

	function item_ins_resource_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_ins_resource(tree,tid)
	end
	function item_import_folder_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		pop_file_dlg("DIR")
		local val = file_dlg_.value
		if not val then return end 
		if  val == "\\" or val  == "/" or not string.match(val,".+\\(.+)") then
			iup.Message("Warning","Do not be allowed to use the root directory !")
			return
		end 

		rmenu_op_.msg_import_folder(tree,tid,val)
	end

	function item_import_files_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		file_dlg_.FILTER = "*.*"
		pop_file_dlg("OPEN",1)
		local val = file_dlg_.value
		if not val then return end 
		rmenu_op_.msg_import_files(tree,tid,val)
	end

	function item_import_tpl_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		file_dlg_.FILTER = "*.apc;*.tpl"
		--file_dlg_.DIRECTORY = "Sample\\BCA\\"
		file_dlg_.DIRECTORY = "Projects\\"
		pop_file_dlg("OPEN")
		local val = file_dlg_.value
		if not val then return end 	
		rmenu_op_.msg_import_tpl(tree,tid,val)
	end
		
	function item_rename_:action()
	 	local tree = workspace_.get_tree()
	 	local tid = cur_id_[1]
		rmenu_op_.msg_rename(tree,tid)
	end
	
	function item_del_:action()
		local tree = workspace_.get_tree()
		local tid = tonumber(cur_id_[1])
		if tid == 0 then return end 
		local alarm = iup.Alarm("Notice","Do you want to delete the node !","Yes","Cancel")
		if alarm == 1 then 
			tree["delnode" .. tid] = "SELECTED"
		end
	end


	function item_assign_view_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_assign_view(tree,tid)
		
	end

	function item_assign_entity_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_assign_entity(tree,tid)
		
	end

	function item_assign_files_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		file_dlg_.FILTER = "*.*"
		pop_file_dlg("OPEN",1)
		local val = file_dlg_.value
		if not val then return end 
		rmenu_op_.msg_assign_files(tree,tid,val)
	end

--[[
	function item_assign_show_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
	--	rmenu_op_.msg_assign_show(tree,tid)
	end
	--]]
	function item_show_model_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_show_model(tree,tid)
	end


	function item_show_links_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_show_links(tree,tid)
	end
	
	function item_export_tpl_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		file_dlg_.FILTER = "*.tpl"
		--file_dlg_.DIRECTORY = "Sample\\BCA\\"
		file_dlg_.DIRECTORY = "Projects\\"
		pop_file_dlg("SAVE")
		local val = file_dlg_.value
		if not val then return end 
		if string.sub(val,-4,-1) ~= ".tpl" then val = val .. ".tpl" end 
		rmenu_op_.msg_export_tpl(tree,tid,val)	
	end



	function item_upload_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_upload_project(tree,tid)	
	end
	
	function item_get_id_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_get_cur_project_id(tree,tid)	
	end
	
	function item_update_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		
		rmenu_op_.update_model(tree,tid)
		rmenu_op_.msg_update_project(tree,tid)	
	end
	
	function item_send_to_:action()
		local tree = workspace_.get_tree()
		local tid = cur_id_[1]
		rmenu_op_.msg_send_to(tree,tid)	
	end

end
	
function create(cur_type)
	init_controls()	
	init_menu()
	init_callback()
end

local function init_item(states)
end

local function init_active_all_item(type)
	item_add_.active = type
	item_add_folder_.active = type
	item_add_file_.active = type
	item_add_resource_.active = type

	item_ins_.active = type
	item_ins_folder_.active = type
	item_ins_file_.active = type
	item_ins_resource_.active = type
	
	item_import_.active = type
	item_import_folder_.active = type
	item_import_files_.active = type
	item_import_tpl_.active = type
	
	item_rename_.active = type
	item_replace_.active = type

	item_del_.active =type
	
	item_assign_.active = type
	item_assign_view_.active = type
	item_assign_entity_.active = type
	--item_assign_show_.active = type
	item_assign_files_.active = type

	item_show_.active = type
	item_show_model_.active = type
	item_show_links_.active = type

	item_export_tpl_.active = type
	item_export_.active = type
	
	item_update_.active = "NO"
	item_upload_.active = "NO"
	item_get_id_.active = "NO"
	item_projects_.active = "NO"
end

local function deal_init_active()
	cur_id_ = {}
	local tree = workspace_.get_tree()
	local str =  tree.MARKEDNODES
	for i = 1,#str do 
		if string.sub(str,i,i) == "+" then 
			table.insert(cur_id_,i - 1);
		end
	end 
	init_active_all_item("YES")
	if tonumber(tree["depth" .. cur_id_[1]]) == 0 then 
		item_ins_.active = "NO"
		item_add_file_.active = "NO"
		item_add_resource_.active = "NO"
		item_del_.active = "NO"
		item_replace_.active = "NO"
		item_assign_.active = "NO"
		item_import_files_.active = "NO"
		item_show_links_.active = "NO"
		item_update_.active = "YES"
		item_upload_.active = "YES"
		item_get_id_.active = "YES"
		item_projects_.active = "YES"
	elseif tonumber(tree["depth" .. cur_id_[1]]) == 1 then 
		item_ins_file_.active = "NO"
		item_assign_.active = "NO"
		item_ins_resource_.active = "NO"
		item_import_tpl_.active = "NO"
		item_setting_.active = "NO"
		item_export_.active = "NO"
		item_show_.active = "NO"
	else 
		item_import_tpl_.active = "NO"
		item_show_.active = "NO"
		item_export_.active = "NO"
		item_setting_.active = "NO"
		if tree["KIND" .. cur_id_[1]] == "LEAF" then 
			item_show_.active = "YES"
			item_add_.active = "NO"
			item_import_.active = "NO"
			item_show_model_.active = "NO"
		else 
			item_assign_.active = "NO"
		end

	end
end

function pop(tree,id)
	deal_init_active()

	menu_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end
