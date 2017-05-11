module(...,package.seeall)

local get_gid_ = nil
local function init_buttons()
	add_btn = iup.button{title="OK",rastersize="80x30"};
	close_btn = iup.button{title="Cancel",rastersize="80x30"};
end

local function init_controls()
	lab_global_id_ = iup.label{title = "Id :",rastersize = "70x"}
	txt_global_id_ = iup.text{rastersize = "400x"}
	
	tog_simple_ = iup.toggle{title = "Simple",}
	tog_all_ = iup.toggle{title = "All",}
	lab_import_ = iup.label{title = "Import : ",}
	lab_warning_ = iup.label{title = "",expand = "HORIZONTAL",fgcolor = "255 0 0"}
	radio_import_ = iup.radio{
		iup.hbox{
			lab_import_;
			tog_simple_;
			tog_all_;
			lab_warning_;
		};
		--title = "Import";
		value = tog_simple_;
	}
end

local function init_dlg()

	dlg_= iup.dialog{
		iup.frame{
			iup.vbox{
				iup.hbox{lab_global_id_,txt_global_id_,gap = 10,},
				--iup.hbox{lab_warning_},
			   iup.hbox{radio_import_,iup.fill{},add_btn,close_btn},
				--iup.hbox{lab_warning_,iup.fill{},add_btn,close_btn},
				alignment = "ALEFT",
			},
		},
		title = "Import ID",
		resize = "NO", 
		margin="10x10",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end	


local function msg()
	function add_btn:action()
		if not string.find(txt_global_id_.value,"%S+") then return end 
		get_gid_ = txt_global_id_.value
		dlg_:hide()
	end
	
	function close_btn:action()
		dlg_:hide()
	end
	function txt_global_id_:valuechanged_cb()
		if #txt_global_id_.value == 23 or #txt_global_id_.value == 41 or #txt_global_id_.value == 0 then 
			lab_warning_.title = ""
			add_btn.active = "Yes"
		else 
			lab_warning_.title = "Warning: Id input error!"
			add_btn.active = "NO"
		end 
	end 
	
end

local function init_data()
	get_gid_ = nil
	txt_global_id_.value = "";
	add_btn.active = "NO"
	lab_warning_.title = ""
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
