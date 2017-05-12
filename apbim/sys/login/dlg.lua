_ENV = module(...,ap.adv)

local iup = require "iuplua"
local iupcontrol = require( "iupluacontrols" )

local wid = "100X"
local name_lab_ = iup.label{title="Name:",rastersize=wid};
local name_txt_ = iup.text{expand="HORIZONTAL"};
local pass_lab_ = iup.label{title="Password:",rastersize=wid};
local pass_txt_ = iup.text{expand="HORIZONTAL",password="YES"};
local pass_tog_ = iup.toggle{title="Auto Login",rastersize="200X"};
	--std
local ok 		= iup.button{title="OK"		,rastersize="60X30"};
local cancel 	= iup.button{title="Cancel"	,rastersize="60X30"};

local function tabs()
	return 
	iup.vbox{
		tabtitle = "User";
		iup.hbox{name_lab_,name_txt_};
		iup.hbox{pass_lab_,pass_txt_};
		-- iup.hbox{pass_tog_};
	};
end

local dlg_ = iup.dialog
{
	iup.vbox
	{
		tabs();
		iup.hbox{ok,cancel};
		margin="10x10";
		alignment="ARIGHT"
	};
	title="Login";
	size="320x";
}

----operate---

-- arg={ok=}
function pop(arg)
	if type(arg)~="table" then return end
	if type(arg.ok)~="function" then return end

	local function init()
		-- name_txt_.value = require"user_info".read_config().name;
		-- pass_txt_.value = require"user_info".read_config().pass;
	end


	local function add_user_flag(str)
		add_menu(frm,
			{	
				name = str,
				items = {},
			}
		);
	end


	local function on_ok()
		if name_txt_.value=="" then 
			trace_out("Name cann't enmpty.\n") 
			return 
		end;
		if pass_txt_.value=="" then 
			trace_out("Password cann't enmpty.\n") 
			return 
		end;
		arg.ok();
		dlg_:hide();
	end

	function ok:action()
		on_ok();
	end
	function cancel:action()
		dlg_:hide();
	end

	init();
	dlg_:show() 
end






