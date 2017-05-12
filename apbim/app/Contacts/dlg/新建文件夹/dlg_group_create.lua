
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"

local btn_ok_;
local btn_close_;
local lab_name_;
local txt_name_;
local frame_note_;
local txt_note_;
local tog_;

local dlg_ = nil

--arg = {Warning,set_data,Datas,TogTitle} --Datas 用来传入可能用到的数据比如是否编辑还是创建
function pop(arg)
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_close_ = iup.button{title = "Cancel",rastersize = wid}
		
	end 

	local function init_controls()
		local wid = "80x"
		lab_name_ = iup.label{title = "Group Name : ",rastersize = wid}
		txt_name_ = iup.text{rastersize = "400x",expand ="HORIZONTAL"}
		txt_note_ = iup.text{rastersize = "400x200",expand ="HORIZONTAL"}
		frame_note_ = iup.frame{
			txt_note_;
			title = "Note";
		}
		tog_ = iup.toggle{title = 'Invite Members',fontsize = 12,fgcolor = '0 0 255'}
		tog_.value = 'ON'
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_name_,txt_name_};
				iup.hbox{frame_note_};
				iup.hbox{tog_,iup.fill{},btn_ok_,btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Create Group";
			resize = "NO";
			--TOPMOST = "YES";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 
	
	local function get_data()
		local data = {}
		data.GroupName = txt_name_.value
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
		function btn_close_:action()
			dlg_:hide()
		end
		
	end 
	

	local function init_data()
		txt_name_.value = ''
		tog_.active = 'YES'
		if arg.Datas  then 
			txt_name_.value = arg.Datas.GroupName
			txt_note_.value = arg.Datas.Note
			tog_.value = 'OFF'
			tog_.active = 'NO'
		end
		data_ = nil
	end 

	local function init()

		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		init_data()
		dlg_:map()
		
		dlg_:popup()
	end 

	init()
end

