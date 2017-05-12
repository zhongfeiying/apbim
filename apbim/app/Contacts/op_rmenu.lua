_ENV = module(...,ap.adv)

local require_files_ = require "app.Contacts.require_files"
--------------------------------------------------------------------------------------
local tree_config_ = require_files_.tree_config()
local db_contact_ = require_files_.db_contact()
local op_tree_ = require_files_.op_tree()
local op_server_ = require_files_.op_server()
local tree_ = require_files_.tree()
local luaext_ = require_files_.luaext()
local op_disgroup_ = require_files_.op_disgroup()
local op_channel_ = require_files_.op_channel()
local op_msg_ = require_files_.op_msg()

--------------------------------------------------------------------------------------
--action
local function get_index_data(index)
	if not index then return end 
	local db = db_contact_.get()
	local num = 0
	for k,v in string.gmatch(index,'[^/+]+') do
		db = db[k]
	end 
	if not db then return {} end 
	return op_tree_.deep_copy(db)
end 

function get_node_index_data()
	local tree = tree_.get_class()
	local attr = tree:get_attr()
	local AttrIndex = type(attr) == 'table' and attr.AttrIndex 
	return get_index_data(AttrIndex)
end

function locate_contact()
	local dlg_add,groupname = require_files_.dlg_add()
	local arg = {Name = 'Locate Contact : ';set_data = function(str) groupname = str end,Warning = function (str) if  groups[str] then iup.Message('Notice','The group has been existed ! Please re-enter the group name !') return true end end }
	dlg_add.pop(arg)
	if not groupname then return end 
end




function add_group()
	local groups = tree_config_.get_contacts()
	local dlg_add,groupname = require_files_.dlg_add()
	local arg = {Name = 'Group Name : ';DlgName = 'Add Group';set_data = function(str) groupname = str end,Warning = function (str) if groups[str] then iup.Message('Notice','The group has been existed ! Please re-enter the group name !') return true end end }
	dlg_add.pop(arg)
	if not groupname then return end 
	tree_config_.add_group(groupname)
	op_tree_.add_group(groupname)
end 

function manage_contacts()
	--trace_out('manage_contacts \n')
end

function dissolve_group()
	local tree = tree_.get_class()
	local count = tree:get_child_numbers()
	local groupname = tree:get_title()
	tree_config_.dissolve_group(groupname)
	if count ~= 0 then
	db_contact_.dissolve_group(groupname)
	end 
	op_tree_.dissolve_group(groupname)
end



function add_contact()
	local contacts = db_contact_.get_contacts()
	local dlg_create_user,userData = require_files_.dlg_create_user()
	local arg = {set_data = function(data) userData = data end,Warning = function (str) if contacts[str] then iup.Message('Notice','The contact has been existed ! Please re-enter !') return true end end }
	dlg_create_user.pop(arg)
	if not userData then return end 
	local tree = tree_.get_class()
	local groupname = tree:get_title()
	userData.Group = groupname
	tree_config_.add_contact(userData)
	db_contact_.add_contact(userData)
	op_tree_.add_contact(userData)
end



function edit_contact()
	local contacts = db_contact_.get_contacts()
	local data = get_node_index_data()
	local dlg_create_user,userData = require_files_.dlg_create_user()
	local arg = {set_data = function(data) userData = data end,Datas = data,Warning = function (str) if contacts[str]  and str ~= data.Name then iup.Message('Notice','The contact has been existed ! Please re-enter !') return true end end }
	dlg_create_user.pop(arg)
	if not userData then return end 
	userData.Group = data.Group
	if userData.Name ~= data.Name then 
	db_contact_.edit_contact(userData,data)
	tree_config_.edit_contact(userData,data)
	op_tree_.edit_contact(userData,data)
	else 
	db_contact_.edit_contact(userData)
	end 
end

function delete_contact()
	local alarm = iup.Alarm('Warning','Do you want to delete the contact !','Yes','No')
	if alarm ~= 1 then return end 
	local tree = tree_.get_class()
	local attr = tree:get_attr()
	local AttrIndex = type(attr) == 'table' and attr.AttrIndex 
	local data = get_index_data(AttrIndex)
	db_contact_.delete_contact(data)
	tree_config_.delete_contact(data)
	op_tree_.delete_contact(data)
end 



function move_to(group)
	--trace_out('move_to group = ' .. group .. '\n')
	local tree = tree_.get_class()
	local attr = tree:get_attr()
	local AttrIndex = type(attr) == 'table' and attr.AttrIndex 
	local data = get_index_data(AttrIndex)
	local curGroupName = tree:get_title(tree:get_pid())
	--trace_out('curGroupName = ' .. curGroupName .. '\n')
	db_contact_.change_group(data.Name,group)
	tree_config_.change_group(data.Name,curGroupName,group)
	op_tree_.change_group(curGroupName)
end

