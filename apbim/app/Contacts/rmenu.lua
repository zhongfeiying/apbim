_ENV = module(...,ap.adv)

local require_files_ = require "app.Contacts.require_files"
local op_rmenu_ = require_files_.op_rmenu()
local tree_ = require_files_.tree()
--------------------------------------------------------------------------------------
--action

--[[
Rmenus_.move_up = {Title = "Move Up",Action = move_up,ShowRule = move_up };
Rmenus_.move_down = {Title = "Move Down",Action = move_down};
--]]

local function test()
end
--------------------------------------------------------------------------------------
local Rmenus_ = {}
Rmenus_.add_group = {Title = "Add Group",Action = op_rmenu_.add_group};
Rmenus_.manage_contacts = {Title = "Manage contacts",Action = op_rmenu_.manage_contacts};


Rmenus_.add_contact = {Title = "Add Contact",Action = op_rmenu_.add_contact};
Rmenus_.edit_contact = {Title = "Edit",Action = op_rmenu_.edit_contact};
Rmenus_.rename_group = {Title = "Rename",Action = op_rmenu_.rename_group};
Rmenus_.delete_contact = {Title = "Delete",Action = op_rmenu_.delete_contact};
Rmenus_.dissolve_group = {Title = "Dissolve Group",Action = op_rmenu_.dissolve_group};
Rmenus_.locate_contact = {Title = "Locate Contact",Action = op_rmenu_.locate_contact};
Rmenus_.move_to = {Title = "Move To",Submenu = op_rmenu_.get_move_menu };
Rmenus_.contact_information = {Title = "Information"};


Rmenus_.create_group = {Title = "Create",Action = op_rmenu_.create_discussion_group};	
--Rmenus_.rename_group = {Title = "Rename",Action = op_rmenu_.group_rename};
Rmenus_.edit_group = {Title = "Edit",Action = op_rmenu_.edit_discussion_group};
Rmenus_.invite_members = {Title = "Invite Members",Action = op_rmenu_.group_invite_members};
Rmenus_.quit_group = {Title = "Quit",Action = op_rmenu_.quit_discuss_group};
Rmenus_.update_members = {Title = "Update",Action = op_rmenu_.update_members};

Rmenus_.create_channel = 	{Title = "Create",Action = op_rmenu_.create_channel};
Rmenus_.edit_channel = 	{Title = "Edit",Action = op_rmenu_.edit_channel};
Rmenus_.delete_channel = 	{Title = "Delete",Action = op_rmenu_.delete_channel};
Rmenus_.subscribe_channel = {Title = "Subscribe",Action = op_rmenu_.subscribe_channel,ShowRule = op_rmenu_.ShowRule_subscribe_channel};
Rmenus_.unsubscribe_channel ={Title = "Unsubscribe",Action = op_rmenu_.unsubscribe_channel,ShowRule = op_rmenu_.ShowRule_unsubscribe_channel};
Rmenus_.invitation_code =	{Title = "Get Invitation Code",Action = op_rmenu_.invitation_code};

local menus_ = {}

menus_.contacts_rmenu = 
{
		Rmenus_.add_group;
	--	Rmenus_.manage_contacts;
}

menus_.groups_rmenu =
{
		Rmenus_.create_group;
	};

menus_.channels_rmenu =
{
		Rmenus_.create_channel;
	}

menus_.contacts_friends_rmenu =
{
		Rmenus_.add_contact;
		--Rmenus_.move_to;
		--Rmenus_.add_contact;
	}

menus_.contacts_strangers_rmenu =
{
		--Rmenus_.move_to;
		--Rmenus_.add_contact;
	}

menus_.contacts_folder_rmenu =
 {
		Rmenus_.add_contact;
		Rmenus_.rename_group;
		'';
		Rmenus_.dissolve_group;
		--Rmenus_.move_to;
		--Rmenus_.add_contact;
	}

menus_.contacts_file_rmenu =
{
		Rmenus_.edit_contact;
		Rmenus_.delete_contact;
		'';
		Rmenus_.move_to;
	--	'';
	--	Rmenus_.move_to;
	--	Rmenus_.contact_information;
	}

menus_.groups_members_menu =
{
		--Rmenus_.rename_group;
		Rmenus_.edit_group;
		Rmenus_.quit_group;
		'';
		Rmenus_.invite_members;
		Rmenus_.update_members;
		--Rmenus_.move_to;
		--Rmenus_.add_contact;
	}

menus_.channels_members_rmenu = 
{
		Rmenus_.edit_channel;
		Rmenus_.delete_channel;
		'';
		Rmenus_.subscribe_channel;
		Rmenus_.unsubscribe_channel;
		'';
		Rmenus_.invitation_code;
}


function get()
	return menus_
end

function get_menu(str)	
	return menus_[str]
end
--]==]