module(...,package.seeall)

local download_file_ = nil

local function init_buttons()
	btn_add_ = iup.button{title="OK",rastersize="80x30"};
	btn_close_ = iup.button{title="Cancel",rastersize="80x30"};
end

local function init_controls()
	lab_download_id_ = iup.label{title = "Id :",rastersize = "70x"}
	txt_download_id_ = iup.text{rastersize = "400x"}
end

local function init_dlg()

	dlg_= iup.dialog{
		iup.frame{
			iup.vbox{
				iup.hbox{lab_download_id_,txt_download_id_,gap = 10,},
			   iup.hbox{btn_add_,btn_close_},
				alignment = "ARIGHT",
			},
		},
		title = "Download Files",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end	


local function msg()
	function btn_add_:action()
		if not string.find(download_file_.value,"%S+") then return end 
		download_file_ = txt_download_id_.value
		dlg_:hide()
	end
	function btn_close_:action()
		dlg_:hide()
	end
end

local function init_data()
	if download_file_ then 
		txt_download_id_.value = download_file_
	end 
	download_file_ = nil
end

local function show()
	init_data()
	dlg_:popup() 
end


local function init() 
	init_buttons();
	init_controls();
	init_dlg();
	init_data()
	msg();
	dlg_:popup();
end


function return_gid()
	local str = "simple"
	if radio_import_.value == tog_all_ then 
		str = "all"
	end 
	return get_gid_,str
end

function pop()	
	if dlg_ then 
		show() 
	else
		init()
	end
end

function set_data(str)
	download_hid_ = str
end