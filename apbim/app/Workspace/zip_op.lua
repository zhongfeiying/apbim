_ENV = module(...,ap.adv)

local zip = require "luazip"


function zip_create(FileAllPath)
	local ar = assert(zip.open(FileAllPath,zip.CREATE))
	return ar
end

function zip_close(ar)
	ar:close()
end


function zip_add_dir(ar,dir) 
	--参数dir是要添加zip文件的目录,其形式可能是a 或者 a\\b\\c
	--创建出来的结果就是在压缩文件中创建一个a 文件夹，或递归创建文件夹
	local f = ar:open(dir,zip.OR(zip.FL_NOCASE, zip.FL_NODIR));
	if f then ar:delete(dir) end
	ar:add_dir(dir)
end

function zip_add_file(ar,FileAllPathInZip,ZipType,ZipFileAllPath,replace)
	local index = ar:name_locate(FileAllPathInZip,zip.OR(zip.FL_NOCASE,zip.FL_NODIR))
	if not index then	
		ar:add(FileAllPathInZip,ZipType,ZipFileAllPath)
	else 
		if replace then 
			ar:replace(index,ZipType,ZipFileAllPath)
		end
	end
end

function zip_open(FileAllPath)
	trace_out("FileAllPath = " .. FileAllPath .. "\n")
	local ar = assert(zip.open(FileAllPath,zip.CHECKCONS))
	return ar
end

function zip_read_file_in(ar,FileAllPathInZip)
	local zip_file = ar:open(FileAllPathInZip,zip.OR(zip.FL_NOCASE,zip.FL_NODIR))
	return zip_file
end


function zip_get_file_stat_in(read_zip,FileAllPathInZip)
	local stat = read_zip:stat(FileAllPathInZip,zip.OR(zip.FL_NOCASE , zip.FL_NODIR) )
	return stat
end

function zip_get_filename_by_index(ar,index)
	return ar:get_name(index,zip.FL_UNCHANGED)
end

function zip_get_filesname_in(ar)
	local t = {}
	for i=1,#ar do 
		local filename = zip_get_filename_by_index(ar,i)
		t[filename] = i
	end
	return t
end

function zip_delete_file(ar,FileAllPathInZip)
	local index = ar:name_locate(FileAllPathInZip,zip.OR(zip.FL_NOCASE,zip.FL_NODIR))
	if index then 
		ar:delete(index)
	end
end
