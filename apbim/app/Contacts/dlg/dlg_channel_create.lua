_ENV = module(...,ap.adv)


local btn_ok_;
local btn_cancel_;


local lab_name_;
local txt_name_;
local frame_note_;
local txt_note_;
local tog_;

local dlg_ = nil


--arg = {set_data,Warning,Datas}
function pop(arg)
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_name_ = iup.label{title = "Name : ",rastersize ="50x"}
		txt_name_ = iup.text{rastersize = "300x",expand = "HORIZONTAL"}
		
		txt_note_ =  iup.text{rastersize = "200x200",expand = "HORIZONTAL",MULTILINE="YES",WORDWRAP= "YES"}
		frame_note_ = iup.frame{
			txt_note_;
			title = "Note";
		}
		
		tog_ = iup.toggle{title = "Subscribe"}
		tog_.value = "ON"
	end 

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_name_,txt_name_};
				iup.hbox{frame_note_};
				iup.hbox{tog_,iup.fill{},btn_ok_,btn_cancel_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Create Channel";
			resize = "NO";
		}
	end 

	local function get_data()
		local data = {}
		data.ChannelName = txt_name_.value
		data.Note = txt_note_.value
		data.Time = os.time()
		return data
	end

	local function init_callback()
		function btn_ok_:action()
			local str = txt_name_.value
			if not string.find(str,"%S+") then return end 
			if arg.Warning and arg.Warning(str) then
				txt_name_.value = ''
				iup.SetFocus(txt_name_)
				return 
			end 
			if arg and  type(arg.set_data) == 'function' then 
				arg.set_data(get_data(),tog_.value)
			end 
			dlg_:hide()
		end 
		
		function btn_cancel_:action()
			dlg_:hide()
		end
	end 

	local function init_data()
		txt_name_.value = ''
		txt_note_.value = ''
		if arg.Datas  then 
			txt_name_.value = arg.Datas.ChannelName
			txt_note_.value = arg.Datas.Note
			if arg.Datas.Subscribe then 
				tog_.value = 'ON'
			else 
				tog_.value = 'OFF'
			end
		end
	end 



	local function init()
		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		init_data()
		dlg_:popup()
	end 
	
	init() 
end



