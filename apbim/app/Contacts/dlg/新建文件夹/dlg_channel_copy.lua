
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local btn_close_;
local lab_id_;
local list_id_;
local frame_id_;



local dlg_ = nil
local data_ = nil
local re_data_ = nil



function pop()
	local iup = require "iuplua"
	
	local function init_buttons()
		local wid = "100x"
		btn_close_ = iup.button{title = "Close",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_id_ = iup.label{title = "Channel Id : ",rastersize = wid}
		list_id_ = iup.list{READONLY = "yes",EDITBOX = "YES",DROPDOWN = "YES",expand = "HORIZONTAL",rastersize = "300x",VISIBLEITEMS  = 0}
		frame_id_ = iup.frame{
			iup.hbox{lab_id_,list_id_};
			margin = "10x10"
		};
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{frame_id_};
				iup.hbox{btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Copy Channel Id";
			resize = "NO";
			--TOPMOST = "YES";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function init_callback()
		function btn_close_:action()
			dlg_:hide()
		end
	end 
	
	

	local function init_data()
		list_id_.value = ''
		re_data_ = nil
		if data_ then 
			list_id_.value = data_.Gid
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
		dlg_:map()
		init_data()
		dlg_:popup()
	end 
	if dlg_ then show() else init() end 
end

function set_data(data)
	data_ = data
end

function get_data()
	return re_data_
end 
