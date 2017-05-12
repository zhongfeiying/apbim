_ENV = module(...,ap.adv)

require "iuplua"
local sava_path_ = "data\\" 
local sava_path2_ = "data\\docs\\" 
local sys_tab_ = require "sys.table"

os.execute("if not exist " .. "\"" .. sava_path_ .. "\"" .. " mkdir " .. "\"" .. sava_path_ .. "\"");
os.execute("if not exist " .. "\"" .. sava_path2_ .. "\"" .. " mkdir " .. "\"" .. sava_path2_ .. "\"");
local function table_is_empty(t)
	return _G.next(t) == nil
end 
local function del_only_read_file_attr(name)
	local file = io.open(name,"r")
	if file then 
		file:close()
		os.execute("ATTRIB -R " .. name)
	end
end

function save_path_db(name,db)
	local file_name = sava_path_ .. name
	del_only_read_file_attr(file_name)
	local file = io.open( file_name, "w+")
	if not file then 
		trace_out("file is not exist!\n")
		return 
	end
	local str = sys_tab_.tostr(db)
	file:write("db = ".. str); 
	file:close()
end 

function save_path2_db(name,db)
	local file_name = sava_path2_ .. name
	del_only_read_file_attr(file_name)
	local file = io.open(file_name, "w+")
	local str = sys_tab_.tostr(db)
	file:write("db = ".. str); 
	file:close()
end 

function get_sava_path_file(name)
	local file_all_path = sava_path_ .. name
	del_only_read_file_attr(file_all_path)
	local file = io.open(file_all_path,"r")
	if file then
		file:close() 
		dofile(file_all_path)
		return db;
	else 
		return nil
	end
end

function get_sava_path2_file(name)
	local file_all_path = sava_path2_ .. name
	del_only_read_file_attr(file_all_path)
	local file = io.open(file_all_path,"r")
	if file then 
		file:close() 
		dofile(file_all_path)
		return db;
	else 
		return nil
	end
end

