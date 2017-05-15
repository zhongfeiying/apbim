
_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"

local btn_ok_;
local btn_close_;
local btn_turn_left_;
local btn_turn_right_;

local lab_name_;
local txt_name_;
local list_friends_;
local list_group_member_;
local list_groups_;
local frame_contacts_;
local frame_group_;
local frame_;


local dlg_ = nil

--arg = {set_data,Datas,DlgTitle}
function pop(arg)
	local save_group_txt_ = nil
	local save_friend_txt_= nil
	local save_friend_item_= nil
	local save_send_txt_ = nil
	local save_send_item_ = nil
	local invite_members_ = {}
	local contacts_data_ = arg.Datas
	
	local function init_buttons()
		local wid = "100x"
		btn_ok_ = iup.button{title = "Ok",rastersize = wid}
		btn_close_ = iup.button{title = "Cancel",rastersize = wid}
		btn_add_ = iup.button{title = "Add",rastersize = '50x'}
		
		btn_turn_left_ = iup.button{rastersize = "50x"}
		iup.SetAttribute(btn_turn_left_,"IMAGE","IUP_ArrowLeft")
		
		btn_turn_right_ = iup.button{rastersize = "50x"}
		iup.SetAttribute(btn_turn_right_,"IMAGE","IUP_ArrowRight")
	end 

	local function init_controls()
		local wid = "80x"
		list_friends_ = iup.list{}
		list_friends_.rastersize = "200x300"
		list_friends_.expand = "YES"
		list_group_member_ = iup.list{}
		list_group_member_.rastersize = "200x300"
		list_group_member_.expand = "YES"
		list_groups_ = iup.list{dropdown = "YES",expand = "HORIZONTAL"}

		frame_contacts_ = iup.frame{
			iup.vbox{
				iup.hbox{list_groups_;};
				list_friends_;
				margin = "0x0";
			};
			title = "Contact List";
		}

		frame_group_ = iup.frame{
			iup.vbox{
				list_group_member_;
				margin = "0x0";
			};
			title = "Set Group Members";
		}
		
		frame_ = iup.frame{
			iup.hbox{
				frame_contacts_;
				iup.vbox{
					iup.fill{};
					btn_turn_right_;
					iup.fill{};
					btn_turn_left_;
					iup.fill{};
				};
				frame_group_;
			};
			--SUNKEN = "YES";
			margin = "0x2";
		};
		
		lab_name_ = iup.label{title = 'Name : ',rastersize = wid}
		txt_name_ = iup.text{expand = 'HORIZONTAL'}
	end

	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{lab_name_,txt_name_,btn_add_};
				iup.hbox{frame_};
				iup.hbox{btn_ok_,btn_close_};
				alignment = "ARIGHT";
				margin = "10x10"
			};
			title = arg.DlgTitle or "Invite Members";
			resize = "NO";
			--TOPMOST = "YES";
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 

	local function  deal_ok()
		local Members = {}
		return Members
	end
	
	local function init_friends_list()
		list_friends_[1] = nil
		local t =  contacts_data_[list_groups_[list_groups_.value]]
		for k,v in pairs (t) do 
			if not invite_members_[k] then 
				list_friends_.APPENDITEM = k
			end 
		end
	end
	
	local function deal_turn_right(item,txt)
		if invite_members_[txt] then iup.Message("Notice","It has been exist !") return end 
		invite_members_[txt] = true
		list_group_member_.APPENDITEM = txt
		list_friends_.REMOVEITEM = item
	end


	local function deal_turn_left(item,txt)
		if invite_members_[txt] then invite_members_[txt] = nil end 
		list_group_member_.REMOVEITEM = item
		init_friends_list()
	end

	local function init_callback()
	
		function btn_add_:action()
			local str = txt_name_.value
			if string.find(str,"%S+") and not invite_members_[str] then
				invite_members_[str] = true
				list_group_member_.APPENDITEM = str
			end 
			txt_name_.value = ''
			iup.SetFocus(txt_name_)
		end
		
		function btn_ok_:action()
			if arg and  type(arg.set_data) == 'function' then 
				arg.set_data(invite_members_)
			end 
			dlg_:hide()
		end
		function btn_close_:action()
			dlg_:hide()
		end
		
		function list_groups_:action(txt,item,state)
			if state == 1 then 
				
				if save_group_txt_ and save_group_txt_ == txt then return end 
				save_group_txt_ = txt
				init_friends_list()
				save_friend_txt_ = nil
				save_friend_item_ = nil
			end 
		end
		
		function list_friends_:action(txt,item,state)
			if state == 1 then 
				save_friend_txt_ = txt
				save_friend_item_ = tonumber(item)
			end 
		end

		function list_group_member_:action(txt,item,state)
			if state == 1 then 
				save_send_txt_ = txt
				save_send_item_ = tonumber(item)
			end 
			
		end

		function btn_turn_right_:action()
			if not save_friend_item_ then return end 
			deal_turn_right(save_friend_item_,save_friend_txt_)
			save_friend_txt_ = nil
			save_friend_item_ = nil
		end

		function btn_turn_left_:action()
			if not save_send_item_ then return end
			deal_turn_left(save_send_item_,save_send_txt_)
			save_send_txt_ = nil
			save_send_item_ = nil
		end

		function list_friends_:button_cb(button, pressed, x, y, str)
			if string.find(str,"D") and string.find(str,"1") then 
				if not save_friend_item_ then return end 
				deal_turn_right(save_friend_item_,save_friend_txt_)
				save_friend_txt_ = nil
				save_friend_item_ = nil
			end 
		end


		function list_group_member_:button_cb(button, pressed, x, y, str)
			if string.find(str,"D") and string.find(str,"1") then 
				if not save_send_item_ then return end 
				deal_turn_left(save_send_item_,save_send_txt_)
				save_send_item_ = nil
				save_send_txt_ = nil
			end 
		end
	end 
	
	local function init_list_groups()
		for k,v in ipairs (contacts_data_) do 
			list_groups_.APPENDITEM = v
		end 
	end 
	
	local function init_list()
		list_friends_[1] = nil
		list_group_member_[1] = nil
		list_groups_[1] = nil
		init_list_groups()
		list_groups_.value= 1
		init_friends_list()
	end

	local function init_data()
		txt_name_.value = ''
		init_list()
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

