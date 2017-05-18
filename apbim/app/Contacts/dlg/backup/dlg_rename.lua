
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local btn_ok_;
local btn_close_;
local lab_old_name_;
local txt_old_name_;
local lab_new_name_;
local txt_new_name_;
local lab_separator_;



local dlg_ = nil



--arg = {get_data,Warning,OldName}
function pop(arg)
	--local iup = require "iuplua"
	local save_data = {}
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_close_ = iup.button{title = "Cancel",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_old_name_ = iup.label{title = "Old Name : ",rastersize = wid}
		txt_old_name_ = iup.text{rastersize = "300x",expand ="HORIZONTAL"}
		
		lab_new_name_ = iup.label{title = "New Name : ",rastersize = wid}
		txt_new_name_ = iup.text{rastersize = "300x",expand ="HORIZONTAL"}
		lab_separator_ = iup.label{title = '',SEPARATOR = "HORIZONTAL",expand = "HORIZONTAL"}
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.frame{
					iup.vbox{
						iup.hbox{lab_old_name_,txt_old_name_};
						iup.hbox{lab_separator_};
						iup.hbox{lab_new_name_,txt_new_name_};
					};
				};
				iup.hbox{btn_ok_,btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Rename";
			resize = "NO";
			--TOPMOST = "YES";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function init_callback()
		
		function btn_ok_:action()
			local str = txt_new_name_.value
			if arg.Warning and arg.Warning(str) then
				txt_new_name_.value = ''
				iup.SetFocus(txt_new_name_)
				return 
			end 
			
			if arg and  type(arg.set_data) == 'function' then 
				arg.set_data(str)
			end 
			dlg_:hide()
		end
		function btn_close_:action()
			dlg_:hide()
		end
	end 
	
	

	local function init_data()
		txt_old_name_.value = type(arg) == 'table' and arg.OldName or ''
		txt_new_name_.value = ""
		lab_old_name_.active = "NO"
		txt_old_name_.active = "NO"
	end 

	local function init()

		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		dlg_:map()
		init_data()
		dlg_:popup()
	end 

	init()
end
