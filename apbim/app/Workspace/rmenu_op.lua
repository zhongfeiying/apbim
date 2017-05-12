
_ENV = module(...,ap.adv)
--module(...,package.seeall)
-- open op
local lfs = require "lfs"
local luaext_ = require "app.workspace.ctr_require".luaext() 
local base_op_ = require "app.workspace.ctr_require".base_op()
local workspace_ = require "app.workspace.ctr_require".Workspace()
local zip_op_ =  require "app.workspace.ctr_require".zip_op()
local server_op_ =  require "app.workspace.ctr_require".server_op()
local file_op_ = require "app.workspace.ctr_require".file_op()
local workspace_ = require "app.workspace.ctr_require".Workspace()
local tree_op_ = require "app.workspace.ctr_require".tree_op()
local dlg_tree_rename_ = require "app.workspace.ctr_require".dlg_tree_rename()
local dlg_resource_ = require "app.workspace.ctr_require".dlg_resource()
--local dlg_assign_ = require "app.workspace.ctr_require".dlg_assign()
local dlg_assign_view_ = require "app.workspace.ctr_require".dlg_assign_view()
local dir_tools_ = require "app.workspace.ctr_require".dir_tools()
local dlg_show_links_ = require "app.workspace.ctr_require".dlg_show_links()
local ctr_require_ = require "app.workspace.ctr_require"
local project_db_ = ctr_require_.project_db()  
local op_server_ = ctr_require_.op_server()  

local tar_counts_ = nil
function tar_file(diskfile,tarfile)
	--if not  file_op_.check_file_exist(diskfile) then return end 
	if  not file_op_.check_file_exist(diskfile) then return end 
	local ar = zip_op_.zip_create(tarfile)
	if not ar then return end 
	zip_op_.zip_add_file(ar,"Projects\\__Projects.lua","file",diskfile,true) --参数是 zip文件中显示的名字，添加的压缩类型，添加的压缩文件源
	zip_op_.zip_close(ar)
end

local function tar_project_file(t)
	local db = project_db_.get()
	--local path = file_op_.get_bca_save_path()
	--local path = require"app.Project.dlg".get_path();
	local path = file_op_.get_bca_save_path()
	if db[t.name] then 
		tar_file(path .. "temp\\" .. db[t.name].Gid,path .. db[t.name].Name)
	end 
	tar_counts_ = tar_counts_ or 1
	tar_counts_ = tar_counts_ - 1
	if tar_counts_ == 0 then 
		--os.execute("rd /s /q " .. path .. "temp")
		os.execute("if  exist " .. "\"" ..  path .. "temp" .. "\"" .. " rd /s /q " .. "\"" ..  path  .. "temp" .. "\"");
		tar_counts_ = nil
	end 
end

local function get_path_apc_file(path)
	if not path then return {} end 
	local files = {}
	for line in lfs.dir(path) do
		local attr = lfs.attributes(path .. line)
		if attr.mode == "file" then 
			if string.sub(line,-4,-1) == ".apc" then 
				files[line] = true 
			end
		end 
	end
	return files
end

local function deal_project_db()
	project_db_.init()
	local db = project_db_.get()
	--local path = require"app.Project.dlg".get_path();
	local path = file_op_.get_bca_save_path()
	--local path = file_op_.get_bca_save_path()
	--os.execute("mkdir " .. path .. "Temp")
	os.execute("if not exist " .. "\"" ..  path .. "Temp" .. "\"" .. " mkdir " .. "\"" ..  path .. "Temp" .. "\"");
	local apcfiles = get_path_apc_file(path)
	tar_counts_ = tar_counts_ or 0
	for k,v in pairs (db) do 
		if type(v) == "table" and not apcfiles[v.Name] then 
			tar_counts_ = tar_counts_ + 1
			--create_a_zip_file(file)
			project_db_.get_net_file(v.Gid,path .. "temp\\",tar_project_file)
		end
	end 
	if tar_counts_ == 0 then 
		os.execute("if  exist " .. "\"" ..  path .. "temp" .. "\"" .. " rd /s /q " .. "\"" ..  path  .. "temp" .. "\"");
		tar_counts_ = nil
	end 
