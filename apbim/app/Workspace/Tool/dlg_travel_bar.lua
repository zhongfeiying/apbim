module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil
local cur_doc_ = ""
local str = "Running "
local dlg_status_ = false
local speed_str_ = "Speed:  "
local unit_ = "n/s"
local speed_nums_ = 0

local take_time_ = "Using Time : "
local cur_time_ = 0

local function init_controls()
	lab_travel_ = iup.label{title = str,fontsize = 20,alignment = "ALEFT";rastersize = "400x";}
	lab_tip_ = iup.label{title = "Please Waiting ! ",fontsize = 10,fgcolor = "255 0 0"}
	net_speed_ = iup.label{title = speed_str_,rastersize = "200x",fgcolor = "255 0 0"}
	
	time_ = iup.label{title = take_time_,rastersize = "200x",fgcolor = "255 0 0"}
end


local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_tip_;iup.fill{},net_speed_,iup.fill{rastersize = "10x"},time_};
			iup.hbox{lab_travel_;};
			alignment = "ALEFT";
			margin = "0x0";
		};
		title = "Travel";
		rastersize = "800x";
		resize = "NO";
		BRINGFRONT  = "YES",
		TOPMOST = "YES";
	}
end 


local function init_data()
	local change_title = cur_change_title_ or  ""
	lab_tip_.title  = change_title  .. " Please Wait ! "
	speed_nums_ = 0
	speed_str_ = "Speed:  "
	unit_ = "n/s"
	cur_time_ = 0
	time_.title = take_time_ .. cur_time_ .. " Sec"
	net_speed_.title = speed_str_ .. speed_nums_ .. unit_
end 

local function show()
	init_data()
	dlg_:showxy(iup.CENTER, iup.CENTER)
end 

function init_msg()
	function dlg_:close_cb()
		dlg_status_ = false
	end 
end 

local function init()
	init_controls()
	init_data()
	
	init_dlg()
	init_msg()
	dlg_:showxy(iup.CENTER, iup.CENTER)
end

function pop()
	dlg_status_ = true
	if dlg_ then show() else init() end 
end


function set_title(str)
	cur_change_title_ = str
end


function set_data(num)
	if #cur_doc_ > 10 then 
		cur_doc_ = ""
	end
	dlg_:showxy()
	if not num then 
		dlg_status_ = false
		dlg_:hide();
	else 
		cur_doc_ = cur_doc_ .. "."
		lab_travel_.title = str .. cur_doc_
	end
end

function set_speed_tips(str)
	unit_ = str
end 

function set_speed(nums,t)
	local t = t or 1
	cur_time_ = cur_time_ + t
	time_.title = take_time_ .. cur_time_ .. " Sec"
	net_speed_.title = speed_str_ .. nums .. " " .. unit_
	
end 

function get_dlg_status()
	return dlg_status_
end
