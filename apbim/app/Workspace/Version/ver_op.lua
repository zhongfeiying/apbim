

_ENV = module(...,ap.adv)

local base_op_ = require "app.workspace.ctr_require".base_op()
local file_op_ = require "app.workspace.ctr_require".file_op()
local dlg_warning_ = require "app.workspace.ctr_require".dlg_warning()
local tree_op_ = require "app.workspace.ctr_require".tree_op()



local function table_is_empty(t)
	return _G.next(t) == nil
end 

function add_file(t)  --版本 控制文件
	local filehash = base_op_.get_file_hash(t.path)
	--dawenjian
	if not filehash then return end 
	local hid =  filehash .. "1"
	t.hid = hid
	base_op_.copy_file(t.path,file_op_.get_version_all_path(t.hid))
	base_op_.add_version(t)
end

function add_dir(t)  --版本 控制文件夹
	local cur_data = t.data or  {}
	local filehash = base_op_.get_temp_hash(cur_data) 
	if not filehash then return end 
	local hid =  filehash .. "0"
	t.hid = hid
	file_op_.save_docs_path_tab(t.hid,cur_data)
	base_op_.add_version(t)
end


function commit_file(t) --版本 控制submit文件
	if not t.branch then t.branch = "master" end
	local filehash = base_op_.get_file_hash(t.path)
	if not filehash then return end 
	local hid =  filehash .. "1"
	local old_hid = base_op_.get_cur_ver_hid(t.gid,t.branch)
	if not old_hid then return  end 
	if old_hid == "empty" then 
		t.hid = hid
		local value = base_op_.com_version(t)
		return value
	else 
		t.old_hid = old_hid
		if  not base_op_.need_commit_file(hid,old_hid) then return  end 
		base_op_.copy_file(t.path,file_op_.get_version_all_path(hid))
		t.hid = hid
		local value = base_op_.com_version(t)
		return value
	end 
end

function commit_dir(t) --版本 控制submit文件夹
	if not t.branch then t.branch = "master" end
	local cur_data = t.data
	if  not cur_data   then 
		cur_data = {}
	end 
	local filehash = base_op_.get_temp_hash(cur_data) 
	if not filehash then return end 
	local hid =  filehash .. "0" 
	local old_hid = base_op_.get_cur_ver_hid(t.gid,t.branch)
	if not old_hid then return  end 
	if old_hid == "empty" then 
		t.hid = hid
		file_op_.save_docs_path_tab(t.hid,cur_data)
		local value = base_op_.com_version(t)
		return value
	else 
		if not base_op_.need_commit_dir(hid,old_hid) then return  end 
		t.old_hid = old_hid
		t.hid = hid
		file_op_.save_docs_path_tab(t.hid,cur_data)
		local value = base_op_.com_version(t)
		return value
	end 
end

local function check_log(gid)
	local value = ""
	value = value .. "if not db then db = {} end  "
	value = value .. "db[#db][\"content\"][\"" .. gid .. "\"] = \"end\" "
	file_op_.save_log_str(value) 
end

local function deal_select_result(cur_type,local_db,doc_db,path,name)
	if cur_type == 0 then 
		return 
	elseif cur_type == 1 then
		base_op_.checkout_local(local_db.gid,path,name)
		check_log(local_db.gid)
		return true 
	elseif cur_type == 2 then 
		base_op_.copy_file(file_op_.get_version_all_path(doc_db[local_db.branch].cur_version),path .. name)
		base_op_.checkout_local(local_db.gid,path,name)
		check_log(local_db.gid)
		return true 
	end 
end 



local  dlg_warning_status_ = nil;
function init_warning_status(status)
	dlg_warning_status_ = status or nil;
