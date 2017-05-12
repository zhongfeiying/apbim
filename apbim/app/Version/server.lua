
_ENV = module(...,ap.adv)



local menu_status_="-1";--菜单此时状态
local son_ids_ = {};--选择树节点的子节点的个数



function download(id)
	init_send_connect()
	local res = get_file(id);	
	trace_out("file name is " .. id  .. " download ,The result is " .. res .. "\n");
end


function pull(son_ids)
	init_send_connect()
	for k,v in pairs(son_ids) do
		trace_out("pull file = " .. v .. "\n");
		get_file(v);
	end
	menu_status_ = "PULL";
	son_ids_ = son_ids;
end

function push(son_ids)
	--local exe_path = require"app.Tool.file_op".get_exe_path();
	--require "app.Version.file_download".set_cur_info("pull");	
	init_send_connect()
	--trace_out("ct = " .. ct .. "\n")
	for k,v in pairs(son_ids) do
		--trace_out("push file = " .. v .. "\n");
		--local f = exe_path .. "data\\docs\\" .. v;
		--require"app.Tool.file_op".copy_file(f,exe_path);
	--	trace_out("v = " .. v .. "\n")
		send_file(ct,v);
	end
	--menu_status_ = "PUSH";
	--son_ids_ = son_ids;
end





