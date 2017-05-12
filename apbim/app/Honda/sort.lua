

local SRC_ = "G:\\better\\music\\MP3\\";
local DST_ = "H:\\MP3\\";
local BAT_ = "app\\Honda\\sort_usb.bat";
local USB_ = "app\\Honda\\sort_usb.lua";


local usbs_ = {};
local news_ = {};
-- local dels_ = {};

function print_news()
	print("news_:")
	for k,v in pairs(news_) do
		print(k);
	end
end

function print_usbs()
	print("usbs_:")
	for k,v in pairs(usbs_) do
		print(v);
	end
end

function init_news()
	news_ = require"sys.io".get_filename_list(SRC_);
end

function init_usbs()
	if not io.open(USB_,"r") then return end
	dofile(USB_);
	usbs_ = usb;
end

function del_usbs_by_news_nonexistent()
	local temp = {};
	for k,v in pairs(usbs_) do
		if not news_[v] then table.insert(temp,1,k) end
	end
	for k,v in pairs(temp) do
		table.remove(usbs_,v);
	end
end

function del_news_by_usbs_repeat()
	for k,v in pairs(usbs_) do
		if news_[v] then news_[v] = nil end
	end
end


function append_usbs_by_news()
	for k,v in pairs(news_) do
		table.insert(usbs_,k);
	end
end

function save_usbs()
	io.output(USB_,"w");
	io.write('usb = {\n');
	for k,v in ipairs(usbs_) do
		io.write('[[',v,']];\n')
	end
	io.write('}\n');
	io.close();
end

function save_bat()
	io.output(BAT_,"w");
	io.write('set SRC='..SRC_..'\n');
	io.write('set DST='..DST_..'\n');
	io.write('rd %DST% /s /q\n');
	io.write('md %DST%\n');
	for k,v in ipairs(usbs_) do
		if type(v)~="string" then break end
		io.write('copy "%SRC%',v,'" %DST%\n')
	end
	io.close();
end

function call_bat()
	os.execute(BAT_);
end

trace_out(SRC_.."\n");

init_usbs();
init_news();
del_usbs_by_news_nonexistent()
del_news_by_usbs_repeat();
-- copy_usbs_2_dels_by_no_news();
-- del_usbs_by_dels();
-- append_usbs_by_dels();
append_usbs_by_news();
save_usbs();
save_bat();
call_bat();
-- print_news();
-- print_usbs();
trace_out(SRC_.."\n");

