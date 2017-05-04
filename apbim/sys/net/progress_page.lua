_ENV = module(...,ap.adv)

local iup_ = require"iuplua";
local iupcontrol = require"iupluacontrols"

local cancel_ = iup_.button{title="Cancel",rastersize="100x30"};
local text_ = iup_.label{fontsize="12",expand="Yes",};
local gauge_ = iup.gauge{fontsize="12",expand = "Yes"}
local dlg_ = iup.vbox{
	title="Progress"; 
	tabtitle="Progress"; 
	resize="NO"; 
	rastersize="800x100"; 
	margin = "5x5";
	MENUBOX="Yes"; 
	iup.vbox{
		iup.frame{
			iup.vbox{
				-- iup.hbox{text_};
				iup.hbox{gauge_};
			};
		};
		alignment="aRight";
	};
};

local function minute_text(t)
	local h = math.floor(t/3600);
	local m = math.floor((t-h*3600)/60);
	local s = math.ceil(t%60);
	return (h~=0 and h.."h" or "")..(m~=0 and m.."m" or "")..s.."s";
end

local function byte_text(t)
	local digit = 1000
	local n =  math.floor(t*digit)/digit;
	if n<1000 then return n,"B" end
	local n =  math.floor(t*digit/1024)/digit;
	if n<1000 then return n,"k" end
	local n =  math.floor(t*digit/1024/1024)/digit;
	if n<1000 then return n,"M" end
	local n =  math.floor(t*digit/1024/1024/1024)/digit;
	-- if n<1000 then return n.."G" end
	return n,"G"
end

local function time_used_string(stime,ntime)
	local time = ntime-stime;
	return "Used time:"..minute_text(time).."; ";
end

local function time_unused_string(stime,ntime,count,it)
	local time = math.ceil((ntime-stime)*(count-it)/it);
	return "Remaining:"..minute_text(time).."; ";
end

local function Speed_string(stime,ntime,it)
	local time = ntime-stime;
	return ""..string.format("%.2f",math.floor(it*100/time)/100)..""
end

local function byte_string(stime,ntime,size)
	local time = ntime-stime;
	local cb,cu = byte_text(size);
	local sb,su = byte_text(size/time);
	return string.format("%.3f",cb)..cu.."("..string.format("%.3f",sb)..su.."/s); "
end

local function Completed_number(count,it)
	return it/count
end

local function Completed_string(count,it)
	return math.floor(it/count*100).."%;  "
end


local stime_ = 0;
local ptime_ = 0;
local count_ = 0;
local left_ = 0;
local file_="";
local sizen_ = 0;
local sizei_ = 0;
local timer_=nil;
local function Progress_string(ntime)
	stime_=stime_>0 and  stime_ or ntime;
	return 
			byte_string(stime_,ntime,sizen_+sizei_)..
			count_.."("..left_..':'..count_-left_.."|"
			..Speed_string(stime_,ntime,count_-left_).."); "
			..Completed_string(count_,count_-left_)
			..time_used_string(stime_,ntime)
			..time_unused_string(stime_,ntime,count_,count_-left_)
			
end

--arg={title="Progress",n=};
function show(t)
	t = type(t)=='table' and t or {};
	left_ = t.n or left_;
	local ntime = os.clock();
	-- if t.add then count_=count_+1 end
	if left_>0 then 
		-- if ntime-ptime_<1 then return else ptime_=ntime end
		count_=left_>count_ and left_ or count_;
		-- text_.title,gauge_.text = Progress_string(ntime);
		local str = Progress_string(ntime);
		require'sys.statusbar'.show_text(str);
		gauge_.text = str;
		gauge_.value = Completed_number(count_,count_-left_);
		dlg_.title = t.title or dlg_.title;
		dlg_:show() 
		timer_ = timer_ or require'sys.timer'.set{msec=1000,f=show}
	else 
		-- dlg_:hide()
		stime_=0;
		ptime_=0;
		count_=0;
		left_=0;
		file_="";
		sizen_=0;
		sizei_=0;
		require"sys.statusbar".update();
		timer_ = timer_ and require'sys.timer'.kill{id=timer_}
		require'sys.statusbar'.show_text("Finish");
	end
	require'sys.net.file'.start();
	return dlg_;
end

function add(t)
	count_ = count_+1;
	show(t);
end

-- t={file=,size=}
local file_size_=0;
function set_size(t)
	t = t or {}
	if file_~=t.file then 
		sizen_ = sizen_+sizei_;
		file_ = t.file;
	end
	sizei_=t.size 
	show();
end

function get()
	return dlg_;
end




