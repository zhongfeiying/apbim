_ENV = module(...,ap.adv)
local ver_api_ = require "app.Version.version_api"


-------------------------------------------------------------------------------------
local function get_true_gid(gid,type)
	local cur_type = 0
	if type == "file" then 
		gid = gid .. 1
		cur_type = 1
	else 
		gid = gid .. 0
	end
	return gid,cur_type
end


local function  deal_save_commit_data(tab,verbranchdb,verdb,hid,msg)
	local db = nil 
	if hid  ~= verdb.hid then 
		db = ver_api_.get_per_ver_db(tab,hid,msg,verdb)
		table.insert(verbranchdb,db)
		verbranchdb[1].cur_version = hid
		if not tab.hids[hid] then tab.hids[hid] = "" end 
	end
	if tab.hid ~= "-1" then 
		tab.hid = hid
	end
	
end 


local function commit(data,content,cur_type,msg)
	local verdb,verbranchdb = ver_api_.deal_get_gid_file_ver_db(data)
	local hid = ver_api_.get_str_hash_id(content) .. cur_type
	trace_out("hid = " .. hid .. "\n")
	if not hid then return end 
	--DB_Doc_.save_path2_db(hid ,data.gids)
	trace_out("verdb.hid = " .. verdb.hid .. "\n")
	if hid  == verdb.hid then return end 
	deal_save_commit_data(data,verbranchdb,verdb,hid,msg)
	trace_out("here\n")
	ver_api_.save_path3_db(hid,content)
	trace_out("hid = " .. hid .. "\n")
	-- if type == "file" then 
		-- local cur_path = ver_api_.save_path3_db(hid,content)
		-- data.local_link = string.gsub( cur_path , "\\","/")
	-- else 
		
	-- end 
	ver_api_.save_path4_db(data.gid,data)
end

function add(gid,content,type,msg)
	--外部接口
	local cur_gid = gid
	gid,cur_type = get_true_gid(gid,type)
	local t = ver_api_.get_save_file_db(gid)
	if not t then 
		local db = ver_api_.set_t(gid)
		local hid = ver_api_.get_str_hash_id(content) .. cur_type
		if not hid then return end 
		--db.name = hid
		--db.version = true
		if type == "file" then 
			local cur_path = ver_api_.save_path3_db(hid,content)
			db.local_link = string.gsub( cur_path , "\\","/")
			msg = msg or ""
			ver_api_.deal_ver_create(db,msg)
			ver_api_.save_path4_db(gid,db)
		else 
			
		end 
	else 
		commit(t,content,cur_type,msg)
	end 
end

local function deal_push(gid)
	local data = ver_api_.get_save_file_db(gid)
	if not data then return end 
	data.server = true 
	ver_api_.save_path4_db(data.gid,data)
	local t = {}
	table.insert(t,data.gid)
	if type(data.hids) == "table" then 
		for k,v in pairs (data.hids) do 
			table.insert(t,k)
		end
	end
	require"app.Version.server".push(t);
end
local function deal_pull(gid)
	local data = ver_api_.get_save_file_db(gid)
	
	local t = {}
	table.insert(t,gid)
	if data then 
		if type(data.hids) == "table" then 
			for k,v in pairs (data.hids) do 
				table.insert(t,k)
			end
		end
	end
	require"app.Version.server".pull(t);
end 

local function get_cur_version_hid_to_append(gid,ver)
	if ver then return ver end 
	local data = ver_api_.get_save_file_db(gid)
	--require "sys.table".totrace(data)
	if not data then return end 
	local verdb,verbranchdb = ver_api_.deal_get_gid_file_ver_db(data)
	return data,verdb.hid
end 

function putkey(gid,content,type,ver) --外部接口
	local gid,cur_type = get_true_gid(gid,type)
	local data,hid = get_cur_version_hid_to_append(gid,ver)
	if not hid then return end 
	--ver_api_.save_putkey(id,content)
	content =  ver_api_.get_save_file_str(hid) .. content
	commit(data,content,type)
end

function set_status(t)
	ver_api_.set_status()
end

function get(gid,ver,type) --外部接口
	local gid = get_true_gid(gid,type)
	return ver_api_.deal_get(gid,ver)
	
end

function  push(gid,type)
	local gid = get_true_gid(gid,type)
	deal_push(gid)
end 

function  pull(gid,type)
	local gid = get_true_gid(gid,type)
	deal_pull(gid)
end 













