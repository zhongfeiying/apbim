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
	['Username'] = {
		English = 'Username : ';
		Chinese = '用户名 ： ';
	};
	['Password'] = {
		English = 'Change Password';
		Chinese = '修改密码';
	};
	['old'] = {
		English = 'Old : ';
		Chinese = '旧密码 ： ';
	};
	['new'] = {
		English = 'New : ';
		Chinese = '新密码 ： ';
	};
	['confirm'] = {
		English = 'Confirm : ';
		Chinese = '确认 ： ';
	};
	['ok'] = {
		English = 'Ok';
		Chinese = '确定';
	};
	
}
local lab_wid = '80x'
local btn_wid = '100x'

local username_lab = iup.label{rastersize=lab_wid}
local username_txt = iup.text{expand="Yes",readonly="Yes"}
local password_lab = iup.label{rastersize=lab_wid}
local password_txt = iup.text{expand="Yes",password="Yes"}
local password_new_lab = iup.label{rastersize=lab_wid}
local password_new_txt = iup.text{expand="Yes",password="Yes"}
local password_again_lab = iup.label{rastersize=lab_wid}
local password_confirm = iup.text{expand="Yes",password="Yes"}
local ok = iup.button{rastersize=btn_wid}
local cancel = iup.button{rastersize=btn_wid}

local dlg = iup.dialog{
	rastersize = "500x";
	
	aligment = 'ARight';
	iup.vbox{
		-- iup.hbox{username_lab,username_txt};
		iup.hbox{password_lab,password_txt};
		iup.hbox{password_new_lab,password_new_txt};
		iup.hbox{password_again_lab,password_confirm};
		iup.hbox{iup.fill{},ok,cancel};
		margin = "8x8";
	}
}

local function init_language(lan)
	lan = lan or  language_.get()
	lan = lan and language_package_.__support[lan] or default_language_;
	username_lab.title = language_package_.Username[lan]
	password_lab.title = language_package_.old[lan]
	password_new_lab.title = language_package_.new[lan]
	password_again_lab.title = language_package_.confirm[lan]
	ok.title = language_package_.ok[lan]
	cancel.title = language_package_.cancel[lan]
	dlg.title =  language_package_.Password[lan]
end

--t = {language,}
function pop(t)
	t = t or {}
	local function init()
		init_language(t.language)
		-- username_txt.value = require'sys.user'.get().user;
		-- username_txt.active = active
		password_txt.value = "";
		password_new_txt.value = "";
		password_confirm.value = "";
	end
	
	local function on_ok()
		local username =require'sys.user'.get().user;-- username_txt.value;
		local password = password_txt.value;
		local password_new = password_new_txt.value;
		local password_again = password_confirm.value;
		if not username or username=='' then iup.Alarm("Warning","Input username","OK") return end
		if not password or password=='' then iup.Alarm("Warning","Input Old password","OK") return end
		if not password_new or password_new=='' then iup.Alarm("Warning","Input New password","OK") return end
		if password_new~=password_again then iup.Alarm("Warning","New Passwords does not match","OK") return end
		require'sys.net.user'.passwd{
			user=username,
			password=password,
			password_new=password_new,
			cbf=function(gid)
				trace_out('Register:'..gid..'\n')
				if string.upper(gid) == 'OK' then
					dlg:hide();
				else
					iup.Alarm("Warning","Old Password is wrong.","OK") 
				end
			end
		}
	end
	
	local function on_cancel()
		dlg:hide();
	end
	
	function ok:action()
		on_ok();
	end
	
	function cancel:action()
		on_cancel();
	end
	


	init();
		require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};
	dlg:popup();
end

