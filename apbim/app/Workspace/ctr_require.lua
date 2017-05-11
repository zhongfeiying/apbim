--module(...,package.seeall)


_ENV = module(...,ap.adv)

function luaext()
	local luaext_ = require"luaext"
	return luaext_
end

-------------------------------ap.sys 文件夹   -------------------
function Entity()
	local Entity_ = require"sys.Entity"
	return Entity_
end 

function Mgr()
	local mgr_ = require"sys.mgr"
	return mgr_
end 


function Text()
	local text_ = require"sys.text"
	return text_
end 

function Table()
	local table_ = require"sys.table"
	return table_
end

function Dt()
	local dt_ =require"sys.dt"
	return dt_
end

function get_sys_interface_id()
	local id_ = require "sys.interface.id"
	return id_
end

function statusbar()
	local statusbar_ = require"sys.interface.statusbar"
	return statusbar_
end 

-------------------------------login 文件夹   -------------------
function dlg_reg()
	local dlg_reg_ = require "app.login.dlg_reg"
	return dlg_reg_
end

function dlg_login()
	local login_dlg_ = require "app.Login.dlg_login"
	return login_dlg_
end 

function dlg_server()
	local dlg_server_ = require "app.Login.dlg_server"
	return dlg_server_
end

-------------------------------file 文件夹   -------------------
--[[
function file_op()
	--package.loaded["app.file.file_op"] = nil --可以重新加载该文件
	local file_op_ = require "app.file.file_op"
	return file_op_
end


function file_save()
	local file_save_ = require "app.file.file_save"
	return file_save_
end
--]]
-------------------------------workspace 文件夹   -------------------
--[[
function workspace()
	local Workspace_ = require "app.workspace.workspace"
	return Workspace_
end 

function tree_op()
	local tree_op_ = require "app.workspace.tree_op"
	return tree_op_
end

function rmenu()
	local rmenu_ = require "app.workspace.Rmenu"
	return rmenu_
end 

function rmenu_op()
	local rmenu_op_ = require "app.workspace.rmenu_op"
	return rmenu_op_
end

function init_program()
	local init_program_ = require "app.workspace.init_program"
	return init_program_
end 

-- function log_op()
	-- local log_op_ = require "app.workspace.log_op"
	-- return log_op_
-- end 

-- function tabs_change()
	-- local tabs_change_ = require "app.workspace.tabs_change"
	-- return tabs_change_
-- end 
--]]
-------------------------------Server 文件夹   -------------------

function server_op()
	local server_op_ = require "app.workspace.server.server_op"
	return server_op_
end 

function server_db()
	local server_db_ = require "app.workspace.server.server_db" 
	return server_db_
end 

function server_base()
	local server_base_ = require "app.workspace.server.server_base" 
	return server_base_
end 
-------------------------------Tool 文件夹   -------------------

function dir_tools()
	local dir_tools_ = require "app.workspace.Tool.dir_tools"
	return dir_tools_
end 
--[[
function dlg_show_details()
	local dlg_show_details_ = require "app.Tool.dlg_show_details"
	return dlg_show_details_
end

function dlg_warning()
	local dlg_warning_ = require "app.Tool.dlg_warning"
	return dlg_warning_
end

function dlg_import_gid()
	local dlg_import_gid_ = require "app.tool.dlg_import_gid"  
	return dlg_import_gid_
end

function dlg_download_hid_file()
	local dlg_download_hid_file_ = require "app.tool.dlg_download_hid_file"  
	return dlg_download_hid_file_
end  

function dlg_tree_rename()
	local dlg_tree_rename_ = require "app.Tool.dlg_tree_rename"
	return dlg_tree_rename_
end 

function dlg_com_ifo()
	local dlg_com_ifo_ = require "app.Tool.dlg_com_ifo"
	return dlg_com_ifo_
end

function dlg_travel_bar()
	local travel_bar_ =  require "app.Tool.dlg_travel_bar" 
	return travel_bar_
end

function dlg_progress_bar()
	local progress_bar_ =  require "app.Tool.dlg_progress_bar" 
	return progress_bar_
end

function dlg_properties_show()
	local dlg_property_ =  require "app.Tool.dlg_properties_show"
	return dlg_property_
end

-- function dlg_copy_gid()
	-- local dlg_copy_gid_ = require "app.Tool.dlg_copy_gid"
	-- return dlg_copy_gid_
-- end

function dlg_last_version()
	local dlg_last_ver_ =  require "app.Tool.dlg_last_version"
	return dlg_last_ver_
end 

function dlg_merge_version()
	local dlg_merge_version_ = require "app.Tool.dlg_merge_version"
	return dlg_merge_version_
end 

function dlg_check_out()
	local dlg_check_out_ = require "app.Tool.dlg_check_out"
	return dlg_check_out_
end 

function dlg_checkout_fix()
	local dlg_checkout_fix_ = require "app.Tool.dlg_checkout_fix"
	return dlg_checkout_fix_
end 

function dlg_branch_switch()
	local dlg_branch_switch_ = require "app.Tool.dlg_branch_switch"
	return dlg_branch_switch_
end

function dlg_select_merge()
	local dlg_select_merge_ = require "app.Tool.dlg_select_merge"
	return dlg_select_merge_
end 

function dlg_new_progress_bar()
	local dlg_new_progress_bar_ = require "app.Tool.dlg_new_progress_bar"
	return dlg_new_progress_bar_
end 


function dlg_update_pro()
	local dlg_update_pro_ = require "app.Tool.dlg_update_pro"
	return dlg_update_pro_
end 

function dlg_update_pro_file()
	local dlg_update_pro_file_ = require "app.Tool.dlg_update_pro_file"
	return dlg_update_pro_file_
end 

function dlg_import_files_exist()
	local dlg_import_files_exist_ = require "app.Tool.dlg_import_files_exist"
	return dlg_import_files_exist_
end 

--]]
-------------------------------Version 文件夹   -------------------
function ver_op()
	local ver_op_ = require "app.Workspace.version.ver_op"
	return ver_op_