end 




function user_project_manager()
	project_db_.get_net_file(name,path,deal_project_db)
end


function check_update(tree,file)
	local tab,rest = tree_op_.get_tree_data(tree,0)
	local ar = zip_op_.zip_create(file)
	if not ar then return end 
	local t = zip_op_.zip_get_filesname_in(ar)
	local update = false
	for k,v in ipairs (rest) do 
		if not t["Projects\\res\\" .. v.hid] then 
			update = true 
			break
		end 
	end
	zip_op_.zip_close(ar)
	if update then 
		iup.Message("Warning","The Project has been changed,Please update the project !")
	end 
end

function msg_open(tree,tid,allpathstr)
	if not tree or not tid or not allpathstr then return end 
	if tree["kind" .. tid] == "LEAF" then 
		local newstr = ""
		local nums= 0
		for dir in string.gmatch(allpathstr,"[^/]+") do 
			if string.find(dir,"%s+") then 
				if nums == 0 then 
					newstr = newstr .. "\"" .. dir .. "\""
				else 
					newstr = newstr .. "/" .. "\"" .. dir .. "\""
				end 
			else 
				if nums == 0 then 
					newstr = newstr .. dir
				else 
					newstr = newstr .. "/" .. dir
				end 
			end 
			nums = nums + 1
		end 
		newstr = string.gsub(newstr,"/","\\")
		os.execute("if exist " .. newstr .. ". ( start " .. newstr .. " .) else echo file missing !")
	else
		local exist = lfs.dir(string.gsub(allpathstr,"/","\\"))()
		if not exist then iup.Message("Warning","The work path has been deleted !Please reset !") return end 
		os.execute("explorer " .. "\"" .. string.gsub(allpathstr,"/","\\") .. "\"")
	end 	
end 


--[[
local dlg_ = nil
function add_user_version(t,dlg)
	dlg_ = dlg
	local title,msg = "User","New Register !"
	--if not msg then return add_user_version(t)  end 
	t.title = title 
	t.msg = msg 
	ctr_version_.add_dir(t)
	server_op_.upload_file()
end
--]]
--
--
function lua_copy_file(source,destination)
	local sourcefile = io.open(source,"rb")
	local destinationfile = io.open(destination,"w+")
	for line in sourcefile:lines() do 
		destinationfile:write(line)
	end
	sourcefile:close()
	destinationfile:close()
end

function set_node_gid(tree,tid,type)
	local t = iup.TreeGetUserId(tree,tid)
	type = type or 0
	if not t or not t.gid then 
		t=  t or {}
		t.gid = luaext_.guid() .. type
	end
	iup.TreeSetUserId(tree,tid,t)
end

local function create_tree_datas(tree,tid,tab)
	local t = iup.TreeGetUserId(tree,tid)
	if not t then t = {} end
	if not t.gid then t.gid = luaext_.guid() end 
	if not t.name then t.name = tree["title" .. tid] end 
	if tree["kind" .. tid] == "LEAF" then 
		if t.res then 
			for k,v in ipairs (t.res) do
				if v.ifo  then 
					local path = string.match(v.ifo,"(.+/).+")
					v.hid = base_op_.get_file_hash(string.gsub(v.ifo,"/","\\"))
					v.hidpath = path .. v.hid
					if v.hid then 
						lua_copy_file(string.gsub(v.ifo,"/","\\"),string.gsub(path,"/","\\") .. v.hid)
						table.insert(tab,v.hidpath)
					end
				end 
			end
		end
	end
	iup.TreeSetUserId(tree,tid,t)
end

local function create_id(tree,tid,tab)
	local totalnums = tonumber(tree.count)
	if totalnums == 0 then return end 
	for i = 0,totalnums - 1 do 
		create_tree_datas(tree,i,tab)
	end
end


function upload_files(uploaddatas) 
	for k,v in ipairs (uploaddatas) do
		v= string.gsub(v,"\\","/")
		server_op_.upload_append({path = v,name = string.match(v,".+/(.+)")})
	end
	server_op_.upload_file()
end

