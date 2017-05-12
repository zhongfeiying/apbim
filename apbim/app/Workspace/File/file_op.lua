
_ENV = module(...,ap.adv)
--module(...,package.seeall)
local lfs = require "lfs"
local file_save_ = require "app.workspace.ctr_require".file_save()

------------------------------------------------------------------------------------------------------
local cur_user_ = nil;
local sava_path_ = "data\\" 
local base_path_ = "data\\" 

local save_log_ = "log.lua"
local save_admin_ = "admin.lua"
local save_server_ = "server.lua"
local upload_file_ = "Upload_file.lua"
local download_file_ = "Download_file.lua"
local sava_path2_ = nil
local sava_path3_ = nil
local check_list_ = "Checklist.lua"
local dir_checkout_apdoc_ = ".ApDoc\\"
local dir_checkout_apdoc_db_file_ = "__apdoc.db"
--local dir_local_ = "Local\\"
local cur_project_path_ = nil

--local save_bim_pro_ = "Sample\\BCA\\"
local save_bim_pro_ = require"app.Project.dlg".get_path() or "Projects\\" 

local version_path_ = "version_path.lua"
local file = io.open(version_path_,"r")
if file then 
	file:close()
	dofile(version_path_)
	if path_ then 
		os.execute("if not exist " .. "\"" .. string.gsub(path_,"/","\\") .. "data\\" .. "\"" .. " del /q /f  version_path.lua ")
		file = io.open(version_path_,"r")
		if file then 
			file:close()
			sava_path_ = string.gsub(path_,"/","\\") .. "data\\"
			base_path_ = string.gsub(path_,"/","\\") .. "data\\"
		end 
		_G.path_ = nil
	end
end 



function set_cur_user(gid,name)
	
	cur_user_ = {}
	cur_user_.gid = gid
	cur_user_.name = name
	sava_path2_ = "data\\" .. gid .. "\\Docs\\" 
	sava_path3_ = "data\\" .. gid .. "\\Local\\" 
	sava_path_ = "data\\" .. gid .. "\\" 
	base_path_ = "data\\"
	local file = io.open(version_path_,"r")
	if file then 
		file:close()
		
		dofile(version_path_)
		
		if path_ then 
		
			sava_path2_ = string.gsub(path_,"/","\\") .. "data\\" .. gid .. "\\Docs\\" 
			sava_path3_ = string.gsub(path_,"/","\\") .. "data\\" .. gid .. "\\Local\\" 
			sava_path_ = string.gsub(path_,"/","\\") .. "data\\" .. gid .. "\\" 
			base_path_ = string.gsub(path_,"/","\\") .. "data\\"
		end
	end 
	os.execute("if not exist " .. "\"" .. base_path_ .. "BCA.Res\\Res\\" .. "\"" .. " mkdir " .. "\"" .. base_path_ .. "BCA.Res\\Res\\" ..  "\"");
end

function get_cur_user()
	return cur_user_
end 

function get_bca_save_path()
	local file = io.open("ProjectsPath.lua","r")
	if file then
		file:close()
		dofile("ProjectsPath.lua")
		if path_ then 
			local t = lfs.attributes(string.sub(string.gsub(path_,"/","\\"),1,-2))
			if not t then 
				os.execute("if not exist " .. "\"" ..  save_bim_pro_ .. "\"" .. " mkdir " .. "\"" ..  save_bim_pro_ .. "\"");
				return lfs.currentdir() .. "\\" .. save_bim_pro_
			else 
				return string.gsub(path_,"/","\\")
			end
		end
	end  
	os.execute("if not exist " .. "\"" ..  save_bim_pro_ .. "\"" .. " mkdir " .. "\"" ..  save_bim_pro_ .. "\"");
	return  lfs.currentdir() .. "\\" .. save_bim_pro_
end



-- local function cfg_path(path)
	-- local cfg_file_ = "cfg\\project.lua";
	-- local f = loadfile(cfg_file_);
	-- local t = nil;
	-- if type(f)=="function" then t = f() end
	-- if type(t)~="table" then t={} end
	-- return t.projects_pos or "Projects\\"
-- end

-- function get_bca_save_path()
	-- return cfg_path(path)
-- end
--------------------------------------------------------------------------------------------------------------
--create dir
-- os.execute("if not exist " .. "\"" .. sava_path_ .. "\"" .. " mkdir " .. "\"" .. sava_path_ .. "\"");
-- os.execute("if not exist " .. "\"" .. sava_path2_ .. "\"" .. " mkdir " .. "\"" .. sava_path2_ .. "\"");
-- os.execute("if not exist " .. "\"" .. sava_path3_ .. "\"" .. " mkdir " .. "\"" .. sava_path3_ .. "\"");

