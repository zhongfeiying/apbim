_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local msg_mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES",numcol_visible=4};

local dlg = iup.vbox{
	title = "Message";
	tabtitle = "Message";
	margin = "5x5";
	alignment = "aRight";
	-- size = "800x800";
	iup.vbox{
		iup.hbox{msg_mat_};
	};
}

local msg_mat_fields_ = {
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
	-- {
		-- Width = 100;
		-- Head = "Project";
		-- Text = function(k,v,s)
			-- return v.Project_id;
		-- end
	-- };
	{
		Width = 50;
		Head = "From";
		Text = function(k,v,s)
			return v.From;
		end
	};
	{
		Width = 50;
		Head = "To";
		Text = function(k,v,s)
			return v.To;
		end
	};
	{
		Width = 100;
		Head = "Title";
		Text = function(k,v,s)
			return v.Name;
		end
	};
	{
		Width = 30;
		Head = "State";
		Text = function(k,v,s)
			local str = "";
			if v.Arrived then str = str.."*" end
			if v.Read then str = str.."*" end
			if type(v.Confirm)=='string' then str ="X" elseif v.Confirm then str = str.."*" end
			return str;
		end
	};
	{
		Width = 100;
		Head = "Time";
		Text = function(k,v,s)
			return require"sys.dt".time_text(v.Send_Time);
		end
	};
};

function get()
	return dlg;
end

-- t={filter=}
function pop(t)
	t = t or {};
	require"sys.statusbar".show_user(require"sys.mgr".get_user());
	-- dlg.title =  require"sys.mgr".get_user()..' - '..require'app.Msg.linkman'.get_selection_user().name;

	
	local function init_msg_mat()
		local filter = t.filter or function() return true end;
		local msgs = require'sys.table'.filter(require'sys.net.msg'.get_all(),filter);
		require'sys.api.iup.matrix'.init_head{mat=msg_mat_,fields=msg_mat_fields_};
		require'sys.api.iup.matrix'.init_list{mat=msg_mat_,fields=msg_mat_fields_,dat=msgs,minlin=50,sortf=function(k) return tonumber(msgs[k].Send_Time) end};
	end

	local function init()
		init_msg_mat();
		dlg:show();
	end

	-- local function open()
		-- require'sys.net.msg'.open();
		-- init();
		-- require'sys.net.msg'.download{cbf=function()
			-- require'sys.net.msg'.open();
			-- init();
			-- require'sys.net.msg'.save();
			-- require'sys.net.msg'.upload();
		-- end}
	-- end
	
	local function on_look()
		local msgs = require'sys.net.msg'.get_all();
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=msg_mat_,col=1};
		if not msgs[id] then return end
		if type(msgs[id].Read_cbf)=="function" then msgs[id].Read_cbf() end
		-- require'app.Msg.look_dlg'.pop{id=id};
		require'sys.dock'.add_page(require"app.Msg.look_dlg".pop{id=id});
		require'sys.dock'.active_page(require"app.Msg.look_dlg".pop{id=id});
	end

	local function on_select_lin()
		require'sys.api.iup.matrix'.select_lin{mat=msg_mat_}
	end
	
	function msg_mat_:click_cb(lin,col,str)
		if string.find(str,"1") and string.find(str,"D") then on_look() end
		on_select_lin();
	end
	
	init();
	-- open();
	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_look};
	require'sys.net.msg'.resgister_rcvf(init);
	return dlg;
end

