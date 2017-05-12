_ENV = module(...,ap.adv)

local wid = wid or "80x"
local txt_wid = txt_wid or '200x'
local	lab_new_name_;
local	txt_new_name_;
local	txt_note_;
local	lab_phone_;
local	txt_phone_;
local	lab_mail_;
local	txt_mail_;
local	frame_note_;

local function init_controls()
	lab_new_name_ = iup.label{title = "Name : ",rastersize = wid}
	txt_new_name_ = iup.text{rastersize = txt_wid,expand ="HORIZONTAL"}
	txt_note_ = iup.text{expand = "YES",rastersize = "400x200"}
	txt_note_.MULTILINE="YES"
	txt_note_.WORDWRAP = "YES"
	lab_phone_ = iup.label{title = "Phone : ",rastersize = wid}
	txt_phone_ = iup.text{expand = "HORIZONTAL",rastersize = txt_wid}
	lab_mail_ = iup.label{title = "E-Mail : ",rastersize = wid}
	txt_mail_ = iup.text{expand = "HORIZONTAL",rastersize = txt_wid}
	frame_note_ = iup.frame{
		txt_note_;
		title = "Note";
	}
end


function set(vbox,data)
	init_controls()
	
	table.insert(vbox,iup.hbox{lab_new_name_,txt_new_name_})
	table.insert(vbox,iup.hbox{lab_phone_,txt_phone_})
	table.insert(vbox,iup.hbox{lab_mail_,txt_mail_})
	table.insert(vbox,iup.hbox{frame_note_,frame_note_})
	if data and data.Attr then 	
		txt_new_name_.value = data.Attr.Name or ''
		txt_phone_.value = data.Attr.Phone or ''
		txt_mail_.value = data.Attr.Mail or ''
		txt_note_.value = data.Attr.Note or ''
	end 
	
	if data and data.Read then 
		txt_new_name_.READONLY = 'YES'
		txt_phone_.READONLY = 'YES'
		txt_mail_.READONLY = 'YES'
		txt_note_.READONLY = 'YES'
	end 
end

function get()
	local data =  {}
	data.Name = txt_new_name_.value
	data.Phone = txt_phone_.value
	data.Mail = txt_mail_.value
	data.Note = txt_note_.value
	return data
end

function init_name()
	txt_new_name_.value = ''
	iup.SetFocus(txt_new_name_)
end