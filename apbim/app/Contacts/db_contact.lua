_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files" 
local file_op_ = require_files_.file_op()
local op_server_ = require_files_.op_server()


local suffix_ = ".Cdb"
local file_name_ =  require_files_.get_user()  .. "_contacts_db" .. suffix_
local path_ = 'app/Contacts/DB/';

local db_ = nil 

local table_is_empty =  function (t)
	return _G.next(t) == nil
end



local function init_db()
	local db = {}
	db.Contacts = {}
	db.Groups = {}
	db.Channels = {}
	db_ = db
	save()
end

--arg = {cbf = ,datas =}
function get_server_file(arg)
	return op_server_.get(file_name_,path_,arg.cbf)
end 

function init()
	local allpath = string.gsub(path_,"/","\\") .. file_name_
	if file_op_.is_exist_local(allpath) then
		dofile(allpath)
		db_ = db  or {}
		_G.db = nil
	end
	if not db_ or table_is_empty(db_) then init_db() end 
end

function get()
	if not db_ then init() end 
	return db_
end

local function save_db()
	
	local allpath = string.gsub(path_,"/","\\") .. file_name_
	file_op_.save_table_to_file(allpath, db_ or {})
	--file_op_.save_file(allpath,db_ or {})
	op_server_.putkey_file(file_name_,path_)
end 

function save(db)
	local allpath = string.gsub(path_,"/","\\") .. file_name_
	file_op_.save_str(allpath,'db = nil ')
	op_server_.putkey_file(file_name_,path_,save_db)
	
end

function get_contacts()
	if not db_ then init() end 
	return db_.Contacts 
end

function get_groups()
	if not db_ then init() end 
	return db_.Groups 
end

function get_channels()
	if not db_ then init() end 
	return db_.Channels 
end

function add_contact(data)
	local t = get_contacts()
	t[data.Name] = data
	save()
end

function edit_contact(userdata,old)
	if not old then 
		add_contact(userdata)
	else 
		local t = get_contacts()
		t[old.Name] = nil
		t[userdata.Name] = userdata
		save()
	end 
end 

function delete_contact(data)
	local t = get_contacts()
	t[data.Name] = nil
	save()
end

function change_group(name,group)
	local t = get_contacts()
	t[name].Group = group
	save()
end 

function change_contact_attr(name,k,v)
	local t = get_contacts()
	if t[name] then 
	t[name][k] = v
	save()
	end 
end 

function rename_group(name,group)
	change_contact_attr(name,'Group',group)
end


function dissolve_group(name)
	local t = get_contacts()
	for k,v in pairs (t) do 
		if v.Group == name then 
			v.Group = 'Friends'
		end 
	end 
	save()
end


--group
function create_discuss_group(data)
	local t = get_groups()
	t[data.Gid] = data
	save()
end

function edit_discussion_group(data)
	create_discuss_group(data)
end

function quit_discuss_group(data)
	local t = get_groups()
	t[data.Gid] = nil
	save()
end










function create_channel(data)
	local t = get_channels()
	t[data.Gid] = data
	save()
end

function edit_channel(data)
	create_channel(data)
end

function delete_channel(data)
	local t = get_channels()
	t[data.Gid] = nil
	save()
end




