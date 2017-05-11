module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil;
local title_ = nil;
local msg_ = nil;


local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end 

local function init_controls()
	local wid = "100x"
	lab_title_ = iup.label{title = "Tittle :",rastersize = "50x"}
	txt_title_ =  iup.text{expand = "HORIZONTAL",}
	lab_notice_ = iup.label{title = " ( Less than 10 characters. )"}
	txt_msg_ =  iup.text{expand = "HORIZONTAL",rastersize = "500x200",MULTILINE="YES",WORDWRAP = "YES"}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_title_,txt_title_,lab_notice_};
			iup.hbox{txt_msg_};
			iup.hbox{btn_ok_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Version";
		--rastersize = "300x200";
		resize = "NO";
	}
end 


local function init_msg()
	function btn_ok_:action()
		if not string.find(txt_msg_.value,"%S+") then iup.Message("Warning","Msg content can not be empty !") return end 
		--if  string.find(txt_msg_.value,"[^%w_s]") then iup.Message("Warning","Msg char must be a numbe,letter,space or underline !") return end 
		--if  string.find(txt_title_.value,"[^%w_s]") then iup.Message("Warning","Title char must be a numbe,letter,space or underline !") return end 
		if string.find(txt_msg_.value,"\"") or string.find(txt_msg_.value,"\\") or string.find(txt_msg_.value,"\'")  then iup.Message("Warning","Msg char error !") return end 
		if string.find(txt_title_.value,"\"") or string.find(txt_title_.value,"\\") or string.find(txt_title_.value,"\'")   then iup.Message("Warning","Title char error !") return end 
		
		if not string.find(txt_title_.value,"%S+") then iup.Message("Warning","Title can not be empty !") return end 
		if #txt_title_.value > 10 then iup.Message("Warning","The string length of the title must be less than 10 ! Please re-enter !") txt_title_.value = "" return end 
		txt_title_.value = string.gsub(txt_title_.value,"\n"," ")
		msg_ =  string.gsub(txt_msg_.value,"\n"," ")
		title_ = txt_title_.value
		dlg_:hide();
	end 
	function btn_cancel_:action()
		
		dlg_:hide();
	end 
	
end


local function init_data()
	txt_msg_.value = ""
	txt_title_.value = ""
	msg_ = nil
	if title_ then 
		dlg_.title = title_
		title_ = nil
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



function pop()
	if dlg_ then show() else init() end 
end 

function set_data(str)
	title_ = str
end 

function get_data()
	return title_,msg_
end 