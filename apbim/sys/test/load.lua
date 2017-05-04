
local env_ = {ap_trace_out=trace_out};
local txt = "abc\neee\n"
-- txt = string.format("%q",txt);
local str = 'local a=5\n ap_trace_out('..txt..')';
-- str = string.format("%q",str)
require"sys.str".totrace("str:\n"..str.."\n")
local f = load(str,'sys.net.test.load.lua','bt',env_);
if type(f)~="function" then require"sys.str".totrace("error:\n"..str.."\n") return end
local result = f();



