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
	['Change'] = {
		English = 'Change';
		Chinese = '修改';
	};
}

local lab_wid = '80x'
local btn_wid = '100x'
local username_lab;
local username_txt;
local password_lab ;
local password_txt ;
local password_again_lab ;
local password_again_txt ;
local phone_lab;
local phone_txt ;
local mail_lab ;
local mail_txt;
local ok ;
local cance;
local dlg;
local change_title_;

local function init_controls()
	username_lab = iup.label{rastersize=lab_wid}
	username_txt = iup.text{expand="Yes"}
	password_lab = iup.label{rastersize=lab_wid}
	password_txt = iup.text{expand="Yes",password="Yes"}
	password_again_lab = iup.label{rastersize=lab_wid}
	password_again_txt = iup.text{expand="Yes",password="Yes"}
	phone_lab = iup.label{rastersize=lab_wid}
	phone_txt = iup.text{expand="Yes"}
	mail_lab = iup.label{rastersize=lab_wid}
	mail_txt = iup.text{expand="Yes"}
	ok = iup.button{rastersize=btn_wid}
	cancel = iup.button{rastersize=btn_wid}
end

local function init_dlg(show)
	init_controls()
	
	
	local t = {}
	username_txt.active = 'yes'
	phone_txt.active = 'yes'
	mail_txt.active = 'yes'
	if show then 
		local function change(arg)
			arg = arg or {}
			local title =  change_title_ or 'Change';
			return iup.button{
				title = title;
				action = function() if type(arg.f) == 'function' then arg.f() end end ;
				rastersize = '60x';
			}
		end
		t = {
			iup.hbox{username_lab,username_txt};
			iup.hbox{phone_lab,phone_txt,change()};
			iup.hbox{mail_lab,mail_txt,change()};
			iup.hbox{iup.fill{},cancel};
		}
		username_txt.active = 'no'
		-- phone_txt.active = 'no'
		-- mail_txt.active = 'no'
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
	
	dlg  = iup.dialog{
		rastersize = "500x";
		aligment = 'ARight';
		iup.vbox(t);
		margin = "8x8";
	};
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
	change_title_ =  language_package_.Change[lan]
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


local function save(gid)
	local path = 'app/projectmgr/data/'
	local file = path .. gid
	local data = {
		gid = gid;
		projects={};--工程列表
		friends={};--好友列表
		private_folder={};--私人文件夹
		family={};--族库
		recycle={};--回收站
	}
	require 'sys.api.code'.save{file = file,data = data,key = 'db'}
	require 'sys.net.file'.send{
		cbf = function() dlg:hide();end ;
		name = gid,
		path =file;
	}
end

--t = {language = ,show =true}
function pop(t)
	t= t or {}
	local user = {name="",password=""};
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
		local gid = require'luaext'.guid();
		require'sys.net.user'.reg{
			user=username,
			password=password,
			mail=mail,
			phone=phone,
			gid = gid;
			cbf=function(str)
				trace_out('Register:'..str..'\n')
				if string.upper(str) == 'OK' then
					user.name = username;
					user.password = password;
					save(gid)
				else
					iup.Message("Warning","Username already registered") 
				end
			end
		}
	end
	
	
	local function init_callback()
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
	
	end
	
	local function init()	
		init_dlg(t.show)
		init_language(t.language)
		init_data(t.data)
		init_callback()
		
	end
	
	init();
	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};
	dlg:popup();
	return user;
end

