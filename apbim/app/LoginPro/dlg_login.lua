
_ENV = module(...,ap.adv)

local iup = require"iuplua";
local language_ = require 'sys.language'
local default_language_ = 'English'
local language_package_ = {
	__support = {English = 'English',Chinese = 'Chinese'};
	['Login'] = {
		English = 'Login';
		Chinese = '登陆';
	};
	['Logout'] = {
		English = 'Logout';
		Chinese = '登出';
	};
	['cancel'] = {
		English = 'Cancel';
		Chinese = '取消';
	};
	['Username'] = {
		English = 'Username : ';
		Chinese = '用户名： ';
	};
	['Password'] = {
		English = 'Password : ';
		Chinese = '密码： ';
	};
	['Register'] = {
		English = 'Register';
		Chinese = '注册';
	};
	['keep'] = {
		English = 'Keep Password';
		Chinese = '保存密码';
	};
	
	
}

local user_name_ = nil;

function get_user()
	return user_name_;
end
local lab_wid = '80x'
local btn_wid = '100x'
local username_lab = iup.label{rastersize=lab_wid}
local username_txt = iup.list{expand="Yes",editbox="Yes",DROPDOWN="Yes"}
local password_lab = iup.label{rastersize=lab_wid}
local password_txt = iup.text{expand="Yes",password="Yes"}
local register_btn = iup.button{rastersize = btn_wid}
local keep_tog = iup.toggle{}
local ok = iup.button{rastersize = btn_wid}
local cancel = iup.button{rastersize = btn_wid}



local dlg = iup.dialog{
	rastersize = "500x";
	aligment = 'ARight';
	margin = "5x5";
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
	s.__LAST = name
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
			-- print('gid',gid)
			require 'sys.user'.set{user = t.user,gid = gid}
			-- require"sys.net.test".test();
			-- require"sys.statusbar".show_user(require"sys.mgr".get_user());
			--require'sys.api.dos'.md(require'sys.mgr'.get_user_path());
		end
	}
end

local function show_user(t)
	username_txt.value = t.user;
	password_txt.value = t.password;
	keep_tog.value = "ON";
end

local function init_language(lan)
	lan = lan or  language_.get()
	lan = lan and language_package_.__support[lan] or default_language_;
	username_lab.title = language_package_.Username[lan]
	password_lab.title = language_package_.Password[lan]
	register_btn.title = language_package_.Register[lan]
	keep_tog.title = language_package_.keep[lan]
	ok.title = language_package_.Login[lan]
	cancel.title = language_package_.cancel[lan]
	dlg.title =  language_package_.Login[lan]
end

-- t={on_ok=function,on_cancel,language}
function pop(t)
	local function init_list()
		local us = get_user_list();
		local ks = require'sys.table'.sortk(us);
		username_txt[0] = nil;
		local num = 0
		for i,v in ipairs(ks) do
			if v ~= '__LAST' then 
				num = num +1
				username_txt[num]=v;
				if us.__LAST and v ==  us.__LAST then 
					username_txt.value = v
					dlg.STARTFOCUS = password_txt
				end
			end
			-- local str = us[v];
			-- if type(str)=='string' and v==get_user_d() then
				-- login{user=v,password=str,on_ok=t.on_ok,keep=true}
				-- show_user{user=v,password=str,on_ok=t.on_ok,keep=true}
			-- end
		end
	end

	local function init()
		init_language(t.language)
		init_list()
		password_txt.value = ''
	end
	
	local function on_ok()
		login{user=username_txt.value,password=password_txt.value,on_ok=t.on_ok,keep=keep_tog.value=="ON" and true}
	end
	local function on_cancel()
		dlg:hide();
		if type(t.on_cancel) == 'function' then 
			t.on_cancel()
		end
	end
	function register_btn:action()
		--local user = require'sys.interface.register_dlg'.pop();
		local user = require'app.LoginPro.dlg_register'.pop();
		username_txt.value = user.name;
		password_txt.value = user.password;
	end
	function ok:action()
		on_ok();
	end
	function cancel:action()
		on_cancel();
	end
	
	function dlg:close_cb()
		on_cancel();
	end
	-- local cbfs={};
	-- cbfs[iup.K_CR] = on_ok;
	-- function dlg:k_any(n)
		-- if cbfs[n] then cbfs[n](t) end
	-- end

	init();
		require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};

	dlg:popup();
end

