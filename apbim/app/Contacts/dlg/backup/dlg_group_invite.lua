_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local op_rmenu_ = require_files_.op_rmenu()
local btn_accept_;
local btn_refuse_;
local btn_hang_;
local frame_lab_;
local lab_seprator_;
local lab_alarm_;

--arg = {DlgTitle = ,DlgMsg =,GroupName = ,Groupid=,accept_invite,hang_invite,refuse_invite}
function pop(arg,func)
	local iup = require "iuplua"
	
	local function init_buttons()
		local wid = "100x"
		btn_accept_ = iup.button{title = "Accept",rastersize = wid}
		btn_refuse_ = iup.button{title = "Refuse",rastersize = wid}
		btn_hang_ = iup.button{title = "Hang",rastersize = wid}
	end 

	local function init_controls()
		local wid = "100x"
		lab_alarm_ = iup.label{title = 'Alarm msg :',rastersize = "400x20",ALIGNMENT ="ALEFT",WORDWRAP="YES",expand = 'VERTICAL'}
		lab_alarm_.title = arg.DlgMsg or lab_alarm_.title
		lab_seprator_ = iup.label{SEPARATOR = "HORIZONTAL",expand = "HORIZONTAL"}
		frame_lab_ = iup.frame{
			--lab_alarm_;
			bgcolor = "255 255 255";
		}
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_alarm_};
				iup.hbox{lab_seprator_};
				iup.hbox{iup.fill{},btn_accept_,iup.fill{},btn_refuse_,iup.fill{}};
				alignment = "ARIGHT";
				margin = "10x5"
			};
			title = "Alarm";
			resize = "NO";
			--TOPMOST = "YES";
			STARTFOCUS = btn_accept_;
		}
		dlg_.title = arg.DlgTitle or dlg_.title
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function init_callback()
		function btn_accept_:action()
			if func and type(func.accept_invite) == 'function' then 
				func.accept_invite(arg)
			end 
			dlg_:hide()
		end
		
		
		function btn_refuse_:action()
			if func and  type(func.refuse_invite) == 'function' then 
				func.refuse_invite(arg)
			end
			dlg_:hide()
		end
		
		function dlg_:close_cb()
			return iup.IGNORE
		end
	end 


	local function init()

		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		dlg_:showxy(iup.RIGHT,iup.BOTTOM)
	end 
 
	init()
end

