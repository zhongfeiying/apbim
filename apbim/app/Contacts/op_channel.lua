_ENV = module(...,ap.adv)

local require_files_ = require "app.Contacts.require_files" 
local file_op_ = require_files_.file_op()
local op_server_ = require_files_.op_server()
local path_ = 'app/Contacts/DB/';
local suffix_ = ".lua"

local function table_is_empty(t)
	return _G.next(t) == nil
end


function save(db,id)
	if not db or not id then return end 
	local allpath = string.gsub(path_,"/","\\") .. id .. suffix_
	file_op_.save_table_to_file(allpath,db)
	--op_server_.send_file(file_name_,path_,f,datas)
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

function create(id)
	save({},id)
end

