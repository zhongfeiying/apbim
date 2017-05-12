module(...,package.seeall)
require "iuplua"
local dlg_ = nil
local return_tab_ = {}
local cur_path_ = nil
local lab_str_ = "Notice : Data collisions ! what would it be ? "
local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
end

local function init_controls()
	
	lab_notice_ = iup.label{title = lab_str_,expand = "HORIZONTAL",fgcolor = "255 0 0",fontsize = 12}
	tog_reset_dir_ = iup.toggle{title = "Reset the directory !"}
	tog_retain_ = iup.toggle{title = "Retain the original data (replace the same file name) ! "} --保留原有数据，如果下载到的文件名称与原有的文件名称一致替换
	tog_cancel_ = iup.toggle{title = "Cancel to update current folder !"}
	
	tog_all_ = iup.toggle{title = "Apply to all ! ",fontsize = 12}
	
	radio_select_ = iup.radio{
		iup.vbox{
			iup.fill{};
			iup.hbox{tog_reset_dir_};
			iup.fill{};
			iup.hbox{tog_retain_};
			iup.fill{};
			iup.hbox{tog_cancel_};
			iup.fill{};
		};
		value = tog_reset_dir_;
	}
	frame_radio_ = iup.frame{
		radio_select_;
		rastersize = "300x";
		title = "Select Operation";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_notice_};
			iup.hbox{iup.fill{},frame_radio_,iup.fill{}};
			iup.hbox{
				--tog_all_;
				iup.fill{};
				btn_ok_;
			};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Update Warning";
		resize = "NO";
	}
end

local function init_msg()
	function btn_ok_:action()
		if radio_select_.value == tog_reset_dir_ then 
			return_tab_.select = 1
		elseif radio_select_.value == tog_retain_ then
			return_tab_.select = 2
		elseif radio_select_.value == tog_cancel_ then 
			return_tab_.select = 3
		end
		if tog_all_.value == "ON" then 
			return_tab_.apply_all = true
		end 
		dlg_:hide()
	end
	
	function dlg_:close_cb()
		return_tab_.select = 3
	end
	
end

local function init_data()
	tog_all_.value = "ON"
	radio_select_.value = tog_reset_dir_
	return_tab_ = {}
	if cur_path_ then 
		lab_notice_.title = "The data of folder  (" .. string.gsub(cur_path_,"/","\\") .. ")  collisions ! what would it be ? "
	end 
end


local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:popup()
end

local function show()
	init_data()
	dlg_:popup()
end

function pop()
	if dlg_ then show() else init() end 
end

function return_db()
	return return_tab_
end

function set_data(path)
	cur_path_ = path
end