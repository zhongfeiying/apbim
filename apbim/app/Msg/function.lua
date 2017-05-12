_ENV = module(...,ap.adv)

local function get_trace_code()
	local str = '';
	str = str..'local function exe_f() \n';
	local txt = "#TestExecute#\n"
	str = str..'ap_trace_out('..string.format("%q",txt)..'); \n';
	-- str = str..'ap_trace_out([==['..txt..']==]); ';
	-- str = str..'ap_trace_out("#TestExecute#\\n"); ';
	str = str..'end \n';
	str = str..'ap_set_exe_cbf(exe_f)\n';
	return str;
end

local function get_project_code()
	local project_name = require'sys.mgr'.get_model_zipfile_name();

	local str = '';
	str = str..'local function exe_f() \n';
	str = str..'ap_open_project_name([['..project_name..']]) \n';
	str = str..'end \n';
	str = str..'exe_f()\n';
	return str;
end

local function get_project_code()
	local id = require'sys.mgr'.get_model_id();

	local str = '';
	str = str..'local function exe_f() \n';
	str = str..'ap_open_project_id{id='..string.format('%q',id)..',cbf=function() ap_trace_out('..string.format('%q','Open Project End\n')..') end} \n';
	str = str..'end \n';
	str = str..'ap_set_exe_cbf(exe_f)\n';
	return str;
end

local function get_selection_code()
	local str = '';
	str = str..'local function exe_f() \n';
	local sels = require'sys.mgr'.curs();
	for k,v in pairs(sels) do
		str = str..'ap_select_item("'..k..'",true); \n';
		str = str..'ap_redraw_item("'..k..'"); \n';
	end
	str = str..'ap_update_scene(); \n';
	str = str..'end \n';
	str = str..'exe_f()\n';
	return str;
end

local function get_view_code()
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end
	local smd = require"sys.Group".Class:new();
	smd:set_name("NewView");
	smd:set_scene(sc);
	smd:add_scene_all();
	require"sys.mgr".add(smd);
	local smd_str = "return "..require'sys.table'.tostr(smd);
	local project_name = require'sys.mgr'.get_model_zipfile_name();

	local str = '';
	str = str..'local function exe_f() \n';
	str = str..'ap_open_project_name([['..project_name..']]) \n';
	str = str..'local id = ap_add_item([===['..smd_str..']===]) \n';
	str = str..'local smd = ap_get_item(id) \n';
	str = str..'smd:open{name=smd.Name} \n';
	str = str..'end \n';
	str = str..'ap_set_exe_cbf(exe_f)\n';
	return str;
end

local function get_file_code(hid,name,path,pathname)
	local str = '';
	str = str..'local function f() \n';
	str = str..'ap_open_project_name([['..project_name..']]) \n';
	str = str..'local id = ap_add_item([===['..smd_str..']===]) \n';
	str = str..'local smd = ap_get_item(id) \n';
	str = str..'smd:open{name=smd.Name} \n';
	str = str..'end \n';
	str = str..'f()\n';
	return str;
end