local function create_folder()
	os.execute("if not exist " .. "\"" .. sava_path_ .. "\"" .. " mkdir " .. "\"" .. sava_path_ .. "\"");
	if not cur_user_ then return end 
	os.execute("if not exist " .. "\"" .. sava_path2_ .. "\"" .. " mkdir " .. "\"" .. sava_path2_ .. "\"");
	os.execute("if not exist " .. "\"" .. sava_path3_ .. "\"" .. " mkdir " .. "\"" .. sava_path3_ .. "\"");

	os.execute("if not exist " .. "\"" ..  save_bim_pro_ .. "\"" .. " mkdir " .. "\"" ..  save_bim_pro_ .. "\"");
end 


function create_dir(path)
	os.execute("if not exist " .. "\"" .. path .. "\"" .. " mkdir " .. "\"" .. path .. "\"");
end 
-------------------------------------------------------------------------------------------------------------
function makedir(dir)
	if not dir then return end 
	os.execute("if not exist " .. "\"" .. dir .. "\"" .. " mkdir " .. "\"" .. dir .. "\"");
end 

--离散文件取id文件前两位建立文件夹存储并且返回文件相对存储路径
function get_dir(file,path)
	local dir = string.sub(file,1,2)
	if path then 
		makedir(path .. dir .. "\\")
	end 
	return dir .. "\\"
end
----------------------------------------------------------------------
-- 获取常用文件路径
function get_root_path() 
	return base_path_
end 
--get_data_path()  获取当前目录（ap）下的data文件夹路径
function get_data_path() 
	return sava_path_;
end 

--get_docs_path() 获取当前目录（ap）下的data文件夹下docs文件夹路径
function get_docs_path()
	return sava_path2_
end 

function set_checkout_pro_path(path)
	cur_project_path_ = path
	if string.sub(cur_project_path_,-1,-1) ~= "\\" then 
		cur_project_path_ = cur_project_path_ .. "\\"
	end 
end 

function get_dir_checkout_apdoc()
	return ".ApDoc"
end

function get_apdoc_db_file()
	return dir_checkout_apdoc_db_file_
end

function get_checkout_apdoc_path()
	if cur_project_path_ then  return cur_project_path_ .. dir_checkout_apdoc_ end 
	return dir_checkout_apdoc_
end 

-- function get_checkout_local_path()
	-- if cur_project_path_ then return cur_project_path_ .. dir_checkout_apdoc_ .. dir_local_ end 
	-- return dir_checkout_apdoc_ .. dir_local_ 
-- end 

--get_local_path()  获取当前目录（ap）下的data文件夹下local文件夹路径
function get_local_path() 
	return sava_path3_
end 

--get_version_all_path(name)  获取当前目录（ap）下的data文件夹下doc下gid或者hid文件全路径
function get_version_all_path(name) 
	if type(name) ~= "string"  then trace_out("Function (get_version_all_path) Lost parameter ! \n") return end 
	return sava_path2_ ..  get_dir(name,sava_path2_) .. name
end 
--get_local_all_path(name)  获取当前目录（ap）下的data文件夹下local下gid文件全路径
function get_local_all_path(name) 
	if type(name) ~= "string" then trace_out("Function (get_local_all_path) Lost parameter ! \n") return end 
	return sava_path3_ ..  get_dir(name,sava_path3_) .. name
end 
----------------------------------------------------------------------

--get_file_size(name) 获取文件大小 参数是全路径（或者ap下的相对路径）
function get_file_size(path)
	if type(path) ~= "string" then trace_out("Function (get_file_size) Lost parameter ! \n") return end 
	local str = path
	local f = create_file(str,"r")
	local fs = getfilesize(f)
	close_file(f)
	return fs
end

--check_file_exist(full_path) 判断文件是否存在磁盘上 参数full_path是文件的全路径或者ap下的相对路径
function check_file_exist(full_path)
	if type(full_path) ~= "string" then trace_out("Function (check_file_exist) Lost parameter ! \n") return end 
	local file = io.open(full_path,"r")
	local status = false
	if file then 
		file:close()
		status = true 
	end
	return status
end 

