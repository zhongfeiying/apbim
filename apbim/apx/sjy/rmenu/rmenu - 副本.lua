_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local op_menu_ = require_files_.op_menu()
local tree_ = require_files_.tree()
local IupTree_ = require_files_.IupTree()
local rmenu_op_ = require_files_.rmenu_op()
local cmds_ = rmenu_op_.get_cmds()
local config_db_ = require_files_.config_db()

local hide_ = true
local active_ = nil

local function node_depth(tree,tid,depth)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= depth then 
		hide = hide_
		active = active_
	end
	return hide,active;
end

local function add_group_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function add_contact_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		if  IupTree_.get_node_title(tree,tid) == "Strangers" then 
			hide = hide_
			active = active_
		end
	end
	return hide,active;
	--return node_depth(tree,tid,1)
end

local function edit_contact_showrule(tree,tid)
	return node_depth(tree,tid,2)
end

local function rename_group_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		if IupTree_.get_node_title(tree,tid) == "Friends" or  IupTree_.get_node_title(tree,tid) == "Strangers" then 
			hide = hide_
			active = active_
		end
	end
	return hide,active;
	--return node_depth(tree,tid,1)
end

local function delete_contact_showrule(tree,tid)
	return node_depth(tree,tid,2)
end

local function merge_group_showrule(tree,tid)
	-- local hide,active;
	-- if IupTree_.get_node_depth(tree,tid) ~= 0 then 
		-- hide = hide_
		-- active = active_
	-- else 
		-- local 
	-- end
	-- return hide,active;
	return node_depth(tree,tid,0)
end

local function dissolve_group_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		if IupTree_.get_node_title(tree,tid) == "Friends" or  IupTree_.get_node_title(tree,tid) == "Strangers" then 
			hide = hide_
			active = active_
		end
	end
	return hide,active;
	--return node_depth(tree,tid,1)
end

local function contact_manager_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function move_contact_showrule(tree,tid)
	
	return node_depth(tree,tid,2)
end

local function contact_history_msg_showrule(tree,tid)
	return node_depth(tree,tid,2)
end 

local function move_up_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) == 0 then 
		hide = hide_
		active = active_
	else 
		local newid = tid - 1
		if IupTree_.get_node_depth(tree,newid) < IupTree_.get_node_depth(tree,tid) then 
			hide = hide_
			active = active_
		end
	end
	return hide,active;
end

local function move_down_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) == 0 then 
		hide = hide_
		active = active_
	else 
		local newid = tid + IupTree_.get_folder_totalcount(tree,tid) +  1
		if not IupTree_.get_node_depth(tree,newid)  then 
			hide = hide_
			active = active_
		elseif IupTree_.get_node_depth(tree,newid) < IupTree_.get_node_depth(tree,tid) then
			hide = hide_
			active = active_
		end
	end
	return hide,active;
end
-----------------------------------------------------------------------------
-- ÌÖÂÛ×é
local function group_create_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function group_rename_showrule(tree,tid)
	return node_depth(tree,tid,1)
end 

local function group_edit_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function group_invite_members_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function group_quit_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function group_manage_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function group_history_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

--------------------------------------------------------------------------------------
--
local function channels_create_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function channels_rename_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function channels_edit_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function channels_subscribe_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		local t = IupTree_.get_node_attribute(tree,tid)
		if t and t.Subscribe then 
			hide = hide_
			active = active_
		end 
	end
	return hide,active
	--return node_depth(tree,tid,1)
end

local function channels_unsubscribe_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		local t = IupTree_.get_node_attribute(tree,tid)
		if t and not t.Subscribe then 
			hide = hide_
			active = active_
		end 
	end
	return hide,active
end

local function channels_delete_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function channels_manage_showrule(tree,tid)
	return node_depth(tree,tid,0)
end


local function channels_history_showrule(tree,tid)
	return node_depth(tree,tid,1)
end

local function locate_contact_showrule(tree,tid)
	return node_depth(tree,tid,0)
end

local function channels_copy_showrule(tree,tid)
	local hide,active;
	if IupTree_.get_node_depth(tree,tid) ~= 1 then 
		hide = hide_
		active = active_
	else 
		local t = IupTree_.get_node_attribute(tree,tid)
		if t and not t.Subscribe then 
			hide = hide_
			active = active_
		end 
	end
	return hide,active
end
--------------------------------------------------------------------------------------