end
function checkout_file(gid,path,files)
	--参数是gid check路径 第三个参数不用填
	if not path or not gid then return end 
	os.execute("if not exist " .. "\"" .. path.. "\"" .. " mkdir " .. "\"" .. path .. "\"");
	local local_db = file_op_.get_local_path_tab(gid)
	if not local_db then  return end 
	local doc_db = file_op_.get_docs_path_tab(gid)
	if not doc_db then   return end 
	local name = base_op_.get_file_name(string.gsub(local_db.local_link,"/","\\"))
	local file_op,apply_all = nil,nil
	if  not dlg_warning_status_ then
		local file_exist = file_op_.check_file_exist(path .. name)
		if file_exist then 
			local hash_file = base_op_.get_file_hash(path .. name) .. "1"
			if hash_file == doc_db[local_db.branch].cur_version then 
				check_log(gid)
				base_op_.checkout_local(local_db.gid,path,name)
			else 
				dlg_warning_.set_info(path .. name)
				dlg_warning_.pop()
				file_op,apply_all= dlg_warning_.get_info()
			end
		else 
			base_op_.copy_file(file_op_.get_version_all_path(doc_db[local_db.branch].cur_version),path .. name)
			base_op_.checkout_local(local_db.gid,path,name)
			check_log(gid)
		end
	else 
		return deal_select_result(dlg_warning_status_,local_db,doc_db,path, name)
	end 
	if file_op then 
		if files and apply_all then
		dlg_warning_status_ = file_op
		end
		return deal_select_result(file_op,local_db,doc_db,path, name)
	end 
	return true 
end

function checkout_dir(gid,path,dlg_data,status,content)
	if not gid or not path   then return end 
	local value = ""
	value = value .. "db[\"work_path\"] = \"" .. string.gsub(path,"\\","/") .. "\" "
	file_op_.save_local_path_str(gid,value)
	local doc_db =  file_op_.get_docs_path_tab(gid) 
	if not doc_db then return end 
	local local_db = file_op_.get_local_path_tab(gid) 
	if not local_db then return end 
	local name = local_db.name
	local db = file_op_.get_docs_path_tab(doc_db[local_db.branch].cur_version) 
	if not db then return end 
	local cur_path =  path .. name .. "\\"
	if dlg_data and dlg_data.list_ and not status then 
		cur_path = path
		if dlg_data and dlg_data.list_ == "false" then 
			cur_path =  path .. name .. "\\"
		end 
		
	end
	if not content or not content[gid] then 
	os.execute("if not exist " .. "\"" .. cur_path.. "\"" .. " mkdir " .. "\"" .. cur_path .. "\"");
	end 
	check_log(gid)
	for k,v in ipairs (db) do 
		if tonumber(string.sub(v.gid,-1,-1)) == 1 then
			if not content or not content[v.gid] then 
			if not checkout_file(v.gid,cur_path,true) then return end 
			end 
		else 
			if dlg_data and dlg_data.recursive_ and dlg_data.recursive_ ~= "false" then 
			checkout_dir(v.gid,cur_path,dlg_data,nil,content)
			-- local value = ""
			-- value = value .. "db.work_path = \"" .. cur_path .. "\" "
			-- file_op_.save_path_data_LocalInformation_str(v.gid,value)
			end 
		end 
	end 
	return true 
end

function create_branch(gid,branch)
	if not gid  or not branch then return end 
	return base_op_.create_branch(gid,branch)
end

function del_branch(gid,branch)
	if not gid  or not branch then return end 
	base_op_.del_branch(gid,branch)
end

function change_branch(gid,branch)
	if not gid  or not branch then return end 
	local value = ""
	value = value .. "db.branch = \"" .. branch .. "\" "
	file_op_.save_local_path_str(gid,value)
end

function merge_file(t)
	local filehash = base_op_.get_file_hash(t.filename)
	if not filehash then return end 
	local hid =  filehash .. "1"
	if not base_op_.need_commit_merge_file(hid,t.ver_ids) then return end 
	base_op_.copy_file(string.gsub(t.filename,"/","\\"),file_op_.get_version_all_path(hid))
	t.hid = hid
	local value = base_op_.merge_commit(t)
	return value
end