--del_file_read_attr(full_path)  去除文件只读属性 参数full_path是文件的全路径或者ap下的相对路径
function del_file_read_attr(full_path) 
	if type(full_path) ~= "string" then trace_out("Function (del_file_read_attr) Lost parameter ! \n") return end 
	if check_file_exist(full_path) then
		os.execute("ATTRIB -R \"" .. full_path .. "\"")
		return true 
	end
end

--copy_file(OldFile,NewFile)  拷贝文件,两个参数分别是元文件全路径，目标文件全路径
function copy_file(OldFile,NewFile) 
	if type(OldFile) ~= "string" or type(NewFile) ~= "string" then trace_out("Function (copy_file) Lost parameter ! \n") return end 
	os.execute("copy /y " .. "\"" .. OldFile .. "\"" .. " " .. "\"" .. NewFile .. "\"")
end 
------------------------------------------------------------------------------------------------------------------------------
--存成磁盘文件
--save_table_to_file(FileAllPath,tab) 将数据保存成文件，数据就是lua中的表结构
function save_table_to_file(FileAllPath,tab)
	if type(FileAllPath) ~= "string" or type(tab)~= "table" then trace_out("Function (save_table_to_file) Lost parameter ! \n") return end 
	--trace_out("FileAllPath = " .. FileAllPath .. "\n")
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	file_save_.save_file_l(FileAllPath,tab)
end 

--save_root_path_tab(name,tab) 将数据tab存入data\\（name）所代表的文件中
function save_root_path_tab(name,tab)
	if type(name) ~= "string" or type(tab)~= "table" then trace_out("Function (save_root_path_tab) Lost parameter ! \n") return end 
	create_folder()
	local file_name = base_path_ .. name
	save_table_to_file(file_name,tab)
end 

--save_data_path_tab(name,tab) 将数据tab存入data\\（name）所代表的文件中
function save_data_path_tab(name,tab,path)
	if type(name) ~= "string" or type(tab)~= "table" then trace_out("Function (save_data_path_tab) Lost parameter ! \n") return end 
	create_folder()
	local file_name = sava_path_ .. name
	if path then 
		file_name = path .. name
	end
	save_table_to_file(file_name,tab)
end 
--save_log_tab(tab) --保存log日志文件数据表
function save_log_tab(tab) 
	save_data_path_tab(save_log_,tab)
end 

--save_admin_tab(tab) 保存data\\admin.lua文件
function save_admin_tab(tab,path)
	
	save_data_path_tab(save_admin_,tab,path)
end 
--save_server_tab(tab) 保存data\\server.lua文件
function save_server_tab(tab)
	save_data_path_tab(save_server_,tab)
end 
--save_upload_tab(tab) 保存data\\upload_file.lua文件
function save_upload_tab(tab)
	save_data_path_tab(upload_file_,tab)
end 
--save_download_tab(tab) 保存data\\download_file.lua文件
function save_download_tab(tab)
	save_data_path_tab(download_file_,tab)
end 

function save_checklist_tab(tab)
	save_data_path_tab(check_list_,tab)
end

--save_docs_path_tab(name,tab) 将数据tab存入data\\docs\\？\\（name）所代表的文件中
function save_docs_path_tab(name,tab)
	if type(name) ~= "string" or type(tab)~= "table" then trace_out("Function (save_docs_path_tab) Lost parameter ! \n") return end 
	local file_name = sava_path2_ ..  get_dir(name,sava_path2_) .. name
	save_table_to_file(file_name,tab)
end

--save_local_path_tab(name,tab) 将数据tab存入data\\local\\？\\（name）所代表的文件中
function save_local_path_tab(name,tab)
	if type(name) ~= "string" or type(tab)~= "table" then trace_out("Function (save_local_path_tab) Lost parameter ! \n") return end 
	local file_name = sava_path3_ ..  get_dir(name,sava_path3_) .. name
	save_table_to_file(file_name,tab)
end

function save_checkout_path_tab(path,name,tab)
	if type(name) ~= "string" or type(tab)~= "table" then trace_out("Function (save_local_path_tab) Lost parameter ! \n") return end 
	local file_name = path ..  get_dir(name,path) .. name
	save_table_to_file(file_name,tab)
end




