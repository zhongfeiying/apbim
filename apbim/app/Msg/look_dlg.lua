_ENV = module(...,ap.adv)

local iup = require'iuplua'

local from_user_name_lab = iup.label{title='From:',size='50x'};
local from_user_name_txt = iup.list{expand='Horizontal',editbox="Yes",DROPDOWN="Yes"};
local to_user_name_lab = iup.label{title='To:',size='50x'};
local to_user_name_txt = iup.list{expand='Horizontal',editbox="Yes",DROPDOWN="Yes"};
local title_lab = iup.label{title='Title:',size='50x'};
local title_txt = iup.list{expand='Horizontal',editbox="Yes",DROPDOWN="Yes"};
local file_lst = iup.list{expand='Horizontal',size='x42'};
local content_txt = iup.text{expand='Yes',MULTILINE="Yes"};
local file_view_btn = iup.button{title="Open View",size="60x"}
local file_open_btn = iup.button{title="Open File",size="60x"}
local file_download_btn = iup.button{title="Download",size="60x"}
local project_btn = iup.button{title="Open Message Project",size="100x"}
local view_btn = iup.button{title="Open Message View",size="100x"}
local reply_btn = iup.button{title="Reply",expand='Horizontal'}

local dlg = iup.vbox{
	title = require'sys.mgr'.get_user().." 's Message";
	tabtitle = "Message Detailed";
	margin = "5x5";
	aligment = 'ARight';
	-- size = "500x";
	iup.vbox{
		iup.hbox{from_user_name_lab,from_user_name_txt};
		iup.hbox{to_user_name_lab,to_user_name_txt};
		iup.hbox{title_lab,title_txt};
		iup.hbox{project_btn,view_btn,reply_btn};
		iup.frame{title="Files:",iup.hbox{file_lst,iup.vbox{file_view_btn,file_open_btn,file_download_btn,}}};
		iup.frame{title="Text:",iup.hbox{content_txt}};
	};
}

-- t={id=}
function pop(t)
	if not t then return dlg end

	local msg = require'sys.net.msg'.get_msg(t.id);
	-- dlg.tabtitle = "Message:"..msg.Name;
	
	local function get_list_selection_item(list)
		return tonumber(list.value);
	end
	
	local function open_project()
		if not msg then return end
		if not msg.Project_id then iup.Alarm("Warning","No Project","OK") return end
		require'app.Project.function'.open_id{id=msg.Project_id};
		require"sys.statusbar".update();
	end

	local function open_view(str)
		if not str then iup.Alarm("Warning","No View","OK") return end
		if msg and msg.Project_id~=require'sys.mgr'.get_model_id() then iup.Alarm("Warning","Open Project, Please","OK") return end
		
		require'sys.Group'.open_group_by_str(str);
		-- if not msg then return end
		-- require'app.Project.function'.open_id{
			-- id = msg.Project_id;
			-- cbf = function()
				-- require'sys.Group'.open_group_by_str(str);
			-- end
		-- };
	end

	local function init()
		if not msg then return end
		from_user_name_txt.value = msg.From;
		to_user_name_txt.value = msg.To;
		title_txt.value = msg.Name;
		require'sys.api.iup.list'.init{list=file_lst,dat=msg.Files,textf=function(k,v) return v.Path or v.Name end};
		content_txt.value = msg.Text;
		dlg:show();
	end

	local function on_reply()
		if not msg then return end
		open_project();
		require'sys.dock'.active_page(require'app.Msg.send_dlg'.pop{To=msg.From,rid=msg.rid or t.id,pid=t.id});
	end

	function project_btn:action()
		open_project();
	end
	
	function view_btn:action()
		if not msg then return end
		open_view(msg.View)
	end
	
	local function download_file(open)
		local i = get_list_selection_item(file_lst);
		if not i then return end
		if not msg then return end
		if not msg.Files then return end
		if not msg.Files[i] then return end
		
		local str = require'sys.api.iup.file_dlg'.save{name=msg.Files[i].Path or msg.Files[i].Name,exname=require'sys.str'.get_exname(msg.Files[i].Name)}
		if not str or str=='' then return end
		require'sys.net.file'.get{
			name = msg.Files[i].hid,
			path = str,
			cbf = function()
				file_lst[i] = str;
				msg.Files[i].Path = str;
				require'sys.net.msg'.update();
				if open and require'sys.io'.is_there_file{file=str} then require'sys.api.dos'.start(str) return end
			end
		}
	end

	function file_download_btn:action()
		 download_file();
	end

	function file_open_btn:action()
		local i = get_list_selection_item(file_lst);
		if not i then return end
		if not msg then return end
		if not msg.Files then return end
		if not msg.Files[i] then return end
		
		local pathname = msg.Files[i].Path;
		if pathname and require'sys.io'.is_there_file{file=pathname} then require'sys.api.dos'.start(pathname) return end
		-- if pathname then os.execute('start """'..pathname..'"\n') end
		 download_file(true);
	end
	
	function file_view_btn:action()
		local i = get_list_selection_item(file_lst);
		if not i then return end
		if not msg then return end
		if not msg.Files then return end
		if not msg.Files[i] then return end
		open_view(msg.Files[i].View)
	end
	
	function reply_btn:action()
		on_reply();
	end
	
	init();
	return dlg;
end

