_ENV = module(...,ap.adv)
local ctr_require_ = require "app.Contacts.require_files"
local file_save_ = ctr_require_.file_save()
local file_save_o_ = ctr_require_.file_save_o()
local crypto = require "crypto"
local lfs = require "lfs"
--[[
--�ӿں�����
		is_exist_local(AllPath) --�ж��ļ������ļ����Ƿ���ڣ����������뿴��15��
		start_file(AllPath)
		start_explorer(AllPath)
		open(AllPath)     --�򿪣�������ļ�������windowsϵͳ�������Ӧ�ļ���������ļ��������Ӧ����Դ������
		get_file_size(AllPath)	--��ȡ�ļ����ݳ���	
		del_file_read_attr(AllPath) 
		copy_file(OldFile,NewFile) 
		save_str_to_file(FileAllPath,str) 
		save_table_to_file(FileAllPath,tab)
		get_content_hash(str) 
		get_file_hash(f) 
--]]

--���ܣ��ж��ļ������ļ����Ƿ��ڱ��ش����ϴ���
--������
--		AllPath���ļ������ļ���ȫ·��(�ļ��и�ʽ��c:\\a\\b,����Ǹ�Ŀ¼���ļ��и�ʽΪc:\\���ļ���ʽ��c:\\a\\b\\c.txt)

function is_exist_local(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	local t = lfs.attributes(AllPath)
	if t then
		return true
	end 
	return false 
end

--���ܣ����ļ�
--������
--		AllPath���ļ������ļ���ȫ·��(�ļ��и�ʽ��c:\\a\\b,����Ǹ�Ŀ¼���ļ��и�ʽΪc:\\���ļ���ʽ��c:\\a\\b\\c.txt)

function start_file(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	os.execute("start \"\" " .. AllPath)
end

--���ܣ����ļ�
--������
--		AllPath���ļ������ļ���ȫ·��(�ļ��и�ʽ��c:\\a\\b,����Ǹ�Ŀ¼���ļ��и�ʽΪc:\\���ļ���ʽ��c:\\a\\b\\c.txt)

function start_explorer(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	os.execute("explorer  " .. AllPath)
end

--���ܣ����ļ������ļ���
--������
--		AllPath���ļ������ļ���ȫ·��(�ļ��и�ʽ��c:\\a\\b,����Ǹ�Ŀ¼���ļ��и�ʽΪc:\\���ļ���ʽ��c:\\a\\b\\c.txt)

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



--���ܣ���ȡ�ļ�����
--������
--		AllPath���ļ�ȫ·��
--return���ļ����� ���� nil
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

--del_file_read_attr(full_path)  ȥ���ļ�ֻ������ ����full_path���ļ���ȫ·������ap�µ����·��
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

--save_str_to_file(FileAllPath,str)  ���Ѿ����ڵ��ļ���׷���������ݣ������Ƿ��Ϲ淶���ַ���
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

--save_table_to_file(FileAllPath,tab) �����ݱ�����ļ������ݾ���lua�еı�ṹ
function save_table_to_file(FileAllPath,tab)
	if type(FileAllPath) ~= "string" or type(tab)~= "table" then trace_out("Function (save_table_to_file) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	file_save_.save_file_l(FileAllPath,tab)
end 

--save_table_to_file(FileAllPath,tab) �����ݱ�����ļ������ݾ���lua�еı�ṹ
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

-- get_content_hash(str) �õ��ַ�����ϣֵ
function get_content_hash(str) --��������ַ���
	if not str or #str == 0 then return end 
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(str);
	d:reset();
	return s1
end

--get_file_hash(f)�õ��ļ���ϣֵ
function get_file_hash(f) --��������ļ�·��
	f = string.gsub(f,"/","\\")
	local file = io.open(f,"rb");
	if not file then return end 
	local s = file:read("*all");
	local s1 = get_content_hash(s)
	file:close();
	return s1
end



