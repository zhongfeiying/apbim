_ENV = module(...,ap.adv)
local file_op_ =require "app.workspace.ctr_require".file_op()
local file = "cfg\\uploaded_file.lua"
local zip_op_ = require "app.workspace.ctr_require".zip_op()
local rmenu_op_ =require "app.workspace.ctr_require".rmenu_op()
local tree_op_ =require "app.workspace.ctr_require".tree_op()
local db_ ={}
local user_path_ = "cfg/msg/"
local user_file_ =  "uploaded_file.lua"


local function get()
	local file = string.gsub(user_path_,"/","\\") .. user_file_
	if file_op_.check_file_exist(file) then 
		dofile(file)
		db_ = db or {}
		_G.db = nil
	end 
	return db_
end

local function save()
	local file = string.gsub(user_path_,"/","\\") .. user_file_
	file_op_.save_table_to_file(file,db_)
end


local count_ = nil
local path_ = nil
local function count_num(t)
	count_ = count_ - 1
	db_ = db_ or {}
	db_[t.name] = true
	save()
	if count_ == 0 then 
		if path_ then 
			--os.execute("rd /s /q " .. path_)
			os.execute("if  exist " .. "\"" ..  path_  .. "\"" .. " rd /s /q " .. "\"" ..  path_  .. "\"");
			path_ = nil
		end 
	end 
end

local function open_zip_file(data,FileAllPath)
	local dirpath = string.match(FileAllPath,"(.+\\).+")
	path_ = dirpath .. "Temp"
	--os.execute("mkdir " .. dirpath .. "Temp ")
	os.execute("if not exist " .. "\"" ..  dirpath .. "Temp" .. "\"" .. " mkdir " .. "\"" ..  dirpath .. "Temp" .. "\"");
	local newdirpath = dirpath .. "Temp\\"
	local ar = zip_op_.zip_create(FileAllPath)
	if not ar then return end 
	local t = zip_op_.zip_get_filesname_in(ar)
	for k,v in pairs (t) do 
		if data[k] then 
			rmenu_op_.zip_to_local(ar,v,newdirpath .. data[k])
		end 
	end
	zip_op_.zip_close(ar)
	count_ = count_  or 0
	for k,v in pairs (data) do 
		if file_op_.check_file_exist(newdirpath .. v) then 
			count_ = count_ + 1
			local t = {}
			t.name = v
			t.path = newdirpath
			t.cbf = count_num
			require "sys.net.file".send(t)
			-- if k == "Projects\\__Projects.lua" then 
				-- require "sys.net.file".putkey(t)
			-- else
				-- require "sys.net.file".send(t)
			-- end
		end
	end
end

function upload_all_files(tree,file)
	local db = get()
	local tab,rest = tree_op_.get_tree_data(tree,0)
	if not tab then iup.Message("Notice","Please save firstly !") return end 
	local proid = tab.attributes.gid
	local data = {}
	for k,v in ipairs (rest) do 
		if v.hid and not db[v.hid] then
			data["Projects\\res\\" .. v.hid] =  v.hid
		end	
	end 
	data["Projects\\__Projects.lua"] = proid
	open_zip_file(data,file)
end


local download_count_ = nil
local download_file_ = nil
local download_files_ = nil

function tar_file(t)
	if not download_file_ then return end 
	local ar = zip_op_.zip_create(download_file_)
	if not ar then return end 	
	zip_op_.zip_add_file(ar,"Projects\\res\\" .. t.name,"file",t.path .. t.name)
	zip_op_.zip_close(ar)
	
end 

local function download_ok(t)
	download_count_ = download_count_ - 1
	tar_file(t)
	if download_count_ == 0 then 
		if path_ then 
			os.execute("if exist " .. path_ .. " rd /s /q " .. path_)
			path_ = nil
			download_count_ = nil
			download_files_ = nil
			download_file_ = nil
		end 
	end 
end

local function deal_download(data,FileAllPath)
	download_count_ = download_count_ or 0
	local dirpath = string.match(FileAllPath,"(.+\\).+")
	path_ = dirpath .. "Temp"
	--os.execute("mkdir " .. dirpath .. "Temp ")
	os.execute("if not exist " .. "\"" ..  dirpath .. "Temp" .. "\"" .. " mkdir " .. "\"" ..  dirpath .. "Temp" .. "\"");
	local newdirpath = dirpath .. "Temp\\"
	
	for k,v in pairs (data) do 
		
		download_count_ = download_count_ + 1
		local t = {}
		t.name = v
		t.path = newdirpath
		t.cbf = download_ok
		require "sys.net.file".get(t)
	end 
end

function download_all_files(tree,file)
	local tab,rest = tree_op_.get_tree_data(tree,0)
	if not tab then return end 
	local ar = zip_op_.zip_create(file)
	if not ar then return end 
	local t = zip_op_.zip_get_filesname_in(ar)
	local update = false
	download_files_ = download_files_ or {}
	download_file_ = file
	for k,v in ipairs (rest) do 
		--if not t["Projects\\res\\" .. v.hid] then 
		if v.hid and not  t["Projects\\res\\" .. v.hid] then
			update = true 
			download_files_["Projects\\res\\" .. v.hid] = v.hid
		end 
	end
	zip_op_.zip_close(ar)
	--require "sys.table".totrace(download_files_)
	if update then 
		deal_download(download_files_,file)
	end 
	--open_zip_file(data,file)
	
end