local Rmenus_ = {
	["Contacts"] = {
		{Title = "Add Group",Action = cmds_.add_group,ShowRule = add_group_showrule;};
		--{Title = "Merge Group",Action = cmds_.merge_group,ShowRule = merge_group_showrule;};
		{Title = "Add Contact",Action = cmds_.add_contact,ShowRule = add_contact_showrule;};
		{Title = "Edit",Action = cmds_.edit_contact,ShowRule = edit_contact_showrule;};
		{Title = "Rename",Action = cmds_.rename_group,ShowRule = rename_group_showrule;};
		{Title = "Delete",Action = cmds_.delete_contact,ShowRule = delete_contact_showrule;};
		"";
		{Title = "Dissolve Group",Action = cmds_.dissolve_group,ShowRule = dissolve_group_showrule;};
		{Title = "Locate Contact",Action = cmds_.locate_contact,ShowRule = locate_contact_showrule;};
		"";
		{Title = "Move Up",Action = cmds_.move_up  ,ShowRule = move_up_showrule;};
		{Title = "Move Down",Action = cmds_.move_down,ShowRule = move_down_showrule;};
		"";
		--{Title = "Contact Manager",Action = cmds_.contact_manager,ShowRule = contact_manager_showrule;};
		{Title = "Move To",ShowRule = move_contact_showrule;};--Action = cmds_.move_contact,
		--{Title = "History",Action = cmds_.contact_history_msg,ShowRule = contact_history_msg_showrule;};
		"";
	};
	["Groups"] = {
		{Title = "Create",Action = cmds_.group_create,ShowRule = group_create_showrule;};
		{Title = "Rename",Action = cmds_.group_rename,ShowRule = group_rename_showrule;};
		{Title = "Edit",Action = cmds_.group_edit,ShowRule = group_edit_showrule;};
		"";
		{Title = "Invite Members",Action = cmds_.group_invite_members,ShowRule = group_invite_members_showrule;};
		{Title = "Quit",Action = cmds_.group_quit,ShowRule = group_quit_showrule;};
		"";
		--{Title = "Manage Groups",Action = cmds_.group_manage,ShowRule = group_manage_showrule;};
	--	{Title = "History",Action = cmds_.group_history,ShowRule = group_history_showrule;};
		"";
	};
	["Channels"] = {
		{Title = "Create",Action = cmds_.channels_create,ShowRule = channels_create_showrule;};
		"";
		{Title = "Rename",Action = cmds_.channels_rename,ShowRule = channels_rename_showrule;};
		{Title = "Edit",Action = cmds_.channels_edit,ShowRule = channels_edit_showrule;};
		{Title = "Delete",Action = cmds_.channels_delete,ShowRule = channels_delete_showrule;};
		"";
		{Title = "Subscribe",Action = cmds_.channels_subscribe,ShowRule = channels_subscribe_showrule;};
		{Title = "Unsubscribe",Action = cmds_.channels_unsubscribe,ShowRule = channels_unsubscribe_showrule;};
		"";
		{Title = "Copy Id",Action = cmds_.channels_copy,ShowRule = channels_copy_showrule;};
		"";
		--{Title = "Manage Channels",Action = cmds_.channels_manage,ShowRule = channels_manage_showrule;};
		--{Title = "History",Action = cmds_.channels_history,ShowRule = channels_history_showrule;};
		
	};
}


-- function new(t)
	-- t = t or {};
	-- setmetatable(t,Rmenus_);
	-- Rmenus_.__index = Rmenus_;
	-- return t;
-- end

local function get_item_pos(str,db)
	if type(db) ~= "table" then  return end 
	for k,v in ipairs (db) do 
		if v.Title == str then 
			return db[k]
		end 
	end 
	return 
end 

