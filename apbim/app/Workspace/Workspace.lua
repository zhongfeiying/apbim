
_ENV = module(...,ap.adv)
--module(...,package.seeall)
local file_op_ = require "app.workspace.ctr_require".file_op()
local tree_op_ = require "app.workspace.ctr_require".tree_op()
local rmenu_ = require "app.workspace.ctr_require".rmenu()
local rmenu_op_ = require "app.workspace.ctr_require".rmenu_op()
--local server_db_ = require "app.workspace.ctr_require".server_db()
local dlg_project_list_ = require "app.workspace.ctr_require".dlg_project_list()
local docks_ = require "app.workspace.ctr_require".docks()
local dlg_tree_rename_ =require "app.workspace.ctr_require".dlg_tree_rename()
local dlg_show_files_ =require "app.workspace.ctr_require".dlg_show_files()
local op_server_ =require "app.workspace.ctr_require".op_server()
require "lfs"
local workspace_ = {}
local tree_;

local function init_controls()
	tree_ = iup.tree{};
	tree_.font = "COURIER_NORMAL_10"
	tree_.addexpanded = "NO"
	tree_.expand="YES"
	tree_.SHOWCLOSE = "NO"
	tree_.tabtitle = "BIM View"
	docks_.add_page(tree_)
	--docks_.pop()
	tabs = docks_.get_tabs()
end


function get_tree()
	return tree_
end

function get_tab_pos()
	return tonumber(tabs.VALUEPOS)
end
------------------------------------------------------------------------------------
--iup 回调
--
--
local zip_file_ = nil
function set_cur_zip_file(file)
	zip_file_ = file
end

function get_cur_zip_file()
	-- local file = require "sys.mgr.model".get_zipfile() 
	-- zip_file_ = file or zip_file_
	return zip_file_
end


local function init_callback()
	local save_sel_id = 0
	function tree_:rightclick_cb(id)
		if not save_sel_id then return end 
		self["MARKED" .. id] = "yes"
		tree_.showrename = "NO"
		local t = iup.TreeGetUserId(tree_,save_sel_id)
		--require"sys.table".totrace(t)
		rmenu_.pop() 
	end
	--[[
	function tree_:selection_cb(id,number)
		tree_.showrename = "NO"
		if number == 1 then 
			save_sel_id = id
			if tree_["KIND" .. id] == "LEAF" then 
				local t = iup.TreeGetUserId(tree_,save_sel_id)
				if t and t.LinkEntities then
					local sc = require"sys.mgr".get_cur_scene();
					if not sc then return end 
					local ents = {}
					local status =false
					for k,v in ipairs (t.LinkEntities) do
						if v.type== "Member" then
							status = true
							for m,n in pairs (v.ifo) do
								local ent = require "sys.mgr".get_table(m)
								ents[m] =ent
							end
						end
					end
					if status then
						local CurSceneAll = require "sys.mgr".get_scene_all(sc)
						if not CurSceneAll then return end 
						local newents = {}
						local status = false 
						require "sys.mgr".select_none({redraw = true})
						for k,v in pairs (ents) do 
							if  CurSceneAll[k] then
								 status = true
								 require "sys.mgr".select(v,true)
								 require "sys.mgr".redraw(v)
								 newents[k] = v
							end
						end
						if status then 
							require "sys.mgr".scene_to_fit{scene=sc,ents = newents}
							require "sys.mgr".update()
						end
					end
				end
		 
			end
		end 
	end
	--]]
	
	function tree_:selection_cb(id,number)
		tree_.showrename = "NO"
		if number == 1 then 
			save_sel_id = id
		end 
	end


	
	function tree_:button_cb(button, pressed, x, y, str)
		if not save_sel_id then return end 
		if string.find(str,"1") and string.find(str,"D") then 
			if tree_["kind" .. save_sel_id] == "LEAF" then 
				local t = iup.TreeGetUserId(tree_,save_sel_id)
				if t and t.res and #t.res ~= 0  then
					if #t.res ~= 1 then 
						dlg_show_files_.set_datas(t.res)
						dlg_show_files_.pop()
					else 
						local str = string.gsub(t.res[1].ifo,"/","\\")
						local file = io.open(str,"r")
						if not file then 
							dlg_show_files_.set_datas(t.res)
							dlg_show_files_.pop()
						else 
							file:close()
							os.execute("start  \"\" " .. "\""  .. string.gsub(str,"/","\\") .. "\"");

						end
					end
				end 
			end 
		end 
	end 
