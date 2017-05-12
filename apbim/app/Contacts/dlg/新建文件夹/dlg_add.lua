_ENV = module(...,ap.adv)

local btn_ok_;
local btn_close_;
local lab_name_;
local txt_name_;

local dlg_ = nil



--arg = {Name,get_data,Warning}
function pop(arg)
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid,  }
		btn_close_ = iup.button{title = "Close",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_name_ = iup.label{title = arg and arg.Name or  "Name : ",rastersize = wid,}
		txt_name_ = iup.text{rastersize = "300x",expand ="HORIZONTAL"}
	end 

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_name_,txt_name_};
				iup.hbox{btn_ok_,btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = arg and arg.DlgName or "Add";
			resize = "NO";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function init_callback()
		function btn_ok_:action()
			if not string.find(txt_name_.value,"%S+") then return end 
			if arg.Warning and arg.Warning(txt_name_.value) then
				txt_name_.value = ''
				iup.SetFocus(txt_name_)
				return 
			end 
			if arg and  type(arg.set_data) == 'function' then 
				arg.set_data(txt_name_.value)
			end 
			dlg_:hide()
		end
		function btn_close_:action()
			dlg_:hide()
		end
	
	end 

	local function init_data()
		txt_name_.value = ""
	end

	local function init()
		
		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		init_data()
		dlg_:popup()
	end 

	local function show()
		init_data()
		dlg_:popup()
	end 
	
	init()
	
--	if dlg_ then show() else init() end 
end

