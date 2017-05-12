module(...,package.seeall)
require "iuplua"
local dlg_ = nil
local data_ = nil;

local function init_buttons()	
	local wid = "100x"
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end

local function init_controls()	
	local wid = "150x"
	local big_wid = "250x"
	lab_gid_ = iup.label{title = "Global ID : ",rastersize = wid}
	lab_associate_ = iup.label{title = "Associate Files : ",rastersize = wid}
	lab_branch_ = iup.label{title = "Branch Name : ",rastersize = wid}
	lab_com_ = iup.label{title = "Commit Message : ",rastersize = wid}
	lab_ver_ = iup.label{title = "Version : ",rastersize = wid}
	lab_name_ = iup.label{title = "Name : ",rastersize = wid}
	
	txt_gid_ = iup.text{rastersize = "200x",expand = "HORIZONTAL"}
	txt_associate_ = iup.text{rastersize = big_wid,expand = "HORIZONTAL"}
	txt_branch_ = iup.text{rastersize = big_wid,expand = "HORIZONTAL"}
	txt_com_ = iup.text{rastersize = big_wid,expand = "HORIZONTAL"}
	txt_ver_ = iup.text{rastersize = big_wid,expand = "HORIZONTAL"}
	txt_name_ = iup.text{rastersize = big_wid,expand = "HORIZONTAL"}
end

local function init_dlg()	
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_gid_,txt_gid_};
			iup.hbox{lab_name_,txt_name_};
			iup.hbox{lab_associate_,txt_associate_};
			iup.hbox{lab_branch_,txt_branch_};
			iup.hbox{lab_com_,txt_com_};
			iup.hbox{lab_ver_,txt_ver_};
			iup.hbox{btn_close_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Property";
		resize = "NO";
	}
end


local function init_callback()
	function btn_close_:action()
		dlg_:hide();
	end
end

local function init_val(tab)
	txt_gid_.value =( tab and  tab.gid ) or "";
	txt_name_.value =(tab and  tab.name) or ""
	txt_branch_.value = ( tab and  tab.branch ) or "";
	txt_com_.value = ( tab and  tab.msg ) or "";
	txt_ver_.value = ( tab and  tab.hid ) or "";
	txt_associate_.value = ( tab and  tab.local_link  )  or ""
	--[[list_associate_[1] = nil
	if  tab.local_link then 
		list_associate_[1] =  
		list_associate_.value = 1
	end--]]
	
end  

local function init_data()
	init_val()
	if not data_ then return end 
	init_val(data_)
end 

local function show()
	init_data()
	dlg_:popup()
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	init_data()
	dlg_:popup()
end

function set_data(db)
	data_ = db
end

function pop(tree,id)
	if dlg_ then show() else  init() end 
end




