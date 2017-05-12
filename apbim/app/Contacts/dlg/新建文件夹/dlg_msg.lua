
_ENV = module(...,ap.adv)

local dlg_ = nil
local data_ = nil
local channel_ = nil

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	lab_title_ = iup.label{title = "Title : ",}
	txt_title_ = iup.text{expand = "HORIZONTAL",rastersize = "200x"}
	txt_content_ = iup.text{expand = "YES",rastersize = "400x200"}
	txt_content_.MULTILINE="YES"
	txt_content_.WORDWRAP = "YES"
	frame_note_ = iup.frame{
		txt_content_;
		title = "Content";
	}

	tog_arrived_ = iup.toggle{title = "Arrived"}
	tog_read_ = iup.toggle{title = "Read"}
	tog_confirm_ = iup.toggle{title = "Confirm"}
	
	frame_tog_ = iup.frame{
		title = "Message Receipt";
		iup.hbox{iup.fill{},tog_arrived_,iup.fill{},tog_read_,iup.fill{},tog_confirm_,iup.fill{}};
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_title_,txt_title_};
			iup.hbox{frame_note_};
			iup.hbox{frame_tog_};
			iup.hbox{btn_ok_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "10x10"
		};
		title = "Send Messages";
		resize = "NO";
	}
end

local function deal_ok_action()
	data_ = {}
	data_.Title = txt_title_.value
	data_.Content = txt_content_.value
	if tog_arrived_.value == "ON" then 
		data_.Arrived = true
	end 
	if tog_read_.value == "ON" then 
		data_.Read = true
	end
	if tog_confirm_.value == "ON" then 
		data_.Confirm = true
	end
end

local function init_callback()
	function btn_ok_:action()
		if not string.find(txt_title_.value,"%S+") then 
			iup.Message("Warning","Title can not be empty !") 
			return
		end 
		if not string.find(txt_content_.value,"%S+") then 
			iup.Message("Warning","Content can not be empty !") 
			return
		end 
		deal_ok_action()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end
end

local function init_data()
	txt_title_.value = ""
	txt_content_.value = ""
	tog_arrived_.value = "ON"
	tog_read_.value = "ON"
	tog_confirm_.value = "ON"
	tog_arrived_.active = "YES"
	tog_read_.active = "YES"
	tog_confirm_.active = "YES"
	frame_tog_.active = "YES"
	if data_ then 
		txt_title_.value = data_.Title
		txt_content_.value = data_.Content
		tog_arrived_.value = data_.Arrived and "ON" or "OFF"
		tog_read_.value = data_.Read and "ON" or "OFF"
		tog_confirm_.value = data_.Confirm and "ON" or "OFF"
	end
	if channel_ then
		tog_arrived_.value = "OFF"
		tog_read_.value = "OFF"
		tog_confirm_.value = "OFF"
		tog_arrived_.active = "NO"
		tog_read_.active = "NO"
		tog_confirm_.active = "NO"
		frame_tog_.active = "NO"
	end
	data_ = nil
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

function pop(channel)
	channel_ = channel
	if dlg_ then show() else init() end 
end

function set_data(data)
	data_ = data
end

function get_data()
	return data_
end
