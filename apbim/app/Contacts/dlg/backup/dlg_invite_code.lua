_ENV = module(...,ap.adv)

local btn_close_;
local lab_name_;
local txt_name_;

local dlg_ = nil



--arg = {Code,}
function pop(arg)
	
	local function init_buttons()
		local wid = "100x"
		btn_close_ = iup.button{title = "Close",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_name_ = iup.label{title = arg and arg.Name or  "Invite Code : ",rastersize = wid,}
		txt_name_ = iup.text{rastersize = "300x",expand ="HORIZONTAL",READONLY = 'YES',NOHIDESEL = 'yes'}
	end 

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_name_,txt_name_};
				iup.hbox{btn_close_};
				alignment = "ARIGHT";
				margin = "10x5"
			};
			title = arg and arg.DlgName or "Get Invite Code";
			resize = "NO";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function init_callback()
		
		function btn_close_:action()
			dlg_:hide()
		end
	end 

	local function init_data()
		txt_name_.value = ""
		if arg.Code then 
			txt_name_.value = arg.Code
			txt_name_.SELECTIONPOS  = '0:' .. txt_name_.COUNT
		end 
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

	local function show()
		init_data()
		dlg_:popup()
	end 
	
	init()
	
--	if dlg_ then show() else init() end 
end

