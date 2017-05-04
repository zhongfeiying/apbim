_ENV = module(...,ap.adv)

function time()
	return os.time();
end

function date()
	return os.date("*t",os.time());
end

function pub_date()
	return require"sys.io".read_file{file="sys/pubtime.lua"} or date();
end

function date_text(d)
	if type(d)=="number" then d=os.date('*t',d) end;
	if type(d)~="table" then d=date() end;
	return string.format("%04d-%02d-%02d %02d:%02d:%02d",d.year,d.month,d.day,d.hour,d.min,d.sec);
end

function date_str(d)
	if type(d)=="number" then d=os.date('*t',d) end;
	if type(d)~="table" then d=date() end;
	return string.format("%04d_%02d_%02d__%02d_%02d_%02d",d.year,d.month,d.day,d.hour,d.min,d.sec);
end

function time_text(t)
	local d = nil;
	if t then d=os.date('*t',tonumber(t)) else return "" end
	return string.format("%04d-%02d-%02d %02d:%02d:%02d",d.year,d.month,d.day,d.hour,d.min,d.sec);
end
