_ENV = module(...,ap.adv)
local ctr_require_ = require "app.Contacts.require_files"
local file_save_ = ctr_require_.file_save()
local file_save_o_ = ctr_require_.file_save_o()
local crypto = require "crypto"
local lfs = require "lfs"
--[[
--接口函数：
		is_exist_local(AllPath) --判断文件或者文件夹是否存在，函数详情请看第15行
		start_file(AllPath)
		start_explorer(AllPath)
		open(AllPath)     --打开；如果是文件则利用windows系统软件打开相应文件，如果是文件夹则打开相应的资源管理器
		get_file_size(AllPath)	--获取文件内容长度	
		del_file_read_attr(AllPath) 
		copy_file(OldFile,NewFile) 
		save_str_to_file(FileAllPath,str) 
		save_table_to_file(FileAllPath,tab)
		get_content_hash(str) 
		get_file_hash(f) 
--]]

--功能：判断文件或者文件夹是否在本地磁盘上存在
--参数：
--		AllPath，文件或者文件夹全路径(文件夹格式是c:\\a\\b,如果是根目录则文件夹格式为c:\\，文件格式是c:\\a\\b\\c.txt)

function is_exist_local(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	local t = lfs.attributes(AllPath)
	if t then
		return true
	end 
	return false 
end

--功能：打开文件
--参数：
--		AllPath，文件或者文件夹全路径(文件夹格式是c:\\a\\b,如果是根目录则文件夹格式为c:\\，文件格式是c:\\a\\b\\c.txt)

function start_file(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	os.execute("start \"\" " .. AllPath)
end

--功能：打开文件
--参数：
--		AllPath，文件或者文件夹全路径(文件夹格式是c:\\a\\b,如果是根目录则文件夹格式为c:\\，文件格式是c:\\a\\b\\c.txt)

function start_explorer(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	os.execute("explorer  " .. AllPath)
end

--功能：打开文件或者文件夹
--参数：
--		AllPath，文件或者文件夹全路径(文件夹格式是c:\\a\\b,如果是根目录则文件夹格式为c:\\，文件格式是c:\\a\\b\\c.txt)

function open(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	local t = lfs.attributes(AllPath)
	if t then 
		if t.mode == "file" then 
			start_file(AllPath)
		else
			start_explorer(AllPath)
		end
	end 
end



--功能：获取文件长度
--参数：
--		AllPath，文件全路径
--return：文件长度 或者 nil
--[[
function get_file_size(AllPath)
	if type(path) ~= "string" then trace_out("Function (get_file_size) Lost parameter ! \n") return end 
	local str = AllPath
	local f = create_file(str,"r")
	local fs = getfilesize(f)
	close_file(f)
	return fs
end
--]]
function get_file_size(AllPath)
	if type(AllPath) ~= "string" then trace_out("Function (get_file_size) Lost parameter ! \n") return end 
	local t = lfs.attributes(AllPath)
	if t then 
		return t.size
	end
end

--del_file_read_attr(full_path)  去除文件只读属性 参数full_path是文件的全路径或者ap下的相对路径
function del_file_read_attr(AllPath) 
	if type(AllPath) ~= "string" then trace_out("Function (del_file_read_attr) Lost parameter ! \n") return end 
	if is_exist_local(AllPath) then
		os.execute("ATTRIB -R \"" .. AllPath .. "\"")
		return true 
	end
end



function copy_file(OldFile,NewFile) 
	if type(OldFile) ~= "string" or type(NewFile) ~= "string" then trace_out("Function (copy_file) Lost parameter ! \n") return end 
	os.execute("copy /y " .. "\"" .. OldFile .. "\"" .. " " .. "\"" .. NewFile .. "\"")
end 

function get_nil_f()
	return file_save_.get_nil_f()
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

--save_table_to_file(FileAllPath,tab) 将数据保存成文件，数据就是lua中的表结构
function save_table_to_file(FileAllPath,tab)
	if type(FileAllPath) ~= "string" or type(tab)~= "table" then trace_out("Function (save_table_to_file) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	file_save_.save_file_l(FileAllPath,tab)
end 

--save_table_to_file(FileAllPath,tab) 将数据保存成文件，数据就是lua中的表结构
function save_file(FileAllPath,tab)
	if type(FileAllPath) ~= "string" or type(tab)~= "table" then trace_out("Function (save_table_to_file) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	file_save_o_.save_file_l(FileAllPath,tab)
end 

function save_str(FileAllPath,str)
	if type(FileAllPath) ~= "string" or type(str)~= "string" then trace_out("Function (save_table_to_file) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	local file = io.open(FileAllPath,"w+")
	file:write(str);
	file:close()
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