end
--[[
					for k,v in ipairs (t.res) do
						if string.sub(v.ifo,-4,-1) == ".apc" then 
						else
							--os.execute("start  \"\" " .. "\"" .. lfs.currentdir() .. "\\" .. string.gsub(v.ifo,"/","\\") .. "\"");
							local val =	os.execute("start  \"\" " .. "\""  .. string.gsub(v.ifo,"/","\\") .. "\"");
							
						end
					end 
--]]

function init_data(filename,check)
	tree_.delnode0 = "CHILDREN"
	local file = rmenu_op_.read_zip_file(filename)
	if not file then return end 
	local data = file_op_.get_file_data(file)
	os.remove(file)
	if not data then return end 
	
	tree_op_.set_tree_datas(tree_,data)
	tree_.STATE0 = "EXPANDED"
--	tree_.title0 = tab.user
end

local function get_dlg_select()
	dlg_project_list_:pop()
	return dlg_project_list_.get_data()
end

local function open_model(filename)
	require"sys.mgr".open{zipfile=filename};
end

local function close_all_scene()
	
	local all = require "sys.mgr".get_all_scene()
	for k,v in pairs (all) do 
		require "sys.mgr".close_scene(k)
	end
	require"sys.mgr".init();
end

local filename_ = nil
-- function change_pro(filename)
	-- filename_ = filename
	-- tree_.delnode0 = "CHILDREN"
	-- tree_.title0 = "Project"
	-- close_all_scene()
	-- if filename then 
		-- init_data(filename)
		-- open_model(filename)
	-- end
-- end

function change_pro(filename,new)
	--filename_ = filename
	tree_.delnode0 = "CHILDREN"
	tree_.title0 = "Project"
	iup.TreeSetUserId(tree_,0,nil)
	if new then 
	close_all_scene()
	end 
	if filename then 
	
		set_cur_zip_file(filename)
		
		--rmenu_op_.check_update(tree_,filename)
		--open_model(filename)
		--open_model(filename)
		local status = rmenu_op_.msg_update_project(tree_,0,"check")
		if not status then 
			init_data(filename,check)
			open_model(filename)
		end 
		
	end
end

function locate_tab_page()
	local num = tabs.COUNT
	for i = 1,num do
		local title = tabs["TABTITLE" .. (i-1)]
		if title == "BIM View" then 
			tabs.VALUEPOS = i-1
			break;
		end
	end
end

function create_new_project()
	change_pro()
end

local function save_model(filename)
	require "sys.mgr".save{zipfile = filename}
	
end


