
_ENV = module(...,ap.adv)
--module(...,package.seeall)
--package.cpath = "?.dll;?53.dll;" .. package.cpath
local lfs = require "lfs"
local file_op_ = require "app.workspace.ctr_require".file_op()
local workspace_ = require "app.workspace.ctr_require".Workspace()
require "iuplua"
require "iupluacontrols"

local dlg_ = nil
local sel_val_ = nil
local status_ = nil
local function init_buttons()
	local wid = "100x"
	btn_open_ = iup.button{title = "Open",rastersize = wid}
	btn_cancel_ = iup.button{title = "Close",rastersize = wid}
	btn_sel_path_ = iup.button{title = " . . . ",rastersize = "50x"}
end

local function init_controls()
	local wid = "100x"
	lab_path_ = iup.label{title = "Project Path : ",rastersize =wid}
	txt_path_ = iup.text{expand = "HORIZONTAL",active = "NO"}

	list_pro_ = iup.list{rastersize = "500x400"}
	frame_list_ = iup.frame{
		list_pro_;
		title = "Project List";
	}

	filedlg_dir_ = iup.filedlg{
		rastersize= "800x800";
		SHOWPREVIEW = "yes";
		NOCHANGEDIR = "yes";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_path_,txt_path_,btn_sel_path_};
			iup.hbox{frame_list_};
			iup.hbox{btn_open_,btn_cancel_};
			alignment = "ARIGHT";
			MARGIN = "10X10";
		};
		title = "Open Project";
		resize = "NO";
		--topmost = "YES";
	}
end


local function insert_list_data(path_)
	list_pro_[1] = nil
	for line in lfs.dir(path_) do
		local attr = lfs.attributes(path_ .. line)
		--trace_out("line = " .. line .. "\n")
		if attr.mode == "file" then 
			if string.sub(line,-4,-1) == ".apc" then 
				list_pro_.APPENDITEM = line
			end
		end 
	end
end

local function deal_open_msg(item)
	if not list_pro_.value or tonumber(list_pro_.value) == 0  then 
		iup.Message("Warning","Please select a project file to open !")
		return 
	end	
	sel_val_ = txt_path_.value .. list_pro_[list_pro_.value]
	local file = require "sys.mgr.model".get_zipfile() 
	if file and file == sel_val_ then 
		return 
	end 
	--workspace_.set_cur_zip_file(sel_val_)
	workspace_.change_pro(sel_val_,"new")
	file_op_.del_file_read_attr("ProjectsPath.lua")
	local file = io.open("ProjectsPath.lua","w+")
	file:write("path_ = \"" .. string.gsub(txt_path_.value,"\\","/") .. "\"\n")
	file:close()
	dlg_:hide()
end

local function init_msg()
	local save_sel_item_ = nil
	function btn_open_:action()
		deal_open_msg()
	end

	function btn_cancel_:action()
		dlg_:hide();
	end

	function btn_sel_path_:action()
		filedlg_dir_.dialogtype = "DIR"
		filedlg_dir_:popup()
		local filepath = filedlg_dir_.value
		if filepath and filepath ~= "\\" then 
			if string.sub(filepath,-1,-1) ~= "\\" then 
				filepath = filepath .. "\\"
			end
			txt_path_.value = filepath
			insert_list_data(filepath)
		end
	end

	function list_pro_:action(text,item,state)
		if state == 1 then 
			save_sel_item_ = tonumber(item)
		end
	end

	function list_pro_:button_cb(button,pressed,x,y,status)
		if not save_sel_item_ then return end 
		if string.find(status,"1") and string.find(status,"D") then
			deal_open_msg(save_sel_item_)
		end
	end
end


local function init_data()
	list_pro_[1] = nil
	sel_val_ = nil
	local path_ = file_op_.get_bca_save_path()	
	if not path_ then return end
	txt_path_.value =  path_ or ""
	if string.sub(path_,-1,-1) ~= "\\" then 
		path_ = path_ .."\\"
	end
	insert_list_data(path_)
end


local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	dlg_:map()
	init_data()
	dlg_:popup()
end


local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end

function pop(status)
	status_ = status
	if dlg_ then show() else init() end 
end

function set_data()
	
end


function get_data()
	return sel_val_
end
--pop()
