module(...,package.seeall)
local dir="D:\\5.1\\docs\\"

local return_val_ = nil;
local tog_status_ = false

local function init_buttons()
	local wid = "70x"
	btn_replace_ = iup.button{title="Replace",rastersize=wid};
	btn_close_ = iup.button{title="Cancel",rastersize=wid};
	btn_leave_ = iup.button{title = "Leave",rastersize =wid}
end

local function init_controls()
	local txt_wid = "250x"
	local wid = "300x"
	lab_dir_ = iup.label{title = dir.." ".."is existed ,replace£¿",rastersize = wid}
	--txt_dir_ = iup.text{rastersize = txt_wid}
	tog_apply_ = iup.toggle{title = "Apply to all items",};
end


local function init_dlg()

	dlg_= iup.dialog{
		iup.frame{
			iup.vbox{
				--iup.hbox{lab_global_id_,txt_global_id_,gap = 10,},
				iup.hbox{lab_dir_,},
				iup.hbox{tog_apply_,iup.fill{}};
				iup.hbox{btn_replace_,iup.fill{},btn_leave_,iup.fill{},btn_close_,},
				alignment = "ARIGHT",
			},
		},
		title = "Warning",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end



function set_info(str)
   -- if  str  then iup.Message("Warning","Please enter dir !")  return end 
    dir=str
	--trace_out("pull file = " .. dir.. "\n");  
end

local function msg()


	function btn_replace_:action()
		--if not string.find(txt_dir_.value,"%S+") then iup.Message("Warning","Please enter dir !") return end 
		return_val_ = 2
		if tog_apply_.value == "ON" then 
			tog_status_ = true 
		end 
		dlg_:hide()
		
	end
	
	function btn_leave_:action()
		return_val_ = 1
		if tog_apply_.value == "ON" then 
			tog_status_ = true 
		end 
		dlg_:hide()
	end
	
	function btn_close_:action()
		return_val_ = 0
		if tog_apply_.value == "ON" then 
			tog_status_ = true 
		end 
		dlg_:hide()
	end
	
	function dlg_:close_cb()
		return_val_ = 0
		if tog_apply_.value == "ON" then 
			tog_status_ = true 
		end 
	    dlg_:hide()
	end
end

function get_info()	
	return return_val_,tog_status_
end

local function init_data()
	return_val_ = nil;
	tog_status_ = false
	if dir then 
		lab_dir_.title = dir .." ".."is existed ,replace£¿"
	end 
end 

local function show()
	--set_info();
	init_data()
	dlg_:popup() 
end


local function init() 
	init_buttons();
	--set_info();
	init_controls();
	init_dlg();
	msg();  
	init_data()
	dlg_:popup();
end


function pop()	
	if dlg_ then 
		show() 	
	else
		init()
	end
end



