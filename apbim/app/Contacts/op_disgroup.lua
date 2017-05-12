_ENV = module(...,ap.adv)

local require_files_ = require "app.Contacts.require_files" 
local file_op_ = require_files_.file_op()
local op_server_ = require_files_.op_server()

local path_ = 'app/Contacts/DB/';
local suffix_ = ".lua"

local function table_is_empty(t)
	return _G.next(t) == nil
end


function download(id,cbf)
	if not id then return end 
	local file_name = id .. suffix_
	op_server_.get(file_name,path_,cbf)
end

function save(db,id,cbf)
	if not db or not id then return end 
	local allpath = string.gsub(path_,"/","\\") .. id .. suffix_
	file_op_.save_table_to_file(allpath,db)
	local file_name = id .. suffix_
	op_server_.putkey_file(file_name,path_,cbf)
end

function open(id)
	local allpath = string.gsub(path_,"/","\\") .. id .. suffix_
	local db_;
	if file_op_.is_exist_local(allpath) then
		dofile(allpath)
		db_ = db  or {}
		_G.db = nil
	end
	return db_
end

function create(id,cbf)
	local db = {}
	local user = require_files_.get_user() 
	db[user] = true 
	save(db,id,cbf)
end

function quit(id,cbf)
	local db = open(id)
	local user = require_files_.get_user() 
	db[user] = function () end 
	save(db,id,cbf)
end



