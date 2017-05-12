_ENV = module(...,ap.adv)

require "lfs"
local file_op_ = require "app.workspace.ctr_require".file_op()
--local dir_tools_ = require "app.workspace.ctr_require".dir_tools()
local luaext_ = require "app.workspace.ctr_require".luaext()
local crypto = require "crypto"
local function table_is_empty(t)
	return _G.next(t) == nil
end 

------------------------------------------------------------------------------------------------------
--get_file_time(file) 根据文件全路径（相对ap路径）获取文件名 ， 得到文件修改的时间
--lfs 外部手动添加的动态库
function get_file_time(file)
	local attr =  lfs.attributes(file)
	local str = attr.modification
	--return os.date("%x",str)  .. " ".. os.date("%X",str)
	return os.date("%Y",str) .. "_" .. os.date("%m",str) .. "_" .. os.date("%d",str) .. "__" .. os.date("%H",str) .. "_" .. os.date("%M",str) .. "_" .. os.date("%S",str)
end 

--get_hid_file_time(hid) 获得 hid 的修改时间
function get_hid_file_time(hid)
	if not hid then return end
	local file_name =  file_op_.get_version_all_path(hid) 
	return get_file_time(file_name)
end  


-- get_content_hash(str) 得到字符串哈希值
function get_content_hash(str) --传入的是字符串
	if not str or #str == 0 then return end 
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(str);
	d:reset();
	return s1
end

--get_file_hash(f)得到文件哈希值
function get_file_hash(f) --传入的是文件路径
	f = string.gsub(f,"/","\\")
	local file = io.open(f,"rb");
	if not file then return end 
	local s = file:read("*all");
	local s1 = get_content_hash(s)
	file:close();
	return s1
end

-- get_file_name(filename) 根据文件全路径（相对路径）获取文件名
function get_file_name(filename)
	if not filename then return end 
	local new_Str = string.reverse(filename )
	new_Str = string.reverse(string.sub(new_Str,1,string.find(new_Str,"\\") -1))
	return new_Str
end 

--copy_file(OldFile,NewFile)  拷贝文件
function copy_file(OldFile,NewFile) 
	return file_op_.copy_file(OldFile,NewFile) 
end 


----------------------------------------------------------------------------------------------------------------
--local function create_version(gid,hid,name,msg,title,path)
--create_version(t) 版本库中生成版本数据表 t传入的参数表，表中必须有的key值为gid,hid,name,msg,title,path（其中path为可选）
local function create_version(t)
	local version_data_tab = {}
	version_data_tab.hid = t.hid
	version_data_tab.user = t.user or file_op_.get_cur_user().name
	if t.name then 
		version_data_tab.name = t.name
	else 
		version_data_tab.name = t.hid
	end 
	--version_data_tab.pids = {}
	version_data_tab.msg = t.msg 
	version_data_tab.title = t.title 
	--version_data_tab.cids = {}
	if tonumber(string.sub(t.gid,-1,-1)) == 1 then
		if t.path then 
			--version_data_tab.filename = get_file_name(t.path)
			version_data_tab.time = get_file_time(t.path) 
		end 
	else 
		version_data_tab.time = get_hid_file_time(t.hid)
	end 
	return version_data_tab
end 


--get_temp_hash(t)将数据表存入临时文件中，运算并返回其hash值 t是一个表
function get_temp_hash(t)
	if not t then return end
	local temp_id = luaext_.guid();
	file_op_.save_data_path_tab(temp_id,t) 
	local file_hash = get_file_hash(file_op_.get_data_path() .. temp_id)
	if file_hash then 
		file_op_.delete_file(file_op_.get_data_path() .. temp_id)
		return file_hash
	end
end
-- add_version(gid,hid,name,msg,title,path) 添加文件或者文件夹的版本
function add_version(t)
	local tab = {}
	tab["master"] = {}
	tab["master"]["" .. t.hid] = create_version(t)
	tab["master"][1] = t.hid
	file_op_.save_docs_path_tab(t.gid,tab)
