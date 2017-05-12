
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local form_contact_ = require_files_.form_contact()
local controls_ = require "app.Contacts.dlg.form.controls"
local apx_tree_ = require_files_.apx_tree()

local btn_close_;
local btn_send_;
local btn_reply_;

local btn_file_;
local btn_project_;
local btn_view_;

local btn_flush_;

local btn_del_;
local btn_open_;
local btn_download_;

local btn_show_member_;

local dlg_ = nil

local txt_msg_;
local list_members_;
local frame_messages_;



local frame_send_;
local frame_members_;



local tab_attr_;

local lab_title_;
local list_attachment_;
local lab_reply_;
local lab_to_;

local txt_to_;
local txt_title_;
local txt_reply_;
local txt_text_;

local tree_messages_;





local bgcolor_ = "200 255 200"

--arg = {Type}
function pop(arg)
	local wid50 = '50x'
	local wid100 = '100x'
	local wid70 = '70x'
	local attachments = {}
	

	
	local function init_buttons()
		btn_close_ = controls_.get_btn_contorls{Title = "Cancel",Wid = wid100}
		btn_send_ =  controls_.get_btn_contorls{Title = "Send",Wid = wid100}
		btn_reply_ =  controls_.get_btn_contorls{Title = "Reply",Wid = wid100}
		btn_file_ =  controls_.get_btn_contorls{Title = "File",Wid = wid100,}
		btn_project_ =  controls_.get_btn_contorls{Title = "Project",Wid = wid100,}
		btn_view_ =  controls_.get_btn_contorls{Title = "View",Wid = wid100}
		btn_flush_ =  controls_.get_btn_contorls{Title = "Flush",Wid = wid100,Flat = 'YES',Expand = 'HORIZONTAL'}
		
		btn_del_ = controls_.get_btn_contorls{Title = "Delete",Wid = wid70,}
		btn_download_ = controls_.get_btn_contorls{Title = "Download",Wid = wid70,}
		btn_open_ = controls_.get_btn_contorls{Title = "Open",Wid = wid70,}
		
		btn_show_member_ = controls_.get_btn_contorls{Title = "Show Members",Wid = wid70,}
	end 
	
	local function init_controls()
		txt_msg_ = iup.text{WORDWRAP = "YES",MULTILINE="YES",rastersize = "400x350",expand = "YES",}
		lab_title_ = controls_.get_lab_contorls{Title = "Title : ",}
		txt_title_ = controls_.get_txt_contorls{Expand = 'HORIZONTAL'}
		
		matrix_attachment_ = iup.matrix{
			ReadOnly = 'YES',
			numlin = 10,
			NUMLIN_VISIBLE = 5,
			NUMCOL_VISIBLE = 2,
			numcol = 2,
			RASTERWIDTH1 = '40x';
			RASTERWIDTH2 = '400x';
			expand = 'YES';
			MARKMODE = 'LIN';
		}
		
		
		frame_attachment_ = iup.frame{
			iup.vbox{
				iup.hbox{
					iup.frame{
						iup.hbox{
						matrix_attachment_;
						iup.vbox{
							iup.fill{},
							btn_del_;
							iup.fill{},
							btn_download_;
							iup.fill{},
							btn_open_;
							iup.fill{},
						};
						};
					};
				};
				iup.hbox{btn_project_,btn_view_,btn_file_};
				margin = '0x0';
			};
			title ='Attachment';
		}
		
		frame_msg_ = iup.frame{
			txt_msg_;
			title = 'Content';
		}
		
		frame_send_ = iup.frame{
			iup.vbox{
				iup.hbox{lab_title_,txt_title_};
				iup.hbox{frame_attachment_};
				iup.hbox{frame_msg_};
				iup.hbox{iup.fill{},btn_reply_,btn_send_,btn_close_};
				alignment = 'ALEFT';
				margin = '0x5';
			};
			rastersize = 'x700';
		}
		
		tree_messages_ = apx_tree_.get_class():new()
		tree_messages_:set_datas(arg.Datas)
		tree_messages_:set_rastersize('300x650')
		frame_messages_ = iup.frame{
			tree_messages_:get_tree();
			bgcolor = bgcolor_;
		}
		
		
	end
	
	
	

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{
					frame_messages_;
					frame_send_;
				};
				alignment = "ARIGHT";
				margin = "5x5"
			};
			title = "Messsages";
			resize = "NO";
			--TOPMOST = "YES";
			expand = 'YES';
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 
	
	local function init_matrix_selected(lin,val)
		matrix_attachment_['mark' .. lin .. ':1'] = val
		matrix_attachment_['mark' .. lin .. ':2'] = val
		matrix_attachment_.redraw = 'all'
	end 

	local function init_callback()
		
		function btn_project_:action()
		--	local project = require 'sys.mgr'.get_
		end
		
		function btn_view_:action()
		end
		
		function btn_file_:action()
		end
		
		function btn_del_:action()
		end
		
		function btn_download_:action()
		end
		
		function btn_open_:action()
		end
		
		function btn_flush_:action()
		end
		
		function btn_reply_:action()
		end
		
		function btn_send_:action()
		end
		
		
		function btn_close_:action()
			dlg_:hide()
		end
		
		function matrix_attachment_:click_cb(lin,col,str)
			if string.find(str,'1') then 
				init_matrix_selected(lin,1)
			end 
		end
	end 
	
	local function init_matrix_head()
		matrix_attachment_:setcell(0,1,'Type')
		matrix_attachment_:setcell(0,2,'Name')
		matrix_attachment_.redraw = 'ALL'
		
	end
	
	local function init_matrix_data()
		
	end 

	local function init_data()
		init_matrix_head()
		init_matrix_data()
	end 

	local function init()

		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		dlg_:map()
		init_data()
		dlg_:show()
	end 

	init()
end

