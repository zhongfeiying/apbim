_ENV = module(...,ap.adv)

local btn_ok_;
local btn_close_;
local lab_new_name_;
local txt_new_name_;
local txt_note_;
local lab_phone_;
local txt_phone_;
local lab_mail_;
local txt_mail_;
local frame_note_;
local lab_group_;
local list_group_;

local dlg_ = nil

--arg = {Datas,get_data,warning}
function pop(arg)
	
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_close_ = iup.button{title = "Close",rastersize = wid}
	end 

	local function init_controls()
		local wid = "80x"
		lab_new_name_ = iup.label{title = "Name : ",rastersize = wid}
		txt_new_name_ = iup.text{rastersize = "200x",expand ="HORIZONTAL"}
		txt_note_ = iup.text{expand = "YES",rastersize = "400x200"}
		txt_note_.MULTILINE="YES"
		txt_note_.WORDWRAP = "YES"
		lab_phone_ = iup.label{title = "Phone : ",rastersize = wid}
		txt_phone_ = iup.text{expand = "HORIZONTAL",rastersize = "200x"}
		lab_mail_ = iup.label{title = "E-Mail : ",rastersize = wid}
		txt_mail_ = iup.text{expand = "HORIZONTAL",rastersize = "200x"}
		frame_note_ = iup.frame{
			txt_note_;
			title = "Note";
		}
		--lab_group_ = iup.label{title = "Group : "}
		--list_group_ = iup.list{expand = "HORIZONTAL",dropdown = "YES",rastersize = "200x"}
	end 

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				--iup.hbox{lab_group_,list_group_};
				iup.hbox{lab_new_name_,txt_new_name_};
				iup.hbox{lab_phone_,txt_phone_};
				iup.hbox{lab_mail_,txt_mail_};
				iup.hbox{frame_note_};
				iup.hbox{btn_ok_,btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Add Contact";
			resize = "NO";
		}
	end 
	
	local function init_val(arg)
		txt_new_name_.value = arg and arg.Name or ""
		txt_note_.value = arg and arg.Note or ""
		txt_phone_.value = arg and  arg.Phone or ""
		txt_mail_.value = arg and arg.Mail or ""
	end 

	local function  deal_ok()
		local data = {}
		data.Name = txt_new_name_.value
		data.Note = txt_note_.value
		data.Phone = txt_phone_.value
		data.Mail = txt_mail_.value
		data.Time = arg and arg.Datas and arg.Datas.Time or os.time()
		return data
	end

	local function init_callback()
		function btn_ok_:action()
			if not string.find(txt_new_name_.value,"%S+") then return end 
			if arg.Warning and arg.Warning(txt_new_name_.value) then
				txt_new_name_.value = ''
				iup.SetFocus(txt_new_name_)
				return 
			end 
			
			if arg and  type(arg.set_data) == 'function' then 
				local data = deal_ok()
				arg.set_data(data)
			end 
			dlg_:hide()
		end
		
		function btn_close_:action()
			dlg_:hide()
		end
		
		--function dlg_:close_cb()
			--iup.Destroy(self)
			--dlg_ = nil
		--end
	end 

	local function init_data()
		
		txt_new_name_.active = "YES"
		lab_new_name_.active = "YES"
	--	if arg.Datas then 
		--	txt_new_name_.active = "NO"
		--	lab_new_name_.active = "NO"
	--	end 
		init_val(arg.Datas)
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
	
	init()

end
