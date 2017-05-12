module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil
local cur_totals_ = nil;
local cur_num_ = 0
local cur_change_title_ = nil;
local show_pos_ = iup.CENTER
local child_progress_nums_ = 0
local cur_child_num_ = 0
local dlg_status_ = false

local speed_str_ = "Speed:  "
local unit_ = "n/s"
local speed_nums_ = 0

local take_time_ = "Using Time : "
local cur_time_ = 0

local function init_controls()
	lab_tip_ = iup.label{title = "Please Wait ! ",fontsize = 10,fgcolor = "255 0 0",expand = "HORIZONTAL"}
	prograssbar_ = iup.gauge{rastersize = "800x";expand = "HORIZONTAL"}
	lab_title_ = iup.label{title = "Running",rastersize = "800x",alignment = "ACENTER:ACENTER",fgcolor = "0 255 0",}
	gauge_big_file_ = iup.gauge{rastersize = "800x";expand = "HORIZONTAL"}
	lab_big_file_ = iup.label{title = "Upload big file : "}
	zbox_gauge_ = iup.zbox{lab_title_,gauge_big_file_}
	zbox_gauge_.value = lab_title_
	
	net_speed_ = iup.label{title = speed_str_,rastersize = "200x",fgcolor = "255 0 0"}
	
	time_ = iup.label{title = take_time_,rastersize = "200x",fgcolor = "255 0 0"}
end


local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_tip_;iup.fill{},net_speed_,iup.fill{rastersize = "10x"},time_};
			iup.hbox{prograssbar_;};
			iup.hbox{zbox_gauge_};
			alignment = "ALEFT";
			margin = "0x0";
		};
		title = "Progress Bar";
		--expand = "VERTICAL";
		resize = "NO";
		BRINGFRONT  = "YES";
		TOPMOST = "YES";
		rastersize = "800x",
	}
end 

local function init_data()
	local change_title = cur_change_title_ or  ""
	lab_tip_.title  = change_title  .. " Please Wait ! "
	if cur_totals_ then 
		cur_num_ = 0
		prograssbar_.min = 0
	end
	show_pos_ =  iup.CENTER
	speed_nums_ = 0
	cur_time_ = 0
	time_.title = take_time_ .. cur_time_ .. " Sec"
	net_speed_.title = speed_str_ .. speed_nums_ .. unit_
end 

function init_msg()
	function dlg_:close_cb()
		dlg_status_ = false
	end 
end 


local function show()
	init_data()
	dlg_:showxy(show_pos_,show_pos_)
end 

local function init()
	init_controls()
	init_dlg()
	init_data()
	init_msg()
	dlg_:showxy(show_pos_, show_pos_)
end



function pop()
	dlg_status_ = true
	if dlg_ then show() else init() end 
end

function set_data(totalnums)
	cur_totals_ = totalnums
end

function set_title(str,size)
	cur_change_title_ = str
end

local function speed()
	if up_time_ then
		local temp_T = tonumber(os.date("%S",os.time())) 
		if temp_T == 0 then 
			temp_T = 60
		end 
		if (temp_T - up_time_) >= 1 then 
			net_speed_.title = speed_str_ .. speed_nums_ .. unit_
			speed_nums_ = 0
		end 
	end 
	speed_nums_ = speed_nums_ + 1
	up_time_ = tonumber( os.date("%S",os.time()) )
	
end

function init_val()
	if not dlg_ then return end 

	cur_num_ = cur_num_ + 1
	local str = 	cur_num_/cur_totals_ * 100
	prograssbar_.TEXT = string.format("%.2f",str) .. "%"
	prograssbar_.VALUE = cur_num_/cur_totals_
	dlg_:showxy()
	--speed()
	if cur_num_ == cur_totals_ then 
		dlg_:hide();
		cur_totals_ = nil
		cur_num_ = 0
		dlg_status_ = false
		dlg_ = nil
	end 
	
	
end

function end_dlg()
	if not dlg_ then return end 
	dlg_:hide();
	cur_totals_ = nil
	cur_num_ = 0
	dlg_ = nil
end

function set_child_progress(nums)
	if not dlg_ then return end 
	zbox_gauge_.value = gauge_big_file_
	child_progress_nums_ = nums or 0
	cur_child_num_ = 0
end 

function upvalue_child_progress()
	if not dlg_ then return end 
	if zbox_gauge_.value == lab_title_ then return end 
	cur_child_num_ = cur_child_num_ + 1
	local str = cur_child_num_/child_progress_nums_ * 100
	gauge_big_file_.TEXT = string.format("%.2f",str) .. "%"
	gauge_big_file_.value = cur_child_num_/child_progress_nums_
end 

function end_child_progress()
	zbox_gauge_.value = lab_title_
	lab_title_.title = "Running"
	child_progress_nums_ = 0 
	cur_child_num_ = 0
end 

function get_dlg_status()
	return dlg_status_
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

