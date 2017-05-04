

local function get_trace_code()
	local str = '';
	str = str..'local function exe_f() \n';
	local txt = "#TestExecute#\n"
	str = str..'ap_trace_out('..string.format("%q",txt)..'); \n';
	str = str..'end \n';
	str = str..'ap_set_exe_cbf(exe_f)\n';
	return str;
end

require'sys.table'.totrace{net_msg=1}
require'sys.net.main'.send_msg("BETTER",get_trace_code())
require'sys.net.msg'.send_msg{To="BETTER",Code=get_trace_code(),Name="Trace->1",Text="This is a Test(Trace).",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
require'sys.table'.totrace{net_msg=2}

