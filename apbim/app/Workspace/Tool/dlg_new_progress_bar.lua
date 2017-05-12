module(...,package.seeall)
require "iuplua"
require "iupluacontrols"

local show_pos_ = iup.CENTER
local dlg_status_ = false
local cur_time_ = nil
local speed_nums_ = nil
local speed_times_ = nil 


local function init_controls()
	local fontsize = 12
	lab_cmd_ = iup.label{title = "Command : ",fgcolor = "255 0 0",fontsize = fontsize}
	lab_speed_ = iup.label{title = "Speed : ",fgcolor = "255 0 0",fontsize = fontsize}
	lab_total_ = iup.label{title = "Total : ",fgcolor = "255 0 0",fontsize = fontsize}
	lab_now_ = iup.label{title = "Now : ",fgcolor = "255 0 0",fontsize = fontsize}
	lab_usingtime_ = iup.label{title = "Using Time : ",fgcolor = "255 0 0",fontsize = fontsize}
	
	lab_cmd_value_ = iup.label{title = "",fgcolor = "0 0 255",rastersize = "150x",expand = "HORIZONTAL",fontsize = fontsize}
	lab_speed_value_ = iup.label{title = "",fgcolor = "0 0 255",rastersize = "150x",expand = "HORIZONTAL",fontsize = fontsize}
	lab_usingtime_value_ = iup.label{title = "0",fgcolor = "0 0 255",rastersize = "150x",expand = "HORIZONTAL",fontsize = fontsize}
	lab_total_value_ = iup.label{title = "",fgcolor = "255 0 0",rastersize = "150x",expand = "HORIZONTAL",expand = "HORIZONTAL",fontsize = fontsize}
	lab_now_value_ = iup.label{title = "",fgcolor = "255 0 0",rastersize = "150x",expand = "HORIZONTAL",expand = "HORIZONTAL",fontsize = fontsize}
	prograssbar_ = iup.gauge{rastersize = "800x20";expand = "HORIZONTAL",fontsize = fontsize}
	lab_title_ = iup.label{title = "",rastersize = "800x20",alignment = "ACENTER:ACENTER",fontsize = fontsize,fgcolor = "0 0 255",}
	gauge_big_file_ = iup.gauge{rastersize = "800x20";expand = "HORIZONTAL",fontsize = fontsize}
	zbox_gauge_ = iup.zbox{lab_title_,gauge_big_file_}
	zbox_gauge_.value = lab_title_
	
end


local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_cmd_,lab_cmd_value_;};
			iup.hbox{
				iup.fill{rastersize = "150x"};
				lab_total_;
				lab_total_value_;
				lab_now_;
				lab_now_value_;
				lab_speed_;
				lab_speed_value_;
				lab_usingtime_;
				lab_usingtime_value_;
			};
			iup.hbox{prograssbar_;};
			iup.hbox{zbox_gauge_};
			alignment = "ALEFT";
			margin = "0x0";
		};
		title = "Progress Bar";
		resize = "NO";
		BRINGFRONT  = "YES";
		TOPMOST = "YES";
	}
end 

local function init_data()
	cur_time_ = nil
	speed_nums_ = nil
	speed_times_ = nil
	dlg_status_ = true
	lab_cmd_value_.title = ""
	lab_now_value_.title = ""
	lab_speed_value_.title = ""
	lab_total_value_.title = ""
	lab_usingtime_value_.title = ""
	prograssbar_.min = 0
	prograssbar_.max = 100
	gauge_big_file_.max = 100
	gauge_big_file_.min = 0
end 

function init_msg()
	function dlg_:close_cb()
		dlg_status_ = false
	end 
end 


local function show()
	init_data()
	dlg_:showxy(show_pos_,show_pos_)
	--iup.MainLoop()
end 

local function init()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:showxy(show_pos_, show_pos_)
	--dlg_:popup()
	
end




function pop()
	dlg_status_ = true
	if dlg_ then show() else init() end 
end


function set_cmd_val(str)
	lab_cmd_value_.title = str
end

function set_speed_val(str)
	str = str or "n/s"
	local speed = 0
	if not speed_times_ then 
		speed_times_ = tonumber(os.time()) 
		speed_nums_ = 0
		speed = 0
	else 
		speed_nums_ = speed_nums_ + 1
		local temp_T = tonumber(os.time())  
		local time2 = temp_T - cur_time_
		if time2 >= 1 then 
			speed = string.format("%.2f",speed_nums_ / time2)
			lab_speed_value_.title = speed .. " " .. str .. " " 
		end 
		
	end 
	
end

function set_time_val(str)
	local showtime = 0
	if not cur_time_ then
		cur_time_ = tonumber(os.time()) 
		showtime = "0 s "
	else 
		local temp_T = tonumber(os.time()) 
		local time2 = temp_T - cur_time_
		local h = math.floor(time2/3600)
		local m = math.floor(time2%3600/60)
		local s = time2 % 60
		if h and h ~= 0  then
			showtime = h .. " h " ..  m .. " m " .. s .. " s "
		elseif m and m ~= 0  then
			showtime =   m .. " m " .. s .. " s "
		else 
			showtime =  s .. " s "
		end 
	end 
	lab_usingtime_value_.title = showtime
	
end

function set_now_val(str)
	if not str then return end 
	lab_now_value_.title = str
	local txt = 	tonumber(str)/tonumber(prograssbar_.max) * 100
	prograssbar_.TEXT = string.format("%.2f",txt) .. "%"
	prograssbar_.VALUE = tonumber(str)
	dlg_:showxy()
	--speed()
	if tonumber(prograssbar_.VALUE) == tonumber(prograssbar_.max) then 
		dlg_:hide();
	end 
end

function set_total_val(str)
	lab_total_value_.title = str
	prograssbar_.max = str
end

function set_big_file_now_val(str)
	if not str then return end 
	local txt = 	tonumber(str)/tonumber(gauge_big_file_.max) * 100
	gauge_big_file_.TEXT = string.format("%.2f",txt) .. "%"
	gauge_big_file_.VALUE = tonumber(str)
end

function set_big_file_total_val(str)
	if not str then return end 
	gauge_big_file_.max = str
end

local function set_big_file_states(states)
	if not states then 
		zbox_gauge_.value = lab_title_
		gauge_big_file_.max = 100
		gauge_big_file_.min = 0
	elseif  states and states == "start" then 
		zbox_gauge_.value = gauge_big_file_
	end 
end 


function dlg_status()
	return dlg_status_
end

function end_dlg()
	dlg_:hide()
end

function init_dlg_msg(t)
	if not t then return end 
	set_speed_val(t.speedunit)
	set_time_val()
	set_cmd_val(t.cmd)
	set_total_val(t.total)
	set_now_val(t.now)
	set_big_file_states(t.bigstates)
	set_big_file_total_val(t.bigtotal)
	set_big_file_now_val(t.bignow)
end 
