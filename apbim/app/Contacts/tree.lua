_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files" 
local apx_tree_ = require_files_.apx_tree()
local op_tree_ = require_files_.op_tree()
local tree;--Ω” ’tree¿‡

function get_tree()
	return tree and tree:get_tree()
end

function get_class()
	return tree
end

function create()
	local function create_tree()
		tree = apx_tree_.get_class():new()
		tree:set_tabtitle('User')
	end
	create_tree()
	return get_tree()
end

function show_datas()
	if not tree then iup.Message('Warning','No Tree !') return end 
	local cur_data = op_tree_.get_tree_data()
	if not cur_data then return end
	tree:set_datas(cur_data)
	tree:show()
end