function get_move_menu()
	local tree = tree_.get_class()
	local groups = tree_config_.get_contacts()
	local curGroupName = tree:get_title(tree:get_pid())
	local menu = {}
	for k,v in ipairs (groups) do 
		if curGroupName ~= v.Title then 
			table.insert(menu,{Title = v.Title,Action = function () move_to(v.Title) end })
		end 
	end 
	return menu
end 

local function db_change_groupname(tree,newGroup)
	local id = tree:get_selected_id()
	local childcounts = tree:get_child_numbers(id)
	local curid = id + 1
	for i = 1,childcounts do 
		local name = tree:get_title(curid)
		db_contact_.rename_group(name,newGroup)
		curid = curid + tree:get_all_numbers(curid) + 1
	end 
	
end 

function rename_group()
	local contacts = db_contact_.get_contacts()
	local groups = tree_config_.get_contacts()
	local tree = tree_.get_class()
	local OldName = tree:get_title()
	local dlg_rename,NewName = require_files_.dlg_rename()
	local arg = {set_data = function(str) NewName = str end,Warning = function (str) if groups[str]  and str ~= OldName then iup.Message('Notice','The group has been existed ! Please re-enter !') return true end end,OldName = OldName }
	dlg_rename.pop(arg)
	if not NewName or NewName == OldName then return end 
	db_change_groupname(tree,NewName)
	tree_config_.rename_group(OldName,NewName)
	op_tree_.rename_group(NewName)
end


local function get_members_list(id)
	local groups = tree_config_.get_contacts()
	local members = op_disgroup_.open(id)
	local datas = {}
	for k,v in ipairs(groups) do 
		table.insert(datas,v.Title)
		datas[v.Title] = {}
		for m, n in ipairs (groups[v.Title]) do 
			if not members[n.Title] then
				datas[v.Title][n.Title] = true
			end 
		end 
	end 
	return datas
	
end

function group_invite_members(oldData)
	local oldData = type(oldData) == 'table' and oldData or get_node_index_data()
	local dlg_group_invite_members_,invite_members = require_files_.dlg_group_invite_members()
	local arg = {}
	arg.set_data = function(members) invite_members = members end
	arg.Datas = get_members_list(oldData.Gid)
	dlg_group_invite_members_.pop(arg)
	if not invite_members then return end 
	for k,v in pairs (invite_members) do 
		op_msg_.group_invite_member(k,oldData)
	end 
end

local function get_all_groups_name(id)
	local tree = tree_.get_class()
	local id = id or tree:get_selected_id()
	local counts = tree:get_child_numbers(id)
	local curid = id + 1
	local t= {}
	for i = 1,counts do 
		t[tree:get_title(curid)] = true
		curid = curid + 1
	end 
	return t
end


function create_discussion_group()
	local dlg_group_create_,userData = require_files_.dlg_group_create()
	local groups = get_all_groups_name()
	local invite = false
	local arg = {}
	arg.set_data = function(data,tog) userData = data  if tog == 'ON' then invite = true end end
	arg.Warning = function (str) if groups[str]  then iup.Message('Notice','The group name has been existed ! Please re-enter !') return true end end
	dlg_group_create_.pop(arg)
	if not userData then return end 
	userData.Gid = luaext_.guid()
	db_contact_.create_discuss_group(userData)
	tree_config_.create_discuss_group(userData)
	op_tree_.create_discuss_group() 
	
	op_disgroup_.create(userData.Gid) --创建组成员文件
	op_server_.subscribe(userData.Gid) --订阅组
	if invite then 
		group_invite_members(userData)
	end 
end 

function edit_discussion_group()
	local oldData = get_node_index_data()
	local dlg_group_create_,userData = require_files_.dlg_group_create()
	local tree = tree_.get_class()
	local id = tree:get_pid()
	local groups = get_all_groups_name(id)
	local arg = {}
	arg.set_data = function(data,tog) userData = data  if tog == 'ON' then invite = true end end
	arg.Warning = function (str) if groups[str] and str ~= oldData.GroupName   then iup.Message('Notice','The group name has been existed ! Please re-enter !') return true end end
	arg.Datas = oldData
	dlg_group_create_.pop(arg)
	if not userData then return end 
	userData.Gid = oldData.Gid
	if userData.GroupName ~= oldData.GroupName then
		db_contact_.edit_discussion_group(userData)
		tree_config_.edit_discussion_group(userData,oldData)
		op_tree_.edit_discussion_group(userData.GroupName)
	else 
		db_contact_.edit_discussion_group(userData)
	end 
end

function quit_discuss_group()
	local oldData = get_node_index_data()
	db_contact_.quit_discuss_group(oldData)
	tree_config_.quit_discuss_group(oldData)
	op_tree_.quit_discuss_group()
	
	op_server_.unsubscribe(oldData.Gid)--取消订阅组
	op_disgroup_.quit(oldData.Gid) --创建组成员文件
	 
