
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
	

	
	local function init_buttons()
		btn_close_ = controls_.get_btn_contorls{Title = "Cancel",Wid = wid100}
		btn_send_ =  controls_.get_btn_contorls{Title = "Send",Wid = wid100}
		btn_reply_ =  controls_.get_btn_contorls{Title = "Reply",Wid = wid100}
		btn_file_ =  controls_.get_btn_contorls{Title = "File",Wid = wid100,Flat = 'YES'}
		btn_project_ =  controls_.get_btn_contorls{Title = "Project",Wid = wid100,Flat = 'YES'}
		btn_view_ =  controls_.get_btn_contorls{Title = "View",Wid = wid100,Flat = 'YES'}
		btn_flush_ =  controls_.get_btn_contorls{Title = "Flush",Wid = wid100,Flat = 'YES',Expand = 'HORIZONTAL'}
		
		btn_del_ = controls_.get_btn_contorls{Title = "Del",Wid = wid50,}
	end 
	
	local function init_frame_send()
		
		
		frame_send_ = iup.frame{
			iup.vbox{
				iup.hbox{btn_file_;iup.label{SEPARATOR = "VERTICAL"},btn_project_;iup.label{SEPARATOR = "VERTICAL"},btn_view_;iup.label{SEPARATOR = "VERTICAL"},iup.fill{},iup.label{SEPARATOR = "VERTICAL"},btn_expanded_};
				txt_send_msg_;
				iup.hbox{iup.fill{},btn_reply_,btn_send_,btn_close_};
				alignment = 'ALEFT';
				margin = '0x0';
			};
		}
	end
	
	local function init_controls()
		txt_msg_ = iup.text{WORDWRAP = "YES",MULTILINE="YES",rastersize = "400x400",expand = "YES",}
		lab_title_ = controls_.get_lab_contorls{Title = "Title",Wid = wid100,}
		txt_title_ = controls_.get_txt_contorls{Expand = 'HORIZONTAL'}
		
		matrix_attachment_ = iup.matrix{
			ReadOnly = 'YES',
			numlin = 5,
			NUMLIN_VISIBLE = 5,
			NUMCOL_VISIBLE = 2,
			numcol = 2,
			RASTERWIDTH1 = '40x';
			RASTERWIDTH2 = '200x';
		}
		frame_attachment_ = iup.frame{
			iup.vbox{
				iup.hbox{
					matrix_attachment_;
					iup.vbox{
						btn_del_;
					};
				};
				iup.hbox{btn_project_,btn_view_,btn_file_};
				margin = '0x0';
			};
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
			};
		}
		
	end

	local function init_frame_member()
		
		local vbox_t = {}
		form_contact_.set(vbox_t,{Read = true,Attr = arg.Attr})
		local vbox_ = iup.vbox(vbox_t)
		vbox_.margin = '5x10';
		vbox_.alignment = 'ALEFT';
		frame_members_ = iup.frame{
			vbox_;
			tabtitle = '';
		}
	end
	
	local function init_frame_message()
		tree_messages_ = apx_tree_.get_class():new()
		tree_messages_:set_datas(arg.Datas)
		
		frame_messages_ = iup.frame{
			tree_messages_:get_tree();
			rastersize = "300x600";
			bgcolor = bgcolor_;
		}
		
	end
	
	local function init_frame_list()
		local t = arg.Members or {}
		t.rastersize = '200x'
		t.expand = 'YES'
		list_members_ = iup.list(t)
		frame_list_ = iup.frame{
			iup.vbox{
				list_members_;
				btn_flush_;
				margin = '0x0';
				alignment = 'ALEFT';
			};
			title = 'Group Members';
			tabtitle = 'Contact';
		}
	end 
	
	
	
	local function get_text_controls(title)
		return iup.text{title,rastersize = wid100,expand = 'HORIZONTAL'}
	end
	
	local function init_controls()
		local wid100 = "50x"
		local txt_wid = "200x"
		
		lab_to_ = iup.label{title = 'Send To : ',rastersize = wid100}
		txt_to_ = get_text_controls('Send To : ') 
		
		init_frame_member()
		init_frame_message()
		init_frame_list()
		
		if arg.Type and arg.Type == 'Group' then 
			zbox_member_ = frame_list_
		elseif  arg.Type and arg.Type == 'Contact' then 
			zbox_member_ = frame_members_
		end 
		-- tab_ = iup.tabs{
			-- zbox_member_;
		-- }
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{
					frame_messages_;
					frame_send_;
				};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = "Messsages";
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