function merge_dir(t)
	local cur_data = t.data
	if  table_is_empty(cur_data)  then 
		cur_data = {db = {}}
	end 
	local filehash = base_op_.get_temp_hash(cur_data) 
	if not filehash then return end 
	local hid =  filehash .. "0" 
	if not base_op_.need_commit_merge_file(hid,t.ver_ids) then return end 
	t.hid = hid
	file_op_.save_docs_path_tab(t.hid,cur_data)
	local value = base_op_.merge_commit(t)
	return value
	-- local filehash = base_op_.get_temp_hash(dir) 
	-- if not filehash then return end 
	-- local hid =  filehash .. "0" 
	-- if not base_op_.need_commit_merge_file(hid,ver_ids) then return end 
	-- file_op_.save_path_data_docs_db(t.hid,cur_data)
	-- base_op_.merge_commit(gid,hid,name,msg,branch,ver_ids)
	-- return 
end

function get_last_version_file(gid,branch)
	local db = file_op_.get_docs_path_tab(gid)
	local version_data = {}
	for k,v in ipairs(db.branch) do 
		if table_is_empty(v.cids) then 
			table.insert(version_data,v)
		end 
	end
	return version_data
end

local function update_get_path(gid,path)
	local local_db = file_op_.get_local_path_tab(gid) 
	if not local_db then return end 
	local cur_path = path .. local_db.name .. "\\"
	return cur_path
end 

local function update_checkout_file(gid,path)
	local local_db = file_op_.get_local_path_tab(gid)
	if not local_db then  return end 
	local doc_db = file_op_.get_docs_path_tab(gid)
	if not doc_db then   return end 
	local branch  = local_db.branch 
	if not branch then 
		branch = "master"
		local val = "db[\"branch\"] = \"master\" "
		file_op_.save_local_path_str(gid,val)
	end 
	local name = doc_db[branch][doc_db[branch].cur_version].filename
	base_op_.copy_file(file_op_.get_version_all_path(doc_db[branch].cur_version),path .. name )
	tree_op_.travel_bar("run")
	base_op_.checkout_local(gid,path,name)
end 

function update_check_out(gid,path)
	if not gid or not path   then return end 
	local value = ""
	value = value .. "db[\"work_path\"] = \"" .. string.gsub(path,"\\","/") .. "\" "
	tree_op_.travel_bar("run")
	os.execute("if not exist " .. "\"" .. path.. "\"" .. " mkdir " .. "\"" .. path .. "\"");
	file_op_.save_local_path_str(gid,value)
	local local_db = file_op_.get_local_path_tab(gid)
	if local_db.gids then 
		for k,v in ipairs (local_db.gids) do 
			if tonumber(string.sub(v.gid,-1,-1)) == 1 then
				update_checkout_file(v.gid,path)
			else 
				local cur_path = update_get_path(v.gid,path)
				if cur_path then 
					update_check_out(v.gid,cur_path)
				end 
			end 
		end 
	end 
end 

function start_copy_progress()
	tree_op_.travel_bar("start","Copying files ! ")
	tree_op_.set_speed_tips("Files / Sec",1)
end
function end_copy_progress()
	tree_op_.travel_bar("end")
end
--

-----------------------------------------------------------------------------
--check out yuanzi 



function set_cur_path(path)
	if not path then return end 
	cur_path_ = path .. get_folder_name()
end

function check_init(path)
	-- 检查是否 需要归档
	file_op_.set_checkout_pro_path(path)
	local path  = file_op_.get_checkout_apdoc_path()
	if string.sub(path,-1,-1) == "\\" then 
		path = string.sub(path,1,-2)
	end 
	os.execute("if not exist \"" .. path .. "\" mkdir \"" .. path .. "\" ")
	os.execute("attrib  -s +H \"" .. path .. "\" /S /D  ")
	--cur_path_ = file_op_.get_checkout_local_path()
	--os.execute("if not exist \"" .. cur_path_ .. "\" mkdir \"" .. cur_path_  .. "\" ")
end

function get_check_gid_path()
	return cur_path_
end


function check_higher_folder_last(t)
	return base_op_.check_higher_folder_last(t)
end







