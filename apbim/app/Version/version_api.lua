_ENV = module(...,ap.adv)

local com_save_ = require "app.Version.comma_save"
local sava_path3_ = "data\\projects\\" 
local sava_path2_ = "data\\docs\\" 
local save_path_ = "data\\"

local download_files_ = nil
local save_file_content_ = nil
os.execute("if not exist " .. "\"" .. sava_path3_ .. "\"" .. " mkdir " .. "\"" .. sava_path3_ .. "\"");

function get_hash_id(f)
	local file = io.open(f,"rb");
	if not file then return end 
	local s = file:read("*all");
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(s);
	--trace_out(s1);
	d:reset();
	file:close();
	return s1
end


function  get_data_db(name)
	local file_all_path = save_path_ .. name
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
function get_save_file_str(hid)
	local file_name = sava_path3_ .. hid
	local file = io.open(file_name,"r")
	local content = nil;
	if file then 
		content = file:read("*all")
		file:close()
	end
	return content
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

function del_only_read_file_attr(name)
	local file = io.open(name,"r")
	if file then 
		file:close()
		os.execute("ATTRIB -R " .. name)
	end
end

function save_path2_db(name,db)
	local file_name = sava_path2_ .. name
	del_only_read_file_attr(file_name)
	com_save_.save_file(file_name,db)
end 

function save_path3_db(name,str)
	local file_name = sava_path3_ .. name
	del_only_read_file_attr(file_name)
	local file = io.open(file_name, "w+")
	file:write(str); 
	file:close()--]]
	return file_name
end  

function save_path4_db(name,db)
	local file_name = sava_path3_ .. name
	del_only_read_file_attr(file_name)
	com_save_.save_file(file_name,db)
end 



function get_save_file_db(gid)
	local file_name = sava_path3_ .. gid
	--trace_out("file_name = " .. file_name .. "\n")
	local file = io.open(file_name,"r")
	local content = nil;
	if file then 
		file:close()
		dofile (file_name)
		return db
	end
	return nil
end

function deal_get_gid_file_ver_db(t)
	if t.hid == "-1" then 
		for k,v in ipairs(t) do 
			if v.branch == t.branch then 
				for m,n in ipairs(v) do 
					if n.hid == v[1].cur_version then 
						return n,v
					end
				end
			end
		end	
	else 
		for k,v in ipairs(t) do 
			if v.branch == t.branch then 
				for m,n in ipairs(v) do 
					if n.hid == t.hid then 
						return n,v
					end
				end
			end
		end	
	end 
end

function delete_temp(name)
	local str = sava_path2_ ..name
	os.execute("del /q /f " .. "\"" .. str .. "\"")
end

function delete_temp3(all_apth)
	os.execute("del /q /f " .. "\"" .. string.gsub(all_apth,"/","\\") .. "\"")
end

function set_t(gid)
	local db = {}
	if tonumber(string.sub(gid,-1,-1)) == 0 then 
		db["gids"] = {}
	else 
		
	end 
	db["gid"] = gid
	db[1] = {}
	db[1][1] = {}
	db[1][1]["cur_version"] = "-1"
	db[1]["branch"] = "master"
	db["hid"] = "-1"
	db["hids"] = {}
	db["branch"] = "master"
	return db
end

function get_str_hash_id(str)
	if not str or #str == 0 then return end 
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(str);
	--trace_out(s1);
	d:reset();
	return s1
end

function time_pause(state)
	while state do 
		if save_file_content_ then 
			break 
		end
	end
end

function import_ids(tab)
	download_files_ = tab
	require "app.Version.file_download".set_cur_info("get_files")
	require "app.Version.file_download".init_downloading(tab)
end
function move_projects_files(name)
	os.execute("copy /y " .. "\"" .. sava_path2_ .. name .. "\"" .. " " .. "\"" .. sava_path3_ .. name .. "\"")
end

