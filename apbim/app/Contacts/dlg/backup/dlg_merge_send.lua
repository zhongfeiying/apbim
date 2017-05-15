
_ENV = module(...,ap.adv)
 
local ctr_require_ = require "app.Contacts.require_files"
local dlg_import_files_ = ctr_require_.dlg_import_files()
local dlg_ = nil
local data_ = nil
local files_data_ = nil
local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	local wid = 14
	tog_msg_ = iup.toggle{title = "Messages",fontsize = wid}
	tog_view_ = iup.toggle{title = "View",fontsize =wid}
	tog_sel_ = iup.toggle{title = "Selected",fontsize = wid}
	tog_files_ = iup.toggle{title = "Files",fontsize = wid}
	frame_tog_ = iup.frame{
		iup.hbox{
			iup.fill{};
			iup.vbox{
				iup.fill{};
				tog_msg_;
				iup.fill{};
				tog_view_;
				iup.fill{};
				tog_sel_;
				iup.fill{};
				tog_files_;
				iup.fill{};
			};
			iup.fill{};
		};
		title = "Send";
		rastersize = "300x300";
		expand = "YES";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_tog_};
			iup.hbox{btn_ok_,btn_cancel_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Select files";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
end

local function table_is_empty(t)
	return _G.next(t) == nil
end

local function deal_ok_action()
	data_ = {}
	if tog_msg_.value == "ON" then 
		data_.Msg = true
	end
	if tog_view_.value == "ON" then 
		data_.View = true
	end
	if tog_sel_.value == "ON" then 
		data_.Selected = true
	end
	if tog_files_.value == "ON" then 
		data_.Files = files_data_
	end
end

local function init_callback()
	
	function tog_files_:valuechanged_cb()
		if self.value == "ON" then
			dlg_import_files_.set_data(files_data_)
			dlg_import_files_.pop()
			local data = dlg_import_files_.get_data()
			if data then
				files_data_ = data
			end
		end
	end

	function tog_view_:valuechanged_cb()
		if self.value == "ON" then 
			local sc = require "sys.mgr".get_cur_scene()
			if not sc then 
				iup.Message("Warning","Please open a view !")
				self.value = "OFF"
			end
		end
	end
	
	function tog_sel_:valuechanged_cb()
		if self.value == "ON" then 
			local curs = require "sys.mgr".curs()
			if not curs or table_is_empty(curs) then 
				iup.Message("Warning","Please select members !")
				self.value = "OFF"
			end
		end
	end

	function btn_ok_:action()
		deal_ok_action()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end

end

local function init_tog()
	tog_msg_.value = "OFF"
	tog_view_.value = "OFF"
	tog_sel_.value = "OFF"
	tog_files_.value = "OFF"
end

local function init_data()
	init_tog()
	data_ = nil
	files_data_ = nil
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

function pop()
	if dlg_ then show() else init() end
end

function set_data(data)
	data_ = data
end

function get_data()
	return data_
end

