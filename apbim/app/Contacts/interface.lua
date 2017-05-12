
_ENV = module(...,ap.adv)

local require_files_ = require "app.Contacts.require_files"
local op_tree_ = require_files_.op_tree()
local file_op_ = require_files_.file_op()


--return : 用户名（返回值是一个用户名，没有选中用户会不会返回值（为nil））
function get_selected()
	return op_tree_.get_selected_name()
end

--返回定义好的设置为nil的函数句柄
function get_nil_f()
	return file_op_.get_nil_f()
end

--保存数据tab到路径FileAllPath下。
function save_file(FileAllPath,tab)
	file_op_.save_table_to_file(FileAllPath,tab)
end 



-- function active_page()
	-- local Contacts_Page_ = require_files_.contacts_page()
	-- local dock_ = require_files_.dock()
	-- dock_.active_page(Contacts_Page_.get())
-- end 

-- function get_tree_class()
	-- return op_tree_.get_class()
-- end

-- function get_tree_control()
	-- return op_tree_.get_tree_control()
-- end