function set_status(gid,ver)
	if gid then 
		local data = get_save_file_db(gid)
		
		if data then 
			if ver and data.hids[ver] then 
				save_file_content_ = get_save_file_str(ver)
				return 
			end 
			local verdb,verbranchdb = deal_get_gid_file_ver_db(data)
			if verdb then 
				save_file_content_ =  get_save_file_str(verdb.hid)
				--trace_out("save_file_content_ = " .. save_file_content_ .. "\n")
			end
		else 
			local t = {}
			table.insert(t,{id = gid})
			import_ids(t)
		end 
	else 
		if #download_files_[1].id < 25 then 
			local data = get_sava_path2_file(download_files_[1].id)
			delete_temp(download_files_[1].id)
			download_files_ = nil
			if data then 
				local verdb,verbranchdb = deal_get_gid_file_ver_db(data)
				if verdb then 
					local t = {}
					table.insert(t,{id = verdb.hid})
					import_ids(t)
				end
			end 
		else 
			move_projects_files(download_files_[1].id)
			save_file_content_ = get_save_file_str(download_files_[1].id)
		end 
	end
	
end


function deal_get(gid,ver)
	download_files_ = nil
	save_file_content_ = nil
	set_status(gid,ver)
	
	return save_file_content_
	
end

function copy_comit_file(ver)
	local source_path = ver.source_file
	local hid = ver.hid
	local gid = ver.gid
	local new_Str = string.reverse(source_path)
	new_Str = string.reverse(string.sub(new_Str,1,string.find(new_Str,"%.")))
	local file_all_path = sava_path3_ .. hid
	source_path = string.gsub(source_path,"/","\\")
	os.execute("copy /y " .. "\"" .. source_path .. "\"" .. " " .. "\"" .. file_all_path .. "\"")
	return file_all_path,new_Str
end

function get_per_ver_db(tab,hid,val,verdb) --tab[1],tab[1][2],hid
	local db = {}
	db.gid = tab.gid
	db.hid = hid
	db.name = tab.name
	db.pid = {}
	db.msg = val
	db.date = require "sys.dt".date_str()
	if tonumber(string.sub(tab.gid,-1,-1)) == 1 then
		--db.source_file = tab.local_link 
		--db.file_all_path, db.file_type= copy_comit_file(db)
		--db.file_all_path =  string.gsub(db.file_all_path ,"\\","/")
		local file_all_path = sava_path3_ .. hid
		db.file_all_path =  string.gsub(file_all_path ,"\\","/")
	end 
	if verdb  then 
		table.insert(db.pid,verdb.hid)
	end 
	return db
end

function deal_ver_create(t,val)
	local hid = nil
	if not t.version then 
		t.version = true
		if tonumber(string.sub(t.gid,-1,-1)) == 1  then 
			hid =  get_hash_id(string.gsub(t.local_link,"/","\\")) .. 1
			if not t.hids[hid] then
				t.hids[hid] = ""
			end  
			t[1][1].cur_version = hid
			t[1][2] = get_per_ver_db(t,hid,val)
			os.execute("copy /y " .. "\"" ..string.gsub(t.local_link,"/","\\") .. "\"" .. " " .. "\"" .. sava_path3_ .. hid .. "\"")
			delete_temp3(t.local_link)
		elseif tonumber(string.sub(t.gid,-1,-1)) == 0 then 
			local hid = get_hash_id(t.gids)
			if not t.hids[hid] then t.hids[hid] = ""   end 
			save_path2_db(hid,t.gids)
			t[1][1].cur_version = hid

			table.insert(t[1],get_per_ver_db(t,hid,val))
		end
	end 
end

function get_file_per_line_tab(name) --将文件中的数据按行存入表中
	local db = {}
	local file = io.open(sava_path3_ .. name,"r")
	local str = ""
	if file then 
		for line in file:lines() do 
			table.insert(db,line)
		end
		file:close()
	end 
	return db
end

local function save_file_append(id,content)
	content = get_save_file_str(id) .. content
	local file_all_path = sava_path3_ .. id
	local file = io.open(file_all_path,"w")
	if not file then return end 
	file:write(content)
	file:close();
end 

function save_putkey(gid,content)
	save_file_append(gid,content)
end