function deal_push_action(tree,tid)
	local filename = workspace_.get_proname()
	if not filename then return end 
	local upload_list = {}
	create_id(tree,tid,upload_list)
	workspace_.save_pro()
	local dirpath = string.match(filename,"(.+\\).+")
	local indexpath = dirpath .. "__Projects.lua"
	local t = iup.TreeGetUserId(tree,0)
	if not t.gid then return end 
	lua_copy_file(indexpath,dirpath .. t.gid)
	table.insert(upload_list,1,dirpath .. t.gid)
	upload_files(upload_list)
	--upload_datas()
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function create_a_zip_file(tree,FileAllPath,id)
	local dirpath = string.match(FileAllPath,"(.+\\).+")
	local indexpath = dirpath .. "__Projects.lua"
	local tab,rest = tree_op_.get_tree_data(tree,0)
	local ar = zip_op_.zip_create(FileAllPath)
	if not ar then return end 
	local tempt = {}
	for k,v in ipairs (rest) do
		local oldhid = v.hid
		local str = string.gsub(v.ifo,"/","\\")
		v.hid = base_op_.get_file_hash(str)
		if  v.hid then 
			--local Dstr = string.match(str,"(.+\\).+") .. v.hid
			local Dstr = v.hid
			lua_copy_file(str,Dstr)
			zip_op_.zip_add_file(ar,"Projects\\res\\" .. v.hid,"file",Dstr)
			--zip_op_.zip_add_file(ar,"res\\" .. v.hid,"file",str)
			if oldhid and oldhid ~= v.hid then 
				zip_op_.zip_delete_file(ar,"Projects\\res\\" .. oldhid)
			end
			table.insert(tempt,Dstr)
		end
	end
	file_op_.save_table_to_file(indexpath,tab)
	zip_op_.zip_add_file(ar,"Projects\\__Projects.lua","file",indexpath,true) --参数是 zip文件中显示的名字，添加的压缩类型，添加的压缩文件源
	zip_op_.zip_close(ar)
	for k,v in ipairs (tempt) do
		os.remove(v)
	end
	os.remove(indexpath)
end

function zip_to_local(ar,FileAllPathInZip,LocalPath)
	
	local ZipReadOneFile = zip_op_.zip_read_file_in(ar,FileAllPathInZip)
	if not ZipReadOneFile then trace_out("file error = " .. FileAllPathInZip .. "\n") return end 
	local stat = zip_op_.zip_get_file_stat_in(ar,FileAllPathInZip)
	if stat then
		file_op_.del_file_read_attr(LocalPath)
		local file = io.open(LocalPath,"wb")
		file:write(ZipReadOneFile:read(stat.size))
		file:close()
	end
	zip_op_.zip_close(ZipReadOneFile)
end

function read_zip_file(FileAllPath)
	local dirpath = string.match(FileAllPath,"(.+\\).+")
	local indexpath = dirpath .. "__Projects.lua"
	local ar = zip_op_.zip_create(FileAllPath)
	if not ar then return end 
	local t = zip_op_.zip_get_filesname_in(ar)
	for k,v in pairs (t) do 
		if k == "Projects\\__Projects.lua" then 
			zip_to_local(ar,v,indexpath)
			break;
		end
		--if k ~= "__Projects.lua" and string.sub(k,-1,-1) ~="/" then
		--	if string.lower(string.sub(k,1,3)) == "res" then 
				--zip_to_local(ar,v,"data\\BCA.Res\\" .. k)
		--	end	
		--end
	end
	zip_op_.zip_close(ar)
	
	return indexpath
end



function show_all_model(name)
	local sc = require "sys.mgr".new_scene{name =name}
	local ents = require "sys.mgr".get_all()
	if type(ents) ~= "table" then return end 
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		-- require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Diagram);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	require"sys.mgr".update(sc);
end


local function assign_view_ifo(name)
	local sc = require "sys.mgr".get_cur_scene()
	if not sc then return end 
	local vw = require "sys.mgr".get_view(sc)

	local smd = require "sys.Group".Class:new(vw)
	smd:set_name(name)
	smd:set_scene(sc)
	smd:add_scene_all()
	if smd.mgrids then
		for k,v in pairs (smd.mgrids) do             
			smd.mgrids[k] = require "sys.mgr".get_table(k)
		end
    end

	require "sys.mgr".add(smd)
	--local str = require "sys.table".tostr(smd)
	--trace_out("str = " .. type(str) .. "\n")

	local t = {}
	t[smd.mgrid] = true
	return t
