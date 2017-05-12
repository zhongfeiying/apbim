_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files" 
local db_contact_ = require_files_.db_contact()
local tree_config_ = require_files_.tree_config()
local rmenu_ = require_files_.rmenu()
local cmd_dlbtn_ = require_files_.cmd_dlbtn()
local tree_ = require_files_.tree()
----------------------------------------------------------------------------------------


local table_is_empty =  function (t)
	return _G.next(t) == nil
end

function deep_copy(old)
	local new = {}
	for k,v in pairs (old) do 
		if type(v) == 'table' then 
			new[k] = deep_copy(v)
		else
			new[k] = v
		end
	end
	return new
end

function get_selected_name()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	local attr = tree:get_attr(id)
	local index = type(attr) == 'table' and attr.AttrIndex 
	if type(index) ~= 'string' then return end 
	return string.match(index,'/([^/+]+)')
end

----------------------------------------------------------------------------------------


local function get_data(data)
	local t = {}
	for k,v in pairs (data) do 
		if type(v) == 'table' then 
			t[k] = deep_copy(v)
		else 
			t[k] = v
		end
	end
	if t.Image then 
		t.Image = tree_config_.get_local_bmp(t.Image)
	end 
	if t.Attr and t.Attr.RmenuIndex then 
		t.Attr.Rmenu = rmenu_.get_menu(t.Attr.RmenuIndex)
	end 
	
	if t.Attr and t.Attr.DLbtn then 
		t.Attr.DLbtn = cmd_dlbtn_.get_function(t.Attr.DLbtn)
	end 
	return t
end 

local function turn_data(db,newdata)
	for k,v in ipairs (db) do 
		local t = get_data(v) or {}
		if v.Kind and v.Kind == 'BRANCH'  then 
			t.Datas = {}
			if v.Title and db[v.Title]  then
				turn_data(db[v.Title],t.Datas)
			end 
		end		
		table.insert(newdata,t)
	end 
end

function get_tree_data()
	local db = tree_config_.get()
	local new_data = {}
	turn_data(db,new_data)
	return new_data
end

function add_group()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	local data = tree_config_.get_contacts()
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,id)
end

function dissolve_group()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	id = tree:get_pid(id)
	local data = tree_config_.get_contacts()
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,id)
end

function change_group()
	local tree = tree_.get_class()
	local pid = tree:get_pid()
	pid = tree:get_pid(pid)
	local data = tree_config_.get_contacts()
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,pid)
end 

function add_contact()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	local data = tree_config_.get_contacts(tree:get_title())
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,id)
end

function edit_contact()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	local pid = tree:get_pid(id)
	local data = tree_config_.get_contacts(tree:get_title(pid))
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,pid)
	tree:set_marked(id)
end

local function delete_selected_node()
	local tree = tree_.get_class()
	tree:delete_selected_nodes()
end

function delete_contact()
	delete_selected_node()
end

local function change_name(name)
	local tree = tree_.get_class()
	tree:set_title(name)
end

function rename_group(name)
	change_name(name)
end

function create_discuss_group(id)
	local tree = tree_.get_class()
	local id = id or tree:get_selected_id()
	local data = tree_config_.get_groups()
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,id)
end

function edit_discussion_group(name)
	change_name(name)
end

function quit_discuss_group()
	delete_selected_node()
end

function create_channel()
	local tree = tree_.get_class()
	local id = tree:get_selected_id()
	local data = tree_config_.get_channels()
	local new_data = {}
	turn_data(data,new_data)
	tree:init_tree_datas(new_data,id)
end

function edit_channel(name)
	change_name(name)
end

local function change_image(image)
	local tree = tree_.get_class()
	tree:set_image(image)
end

function subscribe_channel(image)
	local image = tree_config_.get_local_bmp(image)
	change_image(image)
end

function unsubscribe_channel(image)
	local image = tree_config_.get_local_bmp(image)
	change_image(image)
end

function delete_channel()
	delete_selected_node()
end





