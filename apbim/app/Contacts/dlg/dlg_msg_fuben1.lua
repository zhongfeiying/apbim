
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local form_contact_ = require_files_.form_contact()
local apx_tree_ = require_files_.apx_tree()

local btn_close_;
local btn_send_;
local btn_reply_;

local btn_file_;
local btn_project_;
local btn_view_;

local btn_flush_;

local dlg_ = nil

local frame_members_
local list_members_;

local zbox_member_;
local vbox_all_;


local txt_send_msg_;
local bgcolor_ = "200 255 200"

--arg = {Type}
function pop(arg)
	
	local function init_buttons()
		local wid = "100x"
		local small_wid = '50x'
		btn_close_ = iup.button{title = "Cancel",rastersize = wid}
		btn_send_ = iup.button{title = "Send",rastersize = wid}
		btn_reply_ = iup.button{title = "Reply",rastersize = wid}
		
		btn_file_ = iup.button{title = "File",rastersize = small_wid,FLAT= "YES"}
		btn_project_ = iup.button{title = "Project",rastersize = small_wid,FLAT= "YES"}
		btn_view_ = iup.button{title = "View",rastersize = small_wid,FLAT= "YES"}
		
		btn_flush_ = iup.button{title = "Flush",rastersize = small_wid,FLAT= "YES",expand = 'HORIZONTAL'}
	end 

	local function init_frame_member()
		
		local vbox_t = {}
		form_contact_.set(vbox_t,{Read = true,Attr = arg.Attr})
		local vbox_ = iup.vbox(vbox_t)
		vbox_.margin = '5x10';
		vbox_.alignment = 'ALEFT';
		frame_members_ = iup.frame{
			vbox_;
		}
	end
	
	local function init_frame_message()
		tree_messages_ = apx_tree_.get_class():new()
		tree_messages_:set_datas(arg.Datas)
		txt_send_msg_ = iup.text{WORDWRAP = "YES",MULTILINE="YES",rastersize = "400x100",expand = "YES",}
		local frame_messages_ = iup.frame{
			tree_messages_:get_tree();
			rastersize = "600x600";
			bgcolor = bgcolor_;	
		}
		vbox_all_ = iup.frame{
			iup.vbox{
				frame_messages_;
				iup.hbox{btn_file_;iup.label{SEPARATOR = "VERTICAL"},btn_project_;iup.label{SEPARATOR = "VERTICAL"},btn_view_;iup.label{SEPARATOR = "VERTICAL"},};
				txt_send_msg_;
				iup.hbox{iup.fill{},btn_reply_,btn_send_,btn_close_};
				alignment = 'ALEFT';
				margin = '0x0';
			};
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
			
		}
	end 
	
	local function init_controls()
		local wid = "50x"
		local txt_wid = "200x"
		init_frame_member()
		init_frame_message()
		init_frame_list()
		
		if arg.Type and arg.Type == 'Group' then 
			zbox_member_ = frame_list_
		elseif  arg.Type and arg.Type == 'Contact' then 
			zbox_member_ = frame_members_
		end 
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{
					vbox_all_;
					zbox_member_;
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
		dlg_:popup()
	end 

	init()
end