function save_pro()
	--[[if not filename_ then 
		local path_ = file_op_.get_bca_save_path()
		if not path_ then return end
		if string.sub(path_,-1,-1) ~= "\\" then 
			path_ = path_ .. "\\"
		end
		--local curpath = lfs.currentdir() .. "\\" .. path_ or ""
		local curpath =  path_ or ""
		local str = tree_.title0
		if not str then return end 
		dlg_tree_rename_.set_val(str)
		dlg_tree_rename_.pop()
		local val = dlg_tree_rename_.get_val()
		if not val then return end
		if #val < 5 or  string.sub(val,-4,-1) ~= ".apc" then 
			val = val ..".apc"
		end
		filename_ = curpath .. val
	end
	if filename_ then 
		if string.sub(filename_,-4,-1) ~= ".apc" then 
			filename_ = filename_ .. ".apc"
		end	
	end ]]
	--local file = require "sys.mgr.model".get_zipfile() 
	if not zip_file_ then 
		local path_ = file_op_.get_bca_save_path()
		if not path_ then return end
		if string.sub(path_,-1,-1) ~= "\\" then 
			path_ = path_ .. "\\"
		end
		--local curpath = lfs.currentdir() .. "\\" .. path_ or ""
		local curpath =  path_ or ""
		local str = tree_.title0
		if not str then return end 
		dlg_tree_rename_.set_val(str)
		dlg_tree_rename_.pop()
		local val = dlg_tree_rename_.get_val()
		if not val then return end
		if #val < 5 or  string.sub(val,-4,-1) ~= ".apc" then 
			val = val ..".apc"
		end
		set_cur_zip_file(curpath .. val)
	end
	rmenu_op_.create_a_zip_file(get_tree(),zip_file_)
	save_model(zip_file_)
	--if not file then file = "Projects\\" .. (tree_["title0"] .. ".apc" or "Test.apc")  end 
	--trace_out("file" .. file .. "\n")
	
--	local t = iup.TreeGetUserId(tree_,0)
--	if not  t then return end 
	--require"sys.mgr".add(t);
--	op_server_.upload_all_files(tree_,file)
	--rmenu_op_.create_a_zip_file(get_tree(),filename_)
	--save_model(filename_)
end

function create()

	
	rmenu_op_.user_project_manager()
	--filename_ = filename
	init_controls()
	init_callback()
	rmenu_.create("Version")
	
	change_pro(path,"new")
end

function cmd_trans()
	--rmenu_op_.cmd_trans()
end 

local function get_tree_path(id,t)
	local t = t or {}
	table.insert(t,1,id)
	if tonumber(id) == 0 then return t end
	return get_tree_path(tree_["parent" .. id],t)
end

function get_links_tab()
	local datas = {}
	if not tree_ then return end 
	for i = 0,tonumber(tree_.COUNT)-1 do 
		if tree_["kind" .. i] == "LEAF" then 
			local t= iup.TreeGetUserId(tree_,i)  
			if t and t.LinkEntities then
				for k, v in ipairs (t.LinkEntities) do 
					if v.type == "Member" then 
						v.tid = i
						v.treetitle = tree_["title" .. i]
						v.treepath = get_tree_path(i)
						table.insert(datas,v)
					end
				end
			end
			
		end
	end
	return datas
end

function get_proname()
	return filename_
end


function open()
	locate_tab_page()
	
	dlg_project_list_.pop(status)
	-- local file = require "sys.mgr.model".get_zipfile() 
	-- if not file then return  end 
	-- local id = require "sys.mgr".get_model_id()
	-- change_pro(file)
end

function new()
	local file = require "sys.mgr.model".get_zipfile()
	zip_file_ = file or zip_file_
	if zip_file_ then 
		local alarm = iup.Alarm("Notice","Do you want to create a new project ?","Yes","No")
		if alarm ~= 1 then return end 
		zip_file_ = nil
	end
	locate_tab_page()
	require"sys.main".init();
	--change_pro(path,"new")
	change_pro(path)
end

function save()
	locate_tab_page()
	save_pro()
end

function upload()
	locate_tab_page()
	rmenu_op_.msg_upload_project(tree_)
	
end

function Update_Porject_List()
	rmenu_op_.user_project_manager()
end

function update()
	locate_tab_page()
	if zip_file_ then 
		rmenu_op_.msg_update_project(tree_,0)
	else
		rmenu_op_.user_project_manager()
	end 
	
	-- local file = require "sys.mgr.model".get_zipfile()
	-- if not file then return end 
	-- op_server_.upload_all_files(tree_,file)
end


function Open_Project_Folder()
	--local file = require "sys.mgr.model".get_zipfile() 
	--if not file then return  end 
	local path = file_op_.get_bca_save_path()
	if not path then return end
	--local path = string.match(file,"(.+\\).+")
	os.execute("explorer \"" .. path .. "\"")
end

function download()
	rmenu_op_.download(tree_)
end
