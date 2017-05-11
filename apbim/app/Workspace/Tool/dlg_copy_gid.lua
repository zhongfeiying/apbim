module(...,package.seeall)

local dlg_ = nil
local get_gid_ = nil

local function init_buttons()
	local wid = "100x"
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end 

local function init_controls()
	local wid = "300x"
	lab_gid_ = iup.label{title = "Copy Gid : ",rastersize = "100x"}
	--txt_gid_ = iup.text{rastersize = wid}
    --list_gid_ = iup.list{dropdown = "YES",EDITBOX = "YES", readonly = "YES", rastersize = wid}
	list_gid_ = iup.list{EDITBOX = "YES", readonly = "YES", rastersize = "300x20"}
	--list_gid_ = iup.text{rastersize = wid,expand = "HORIZONTAL",FORMATTING = "YES",SELECTEDTEXT  = "YES"}

end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			--iup.hbox{lab_gid_,txt_gid_};
			iup.hbox{lab_gid_,list_gid_};
			iup.hbox{btn_close_};
			alignment ="ARIGHT";
			margin = "10x10";
		};
		title = "Copy Gid";
		
	}
end 

local function init_callback()
	function btn_close_:action()
		dlg_:hide();
	end
end 

local function init_data()
	if get_gid_ then 
		list_gid_.value = get_gid_
	else 
		--txt_gid_.value = ""
		list_gid_.value = ""
	end
end 

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	init_data()
	dlg_:show()
end

local function show()
	init_data()
	dlg_:show()
end

function pop(str)
	get_gid_ = str
	if dlg_ then show() else init() end 
end