_ENV = module(...,ap.adv)

local iup = require"iuplua";

local username_lab = iup.label{title="Username:",size="80x"}
local username_txt = iup.text{expand="Yes",readonly="Yes"}
local password_lab = iup.label{title="Old Password:",size="80x"}
local password_txt = iup.text{expand="Yes",password="Yes"}
local password_new_lab = iup.label{title="New Password:",size="80x"}
local password_new_txt = iup.text{expand="Yes",password="Yes"}
local password_again_lab = iup.label{title="New Password:",size="80x"}
local password_again_txt = iup.text{expand="Yes",password="Yes"}
local ok = iup.button{title="OK",size="60x"}
local cancel = iup.button{title="Cancel",size="60x"}

local dlg = iup.dialog{
	size = "300x";
	title = "Password";
	margin = "5x5";
	aligment = 'ARight';
	iup.vbox{
		iup.hbox{username_lab,username_txt};
		iup.hbox{password_lab,password_txt};
		iup.hbox{password_new_lab,password_new_txt};
		iup.hbox{password_again_lab,password_again_txt};
		iup.hbox{iup.fill{},ok,cancel};
	}
}

function pop()

	local function init()
		username_txt.value = require'sys.mgr'.get_user();
		password_txt.value = "";
		password_new_txt.value = "";
		password_again_txt.value = "";
	end
	
	local function on_ok()
		local username = username_txt.value;
		local password = password_txt.value;
		local password_new = password_new_txt.value;
		local password_again = password_again_txt.value;
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
	

	require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_ok,[iup.K_ESC]=on_cancel};
	init();
	dlg:popup();
end

