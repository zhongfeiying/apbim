_ENV = module(...,ap.adv)

function set_dlg_title(DlgTitle)
	return ' ap_this_msg().DlgTitle = [==['.. DlgTitle .. ']==] \n';
end

function set_dlg_msg(DlgMsg)
	return ' ap_this_msg().DlgMsg = [==['.. DlgMsg .. ']==] \n';
end

function set_dlg_btn1(Dlgbtn1)
	return ' ap_this_msg().Dlgbtn1 = [==['.. Dlgbtn1 .. ']==] \n';
end

function set_dlg_btn2(Dlgbtn2)
	return ' ap_this_msg().Dlgbtn2 = [==['.. Dlgbtn2 .. ']==] \n';
end


function set_msg_type(MsgType)
	return ' ap_this_msg().MsgType = [==['.. MsgType .. ']==] \n';
end

function set_group_name(GroupName)
	return ' ap_this_msg().GroupName = [==['.. GroupName .. ']==] \n';
end

function set_group_id(Groupid)
	return ' ap_this_msg().GroupId = [==['.. Groupid .. ']==] \n';
end

function set_group_note(note)
	return ' ap_this_msg().GroupNote = [==['.. note .. ']==] \n';
end


function set_group_exe()
	local path = "app.Contacts.dlg.dlg_group_invite"
	return ' ap_this_msg().exe_file =  [==['.. path .. ']==] \n';
end

function set_cmd_type(str)
	return ' ap_this_msg().CmdType =  [==['.. str .. ']==] \n';
end 


function set_send_files(files)
	local str = 'ap_this_msg().Files = {} \n'
	for k,v in pairs (files) do 
		str = str .. 'ap_this_msg().Files[\"' .. v.Hid .. '\"] = {} \n'
		for m,n in pairs (v) do
			if type(n) ~= "function" and type(n) ~= "userdata" and type(n) ~= "table" then 
			str = str .. 'ap_this_msg().Files[\"' .. v.Hid .. '\"][\"' .. m .. '\"] = \"' .. tostring(string.gsub(n,"\\","/")) .. '\" \n'
			end 
		end 
	end 
	return str
end

function set_send_viewname(viewname)
	--local str = 'ap_this_msg().Views = {} \n'
	return 'ap_this_msg().ViewName = [==[' .. viewname .. ']==]'
end

function set_send_view_ifo(smd_str)
	return 'ap_this_msg().View='..string.format('%q',smd_str)..' \n';
end 



function set_view_members(members)
	--local str = 'ap_this_msg().Views = {} \n'
	local smd_str = "return "..require'sys.table'.tostr(members);
	return 'ap_this_msg().ViewMembers = [==[' .. smd_str .. ']==]'
end

function set_send_selected_name(name)
	if not name then return '' end
	return 'ap_this_msg().SelectedName =[==[' .. name .. ']==]'
end 

function set_send_selected(str)
	return 'ap_this_msg().Selected = [==[' .. str .. ']==]'
end

function set_msg_pid(id)
	return 'ap_this_msg().Pid = [==[' .. id .. ']==]'
end

function get_project_code()
	local id = require'sys.mgr'.get_model_id();
	if not id then return "" end
	return 'ap_this_msg().Project_id =  '..string.format('%q',id)..'\n';
end


function set_project_id(id)
	if not id then return '' end 
	return ' ap_this_msg().CurProjectId = [==[' .. id .. ']==] \n';
end

function set_project_filename(name)
	if not name then return '' end
	return ' ap_this_msg().CurProjectFileName = [==[' .. name .. ']==]  \n';
end

function set_view_id(id)
	if not id then return '' end
	return ' ap_this_msg().CurViewId = [==[' .. id .. ']==] \n';
end



