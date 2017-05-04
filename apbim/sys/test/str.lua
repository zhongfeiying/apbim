
local function trace_filename()
	local file = 'D:\\ABC/t1.lua';
	local filename = require'sys.str'.get_filename(file);
	trace_out(filename..'\n')
end

local function trace_exname()
	local file = 'D:\\ABC\\t1.lua';
	local filename = require'sys.str'.get_exname(file);
	trace_out(filename..'\n')
end

trace_filename();
trace_exname();


