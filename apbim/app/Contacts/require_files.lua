
_ENV = module(...,ap.adv)
------------------------------------------------------------------------------
--api 

function dock()
	return require "sys.dock"
end

function luaext()
	return require "luaext"
end

function apx_tree()
	return require "apx.sjy.tree.tree"
end

function get_user()
	return require'sys.mgr'.get_user() or 'Test'
end

------------------------------------------------------------------------------

function contacts_page()
	return require "app.Contacts.contacts_page"
end


function op_server()
	return require "app.Contacts.op_server"
end


function op_tree()
	return require "app.Contacts.op_tree"
end

function op_rmenu()
	return require "app.Contacts.op_rmenu"
end

function op_msg()
	return require "app.Contacts.op_msg"
end

function op_disgroup()
	return require "app.Contacts.op_disgroup"
end

function op_channel()
	return require "app.Contacts.op_channel"
end

function rmenu()
	return require "app.Contacts.rmenu"
end

function db_contact()
	return require "app.Contacts.db_contact"
end

function tree_config()
	return require "app.Contacts.tree_config"
end

function tree()
	return require "app.Contacts.tree"
end
------------------------------------------------------------------------------
--file

function file_op()
	return require "app.Contacts.file.file_op"
end

function file_save()
	return require "app.Contacts.file.file_save"
end

function file_save_o()
	return require "app.Contacts.file.file_save_o"
end

------------------------------------------------------------------------------
--dlg
function dlg_add()
	return require "app.Contacts.dlg.dlg_add"
end

function dlg_add_group()
	return require "app.Contacts.dlg.dlg_add_group"
end

function dlg_create_user()
	return require "app.Contacts.dlg.dlg_create_user"
end

function dlg_rename()
	return require "app.Contacts.dlg.dlg_rename"
end

function dlg_group_create()
	return require "app.Contacts.dlg.dlg_group_create"
end

function dlg_channel_create()
	return require "app.Contacts.dlg.dlg_channel_create"
end

function dlg_invite_code()
	return require "app.Contacts.dlg.dlg_invite_code"
end

function dlg_group_invite_members()
	return require "app.Contacts.dlg.dlg_group_invite_members"
end

function dlg_msg()
	return require "app.Contacts.dlg.dlg_msg"
end
------------------------------------------------------------------------------
--dlg/form
function form_contact()
	return require "app.Contacts.dlg.form.contact"
end

------------------------------------------------------------------------------
--sendapi
function send_code()
	return require "app.Contacts.SendApi.send_code"
end

function set_msg()
	return require "app.Contacts.SendApi.set_msg"
end

------------------------------------------------------------------------------
--cmd
function cmd_dlbtn()
	return require "app.Contacts.cmd.dlbtn"
end




