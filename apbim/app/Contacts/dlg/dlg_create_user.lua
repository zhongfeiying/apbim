_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local form_contact_ = require_files_.form_contact()

local btn_ok_;
local btn_close_;

local dlg_ = nil
local vbox_t_;
--arg = {Datas,get_data,warning}
function pop(arg)
	
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_close_ = iup.button{title = "Close",rastersize = wid}
	end 

	local function init_controls()
		vbox_t_ = {}
		form_contact_.set(vbox_t_,{Attr = arg and arg.Datas})
		table.insert(vbox_t_,iup.hbox{btn_ok_,btn_close_})
		vbox_t_.alignment = "ARIGHT";
		vbox_t_.margin = "10x10"
	end 

	local function init_dlg()
		
		dlg_ = iup.dialog{
			iup.vbox(vbox_t_);
			title = "Add Contact";
			resize = "NO";
		}
	end 
	

	local function init_callback()
		function btn_ok_:action()
			local data = form_contact_.get() 
			if not string.find(data.Name,"%S+") then return end 
			if arg.Warning and arg.Warning(data.Name) then
				form_contact_.init_name()
				return 
			end 
			
			if arg and  type(arg.set_data) == 'function' then 
				data.Time = arg and arg.Datas and arg.Datas.Time or os.time()
				arg.set_data(data)
			end 
			dlg_:hide()
		end
		
		function btn_close_:action()
			dlg_:hide()
		end
		
	end 


	local function init()
		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		dlg_:popup()
	end 
	
	init()

end