end 


function base_op()
	local base_op_ = require "app.Workspace.version.base_op"
	return base_op_
end 

-- function base_op()
	-- local base_op_ = require "app.Version.base_op"
	-- return base_op_
-- end 

-----------------------------Draw 文件夹   -------------------
--[[
-- function ClassFileVer()
	-- local ClassFileVer_ = require "app.Workspace.ClassFileVer"
	-- return ClassFileVer_
-- end

-- function ClassFile()
	-- local ClassFile_ = require "app.Workspace.ClassFile"
	-- return ClassFile_
-- end 

-- function ClassArrow()
	-- local ClassArrow_ = require "app.Workspace.ClassArrow"
	-- return ClassArrow_
-- end 

-- function ClassDirectory()
	-- local ClassDirectory_ = require "app.Workspace.ClassDirectory"
	-- return ClassDirectory_
-- end 

-- function Char()
	-- local chars_ = require "app.Workspace.Char"
	-- return chars_
-- end 

-- function draw_file()
	-- local draw_file_ = require "app.Workspace.draw_file"
	-- return draw_file_
-- end 

-----------------------------Controler 文件夹   -------------------
 
-- function ctr_version()
	-- local ctr_version_ = require "app.Workspace.ctr_version"
	-- return ctr_version_
-- end

-- function ctr_server()
	-- local ctr_server_ = require "app.Workspace.ctr_server"
	-- return ctr_server_
-- end

--]]

------------------------------------------------------------------------------new --------------------------------------
function docks()
	local docks_ = require "sys.dock"
	return docks_
end
--[[
function dlg_template()
	local dlg_template_ = require "app.Workspace.dlg_template"
	return dlg_template_
end

function dlg_tree_add_node()
	local dlg_tree_add_node_ = require "app.Workspace.dlg_tree_add_node"
	return dlg_tree_add_node_
end

function dlg_copy_gid()
	local dlg_copy_gid_ = require "app.Workspace.dlg_copy_gid"
	return dlg_copy_gid_
end
--]]

function workspace_op()
	local workspace_op_ = require "app.workspace.workspace_op"
	return workspace_op_
end

--[[
function dlg_manage_user()
	local dlg_manage_user_ = require "app.workspace.dlg_manage_user"
	return dlg_manage_user_
end


function dlg_manage_team()
	local dlg_manage_team_ = require "app.workspace.dlg_manage_team"
	return dlg_manage_team_
end


function dlg_import()
	local dlg_import_ = require "app.workspace.dlg_import"
	return dlg_import_
end


function dlg_workflow_start()
	local dlg_workflow_start_ = require "app.workspace.dlg_workflow_start"
	return dlg_workflow_start_
end


function dlg_add_user()
	local dlg_add_user_ = require "app.workspace.dlg_add_user"
	return dlg_add_user_
end
--]]
--

function interface()
	return require "app.workspace.interface"
end

function dlg_tree_rename()
	local dlg_tree_rename_ = require "app.workspace.dlg.dlg_tree_rename"
	return dlg_tree_rename_
end

function func()
	local function_ = require"app.workspace.function"
	return function_
end

function Workspace()
	local Workspace_ = require "app.workspace.Workspace"
	return Workspace_
end

function tree_op()
	local tree_op_ = require "app.workspace.tree_op"
	return tree_op_
end

function rmenu()
	local rmenu_ = require "app.workspace.Rmenu"
	return rmenu_
end

function rmenu_op()
	local rmenu_op_ = require "app.workspace.rmenu_op"
	return rmenu_op_
end

function file_op()
	local file_op_ = require "app.workspace.file.file_op"
	return file_op_
end

function file_save()
	local file_save_ = require "app.workspace.file.file_save"
	return file_save_
end

function dlg_resource()
	local resource_ = require "app.workspace.dlg.dlg_resource"
	return resource_;
end

function add_view()
	local add_view_ = require "app.workspace.dlg.add_view"
	return add_view_
end

function dlg_project_list()
	local dlg_project_list_ = require "app.workspace.dlg.dlg_project_list"
	return dlg_project_list_
end

function zip_op()
	local zip_op_ = require "app.workspace.zip_op"
	return zip_op_
end

function dlg_show_links()
	local dlg_assign_ = require "app.workspace.dlg.dlg_show_links"
	return dlg_assign_
end


function dlg_assign_view()
	local dlg_assign_view_ = require "app.workspace.dlg.dlg_assign_view"
	return dlg_assign_view_
end

function dlg_rev_assign()
	local dlg_rev_assign_ = require "app.workspace.dlg.dlg_rev_assign"
	return dlg_rev_assign_
end

function dlg_show_files()
	local dlg_show_files_ = require "app.workspace.dlg.dlg_show_files"
	return dlg_show_files_
end
function op_server()
	local op_server_ = require "app.workspace.op_server"
	return op_server_
end 

function project_db()
	return require "app.workspace.project_db"
end
