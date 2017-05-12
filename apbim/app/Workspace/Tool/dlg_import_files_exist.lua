module(...,package.seeall)

local dlg_ = nil
local cur_name_ = nil
local cur_select_ = nil

local function init_buttons()
	local wid = "100x"
	btn_no_ = iup.button{title = "No",rastersize = wid}
	btn_replace_ = iup.button{title = "Replace",rastersize = wid}
end
local function init_controls()
	lab_msg_ = iup.label{title = "File has been existed ! Whether do you want to replace it or not ?",expand = "HORIZONTAL",rastersize = "500x"}
	tog_all_ = iup.toggle{title = "Apply All",fontsize =12}
end
local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_msg_,iup.fill{}};
			iup.hbox{tog_all_,iup.fill{},btn_replace_,btn_no_};
			alingment = "ALEFT";
			margin = "10x10";
		};
		title = "File Exist";
	}
end
local function init_msg()
	function btn_replace_:action()
		cur_select_ = 1
		if tog_all_.value == "ON" then 
			cur_select_ = 2
		end 
		dlg_:hide()
	end
	function btn_no_:action()
		if tog_all_.value == "ON" then 
			cur_select_ = 3
		end 
		dlg_:hide()
	end
end
local function init_data()
	cur_select_ = nil
	if cur_name_ then 
		lab_msg_.title = cur_name_ .. " File has been existed ! Whether do you want to replace it or not ?"
	end 
end
local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:popup()
end

local function show()
	init_data()
	dlg_:popup()
end

function set_data(name)
	cur_name_ = name
end

function get_data()
	return cur_select_
end

function pop()
	if dlg_ then show() else init() end 
end