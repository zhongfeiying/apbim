module(...,package.seeall)


function deal_only_read_file_attr(name)
	local file = io.open(name,"r")
	local status = false
	if file then 
		file:close()
		os.execute("ATTRIB -R " .. name)
		status = true 
	end
	return status
end


--�ж��ļ��Ƿ����
function deal_check_file_exist(name)
	local file = io.open(name,"r")
	local status = false
	if file then 
		file:close()
		status = true 
	end
	return status
end

--copy_file(OldFile,NewFile)  �����ļ�
function copy_file(OldFile,NewFile) 
	if not OldFile or not NewFile then return end 
	os.execute("copy /y " .. "\"" .. OldFile .. "\"" .. " " .. "\"" .. NewFile .. "\"")
end 