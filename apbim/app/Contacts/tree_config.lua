_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files" 
local file_op_ = require_files_.file_op()
local op_server_ = require_files_.op_server()

local suffix_ = ".Tdb"
local file_name_ = require_files_.get_user() .. "_tree_config" .. suffix_
local path_ = 'app/Contacts/DB/';

local db_ = nil 

local image_path_ = 'app/Contacts/Image/'
local image_contact_ = "contact"
local image_groups_ = "group"
local image_subscribe_ ="subscribe"
local image_unsubscribe_ ="unsubscribe"
local image_scribe_ ="scribe"



get_local_bmp = function (name)
	local path  = image_path_
	if name and name == "scribe" then 
		return path .. "scribe.bmp"
	elseif name and name == "subscribe" then 
		return path .. "subscribe.bmp"
	elseif name and name == "unsubscribe" then 
		return path .. "unsubscribe.bmp"
	elseif name and name == "contact" then 
		return path .. "contact.bmp"
	elseif name and name == "group" then 
		return path .. "group.bmp"
	end 
	return path .. "contact.bmp"
end

function get_image_subscribe()
	return image_subscribe_
end

function get_image_unsubscribe()
	return image_unsubscribe_
end

local table_is_empty =  function (t)
	return _G.next(t) == nil
end

function get_server_file(arg)
	return op_server_.get(file_name_,path_,arg.cbf)
end 



local function get_branch_data(arg)
	return {Title = arg.Name,Kind = 'BRANCH',Color = arg.Color,Image = arg.Image,Attr = {AttrIndex = arg.AttrIndex,RmenuIndex = arg.RmenuIndex}}
end

local function get_leaf_data(arg)
	return {Title = arg.Name,Kind = 'LEAF',Color = arg.Color,Image = arg.Image,Attr ={AttrIndex = arg.AttrIndex,RmenuIndex = arg.RmenuIndex}}
end

local function get_contact_file(arg)
	local t = get_leaf_data(arg)
	t.Image = image_contact_
	--t.Attr.DLbtn = 'contacts_file'
	return t
end

local function get_group_file(arg)
	local t = get_leaf_data(arg)
	t.Image = image_groups_
	--t.Attr.DLbtn = 'groups_file'
	return t
end

local function get_channel_file(arg)
	local t = get_leaf_data(arg)
	t.Image = t.Image or image_scribe_
	return t
end

local function insert_data(db,arg,i)
	if type(i) =='number' then 
		table.insert(db,i,arg)
	else 
		table.insert(db,arg)
	end 
	
	db[arg.Title] = {}
	return db[arg.Title]
end


local function init_db()
	local db = {}
	local t = db
	t = insert_data(t,get_branch_data{Name = 'User'})
	insert_data(t,get_branch_data{Name = 'Contacts',RmenuIndex = 'contacts_rmenu'})
	insert_data(t,get_branch_data{Name = 'Groups',RmenuIndex = 'groups_rmenu'})
	insert_data(t,get_branch_data{Name = 'Channels',RmenuIndex = 'channels_rmenu'})
	t = t.Contacts
	insert_data(t,get_branch_data{Name = 'Friends',RmenuIndex = 'contacts_friends_rmenu'})
	insert_data(t,get_branch_data{Name = 'Strangers',RmenuIndex = 'contacts_strangers_rmenu'})
	db_ = db
	save()
end

--arg = {cbf = ,datas =}


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

function get_pos(t,title)
	for k,v in ipairs (t) do 
		if v.Title == title then 
			return k
		end 
	end
end

function get_contacts(groupname)
	if groupname then 
		return db_.User.Contacts[groupname]
	else 
		return db_.User.Contacts
	end 
	
end

function get_groups()
	return db_.User.Groups
end

function get_channels()
	return db_.User.Channels
end

function add_group(name)
	local t = get_contacts()
	insert_data(t,get_branch_data{Name = name,RmenuIndex = 'contacts_folder_rmenu'},#t)
	save()
end

function dissolve_group(name)
	local t = get_contacts(name)
	local newt = get_contacts('Friends')
	for k,v in ipairs (t) do 
		table.insert(newt,v)
	end 
	local db = get_contacts()
	local pos = get_pos(db,name)
	table.remove(db,pos)
	db[name] = nil
	save()
end

function change_group(name,oldGroup,newGroup)
	local old = get_contacts(oldGroup)
	local new = get_contacts(newGroup)
	local pos = get_pos(old,name)
	table.insert(new,table.remove(old,pos))
	save()
end

function add_contact(userdata)
--	trace_out('groupname = ' .. userdata.Group .. '\n')
	local t = get_contacts(userdata.Group)
	
	table.insert(t,get_contact_file{Name = userdata.Name,RmenuIndex = 'contacts_file_rmenu',AttrIndex = 'Contacts/' .. userdata.Name})
	save()
end

function edit_contact(userdata,old)
	local t = get_contacts(userdata.Group)
	local pos = get_pos(t,old.Name)
	t[pos] = get_contact_file{Name = userdata.Name,RmenuIndex = 'contacts_file_rmenu',AttrIndex = 'Contacts/' .. userdata.Name}
	save()
end

function delete_contact(data)
	local t = get_contacts(data.Group)
	local pos = get_pos(t,data.Name)
	table.remove(t,pos)
	save()
end

function rename_group(oldGroup,newGroup)
	local t = get_contacts()
	local pos =  get_pos(t,oldGroup)
	local oldGroupData = t[oldGroup] or {}
	t[pos] = get_branch_data{Name = newGroup,RmenuIndex = 'contacts_folder_rmenu'}
	t[newGroup] = {}
	for k,v in ipairs (oldGroupData) do 
		table.insert(t[newGroup],v)
	end 
	t[oldGroup] = nil
	save()
end


--discuss group
--arg = {GroupName,Note,Time,Gid}
function create_discuss_group(arg)
	local t = get_groups()
	table.insert(t,get_group_file{Name = arg.GroupName,RmenuIndex = 'groups_members_menu',AttrIndex = 'Groups/' .. arg.Gid})
	save()
end

function edit_discussion_group(userdata,old)
	local t = get_groups()
	local pos =  get_pos(t,old.GroupName)
	t[pos].Title = userdata.GroupName
	save()
end

function quit_discuss_group(arg)
	local t = get_groups()
	local pos =  get_pos(t,arg.GroupName)
	table.remove(t,pos)
	save()
end
--
--arg = {ChannelName,Note,Time,Gid,Subscribe}
function create_channel(arg)
	local t = get_channels()
	local image = arg and arg.Subscribe and image_subscribe_ or image_scribe_
	table.insert(t,get_channel_file{Name = arg.ChannelName,RmenuIndex = 'channels_members_rmenu',AttrIndex = 'Channels/' .. arg.Gid,Image = image})
	save()
end

function edit_channel(userdata,old)
	local t = get_channels()
	local pos =  get_pos(t,old.ChannelName)
	t[pos].Title = userdata.ChannelName
	save()
end

function subscribe_channel(userdata)
	local t = get_channels()
	local pos =  get_pos(t,userdata.ChannelName)
	t[pos].Image = image_subscribe_
	save()
end 

function unsubscribe_channel(userdata)
	local t = get_channels()
	local pos =  get_pos(t,userdata.ChannelName)
	t[pos].Image = image_unsubscribe_
	save()
end

--arg = {ChannelName,Note,Time,Gid}
function delete_channel(arg)
	local t = get_channels()
	local pos =  get_pos(t,arg.ChannelName)
	table.remove(t,pos)
	save()
end

