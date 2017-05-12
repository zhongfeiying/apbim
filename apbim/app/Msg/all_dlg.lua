_ENV = module(...,ap.adv)

local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local msg_mat = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol=14,numlin_visible=16,widthdef=250,width1=120,width2=100,width3=150,width4=50,width5=50,width6=100,width7=50,width8=100,width9=50,width10=100,width11=50,width12=100,width13=50,width14=50};
local update_btn = iup.button{title="Update",size='60x'}
local download_btn = iup.button{title="Download",size='60x'}
local upload_btn = iup.button{title="Upload",size='60x'}
local open_btn = iup.button{title="Open",size='60x'}
local save_btn = iup.button{title="Save",size='60x'}
local del_btn = iup.button{title="Delete",size='60x'}
local read_btn = iup.button{title="Read",size='60x'}
local confirm_btn = iup.button{title="Confirm",size='60x'}
local veto_btn = iup.button{title="Veto",size='60x'}
local exe_btn = iup.button{title="Execute",size='60x'}
local dlg = iup.dialog{
	size = "1240";
	title = "Message";
	margin = "5x5";
	alignment = "aRight";
	iup.vbox{
		iup.hbox{msg_mat};
		iup.hbox{update_btn,download_btn,upload_btn,open_btn,save_btn,del_btn,read_btn,confirm_btn,veto_btn,exe_btn};
	};
}

local function init_msg_mat()
	local lin = 0;
	msg_mat.numlin = lin;
	-- msg_mat:setcell(lin,0,lin);
	msg_mat:setcell(lin,1,"ID");
	msg_mat:setcell(lin,2,"Name");
	msg_mat:setcell(lin,3,"Text");
	msg_mat:setcell(lin,4,"From");
	msg_mat:setcell(lin,5,"To");
	msg_mat:setcell(lin,6,"Send_Time");
	msg_mat:setcell(lin,7,"Arrived");
	msg_mat:setcell(lin,8,"Arrived_Time");
	msg_mat:setcell(lin,9,"Read");
	msg_mat:setcell(lin,10,"Read_Time");
	msg_mat:setcell(lin,11,"Confirm");
	msg_mat:setcell(lin,12,"Confirm_Time");
	msg_mat:setcell(lin,13,"Function");
	msg_mat:setcell(lin,14,"Type");
	local msgs = require"sys.net.msg".get_all();
	local s = require"sys.table".sortv(msgs, function(k) return msgs[k].Send_Time end);
	if type(s)~="table" then return end
	for i,v in ipairs(s) do
		local k,v = v,msgs[v];
		msg_mat.numlin = i;
		msg_mat:setcell(i,0,i);
		msg_mat:setcell(i,1,k);
		msg_mat:setcell(i,2,v.Name);
		msg_mat:setcell(i,3,v.Text);
		msg_mat:setcell(i,4,v.From);
		msg_mat:setcell(i,5,v.To);
		msg_mat:setcell(i,6,require"sys.dt".time_text(v.Send_Time));
		msg_mat:setcell(i,7,v.Arrived and "Yes" or "No");
		msg_mat:setcell(i,8,require"sys.dt".time_text(v.Arrived_Time));
		msg_mat:setcell(i,9,v.Read and "Yes" or "No");
		msg_mat:setcell(i,10,require"sys.dt".time_text(v.Read_Time));
		msg_mat:setcell(i,11,type(v.Confirm)=='string' and tostring(v.Confirm) or '['..tostring(v.Confirm)..']');
		msg_mat:setcell(i,12,require"sys.dt".time_text(v.Confirm_Time));
		msg_mat:setcell(i,13,type(v.exe_cbf)=="function" and "Yes" or "No");
		msg_mat:setcell(i,14,v.Channel and "Channel" or "Message");
		-- lin=i;
	end
	msg_mat.numlin=math.max(tonumber(msg_mat.numlin),20);
	msg_mat.redraw = "ALL";
end


local function init()
	init_msg_mat();
	dlg:show();
end

function update_btn:action()
	init();
end

function download_btn:action()
	require'sys.net.msg'.download{cbf=init}
end

function upload_btn:action()
	require'sys.net.msg'.upload{}
end

function open_btn:action()
	require'sys.net.msg'.open();
	init();
end

function save_btn:action()
	require'sys.net.msg'.save()
end

function del_btn:action()
	local cell = msg_mat.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = msg_mat:getcell(lin,1);
	require"sys.net.msg".del_msg(gid);
	init_msg_mat();
end

function read_btn:action()
	local cell = msg_mat.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = msg_mat:getcell(lin,1);
	local msgs = require"sys.net.msg".get_all();
	if type(msgs[gid].Read_cbf)=="function" then msgs[gid].Read_cbf() else trace_out("No Report\n") end
end

function confirm_btn:action()
	local cell = msg_mat.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = msg_mat:getcell(lin,1);
	local msgs = require"sys.net.msg".get_all();
	if type(msgs[gid].Read_cbf)=="function" then msgs[gid].Read_cbf() else trace_out("No Report\n") end
	if type(msgs[gid].Confirm_cbf)=="function" then msgs[gid].Confirm_cbf(true) else trace_out("No Report\n") end
end

function veto_btn:action()
	local cell = msg_mat.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = msg_mat:getcell(lin,1);
	local msgs = require"sys.net.msg".get_all();
	if type(msgs[gid].Read_cbf)=="function" then msgs[gid].Read_cbf() else trace_out("No Report\n") end
	if type(msgs[gid].Confirm_cbf)=="function" then msgs[gid].Confirm_cbf("No,I Cann't") else trace_out("No Report\n") end
end

function exe_btn:action()
	local cell = msg_mat.focus_cell;
	local lin = i or string.match(cell,"%d+");
	local gid = msg_mat:getcell(lin,1);
	local msgs = require"sys.net.msg".get_all();
	if type(msgs[gid].Read_cbf)=="function" then msgs[gid].Read_cbf() else trace_out("No Report\n") end
	if type(msgs[gid].exe_cbf)=="function" then msgs[gid].exe_cbf() else trace_out("No Execute\n") end
end

function pop()
	require"sys.statusbar".show_user(require"sys.mgr".get_user());
	dlg.title = "Message - "..require"sys.mgr".get_user();
	init();
	require'sys.net.msg'.resgister_rcvf(init);
	dlg:show();
end