end

local function assign_entity_ifo()
	local curs = require "sys.mgr".curs()
	if not curs then return end 
	local t = {}
	for k,v in pairs (curs) do
		t[k] = true 
	end
	return t
end

local function deal_import_file(tree,tid,path,name)
	tree["addleaf" .. tid] = name
	local t,per = {},{}
	t.res = {}
	per.ifo = string.gsub(path .. name ,"\\","/")
	per.type = string.match(name,".+%.(.+)")
	per.name = name
	table.insert(t.res,per)
	iup.TreeSetUserId(tree,tid+1,t)
	tree_op_.set_image(tree,tid+1,tree_op_.get_image(tree,"Documents",tid+1) )
--	set_node_gid(tree,tid + 1,0)
end

local function deal_import_folder_datas(tree,tid,data,path)
	for k,v in ipairs (data) do
		if v.datas then
			tree["addbranch" .. tid] = v.name
--			set_node_gid(tree,tid + 1,0)
			deal_import_folder_datas(tree,tid+1,v.datas,path .. v.name .. "\\")
		else
			deal_import_file(tree,tid,path,v.name)
		end
	end
end


local function get_import_files_name(val,name,i)
	i = #val - i + 1
--	local curpath = string.gsub(val,name,"")
	local curpath = string.sub(val,1,#val - #name)
	
	local file_names = {}
	if string.find(name,"|") then 
		local save_i = nil
		if string.sub(name,1,1) ~= "|" then 
			save_i = string.find(name,"|",1)
			name = string.sub(name,save_i,-1)
		end
		if save_i then 
			curpath = string.sub(val,1,i + save_i- 1)
			curpath = curpath .. "\\"
		else 
			curpath = string.sub(val,1,i)
		end 
		for per in string.gmatch(name,"[^|]+") do 
			table.insert(file_names,{name = string.lower(per)})
		end
	else 
		table.insert(file_names,{name = string.lower(name)})
	end
	return curpath,file_names
end 

local function get_import_files(val)
	local str = string.reverse(val)
	local i = string.find(str,"\\")
	local name = string.reverse(string.sub(str,1,i -1) )
	return get_import_files_name(val,name,i)
end 

local function get_apc_file_data(FileAllPath)
	local dirpath = string.match(FileAllPath,"(.+\\).+")
	local indexpath = dirpath .. "__Projects.lua"
	local ar = zip_op_.zip_create(FileAllPath)
	if not ar then return end 
	os.remove(indexpath)
	local t = zip_op_.zip_get_filesname_in(ar)
	for k,v in pairs (t) do 
		if k == "Projects\\__Projects.lua" then 
			zip_to_local(ar,v,indexpath)
			break;
		end
	end
	zip_op_.zip_close(ar)
	return indexpath
end
local function get_tpl_file_data(path)
	
end

----------------------------------------------------------------------------------------------------------------------------------
-- item add


function msg_add_folder(tree,tid)
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if not val then return end 
	tree["addbranch" .. tid] = val
	tree["state" .. tid] = "EXPANDED"
--	set_node_gid(tree,tid + 1,0)
end

function msg_add_file(tree,tid)
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if not val then return end
	tree["addleaf" .. tid] = val
	tree_op_.set_image(tree,tid+1,tree_op_.get_image(tree,"Documents",tid+1) )
	tree["state" .. tid] = "EXPANDED"
--	set_node_gid(tree,tid + 1,0)
end

function msg_add_resource(tree,tid)
	dlg_resource_.pop()	
	local data = dlg_resource_.get_data()
	if not data then return end
	tree["addleaf" .. tid] = data.name
	iup.TreeSetUserId(tree,tid+1,data)
	tree_op_.set_image(tree,tid+1,tree_op_.get_image(tree,"Documents",tid+1) )
	tree["state" .. tid] = "EXPANDED"
--	set_node_gid(tree,tid + 1,0)
end
----------------------------------------------------------------------------------------------------------------------------------
--  ins

function msg_ins_folder(tree,tid)
	if not tree or not tid then return end 
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if not val then return end
	tree["insertbranch" .. tid] = val
	local curid = tid + 1 + tree["totalchildcount" .. tid]
--	set_node_gid(tree,curid,0)

end

function msg_ins_file(tree,tid)
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if not val then return end
	tree["insertleaf" .. tid] = val
	local cur_id = tid + 1 + tree["totalchildcount" .. tid]
	iup.TreeSetUserId(tree,cur_id,data)
	tree_op_.set_image(tree,cur_id,tree_op_.get_image(tree,"Documents",cur_id) )
	local curid = tid + 1 + tree["totalchildcount" .. tid]
--	set_node_gid(tree,curid,0)
end


function msg_ins_resource(tree,tid)
	dlg_resource_.pop()	
	local data = dlg_resource_.get_data()
	if not data then return end
	tree["insertleaf" .. tid] = data.name
	local cur_id = tid + 1 + tree["totalchildcount" .. tid]
	iup.TreeSetUserId(tree,cur_id,data)
	tree_op_.set_image(tree,cur_id,tree_op_.get_image(tree,"Documents",cur_id) )
	local curid = tid + 1 + tree["totalchildcount" .. tid]
--	set_node_gid(tree,curid,0)
end
----------------------------------------------------------------------------------------------------------------------------------
--  import

function msg_import_folder(tree,tid,dir)
	if string.sub(dir,-1,-1) ~= "\\" then dir = dir .. "\\" end 
	local tab = dir_tools_.get_folder_content(dir)
	if not tab then return end 
	local curpath = string.sub(dir,1,#dir - #tab[1].name - 1)
	deal_import_folder_datas(tree,tid,tab,curpath)
	tree["state" .. tid] = "EXPANDED"
end

--function msg_import_files(tree,tid,filedlg) 
function msg_import_files(tree,tid,path) 
	local path,file_names = get_import_files(path) 
	--[[
	local path,file_names =nil,{} 
	local counts = filedlg.MULTIVALUECOUNT
	for i = 1,counts do 
		if i == 1 then 
			path = filedlg["MULTIVALUE" .. (i-1)] .."\\"
		else 
			table.insert(file_names,{name = filedlg["MULTIVALUE" .. (i-1)]})
		end
	end
	trace_out("path = " .. path .. "\n")

	--]]
	for k,v in ipairs(file_names) do 
		deal_import_file(tree,tid,path,v.name)
	end
	tree["state" .. tid] = "EXPANDED"	
end



function msg_import_tpl(tree,tid,path)
	workspace_.change_pro()
	local datas = nil
	if string.lower(string.sub(path,-3,-1)) == "apc" then
		path = get_apc_file_data(path)
	end
	local data = file_op_.get_file_data(path)
	os.execute("if exist \"" .. path  .. "\" del /f /q \"" .. path .. "\"")
	if not data then return end 
	tree_op_.set_tree_datas(tree,data,"clear")
	tree.STATE0 = "EXPANDED"
end
----------------------------------------------------------------------------------------------------------------------------------
--  ins

function msg_rename(tree,tid)
	 dlg_tree_rename_.set_val(tree["title" .. tid])
	 dlg_tree_rename_.pop()
	 local val = dlg_tree_rename_.get_val()
	 if not val then return end
	 tree["title" .. tid] =  val
end


function msg_assign_view(tree,tid)
	local sc = require "sys.mgr".get_cur_scene()
	if not sc then iup.Message("Notice","No current view !") return end 
	local view = {}
	view.type = "View"
	dlg_assign_view_.set_data(view)
	dlg_assign_view_.pop()
	if view.title then 
		local t = iup.TreeGetUserId(tree,tid)
		if not t then t = {} end 
		if not t.LinkViews then t.LinkViews = {} end
		--if not t.links then t.links = {} end
		local title = tree["title" .. tid]
		view.ifo = assign_view_ifo(title) or {};
		table.insert(t.LinkViews,view)
		iup.TreeSetUserId(tree,tid,t)
	end
end
local function table_is_empty(t)
	return _G.next(t) == nil
end
function msg_assign_entity(tree,tid)
	local curs = require "sys.mgr".curs()
	if not curs or table_is_empty(curs) then iup.Message("Notice","No members to be selected !") return end 
	local view = {}
	view.type = "Member"
	dlg_assign_view_.set_data(view)
	dlg_assign_view_.pop()
	if view.title then 
		local t = iup.TreeGetUserId(tree,tid)
		if not t then t = {} end 
		--if not t.links then t.links = {} end
		if not t.LinkEntities then t.LinkEntities = {} end
		view.ifo = assign_entity_ifo() or {};
		table.insert(t.LinkEntities,view)
		iup.TreeSetUserId(tree,tid,t)
	end
end


function msg_assign_files(tree,tid,path)
	local path,file_names = get_import_files(path)
	local t = iup.TreeGetUserId(tree,tid) or {}
	t.res = t.res or {}
	for k,v in ipairs (file_names) do
		local tempt = {}
		tempt.ifo = string.gsub(path .. v.name,"\\","/")
		tempt.type = string.match(v.name,".+%.(.+)") 
		tempt.name = v.name
		table.insert(t.res,tempt)
	end
	iup.TreeSetUserId(tree,tid,t)
end

--[[
function msg_assign_show(tree,tid)
	local t = iup.TreeGetUserId(tree,tid)
	if not t then 
		iup.Message("Notice","The Node is a empty node !")
		return
	end
	dlg_assign_.set_data(t)
	dlg_assign_.pop()	
	local datas = dlg_assign_.get_data()
	if datas then 
		t.links = datas
		iup.TreeSetUserId(tree,tid,t)
	end
end
--]]
--

function msg_show_links(tree,tid)
	local t = iup.TreeGetUserId(tree,tid)
	if not t then 
		iup.Message("Notice","The node does not have anything to do with it !")
		return
	end
	dlg_show_links_.set_data(t)
	dlg_show_links_.pop()
	local datas = dlg_show_links_.get_data()
	if datas then 
		iup.TreeSetUserId(tree,tid,datas)
	end
end

function msg_show_model(tree,tid)
	local name = tree["title" .. tid]
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then 
		show_all_model(name)
	else 
		local vw = require"sys.mgr".get_view(sc);
		if vw and vw.Name ~= name then 
			for i,v in ipairs(require"sys.mgr".find_scene{name=name}) do
				require"sys.mgr".close_scene(v)
			end
			show_all_model(name)
		end
	end

end

function msg_export_tpl(tree,tid,path)
	local tab,rest = tree_op_.get_tree_data(tree,0,"clear")
	file_op_.save_table_to_file(path,tab)
end




function msg_upload_project(tree,tid)
--	local file = require "sys.mgr.model".get_zipfile()
	--if not file then return end 
	tree = tree or workspace_.get_tree()
	local file = workspace_.get_cur_zip_file()
	if not file then  iup.Message("Notice","Please open a project or save the new project ! ") return end 
	local t = iup.TreeGetUserId(tree,0) or {}
	t.Server = true
	iup.TreeSetUserId(tree,0,t)
	workspace_.save_pro()
	require "sys.mgr".upload{zipfile = file}
	op_server_.upload_all_files(tree,file)
	local db = {}
	db.Gid =  t.gid 
	db.Name = string.match(file,".+\\(.+)")
	db.MGid =  t.mgid or require "sys.mgr".get_model_id()
	project_db_.add(db)
end

function get_id(file)
	local db_ = project_db_.get()
	for k,v in pairs(db_) do 
		if v.Name == file then 
			return v
		end 
	end
end

local function remove_dir()
	local file = workspace_.get_cur_zip_file()
	if not file then return end 
	local path = string.match(file,"(.+\\).+")
	os.execute("if  exist " .. "\"" ..  path .. "Temp" .. "\"" .. " rd /s /q " .. "\"" ..  path .. "Temp" .. "\"");
end

local function update_tree(t)
	-- local file = require "sys.mgr.model".get_zipfile()
	-- if not file then return end 
	local file = workspace_.get_cur_zip_file()
	if not file then  return end 
	local path = string.match(file,"(.+\\).+")
	tar_file(path .. "temp\\" .. t.name,file)
	remove_dir()
	local tree = workspace_.get_tree()
	if not tree then  return end 
	workspace_.init_data(file)
--	check_update(tree,file)
	op_server_.download_all_files(tree,file)
end

local function download_model_ok()
	local file = workspace_.get_cur_zip_file()
	if not file then return end 
	require "sys.mgr".save{zipfile = file}
	require"sys.mgr".open{zipfile=file};
end

function msg_update_project(tree,tid)
	-- local file = require "sys.mgr.model".get_zipfile()
	-- if not file then return end 
	
	local file = workspace_.get_cur_zip_file()
	if not file then iup.Message("Notice","Please open a project or save the new project ! ") return end 
	tid = tid or 0
	tree = tree or workspace_.get_tree()
	local t = iup.TreeGetUserId(tree,tid)
	if not t or not t.gid then return end 
	local path = string.match(file,"(.+\\).+")
	os.execute("if not exist " .. "\"" ..  path .. "Temp" .. "\"" .. " mkdir " .. "\"" ..  path .. "Temp" .. "\"");
	project_db_.get_net_file(t.gid,path .. "temp\\",update_tree)
	return true 
end

function update_model(tree,tid)
	tid = tid or 0
	tree = tree or workspace_.get_tree()
	local t = iup.TreeGetUserId(tree,tid)
	if t and t.mgid then 
		require "sys.mgr".download{id = t.mgid,cbf = download_model_ok}
	end
end

function get_model_id()
	return require "sys.mgr".get_model_id()
end 

function msg_get_cur_project_id(tree,tid)
	local file = workspace_.get_cur_zip_file()
	if not file then iup.Message("Notice","Please open a project !") return end 
	local t = iup.TreeGetUserId(tree,0)
	if not t or not t.gid  then return end 
	dlg_tree_rename_.set_val(t.gid)
	dlg_tree_rename_.pop()
end

local function download_next(t)

	if file_op_.check_file_exist(t.path .. t.name) then 
		
		dofile(t.path .. t.name)
		local db_ = db
		_G.db = nil
		if not db_ then return end 
		local t= db_.attributes or {}
		if not t.filename then return end 
		local file = string.gsub(t.filename,"/","\\")
		local path = string.match(file,".(+\\).+")
		require "sys.mgr".download{id = t.mgid,cbf = download_model_ok,zipfile = file}
		local newt = {}
		newt.name = t.gid
		newt.path = path .. "temp\\"
		update_tree(newt)
		
	end 
end 

function download()
	dlg_tree_rename_.set_val()
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if not val then return end 
	--os.execute("mkdir " .. path .. "Temp")
	os.execute("if not exist " .. "\"" .. path .. "Temp".. "\"" .. " mkdir " .. "\"" .. path .. "Temp" .. "\"");
	project_db_.get_net_file(val,path .. "temp\\",download_next)
end

function msg_send_to(tree)
	local newfile = workspace_.get_cur_zip_file()
	if not newfile then iup.Message("Notice","Please open a project or save the new project ! ") return end 
	dlg_tree_rename_.set_val()
	dlg_tree_rename_.pop()
	local val = dlg_tree_rename_.get_val()
	if type(val) ~= "string" then return end 
	local file, path_ = project_db_.get_file_ifo(val)
	--if not file then iup.Message() return end 
	path_ = string.gsub(path_,"/","\\")
	local allpath = string.gsub(path_,"/","\\") .. file
	
	local t = iup.TreeGetUserId(tree,0)
	if not t or not t.Server then iup.Message("Warning","Please upload the current project firstly!") return end 
	local db = {}
	db[t.gid] = {}
	db[t.gid].Gid = t.gid 
	db[t.gid].Name = string.match(newfile,".+\\(.+)")
	db[t.gid].MGid = t.mgid or require "sys.mgr".get_model_id()
	file_op_.save_table_to_file(allpath,db)
	project_db_.save_net_file(file,path,function(t) os.remove(t.path .. t.name) end )

end

