_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local path_ = 'cfg/user/'
local name_ = (require"sys.mgr".get_user() or '')..'__project_list.lua'
local file_ = path_..name_

local mat_ = iup.matrix{READONLY="YES",resizematrix="YES"};
local txt_ = iup.text{expand="Horizontal"};
local add_btn_ = iup.button{title='Add',rastersize='100x'};
local del_btn_ = iup.button{title='Delete',rastersize='100x'};
local mdf_btn_ = iup.button{title='Modify',rastersize='100x'};

local dlg = iup.vbox{
	title = "Projects";
	tabtitle = "Projects";
	margin = "5x5";
	alignment = "aRight";
	-- size = "800x800";
	iup.frame{
		title = "Cloud Projects";
		iup.vbox{
			iup.frame{
				iup.vbox{
					iup.hbox{txt_};
					iup.hbox{iup.fill{};mdf_btn_,add_btn_,del_btn_,};
				};
			};
			iup.frame{
				iup.hbox{mat_};
			};
		};
	};
}

local mat_fields_ = {
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
	{
		Width = 100;
		Head = "Project";
		Text = function(k,v,s)
			return v.Name;
		end
	};
	{
		Width = 125;
		Head = "Remark";
		Text = function(k,v,s)
			return v.Remark;
		end
	};
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
};

function get()
	return dlg;
end

-- t={id=,Name=,Remark=}
function add(t)
	if not t.id then return end
	local dat = require'sys.io'.read_file{file=file_} or {}
	dat[t.id] = dat[t.id] or {};
	dat[t.id].Name = t.Name or dat[t.id].Name;
	dat[t.id].Remark = t.Remark or dat[t.id].Remark;
	-- dat[t.id] = {Name=t.Name,Remark=t.Remark};
	require'app.Contacts.File.file_op'.save_table_to_file(file_,dat)
	require'sys.net.file'.putkey{name=name_,path=path_};
	pop();
end

function del(t)
	if not t.id then return end
	local dat = require'sys.io'.read_file{file=file_} or {}
	dat[t.id] = require'app.Contacts.interface'.get_nil_f();
	require'app.Contacts.File.file_op'.save_table_to_file(file_,dat)
	require'sys.net.file'.putkey{name=name_,path=path_};
	pop();
end

-- require'sys.table'.tofile{file=file_,src={}}

-- t={filter=}
function pop(t)
	t = t or {};

	local function init_mat()
		local dat = require'sys.io'.read_file{file=file_,key='db'}
		require'sys.api.iup.matrix'.init_head{mat=mat_,fields=mat_fields_};
		require'sys.api.iup.matrix'.init_list{mat=mat_,fields=mat_fields_,dat=dat,minlin=50,sortf=function(k) return tostring(dat[k].Name) end};
	end

	local function init()
		init_mat();
		dlg:show();
	end

	local function on_look()
		if iup.Alarm("Open Cloud Project","Open the Cloud Project and Close the current Project?","OK","Cancel")~=1 then return end;
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=mat_,col=1};
		require'app.Project.function'.close();
		require'app.Project.function'.open_id{id=id};
	end

	local function on_select_lin()
		require'sys.api.iup.matrix'.select_lin{mat=mat_}
	end
	
	function mat_:click_cb(lin,col,str)
		local txt = require'sys.api.iup.matrix'.get_selection_lin_text{mat=mat_,col=3};
		txt_.value = txt;
		if string.find(str,"1") and string.find(str,"D") then on_look() end
		on_select_lin();
	end
	
	-- function mat_:action()
	-- end
	
	function add_btn_:action()
		add{id=require'sys.mgr'.get_model_id(),Name=require'sys.mgr'.get_model_name(),Remark=require'sys.mgr'.get_user().."'s Project."};
	end
	
	function del_btn_:action()
		del{id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=mat_,col=1};}
	end
	
	function mdf_btn_:action()
		add{id=require'sys.api.iup.matrix'.get_selection_lin_text{mat=mat_,col=1};Remark=txt_.value};
	end
	
	init();
	require'sys.net.file'.get{name=name_,path=path_,cbf=init};
	-- open();
	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_look};
	require'sys.net.msg'.resgister_rcvf(init);
	return dlg;
end