end


function need_commit_file(hid,old_hid)
	--local tim = get_file_time(path)
	--if tim == cur_ver.time then return  end 
	if hid == old_hid then return  end  
	return true 
end 
function need_commit_dir(hid,old_hid)
	--if db.hid ~= "-1" and hid ==  db.hid then return  true end  
	if hid == old_hid then return  end 
	return true 
end 


function get_cur_ver_hid(gid,branch)
	local db = file_op_.get_docs_path_tab(gid)
	if not db then return end 
	if not db[branch] then return end 
	if #db[branch] == 0 then return "empty" end 
	--local cur_ver_hid = db[branch].cur_version
	--if not string.find (cur_ver_hid,"%S+") then  return cur_ver_hid end 
	--if db[branch][cur_ver_hid] then return  db[branch][cur_ver_hid] end 
	return db[branch][#db[branch]]
end 


--local function get_append_content(gid,hid,name,msg,branch,title,cur_ver,path)
local function get_append_content(t)
	local value = ""
	if t.old_hid then 
		value = value ..  "if db[\"" .. t.branch .. "\"][#db[\"" .. t.branch .. "\"]] ~= \"" .. t.old_hid .. "\" then return false end "
	end 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"] = {} "
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"hid\"] = \"" .. t.hid .. "\" "
	if t.name then 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"name\"] = \"" .. t.name .. "\" "
	end 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"msg\"] = \"" .. t.msg .. "\" "
	if t.title then 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"title\"] = \"" .. t.title .. "\" "
	end 
	local user = t.user or file_op_.get_cur_user().name
	if user then
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"user\"] = \"" .. user .. "\" "
	end 
	if tonumber(string.sub(t.gid,-1,-1)) == 1 then
		if t.path then 
	--		value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"filename\"] = \"" .. get_file_name(t.path) .. "\" "
			value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"time\"] = \"" ..  get_file_time(t.path)  .. "\" "
		end 
	else 
		value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"time\"] = \"" ..  get_hid_file_time(t.hid) .. "\" "
	end 
	value = value .. "db[\"" .. t.branch .. "\"][#db[\"" .. t.branch .. "\"] + 1] =  \"" .. t.hid .. "\" "
	value = value .. " return true "
	return value
end 

function com_version(t)
	if not t.gid then return end 
	local value = get_append_content(t)
	file_op_.save_docs_path_str(t.gid,value)
	return value
end


local function get_check_higher_folder_last_content(t)
	local value = ""
	value = value ..  "if not db[\"" .. t.branch .. "\"] then db[\"" .. t.branch .. "\"] = {}  return true end  "
	if t.old_hid then 
		value = value ..  "if  #db[\"" .. t.branch .. "\"] == 0 then  return true end  "
		value = value ..  "if db[\"" .. t.branch .. "\"][#db[\"" .. t.branch .. "\"]] ~= \"" .. t.old_hid .. "\" then return false  else return true end  "
	end 
	return value
end

function check_higher_folder_last(t)
	if not t.gid then return end 
	local value = get_check_higher_folder_last_content(t)
	return value
end

function need_commit_merge_file(hid,ids)
	for k,v in ipairs (ids) do 
		if v == hid then return end 
	end 
	return true 
end 

function create_branch(gid,branch)
	local value = ""
	value = value .. "if not db[\"" .. branch .. "\"] then "
	value = value .. "db[\"" .. branch .. "\"] = {} "
	--value = value .. "db[\"" .. branch .. "\"][\"cur_version\"] = \"\" "
	value = value .. "return true  "
	value = value .. "else return false "
	value = value .. "end  "
	file_op_.save_docs_path_str(gid,value)
	return value
end 

-- stop
--------------------------------------------------------------------------------------------
--
function checkout_local(gid,path,name)
	local value = ""
	value = value .. "db[\"local_link\"] = \"" .. string.gsub(path .. name,"\\","/") .. "\" "
--	value = value .. "db[\"work_path\"] = \"" .. string.gsub(path,"\\","/") .. "\" "
	file_op_.save_local_path_str(gid,value)
end  



-- function checkout(gid,hid,branch)
	-- local value = ""
	-- value = value .. "db[\"" .. branch .. "\"][1][\"cur_version\"] = \"" .. hid .. "\" "
	-- file_op_.save_path_data_docs_str(gid,value)
-- end 




function del_branch(gid,branch)
	local value = ""
	value = valie .. "db[\"" .. branch .. "\"] = nil "
	file_op_.save_docs_path_str(gid,value)
end 

local function get_append_marge_content(t)
	if type(t) ~= "table" then return end 
	local value = ""
	value = value .. "if db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"] then db[\"" .. t.branch .. "\"][\"cur_version\"] =  \"" .. t.hid .. "\"  return end  "
	--value = value .. "db[\"" .. branch .. "\"][#db[\"" .. branch .. "\"]+ 1] = {} "
	for k,v in ipairs (t.ver_ids) do 
		value = value .. "if db[\"" .. t.branch .. "\"][\"".. v .. "\"] then db[\"" .. t.branch .. "\"][\"".. v .. "\"].cids[#db[\"" .. t.branch .. "\"][\"".. v .. "\"].cids + 1] = \"" .. t.hid .. "\"  end "
		--value = value .. "for i = 1,#db[\"" .. branch .. "\"] do if db[\"" .. branch .. "\"][i].hid ==  \"" .. v .. "\" then 	db[\"" .. branch .. "\"][i].cids[#db[\"" .. branch .. "\"][i].cids + 1] = \"" .. hid .. "\" break end	end "
	end 
	
	value = value .. "db[\"" .. t.branch .. "\"][\"cur_version\"] = \"" .. t.hid .. "\" "
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"] = {} "
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"hid\"] = \"" .. t.hid .. "\" "
	-- local user_t = file_op_.get_sava_path_data_db("admin.lua")
	-- if user_t then
	-- value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"user\"] = \"" .. user_t.user  .. "\" "
	-- end 
	if t.name then 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"name\"] = \"" .. t.name .. "\" "
	end 
	
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"pids\"] = {} "
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"cids\"] = {} "
	for k,v in ipairs (t.ver_ids) do 
		value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"pids\"][#db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"pids\"] + 1]  = \"" .. v .. "\" "
	end 
	
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"msg\"] = \"" .. t.msg .. "\" "
	if t.title then 
	value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"title\"] = \"" .. t.title .. "\" "
	end 
	if tonumber(string.sub(t.gid,-1,-1)) == 1 then
		if t.path then 
			value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"filename\"] = \"" .. get_file_name(t.path) .. "\" "
			value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"time\"] = \"" ..  get_file_time(t.path)  .. "\" "
		end 
	else 
		value = value .. "db[\"" .. t.branch .. "\"][\"" .. t.hid .. "\"][\"time\"] = \"" ..  get_hid_file_time(t.hid) .. "\" "
	end 

	return value
end 

function merge_commit(t)
	local value =  get_append_marge_content(t)
	file_op_.save_docs_path_str(t.gid,value)
	return value
end


function check_file_change(file,hid)
	--trace_out("file = ".. file .. "\n")
	local filehash = get_file_hash(file)
	if not filehash then return end 
	local newhid =  filehash .. "1"
	if newhid == hid then return end 
	return true 
end 


function check_dir_files_change(gid,tree_id,change_t)
	local status = false 
	if not change_t then 
		status = true 
	end 	
	local change_t = change_t or {}
	local local_db = file_op_.get_local_path_tab(gid)
	if not local_db or not local_db.gids or not local_db.version  then return end 
	for i = #local_db.gids ,1,-1 do 
		tree_id = tree_id + 1
		local cur_gid = local_db.gids[i].gid
		local local_db = file_op_.get_local_path_tab(cur_gid)
		if local_db.version then
			local doc_db = file_op_.get_docs_path_tab(cur_gid)
			if tonumber(string.sub(cur_gid,-1,-1)) == 1 then
			if check_file_change(string.gsub(local_db.local_link,"/","\\"),doc_db[local_db.branch].cur_version) then table.insert(change_t,tree_id) end 
			else 
				tree_id = check_dir_files_change(cur_gid,tree_id,change_t)
			end 
		end 
	end 
	if status then 
	 return change_t
	else 
	 return tree_id
	end
	--return change_t
end 

local function get_del_finish_data(cur_db,t)
	local data = t or  {}
	for k,v in ipairs (cur_db) do 
		if  not v.datas then 
			if  not  v.del then  table.insert(data,v)  end 
		else 
			local t = {} 
			t.name = v.name
			t.datas = {}
			get_del_finish_data(v.datas,t.datas)
			if not table_is_empty(t.datas)  then table.insert(data,t) end 
		end
	end 
	
	if not t then 
		return data
	end 
end 
--[[
function flush_dir(gid,t)
	local status = false
	local db = file_op_.get_local_path_tab(gid)
	if not db then return end 
	if not db.work_path then return end 
	local str = string.sub(string.gsub(db.work_path,"/","\\"),1,-2)
	local tab = t or dir_tools_.get_folder_content(str)
	local cur_db = nil
	if not t then 
		status = true 
		cur_db = tab[1].datas
		
	else 
		cur_db =  tab.datas
	end 
	
	for k,v in ipairs(db.gids) do 
		local newdb = file_op_.get_local_path_tab(v.gid)
		if tonumber(string.sub(v.gid,-1,-1)) == 1 then 
			if newdb.local_link then 
				for m,n in ipairs (cur_db) do 
					if get_file_name(string.gsub(newdb.local_link,"/","\\"))  == n.name then cur_db[m].del = true break end 
				end 
			end 
		else 
			for m,n in ipairs (cur_db) do 
				if n.name == newdb.name then 
					flush_dir(v.gid,n)
				end 
			end 
		end 
	end 
	if status then 
		local data = get_del_finish_data(tab)
		if  table_is_empty(data) then return  end 
		return data
	end 
end 
--]]
local file_name1_ = "__DirChangeindex.wlua"
local file_name2_ = "__DirChangeData.lua"

local function check_new_change(gid)
	local local_db = file_op_.get_local_path_tab(gid)
	if not local_db then return end 
	if not local_db.work_path then return end 
	--copy_file(file_op_.get_save_path() .. file_name1_,string.gsub(local_db.work_path,"/","\\") .. file_name1_) 
	local file = io.open( file_name2_,"r")
	if not file then 
		file = io.open( file_name2_,"w+")
	end 
	--file:write("cur_path_ = \"" .. local_db.work_path ..file_name2_ .. "\"\n")
	--local work_path = lfs.currentdir()
	--if not work_path then error("Work path is error !") file:close() end 
--	file:write("require_path_ = \"" .. string.gsub(work_path,"\\","/") ..  "\"\n")
	file:write("process_end = false\n")
	file:close()
	os.execute("\"" .. string.gsub(local_db.work_path,"/","\\") .. file_name1_ .. "\"")
	require "app.Version.coroutine".create_ct(local_db.work_path .. file_name1_)
	--trace_out("di path = " .. string.gsub(local_db.work_path,"/","\\") .. file_name1_  .. "\n")
	--os.execute("\"" .. string.gsub(local_db.work_path,"/","\\") .. file_name1_ .. "\"")
	--trace_out("hereer======================================end\n")
end 

function check_new(gid,status)
	if status then 
		return check_new(gid,status)
	else 
		return check_new_change(gid)
	end 
end 

function check_server_version(gid,hid)

end 

