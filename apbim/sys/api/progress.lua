_ENV = module(...,ap.adv)
local iup_ = require"iuplua";
local cancel_ = iup_.button{title="Cancel",rastersize="100x30"};
local text_ = iup_.label{fontsize="16",expand="Yes",};
local image_ =iup.label{expand="Yes",rastersize="x30"};
local dlg_ = iup.dialog{
	title="Progress"; 
	resize="NO"; 
	rastersize="1080x100"; 
	margin = "5x5";
	MENUBOX="NO"; 
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{text_};
			};
		};
		-- iup.hbox{images_,cancel_};
		alignment="aRight";
	};
};
images_ = {"sys/res/progress1.bmp","sys/res/progress2.bmp"}

local function set_image(i)
	local n = table.getn(images_);
	i = i%n+1;
	iup_.SetAttribute(image_, "IMAGE", images_[i]);
end

local function minute_text(t)
	local h = math.floor(t/3600);
	local m = math.floor((t-h*3600)/60);
	local s = math.ceil(t%60);
	-- local s = math.ceil(t%60*10)/10;
	-- local s = string.format("%0.1f",math.ceil(t%60*10)/10);
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
	return "Speed:"..string.format("%.2f",math.floor(it*100/time)/100).."/s; "
	-- return "Speed:"..(math.floor(it*100/time)/100).."/s; "
end

local function now_string(stime,it)
	local ntime = os.clock();
	return "Now:"..it.."; "..speed_string(stime,ntime,it)..time_used_string(stime,ntime);
	-- return "Now:"..it.."; "..time_used_string(stime,ntime)..speed_string(stime,ntime,it);
end

local function count_now_string(stime,it,count)
	if not count then return now_string(stime,it) end
	local ntime = os.clock();
	-- local completed = "Completed:"..math.floor(it/count*100).."%;  ";
	local completed = "Completed:"..string.format("%.1f",it/count*100).."%;  ";
	-- return speed_string(stime,ntime,it)..completed..time_used_string(stime,ntime)..time_unused_string(stime,ntime,count,it);
	return (math.floor(it/count*10000)/100).."%;  ".."Count:"..count.."; Now:"..it.."; "..speed_string(stime,ntime,it)..time_used_string(stime,ntime)..time_unused_string(stime,ntime,count,it);
	-- return string.format("%.2f",math.floor(it/count*100)).."%;  ".."Count:"..count.."; Now:"..it.."; "..speed_string(stime,ntime,it)..time_used_string(stime,ntime)..time_unused_string(stime,ntime,count,it);
end

local dlg_show_ = nil;

function hide()
	dlg_show_ = nil;
	dlg_:hide();
end

function show(str,title)
	dlg_show_ = true;
	text_.title = str or text_.title;
	dlg_.title = title or dlg_.title;
	dlg_:show();
	-- iup_.LoopStep();
end

function keep(str,title)
	if dlg_show_ then
		text_.title = str or text_.title;
		dlg_.title = title or dlg_.title;
	else
		show(str,title) 
	end
end


--arg={title="Progress",msg=true,dlg=true,update=false,statusbar=true,text=false,count=,step=,time=};
function create(arg)
	if type(arg.title)~="string" then arg.title="Progress " end
	if type(arg.msg)=="nil" then arg.msg=true end
	if type(arg.dlg)=="nil" then arg.dlg=true end
	-- if type(arg.update)=="nil" then arg.update=true end
	if type(arg.statusbar)=="nil" then arg.statusbar=true end
	
	local break_ = nil;
	if arg.update then require"sys.mgr".update() end
	local stime_,pretime_ =  os.clock(),os.clock();
	local it_ = 0;
	
	local function close_enough()
		if not arg.count then return false end
		if it_>=arg.count then return true end
	end
	
	local function step_enough()
		if not arg.step then return true end
		return it_%arg.step==0;
	end
	
	local function time_enough()
		if not arg.time then return true end
		local ntime = os.clock();
		if ntime-pretime_< arg.time then return end
		pretime_ = ntime;
		return true;
	end

	local function show_by_run(str)
		if arg.statusbar then require"sys.statusbar".show_text(arg.title.." "..str) end
	end
	
	local function show_by_enough(str)
		if arg.msg then iup_.LoopStep() end
		if arg.dlg then show(str,arg.title) end
		if arg.update then require"sys.mgr".update() end
		if arg.statusbar then require"sys.statusbar".show_text(arg.title.." "..str) end
	end
	
	local timer_ = nil;
	
	local function close()
		hide();
		require"sys.statusbar".show_text("Finish");
		if timer_ then require"sys.timer".kill{id=timer_} timer_=nil end
	end
	
	local function break_test()
		if break_ then close() assert(false) end
	end
	
	local function update()
		if close_enough() then close() return end
		local str = count_now_string(stime_,it_,arg.count);
		show_by_run(str);
		if not step_enough() then return end
		if not time_enough() then return end
		show_by_enough(str);
		break_test();
	end
	
	local function run_text(str)
		if type(str)~="string" then return end
		show_by_run(str);
		if not time_enough() then return end
		show_by_enough(str);
		break_test();
	end
	
	local function run()
		it_=it_+1;
		update();
	end
	
	function cancel_.action()
		break_=true 
		close();
	end
	
	-- if not arg.text then timer_ = require"sys.timer".set{msec=1000,f=update} end
	if arg.text then return run_text,close end
	return run,close;
end


----Sample-------------------------------------------------------------
--[[

1.
local run,close = require"tools.progress".create{title="Progress1",text=true};
do_something1();
run("something1")
do_something2();
run("something2")
...
close();

2.
local run = require"tools.progress".create{title="Progress2",count=require"sys.table".count(t),time=1};
for k,v in pairs(t) do
	do_something(v);
	run();
end

--]]