--save_str_to_file(FileAllPath,str)  向已经存在的文件中追加数据内容，数据是符合规范的字符串
function save_str_to_file(FileAllPath,str) 
	if type(FileAllPath) ~= "string" or type(str) ~= "string" then trace_out("Function (save_str_to_file) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	local db = file_save_.append_contact(FileAllPath,str)
	file_save_.save_file_l(FileAllPath,db)
end 

--save_data_path_str(name,str) 将数据str追加存入data\\（name）所代表的文件中
function save_data_path_str(name,str,path)
	if type(name) ~= "string" or type(str)~= "string" then trace_out("Function (save_data_path_str) Lost parameter ! \n") return end 
	create_folder()
	local file_name = sava_path_ .. name

	if path then 
		file_name = path .. name
	end 
	save_str_to_file(file_name,str) 
end 

--save_docs_path_file(name,tab) 将数据tab存入data\\docs\\？\\（name）所代表的文件中
function save_docs_path_str(name,str)
	if type(name) ~= "string" or type(str)~= "string" then trace_out("Function (save_docs_path_str) Lost parameter ! \n") return end 
	local file_name = sava_path2_ ..  get_dir(name,sava_path2_) .. name
	save_str_to_file(file_name,str)
end

--save_local_path_file(name,tab) 将数据tab存入data\\local\\？\\（name）所代表的文件中
function save_local_path_str(name,str)
	if type(name) ~= "string" or type(str)~= "string" then trace_out("Function (save_local_path_str) Lost parameter ! \n") return end 
	local file_name = sava_path3_ ..  get_dir(name,sava_path3_) .. name
	save_str_to_file(file_name,str)
end

function save_checkout_path_str(path,name,str)
	if type(name) ~= "string" or type(str)~= "string" then trace_out("Function (save_local_path_str) Lost parameter ! \n") return end 
	local file_name = path ..  get_dir(name,path) .. name
	save_str_to_file(file_name,str)
end

--save_log_str(str) 向log.lua文件中追加内容
function save_log_str(str)
	save_data_path_str(save_log_,str)
end 

--save_admin_str(str) 向 admin.lua文件中追加内容
function save_admin_str(str)
	save_data_path_str(save_admin_,str)
end 

--save_server_str(str) 向 server.lua文件中追加内容
function save_server_str(str)
	save_data_path_str(save_server_,str)
end

--save_upload_str(tab) 向 upload_file.lua文件中追加内容
function save_upload_str(str)
	save_data_path_str(upload_file_,str)
end 
--save_download_str(tab) 向 download_file.lua文件中追加内容
function save_download_str(str)
	save_data_path_str(download_file_,str)
end 

function save_checklist_str(str)
	save_data_path_str(check_list_,str)
end

------------------------------------------------------------------------------------------------------------------------------
--取出磁盘文件存放的数据
--get_file_data(FileAllPath) 获取文件中（gid 或者是文件夹的hid文件）的数据
function get_file_data(FileAllPath)
	if not FileAllPath then trace_out("Function (get_file_data) Lost parameter ! \n") return end 
	if check_file_exist(FileAllPath) then 
		dofile(FileAllPath)
		local newdb = db
		_G.db = nil
		return newdb
	else 
		return nil
	end 
end 

--get_data_path_tab(name) 获取data\\下参数name代表文件中存放的数据
function get_data_path_tab(name,path)
	if type(name) ~= "string" then trace_out("Function (get_data_path_tab) Lost parameter ! \n") return end 
	local FileAllPath = sava_path_ .. name
	
	if path then 
		FileAllPath = path .. name
	end 
	return get_file_data(FileAllPath)
end

--get_docs_path_tab(name) 获取data\\docs\\?\\下参数name代表文件中存放的数据
function get_docs_path_tab(name)
	if type(name) ~= "string" then trace_out("Function (get_docs_path_tab) Lost parameter ! \n") return end 
	local FileAllPath = sava_path2_ ..  get_dir(name,sava_path2_) .. name
	return get_file_data(FileAllPath)
end

--get_local_path_tab(name) 获取data\\local\\?\\下参数name代表文件中存放的数据
function get_local_path_tab(name)
	if type(name) ~= "string" then trace_out("Function (get_local_path_tab) Lost parameter ! \n") return end 
	local FileAllPath = sava_path3_ ..  get_dir(name,sava_path3_) .. name
	return get_file_data(FileAllPath)
end

-- function get_checkout_path_tab(name,path)
	-- if type(name) ~= "string" then trace_out("Function (get_local_path_tab) Lost parameter ! \n") return end 
	-- local path = path
	-- if not path then 
		-- path = get_checkout_local_path()
	-- end 
	-- local FileAllPath = path ..  get_dir(name,path) .. name
	-- return get_file_data(FileAllPath)
-- end



--get_log_tab() 获取data\\下log.lua文件中存放的数据
function get_log_tab()
	return get_data_path_tab(save_log_)
end 

--get_admin_tab() 获取data\\下admin.lua文件中存放的数据
function get_admin_tab(path)
	return get_data_path_tab(save_admin_,path)
end 

--get_server_tab() 获取data\\下server.lua文件中存放的数据
function get_server_tab()
	return get_data_path_tab(save_server_)
end 

--get_upload_tab() 获取data\\下upload_file.lua文件中存放的数据
function get_upload_tab()
	return get_data_path_tab(upload_file_)
end 
--get_download_tab() 获取data\\download_file.lua文件中存放的数据
function get_download_tab()
	return get_data_path_tab(download_file_)
end 

function get_checklist_tab()
	return get_data_path_tab(check_list_)
end


--get_file_content(FileAllPath) 获取文件的内容
function get_file_content(FileAllPath)
	if not FileAllPath then trace_out("Function (get_file_content) Lost parameter ! \n") return end 
	local file = io.open(FileAllPath,"rb")
	local content = nil;
	if file then 
		content = file:read("*all")
		file:close()
	end
	return content
end

--get_data_path_str(name) 获取data\\下参数name代表文件中存放的内容
function get_data_path_str(name)
	if type(name) ~= "string" then trace_out("Function (get_data_path_str) Lost parameter ! \n") return end 
	local FileAllPath = sava_path_ .. name
	return get_file_content(FileAllPath)
end

--get_docs_path_str(name) 获取data\\docs\\?\\下参数name代表文件中存放的内容
function get_docs_path_str(name)
	if type(name) ~= "string" then trace_out("Function (get_docs_path_str) Lost parameter ! \n") return end 
	local FileAllPath = sava_path2_ ..  get_dir(name,sava_path2_) .. name
	return get_file_content(FileAllPath)
end

--get_local_path_str(name) 获取data\\local\\?\\下参数name代表文件中存放的内容
function get_local_path_str(name)
	if type(name) ~= "string" then trace_out("Function (get_local_path_str) Lost parameter ! \n") return end 
	local FileAllPath = sava_path3_ ..  get_dir(name,sava_path3_) .. name
	return get_file_content(FileAllPath)
end


--get_log_str() 获取data\\下log.lua文件中存放的内容
function get_log_str()
	return get_data_path_str(save_log_)
end 

--get_admin_str() 获取data\\下admin.lua文件中存放的内容
function get_admin_str()
	return get_data_path_str(save_admin_)
end 

--get_server_str() 获取data\\下server.lua文件中存放的内容
function get_server_str()
	return get_data_path_str(save_server_)
end 

--get_upload_str() 获取data\\下upload_file.lua文件中存放的内容
function get_upload_str()
	return get_data_path_tab(upload_file_)
end 
--get_download_str() 获取data\\download_file.lua文件中存放的内容
function get_download_str()
	return get_data_path_tab(download_file_)
end 
------------------------------------------------------------------------------------------------------------------------------
--delete_file(FileAllPath) 删除磁盘文件
function delete_file(FileAllPath)
	if not FileAllPath then trace_out("Function (delete_file) Lost parameter ! \n") return end 
	os.execute("if exist " .. "\"" .. FileAllPath .. "\" " .. "del /q /f " .. "\"" .. FileAllPath .. "\"")
end

--del_empty_floder(AllPath) 删除空的文件夹
function delete_empty_floder(AllPath)
	if not AllPath then trace_out("Function (delete_empty_floder) Lost parameter ! \n") return end 
	local empty = true 
	os.execute("if not exist " .. "\"" .. AllPath .. "\"" .. " mkdir " .. "\"" .. AllPath .. "\"")
	for line in io.popen("dir /a /b \"" .. AllPath .. "\""):lines() do 
		empty = false
	end 
	if empty then 
		os.execute("rd /q /s " .. "\"" .. AllPath .. "\"")
	end 
end

--delete_floder_all(AllPath) 删除文件夹以及其下所有内容
function delete_floder_all(AllPath)
	if not AllPath then trace_out("Function (delete_floder_all) Lost parameter ! \n") return end 
	os.execute("rd /q /s " .. "\"" .. AllPath .. "\"")
end

function delete_data_all_file()
	os.execute("rd /q /s " .. "\"" .. AllPath .. "\"")
	os.execute("rd /q /s " .. "\"" .. AllPath .. "\"")
end 







