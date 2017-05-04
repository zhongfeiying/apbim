_ENV = module(...,ap.adv)

local txt_ = require"iup".label{fontsize="16",expand="Yes",};
local dlg_ = require"iup".dialog{title = "Progress"; MENUBOX="NO"; resize="NO"; rastersize = "1000x100"; iup.hbox{txt_}};

function close()
	dlg_:hide();
end

local function minute_text(t)
	local h = math.floor(t/3600);
	local m = math.floor((t-h*3600)/60);
	local s = math.ceil(t%60);
	return (h~=0 and h.."h" or "")..(m~=0 and m.."m" or "")..s.."s";
end

local function time_used_string(stime,ntime)
	local time = ntime-stime;
	return "Used time:"..minute_text(time).."; ";
end

local function time_unused_string(stime,ntime,count,it)
	local time = math.ceil((ntime-stime)*(count-it)/it);
	return "Remaining:"..minute_text(time).."; ";
end

local function speed_string(stime,ntime,it)
	local time = ntime-stime;
	return "Speed:"..math.floor(it/time).."/s; "
end

local function count_now_string(stime,count,it)
	local ntime = os.clock();
	return "Count:"..count.."; Now:"..it.."; "..speed_string(stime,ntime,it).." Completed:"..math.floor(it/count*100).."%;  "..time_used_string(stime,ntime)..time_unused_string(stime,ntime,count,it);
end
local function now_string(stime,it)
	local ntime = os.clock();
	return "Now:"..it.."; "..time_used_string(stime,ntime)..speed_string(stime,ntime,it);
end

local function set_show_text(dlg,title,ctrl,str)
	dlg.title = title or dlg.title;
	ctrl.title=str;
	-- dlg:show();
	require"sys.mgr".update()
	require"sys.statusbar".show_text(str);
end
local function set_show_update(is)
	if is then require"sys.mgr".update() end
end


--arg={title="Progress",update=true,text=true,count=0,step=1};
function create(arg)

	local scene_ = require"sys.mgr".get_cur_scene();
	-- dlg_:show();
	local update_ = arg.update;
	local pretime_ =  os.clock();
	local stime_ = os.clock();--start time;
	local count_ = arg.count or 0;
	local step_ = arg.step or 1;
	local time_ = arg.time or 1;
	local it_ = 0;
	local timer_ = nil;
	-- if time_ and scene_ then timer_ = require"sys.timer".set{scene=scene_,msec=time_*1000,f=function()dlg_:show()require"sys.mgr".update()end}end

	local function time_enough()
		local ntime = os.clock();
		if ntime-pretime_<time_ then return end
		pretime_ = ntime;
		return true;
	end

	local function close()
		-- require"sys.mgr".update();
		require"sys.statusbar".show_text("Finish");
		if scene_ and timer_ then require"sys.timer".kill{scene=scene_,id=timer_} end
		dlg_:hide()
	end
	-- local function close()
		-- close()
	-- end
	
	local function show_text(str)
		set_show_update(update_);
		if not time_enough() then return end
		set_show_text(dlg_,arg.title,txt_,str);
	end
	
	local function show_count_step()
		it_=it_+1;
		if it_>=count_ then close() return end
		set_show_update(update_);
		if it_%step_~=0 then return end
		set_show_text(dlg_,arg.title,txt_,count_now_string(stime_,count_,it_));
	end
	
	local function show_count_time()
		it_=it_+1;
		if it_>=count_ then close() return end
		set_show_update(update_);
		if not time_enough() then return end
		set_show_text(dlg_,arg.title,txt_,count_now_string(stime_,count_,it_));
	end
	
	local function show_count()
		it_=it_+1;
		set_show_update(update_);
		if it_>=count_ then close() return end
		set_show_text(dlg_,arg.title,txt_,count_now_string(stime_,count_,it_));
	end
	
	local function show_time()
		it_=it_+1;
		set_show_update(update_);
		if not time_enough() then return end
		set_show_text(dlg_,arg.title,txt_,now_string(stime_,it_));
	end
	
	local function show()
		it_=it_+1;
		set_show_update(update_);
		set_show_text(dlg_,arg.title,txt_,now_string(stime_,it_));
	end
	
	if arg.text then return show_text,close end
	if arg.count and arg.step then return show_count_step,close end
	if arg.count and arg.time then return show_count_time,close end
	if arg.time then return show_time,close end
	if arg.count then return show_count,close end
	return show,close;
end


----Sample-------------------------------------------------------------
--[[

1.
local show,close = require"tools.progress".create{title="Progress1",text=true};
do_something1();
show("something1")
do_something2();
show("something2")
...
close();

2.
local show = require"tools.progress".create{title="Progress2",count=require"sys.api.table".count(t),step=100};
for k,v in pairs(t) do
	do_something(v);
	show();
end

--]]