end

local function notice()
	 iup.Message('Notice','Update Ok !')
end


function update_members()
	local oldData = get_node_index_data()
	op_disgroup_.download(oldData.Gid,notice )
end

--channel
function subscribe_channel(t)
	local oldData =type(t) == 'table' and t or get_node_index_data()
	op_server_.subscribe(oldData.Gid) --订阅组
	oldData.Subscribe =true
	db_contact_.edit_channel(oldData)
	tree_config_.subscribe_channel(oldData)
	op_tree_.subscribe_channel(tree_config_.get_image_subscribe())
	
end 

function unsubscribe_channel(t)
	local oldData =type(t) == 'table' and t or get_node_index_data()
	oldData.Subscribe = nil
	op_server_.unsubscribe(oldData.Gid) --订阅组
	db_contact_.edit_channel(oldData)
	tree_config_.unsubscribe_channel(oldData)
	op_tree_.unsubscribe_channel(tree_config_.get_image_unsubscribe())
end


function create_channel()
	local dlg_channel_create,userData = require_files_.dlg_channel_create()
	local channels = get_all_groups_name()
	local subscribe = false
	local arg = {}
	arg.set_data = function(data,tog) userData = data if tog == 'ON' then subscribe = true end end
	arg.Warning = function (str) if channels[str]  then iup.Message('Notice','The group name has been existed ! Please re-enter !') return true end end
	dlg_channel_create.pop(arg)
	if not userData then return end 
	userData.Gid = luaext_.guid()
	--op_channel_.create(userData.Gid)
	if subscribe then 
		userData.Subscribe =true
	end 
	db_contact_.create_channel(userData)
	tree_config_.create_channel(userData)
	op_tree_.create_channel(userData)
end

function edit_channel()
	local oldData = get_node_index_data()
	local dlg_channel_create,userData = require_files_.dlg_channel_create()
	local tree = tree_.get_class()
	local pid = tree:get_pid()
	local channels = get_all_groups_name(pid)
	local arg = {}
	arg.set_data = function(data,tog) userData = data if tog == 'ON' then subscribe = true end end
	arg.Warning = function (str) if channels[str] and str ~= oldData.ChannelName   then iup.Message('Notice','The Channel name has been existed ! Please re-enter !') return true end end
	arg.Datas = oldData
	dlg_channel_create.pop(arg)
	if not userData then return end 
	userData.Gid = oldData.Gid
	if userData.ChannelName ~= oldData.ChannelName then
		db_contact_.edit_channel(userData)
		tree_config_.edit_channel(userData,oldData)
		op_tree_.edit_channel(userData.ChannelName)
	else 
		db_contact_.edit_channel(userData)
	end 
	
	if subscribe and not oldData.Subscribe then 
		subscribe_channel(userData)
	elseif not subscribe and  oldData.Subscribe then 
		unsubscribe_channel(userData)
	end 
end

function delete_channel()
	local oldData = get_node_index_data()
	if oldData.Subscribe then 
		iup.Message('Notice','Please cancel the subscription firstly !')
		return 
	end 
	db_contact_.delete_channel(oldData)
	tree_config_.delete_channel(oldData)
	op_tree_.delete_channel(oldData)
end

function invitation_code()
	local oldData = get_node_index_data()
	local dlg_invite_code_ = require_files_.dlg_invite_code()
	dlg_invite_code_.pop{Code = oldData.Gid}
end


local function get_invite_groupname(name)
	local groupName = name
	local tree = tree_.get_class()
	local id = 1 + tree:get_all_numbers(1) + 1 
	--tree:set_marked(id)
	local groups = get_all_groups_name(id)
	while true do 
		if groups[name] then 
			name = name .. '_副本'
		else
			return name,id
		end 
	end 
end

local function delete_msg(msg)
	msg.Delete = true
	require 'sys.net.msg'.add_msg(msg)
end

function accept_invite(msg)
	local groupId = msg.GroupId
	local note = msg.GroupNote
	local groupName,id =  get_invite_groupname(msg.GroupName)
	local userdata = {GroupName = groupName,Gid = groupId,Time =os.time(),Note = note}
	db_contact_.create_discuss_group(userdata)
	tree_config_.create_discuss_group(userdata)
	op_tree_.create_discuss_group(id) 
	op_server_.subscribe(groupId)
	op_disgroup_.download(groupId,op_disgroup_.create(groupId))
	delete_msg(msg)
end



function refuse_invite(msg)
	delete_msg(msg)
end


-------------------------------------------------------------------------------
function ShowRule_subscribe_channel()
	local data = get_node_index_data()
	if data.Subscribe then 
		return 'hide'
	end 
end 

function ShowRule_unsubscribe_channel()
	local data = get_node_index_data()
	if not data.Subscribe then 
		return 'hide'
	end 
end 


