_ENV = module(...,ap.adv)

local iup = require"iuplua";

local user_name_ = nil;
function get_user()
	return user_name_;
end

local username_lab = iup.label{title="Username:",size="50x"}
local username_txt = iup.list{expand="Yes",editbox="Yes",DROPDOWN="Yes"}
-- local username_txt = iup.list{expand="Yes",editbox="Yes",DROPDOWN="Yes","BETTER","BETTER_1","zgb","sjy","BETTER_2"}
local password_lab = iup.label{title="Password:",size="50x"}
local password_txt = iup.text{expand="Yes",password="Yes"}
local register_btn = iup.button{title="Register",size="60x"}
local keep_tog = iup.toggle{title="Keep Password",size="80x"}
local ok = iup.button{title="OK",size="60x"}
local cancel = iup.button{title="Cancel",size="60x"}

local dlg = iup.dialog{
	size = "300x";
	title = "Login";
	margin = "5x5";
	aligment = 'ARight';
	iup.vbox{
		iup.hbox{username_lab,username_txt};
		iup.hbox{password_lab,password_txt};
		iup.hbox{register_btn,iup.fill{},ok,cancel};
	}
}

local login_d_file_ = "cfg/login_D.lua";
local function get_user_d()
	local s = require"sys.io".read_file{file=login_d_file_};
	return s;
end

local login_list_file_ = "cfg/login.lua";
local function get_user_list()
	local s = require"sys.io".read_file{file=login_list_file_};
	if type(s)~="table" then s={} end
	return s;
end

local function add_user_to_list(name,pswd,keep)
	local s = get_user_list()
	s[name]= keep and pswd or true;
	require'sys.table'.tofile{file=login_list_file_,src=s};
end

local function login(t)
	-- require'sys.net.msg'.open()
	require'sys.net.user'.login{
		user=t.user;
		password=t.password;
		cbf=function(gid)
			if gid=='-1' then iup.Alarm("Error","User Cann't Login.","OK") return end
			user_name_=t.user;
			dlg:hide();
			trace_out("Login:"..user_name_.."\n");
			t.on_ok();
			add_user_to_list(t.user,t.password,t.keep);
			-- require"sys.net.test".test();
			-- require"sys.statusbar".show_user(require"sys.mgr".get_user());
			require'sys.api.dos'.md(require'sys.mgr'.get_user_path());
		end
	}
end

local function show_user(t)
	username_txt.value = t.user;
	password_txt.value = t.password;
	keep_tog.value = "ON";
end

-- t={on_ok=function}
function pop(t)
	local function init_list()
		local us = get_user_list();
		local ks = require'sys.table'.sortk(us);
		username_txt[0] = nil;
		for i,v in ipairs(ks) do
			username_txt[i]=v;
			local str = us[v];
			-- if type(str)=='string' and v==get_user_d() then
				-- login{user=v,password=str,on_ok=t.on_ok,keep=true}
				-- show_user{user=v,password=str,on_ok=t.on_ok,keep=true}
			-- end
		end
	end

	local function init()
		init_list()
	end
	
	local function on_ok()
		login{user=username_txt.value,password=password_txt.value,on_ok=t.on_ok,keep=keep_tog.value=="ON" and true}
	end
	local function on_cancel()
		dlg:hide();
	end
	function register_btn:action()
		local user = require'sys.interface.register_dlg'.pop();
		username_txt.value = user.name;
		password_txt.value = user.password;
	end
	function ok:action()
		on_ok();
	end
	function cancel:action()
		on_cancel();
	end
	
	-- local cbfs={};
	-- cbfs[iup.K_CR] = on_ok;
	-- function dlg:k_any(n)
		-- if cbfs[n] then cbfs[n](t) end
	-- end
	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};

	init();
	dlg:popup();
end

