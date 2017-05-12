_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files" 

local tree_ = require_files_.tree()


local dlg;

function pop()
	local iup = require "iuplua"
	
	local function init_dlg()
		dlg = iup.frame{
			tabtitle = "User";
			margin = "0x0";
			iup.vbox{
				iup.hbox{tree_.create()};
			};
		}
	end 
	init_dlg()
	return dlg;
end

function init_datas()
	local db_contact_ = require_files_.db_contact()
	local tree_config_ = require_files_.tree_config()
	local function init_show()
		db_contact_.init()
		tree_config_.init()
		tree_.show_datas()
	end
	-- init_show()
	local init_show_nums_ = 2
	local function cbf()
		init_show_nums_ = init_show_nums_ - 1
		if init_show_nums_ == 0 then 
			init_show()
		end 
	end
	db_contact_.get_server_file{cbf = cbf}
	tree_config_.get_server_file{cbf = cbf}
	
end



