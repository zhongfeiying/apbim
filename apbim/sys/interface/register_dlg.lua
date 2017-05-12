_ENV = module(...,ap.adv)

local iup = require"iuplua";

local username_lab = iup.label{title="Username:",size="50x"}
local username_txt = iup.text{expand="Yes"}
local password_lab = iup.label{title="Password:",size="50x"}
local password_txt = iup.text{expand="Yes",password="Yes"}
local password_again_lab = iup.label{title="Password:",size="50x"}
local password_again_txt = iup.text{expand="Yes",password="Yes"}
local phone_lab = iup.label{title="Phone:",size="50x"}
local phone_txt = iup.text{expand="Yes"}
local mail_lab = iup.label{title="Mail:",size="50x"}
local mail_txt = iup.text{expand="Yes"}
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
		iup.hbox{password_again_lab,password_again_txt};
		iup.hbox{phone_lab,phone_txt};
		iup.hbox{mail_lab,mail_txt};
		iup.hbox{iup.fill{},ok,cancel};
	}
}

function pop()
	local user = {name="",password=""};

	local function init()
		username_txt.value = "";
		password_txt.value = "";
		password_again_txt.value = "";
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
					iup.Alarm("Warning","Username already registered") 
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
	

	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};
	init();
	dlg:popup();
	return user;
end

