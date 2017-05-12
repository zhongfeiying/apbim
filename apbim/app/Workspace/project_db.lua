
_ENV = module(...,ap.adv)
local ctr_require_ = require "app.workspace.ctr_require"

local file_op_ = require "app.workspace.ctr_require".file_op()

local suffix_ = ".data2"
local temp_ = ".tmp"

local file_ = require "sys.mgr".get_user() .. "_project_list" .. suffix_
local path_ = "cfg/msg/"
local db_ = {}

function get_file_ifo(name)
	if not name then return end 
	return name  .. "_project_list" .. suffix_,path_
end

--[[
db_ = {
	[gid] = {
		Name = ;
		PGid = gid; --gongcheng gid
		MGid = gid --moxing gid
	};
}

	
--]]

function save_net_file(name,path,f,data)
	require"sys.net.file".putkey{name=name;path=path,
		cbf = function(t)
			if type(f)=='function' then f(t) end
		end
	}
end

function save_send_file(name,path,f,data)
	require"sys.net.file".send{
		name=name;
		path=path,
		cbf = function(t)
			if type(f)=='function' then f(t) end
		end
	}
end

function save(db,allpath)
	local allpath = allpath or string.gsub(path_,"/","\\") .. file_
	file_op_.save_table_to_file(allpath,db or db_ or {})
	save_net_file(file_,path_)
end

local function tempf(t)
	local name = t and t.name or file_
	local path = t and t.path or path_
	if type(path) ~= "string" then return end 
	local allpath = string.gsub(path,"/","\\") .. name
	if not file_op_.check_file_exist(allpath) then
		if file_op_.check_file_exist(allpath .. temp_) then 
			os.rename(allpath .. temp_,allpath)
		end 
		return
	end 
	local file = loadfile (allpath)
	if  file then 
		os.remove(allpath .. temp_)
	else 
		os.remove(allpath)
		os.rename(allpath .. temp_,allpath)
	end 
end

function get_net_file(name,path,f,newdb)
	local name = name or file_
	local path = path or path_
	local allpath = string.gsub(path,"/","\\") .. name
	if file_op_.check_file_exist(allpath) then 
		os.rename(allpath,allpath .. temp_)
	end
	require"sys.net.file".get{
		name = name;
		path = path;
		cbf = function(t)
			if type(f)=='function' then 
				tempf(t) 
				f(t) 
			end
		end
	}
	
end


function get_hid_net_file(name,path,f,newdb)
	local name = name or file_
	local path = path or path_
	local allpath = string.gsub(path,"/","\\") .. name
	require"sys.net.file".get{
		name = name;
		path = path;
		cbf = function(t)
			if type(f)=='function' then 
				f(t) 
			end
		end
	}
	
end

function init()
	local allpath = string.gsub(path_,"/","\\") .. file_
	if file_op_.check_file_exist(allpath) then
		dofile(allpath)
		db_ = db 
		_G.db = nil
	end
	db_ = db_ or {}
	return db_
end

function get()
	return db_ or init() or {}
end

function add(t)
	db_ = db_ or {}
	if not t.Gid then return end 
	if db_[t.Gid] then return end 
	db_[t.Gid] = t

	save()
end