local function get_pos(TitlePos,db,pos)
	if #TitlePos == 0 then 
		if string.lower(pos) ==  "in" then 
			local t = db[#db]
			table.insert(t,{})
			return t[#t]
		else 
			db[#db + 1] = {}
			return db[#db]
		end 
	else 
		local olddb = db
		for k,v in ipairs (TitlePos) do 
			olddb = db
			db = get_item_pos(v,db)
		end
		if string.lower(pos) == "in" then 
			table.insert(db,{})
			return db[#db]
		else 
			olddb[#olddb + 1] = {}
			return olddb[#olddb]
		end 
	end 
end

--arg = {TitlePos = {"",""},Pos = "in" or "down";Menu = "Channels" or "Groups";Title = ,Action = ,ShowRule =,Temp = true}
function add_item(arg)
	if type(arg) ~= "table" or not arg.Menu or not arg.Title then error("Insert Item data error !") return end 
	local menus = Rmenus_[arg.Menu] or {}
	local TitlePos = arg.TitlePos or {}
	local Pos = arg.Pos or "down"
	local db = get_pos(TitlePos,menus,Pos)
	if type(db) ~= "table" then return end 
	for k,v in pairs(arg) do 
		db[k] =v
	end 
end
--[[
args ={
	{TitlePos = {"",""},Pos = "in" or "down";Menu = "Channels" or "Groups";Title = ,Action = ,ShowRule =,Temp = true}
	{TitlePos = {"",""},Pos = "in" or "down";Menu = "Channels" or "Groups";Title = ,Action = ,ShowRule =,Temp = true}
}
]]
function add_items(args)
	for k,v in ipairs (args) do 
		add_item(v)
	end 
end


--arg = {name = }
function init(name)
	local Rmenu_;
	local get_items;
	local tree = tree_.get_tree();
	local curid = tree_.get_select_id(tree);
	
	local function table_is_empty(t)
		return _G.next(t) == nil
	end
	
	local function deal_action(item,t)
		if t.Action and type(t.Action) == "function" then 
			item.action = t.Action
		end
	end
	
	local function insert_separator(t)
		if #t ~= 0 and t[#t].Title then 
			table.insert(t,op_menu_.separator())
		end 
	end
	
	local function del_end_separator(t)
		if type(t) ~= "table" then return end 
		if #t == 0 then return end 
		if not t[#t].title then 
			t[#t] = nil
		end 
	end
	
	local function create(t) 
		local newt = {}
		for k,v in ipairs(t) do 
			if type(v) ~= "table" or table_is_empty(v) then 
				insert_separator(newt)
			else 
				local item = get_items(v)
				if item then 
					table.insert(newt,item)
				end 
			end 
		end 
		
		return newt
	end 
	
	get_items = function (t)
		local item;
		if #t ~= 0 then 
			local newt =create(t)
			del_end_separator(newt)
			if #newt > 1 then 
				item = op_menu_.create_submenu{
					title = t.Title;
					op_menu_.create(newt);
				}
				deal_action(item,t)
			elseif  #newt == 0 then 
				return 
			elseif #newt == 1 then
				item = op_menu_.create_item{title = t.Title .. " " .. newt[1].Title}
				item.action = newt[1].action
			end 
		else 
			item = op_menu_.create_item{title = t.Title}
			deal_action(item,t)
		end
		if type(t.ShowRule) == "function" then
			local hide,active = t.ShowRule(tree,curid)
			if hide then return end 
			if active and string.lower(active) == "no" then 
				item.active = "no"
			end 
		end
		--if t.Image then item.IMAGE = t.Image end
		return item
	end
	
	local function init_controls()
		local t = {}
		for k,v in ipairs(Rmenus_[name]) do 
			if type(v) ~= "table" or table_is_empty(v) then 
				insert_separator(t)
			else 
				local item = get_items(v)
				if item then 
					table.insert(t,item)
				end
			end 
		end
		del_end_separator(t)
		Rmenu_ = op_menu_.create(t)
	end
	
	local function add_move_to_item()
		local cfg_ =config_db_.get_cfg()
		local db = cfg_.get_contacts()
		local args = {}
		local ParentIdTitle = IupTree_.get_node_title(tree,IupTree_.get_parent_node(tree,curid))
		for k,v in ipairs (db) do 
			if v.Title then 
				if ParentIdTitle ~= v.Title then 
					local arg = {TitlePos = {"Move To"},Pos = "in";Menu = "Contacts";Title = v.Title,Action =
					function () cmds_.move_to(v.Title) end 
					,ShowRule = move_contact_showrule,Temp = true}
					table.insert(args,arg)
				end 
			end 
		end
		add_items(args)
	end
	
	local function del_temp_data(data)
		for i =#data ,1,-1 do 
			if type(data[i]) == "table" then 
				if data[i].Temp then 
					table.remove(data,i)
				else 
					if #data[i] ~= 0 then 
						del_temp_data(data[i])
					end 
				end 
			end
		end 
		
	end 
	
	local function init_data()
		del_temp_data(Rmenus_[name])
		if name == "Contacts" then 
			if IupTree_.get_node_depth(tree,curid) == 2 then 
				add_move_to_item()
			end 
		end 
	end 
	
	local function init()
		init_data()
		init_controls()
	end 
	
	init()
	return Rmenu_
end

function pop(menu)
	if not menu then error("Menu is error !") return end 
	iup.Refresh(menu)
	menu:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end 

function get()
	return Rmenus_
end


--[[
--arg = {Title = ,Action = ,Pos = {} or number or nil,ShowRule = ,...}
local function add_item(str,arg)
	Rmenus_[str] = Rmenus_[str] or {}
	if arg.Pos and type(arg.Pos) == "number" then 
		table.insert(Rmenus_[str],arg.Pos,arg)
	elseif arg.Pos and type(arg.Pos) == "table" then 
		--table.insert(Rmenus_.Contacts,arg.Pos,arg)
	else 
		table.insert(Rmenus_[str],arg)
	end
end

function contacts_add_item(arg)
	if type(arg) ~= "table" or type(arg.Title) ~= "string" then iup.Message("Notice","The parameter must be a table and have a key called 'Title' in it !") return end 
	Rmenus_ = Rmenus_ or {}
	add_item("Contacts",arg)
end

function groups_add_item(arg)
	if type(arg) ~= "table" or type(arg.Title) ~= "string" then iup.Message("Notice","The parameter must be a table and have a key called 'Title' in it !") return end 
	Rmenus_ = Rmenus_ or {}
	add_item("Groups",arg)
end

function channels_add_item(arg)
	if type(arg) ~= "table" or type(arg.Title) ~= "string" then iup.Message("Notice","The parameter must be a table and have a key called 'Title' in it !") return end 
	Rmenus_ = Rmenus_ or {}
	add_item("Channels",arg)
end

function add_all(arg)
	if type(arg) ~= "table" or type(arg.Title) ~= "string" then iup.Message("Notice","The parameter must be a table and have a key called 'Title' in it !") return end 
	Rmenus_ = Rmenus_ or {}
	add_item("Contacts",arg)
	add_item("Groups",arg)
	add_item("Channels",arg)
end

--]]