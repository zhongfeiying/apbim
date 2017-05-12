_ENV = module(...,ap.adv)

local iup = require'iuplua'

local to_user_name_lab = iup.label{title='To:',size='50x'};
local to_user_name_txt = iup.list{expand='Horizontal',editbox="Yes",DROPDOWN="Yes"};
local title_lab = iup.label{title='Title:',size='50x'};
local title_txt = iup.list{expand='Horizontal',editbox="Yes",DROPDOWN="Yes"};
local file_lst = iup.list{expand='Horizontal',size='x30'};
local content_txt = iup.text{expand='Yes',MULTILINE="Yes",size='x200'};
local add_btn = iup.button{title="Add",size="60x"}
local del_btn = iup.button{title="Del",size="60x"}
local send_btn = iup.button{title="Send",size="60x"}

local dlg = iup.vbox{
	title = require'sys.mgr'.get_user()..' Send Message';
	tabtitle = 'Send Message';
	margin = "5x5";
	aligment = 'ARight';
	-- size = "500x";
	iup.vbox{
		iup.hbox{to_user_name_lab,to_user_name_txt};
		iup.hbox{title_lab,title_txt};
		iup.hbox{iup.fill{},send_btn};
		iup.frame{title="Files:",iup.hbox{file_lst,iup.vbox{add_btn,del_btn}}};
		iup.frame{title="Text:",iup.hbox{content_txt}};
	};
}

-- t={To=,rid=,pid=}
function pop(t)
	t = t or {}
	local files_ = {};

	local function get_id_code()
		local str = '';
		if t.rid then str = str..'ap_this_msg().rid =  '..string.format('%q',t.rid)..'\n' end
		if t.rid then str = str..'ap_this_msg().pid =  '..string.format('%q',t.pid)..'\n' end
		return str;
	end

	local function get_project_code()
		local id = require'sys.mgr'.get_model_id();
		if not id then return "" end
		return 'ap_this_msg().Project_id =  '..string.format('%q',id)..'\n';
	end

	local function get_view_code()
		local smd = require'sys.Group'.get_view{Name=t.Name}
		if not smd then return "" end
		local smd_str = require'sys.table'.tostr(smd);
		return 'ap_this_msg().View='..string.format('%q',smd_str)..' \n';
	end

	local function get_file_code()
		local str = '';
		str = str..'ap_this_msg().Files=ap_this_msg().Files or {}  \n';
		for i,v in ipairs(files_) do
			str = str..'ap_this_msg().Files['..i..']=ap_this_msg().Files['..i..'] or {}  \n';
			str = str..'ap_this_msg().Files['..i..'].hid = '..string.format('%q',v.hid)..' \n';
			str = str..'ap_this_msg().Files['..i..'].Name = '..string.format('%q',v.Name)..' \n';
			str = str..(v.View and 'ap_this_msg().Files['..i..'].View = '..string.format('%q',v.View)..' \n' or "");
		end
		return str;
	end

	local function get_code(t)
		local str = '';
		str = str..'local function f() \n';
		str = str..get_id_code();
		str = str..get_project_code();
		str = str..get_view_code(t);
		str = str..get_file_code();
		str = str..'end \n';
		str = str..'f()\n';
		return str;
	end

	local function send_msg(t)
		require'sys.net.msg'.send_msg{To=t.To,Code=get_code(),Name=t.Name,Text=t.Text,Arrived_Report=true,Read_Report=true,Confirm_Report=true}
	end

	local function init()
		local pmsg = require'sys.net.msg'.get_msg(t.pid);
		to_user_name_txt.value = t.To or require'app.Msg.linkman'.get_selection_user().name;
		title_txt.value = pmsg and pmsg.Name and "Re: "..pmsg.Name or"";
		content_txt.value = "";
		-- file_lst[0] = nil;
		require'sys.api.iup.list'.clear{list=file_lst};
		dlg:show();
	end

	local function on_send()
		local to = to_user_name_txt.value;
		local title = title_txt.value;
		local content = content_txt.value;
		if not to or to=="" then iup.Alarm("Warning","Write To, Please!", "OK") return end
		if not title or title=="" then if iup.Alarm("Warning","No Title?", "OK","Cancel")==1 then title="Untiled" else return end end
--[[		
		if not require"sys.mgr".get_model_zipfile() then 
			local alarm = iup.Alarm("Project","No Local Project, Save it?", "Yes","No","Cancel"); 
			if alarm==1 then 
				require'app.Project.function'.Upload{
					cbf = function()
						send_msg{To=to,Name=title,Text=content};
						require'sys.dock'.active_page(require"app.Msg.list_dlg".get().tabtitle);
					end
				}
			elseif alarm==2 then
				send_msg{To=to,Name=title,Text=content};
				require'sys.dock'.active_page(require"app.Msg.list_dlg".get().tabtitle);
			end
			return
		end
		require'app.Project.function'.Upload{
			cbf = function()
				send_msg{To=to,Name=title,Text=content};
				require'sys.dock'.active_page(require"app.Msg.list_dlg".get().tabtitle);
			end
		}
--]]
		send_msg{To=to,Name=title,Text=content};
		require'sys.dock'.del_page(dlg);
		require'sys.dock'.active_page(require"app.Msg.list_dlg".get());
	end

	function add_btn:action()
		local str = require'sys.iup'.open_file_dlg{}
		if not str or str=='' then return end
		
		local name = require'sys.str'.get_filename(str);
		local hid = require'sys.hid'.get_by_file(str);
		require'sys.net.file'.send{
			name=hid,
			path=str,
			cbf=function() 
				local smd = require'sys.Group'.get_view{Name=name};
				table.insert(files_,{hid=hid,Name=name,View= smd and require'sys.table'.tostr(smd)});
				file_lst[file_lst.count+1] = str;
			end
		}
	end

	function del_btn:action()
		local i = tonumber(file_lst.value);
		table.remove(files_,i);
		file_lst.REMOVEITEM = i;
	end

	function send_btn:action()
		on_send();
	end

	init();
	return dlg;
end