local function Send_File(sc)
		local name = "dock.lua"
		local path = "sys/api/"
		local pathname = path..name;
		local hid = require'sys.hid'.get_by_file(pathname);
		require'sys.net.file'.send{
			name=hid,
			path=path,
			cbf=function() 
				require'sys.net.msg'.send_msg{To="tbj",Code=get_file_code(hid,name,path,pathname),Name="Copy File",Text="Copy File to your PC.",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
			end
		}
end

local function Send_Trace(sc)
	require'sys.net.msg'.send_msg{To="tbj",Code=get_trace_code(),Name="Trace->1",Text="This is a Test(Trace).",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

local function Send_Project(sc)
	require'sys.net.msg'.send_msg{To="tbj",Code=get_project_code(),Name="Project-->1",Text="open 1's project.",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

local function Send_Selection(sc)
	require'sys.net.msg'.send_msg{To="tbj",Code=get_selection_code(),Name="Selection-->1",Text="Select same member to 1.",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

local function Send_View(sc)
	require'sys.net.msg'.send_msg{To="tbj",Code=get_view_code(),Name="View-->1",Text="this a view to 1.",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

local function Send_Channel(sc)
	require'sys.net.msg'.send_channel{To=require"sys.mgr".get_model_id(),Code=get_selection_code(),Name="Selection-->Channel",Text="Select same member to 1."}
end

local channet_id_ = "test_123"
local function Channel_subscribe(sc)
	require'sys.net.main'.subscribe(channet_id_);
end

local function Channel_unsubscribe(sc)
	require'sys.net.main'.unsubscribe(channet_id_);
end

local function Channel_send(sc)
	require'sys.net.msg'.send_channel{To=channet_id_,Code='ap_trace_out(" $TestChannel$ ")'};
end

local function Send_Text(sc)
	local str = "12345678"
	require"sys.str".totrace(str);
	require'sys.net.main'.send_msg("BETTER_1",str)
	require'sys.net.main'.send_channel(channet_id_,str)
end

local function Send_Text_n(sc)
	local str = "12345678\n"
	require"sys.str".totrace(str);
	require'sys.net.main'.send_msg("BETTER_1",str)
	require'sys.net.main'.send_channel(channet_id_,str)
end

local function BigMsg(sc)
	local path_src = 'sys/test/net/src/'
	local f=io.open(path_src.."test_big.lua",'r');
	local str=f:read('*all');
	f:close();
	require'sys.net.msg'.send_msg{To="BETTER_1",Code=str,Name="TestBigMsg",Text="",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

local function Send(sc)
	-- require'sys.dock'.add_page(require'app.Msg.send_dlg'.pop());
	require'sys.dock'.active_page(require"app.Msg.send_dlg".pop());
end

local function is_this_project(v)
	return require'sys.mgr'.get_model_id()==v.Project_id;
end

local function is_this_linkman(v)
	if not require'app.Msg.linkman'.get_selection_user().name then return true end
	return require'app.Msg.linkman'.get_selection_user().name==v.From or require'app.Msg.linkman'.get_selection_user().name==v.To;
end

local function List_Project_Linkman(sc)
	require'sys.dock'.active_page(
		require"app.Msg.list_dlg".pop{filter=
			function(k,v) 
				return is_this_project(v) and is_this_linkman(v);
				-- if require'sys.mgr'.get_model_id()==v.Project_id and (require'app.Msg.linkman'.get_selection_user()==v.From or require'app.Msg.linkman'.get_selection_user()==v.To) then 
					-- return true 
				-- else 
					-- return false 
				-- end 
			end
		}
	);
end

local function List_Project_All(sc)
	require'sys.dock'.active_page(
		require"app.Msg.list_dlg".pop{filter=
			function(k,v) 
				return is_this_project(v);
				-- if require'sys.mgr'.get_model_id()==v.Project_id then 
					-- return true 
				-- else 
					-- return false 
				-- end 
			end
		}
	);
end

local function List_Linkman_All(sc)
	require'sys.dock'.active_page(
		require"app.Msg.list_dlg".pop{filter=
			function(k,v) 
				return is_this_linkman(v);
				-- if require'app.Msg.linkman'.get_selection_user().name==v.From or require'app.Msg.linkman'.get_selection_user().name==v.To then 
					-- return true 
				-- else 
					-- return false 
				-- end 
			end
		}
	);
end

local function List_All(sc)
	require'sys.dock'.active_page(
		require"app.Msg.list_dlg".pop{filter=
			function(k,v) 
				return true 
			end
		}
	);
end

local function Net_Update(sc)
	require"sys.net.msg".update_net();
end

local function Download(sc)
	require"sys.net.msg".download();
end

local function Upload(sc)
	require"sys.net.msg".upload();
end

local function Test_All(sc)
	require"app.Msg.all_dlg".pop();
end
local function Test_for(sc)
	for i=1,1000 do
		require"sys.net.msg".send_msg{To='tbj',Code='a=2',Name='Test'..i,Text='Text'..i,Arrived_Report=true,Read_Report=true,Confirm_Report=true}
		-- require'sys.net.msg'.send_msg{To="tbj",Code=get_trace_code(),Name="Trace->1",Text="This is a Test(Trace).",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
	end
end
-- if require'sys.mgr'.get_user() == 'BETTER' then Send() else List() end
-- Linkman()

function load()
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Send",},f=Send};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","Project","This Linkman"},f=List_Project_Linkman};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","Project","All Linkman"},f=List_Project_All};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","Linkman","This Project"},f=List_Project_Linkman};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","Linkman","All Project"},f=List_Linkman_All};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","All"},f=List_All};
	require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Update"},f=Net_Update};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","for"},f=Test_for};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","All"},f=Test_All};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","D"},f=Download};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","List","U"},f=Upload};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","File"},f=Send_File};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","Trace"},f=Send_Trace};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","Project"},f=Send_Project};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","Selection"},f=Send_Selection};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","View"},f=Send_View};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send","Channel"},f=Send_Channel};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","subscribe"},f=Channel_subscribe};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","unsubscribe"},f=Channel_unsubscribe};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Channel_send"},f=Channel_send};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send_Text"},f=Send_Text};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","Send_Text -n"},f=Send_Text_n};
	-- require"sys.menu".add{app="Msg",frame=true,view=true,pos={"Window"},name={"Message","Test","BigMsg"},f=BigMsg};
	-- require'sys.dock'.add_page(require'app.Msg.test_dlg'.pop());
	require'sys.dock'.add_page(require'app.Msg.list_dlg'.pop());
	-- require'sys.dock'.add_page(require'app.Msg.look_dlg'.pop());
	-- require'sys.dock'.add_page(require'app.Msg.send_dlg'.pop());
end
