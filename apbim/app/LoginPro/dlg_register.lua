_ENV = module(...,ap.adv)

local iup = require"iuplua";
local language_ = require 'sys.language'
local default_language_ = 'English'
local language_package_ = {
	__support = {English = 'English',Chinese = 'Chinese'};
	['cancel'] = {
		English = 'Cancel';
		Chinese = '取消';
	};
	['Register'] = {
		English = 'Register';
		Chinese = '注册';
	};
	['Username'] = {
		English = 'Username : ';
		Chinese = '用户名 ： ';
	};
	['Password'] = {
		English = 'Password : ';
		Chinese = '密码 ： ';
	};
	['confirm'] = {
		English = 'Confirm : ';
		Chinese = '确认密码 ： ';
	};
	['Mail'] = {
		English = 'Mail : ';
		Chinese = '邮箱 ： ';
	};
	['Phone'] = {
		English = 'Phone : ';
		Chinese = '电话 ： ';
	};
}

local lab_wid = '80x'
local btn_wid = '100x'
local username_lab = iup.label{rastersize=lab_wid}
local username_txt = iup.text{expand="Yes"}
local password_lab = iup.label{rastersize=lab_wid}
local password_txt = iup.text{expand="Yes",password="Yes"}
local password_again_lab = iup.label{rastersize=lab_wid}
local password_again_txt = iup.text{expand="Yes",password="Yes"}
local phone_lab = iup.label{rastersize=lab_wid}
local phone_txt = iup.text{expand="Yes"}
local mail_lab = iup.label{rastersize=lab_wid}
local mail_txt = iup.text{expand="Yes"}
local ok = iup.button{rastersize=btn_wid}
local cancel = iup.button{rastersize=btn_wid}
local dlg;
local function get_status(status,f)
	if not status then return end 
	f()
end 

local function init_dlg(show)
	local t = {}
	username_txt.active = 'yes'
	phone_txt.active = 'yes'
	mail_txt.active = 'yes'
	if show then 
		t = {
			iup.hbox{username_lab,username_txt};
			iup.hbox{phone_lab,phone_txt};
			iup.hbox{mail_lab,mail_txt};
			iup.hbox{iup.fill{},cancel};
		}
		username_txt.active = 'no'
		phone_txt.active = 'no'
		mail_txt.active = 'no'
	else 
		t = {
			iup.hbox{username_lab,username_txt};
			iup.hbox{password_lab,password_txt};
			iup.hbox{password_again_lab,password_again_txt};
			iup.hbox{phone_lab,phone_txt};
			iup.hbox{mail_lab,mail_txt};
			iup.hbox{iup.fill{},ok,cancel};
		}
	end 
	dlg = iup.dialog{
		rastersize = "500x";
		aligment = 'ARight';
		iup.vbox(t);
	}
end


local function init_language(lan)
	lan = lan or  language_.get()
	lan = lan and language_package_.__support[lan] or default_language_;
	username_lab.title = language_package_.Username[lan]
	password_lab.title = language_package_.Password[lan]
	password_again_lab.title = language_package_.confirm[lan]
	phone_lab.title = language_package_.Phone[lan]
	mail_lab.title = language_package_.Mail[lan]
	ok.title =  language_package_.Register[lan]
	cancel.title =  language_package_.cancel[lan]
	dlg.title =  language_package_.Register[lan]
end

local function init_data(data)
	data = data or {}
	username_txt.value = "";
	password_txt.value = "";
	password_again_txt.value = "";
	username_txt.value = data.name;
	phone_txt.value = data.phone
	mail_txt.value = data.mail
end

--t = {language = ,show =true}
function pop(t)
	t= t or {}
	local user = {name="",password=""};

	local function init()	
		init_dlg(t.show)
		init_language(t.language)
		init_data(t.data)
		
	end
	
	local function on_ok()
		local username = username_txt.value;
		local password = password_txt.value;
		local password_again = password_again_txt.value;
		local phone = phone_txt.value;
		local mail = mail_txt.value;
		if not username or username=='' then iup.Alarm("Warning","Input username","OK") return end
		if not password or password=='' then iup.Alarm("Warning","Input password","OK") return end
		if not phone then iup.Alarm("Warning","Input Pone") return end
		if not mail then iup.Alarm("Warning","Input Mail") return end
		if password~=password_again then iup.Alarm("Warning","Passwords does not match","OK") return end
		require'sys.net.user'.reg{
			user=username,
			password=password,
			mail=mail,
			phone=phone,
			cbf=function(gid)
				trace_out('Register:'..gid..'\n')
				if string.upper(gid) == 'OK' then
					user.name = username;
					user.password = password;
					dlg:hide();
				else
					iup.Message("Warning","Username already registered") 
				end
			end
		}
	end
	
	local function on_cancel()
		dlg:hide();
	end
	
	function ok:action()
		if t.show then return end 
		on_ok();
	end
	
	function cancel:action()
		on_cancel();
	end
	

	
	init();
	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};
	dlg:popup();
	return user;
end

