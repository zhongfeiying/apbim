_ENV = module(...,ap.adv)

local iup = require'iuplua'

local user_lab = iup.label{title='User:',size='50x'}
local user_txt = iup.text{expand='Yes',value='TestUser'}
local file_lab = iup.label{title='File:',size='50x'}
local file_txt = iup.text{expand='Yes',value='D:\\Test1234.txt'}
local text_lab = iup.label{title='Text:',size='50x'}
local text_txt = iup.text{expand='Yes',value='Something.'}
local send_btn = iup.button{title="Send",size='60x'}
local dlg = iup.dialog{
	size = "480x";
	title = "Message";
	margin = "5x5";
	alignment = "aRight";
	iup.vbox{
		iup.hbox{user_lab,user_txt};
		iup.hbox{file_lab,file_txt};
		iup.hbox{text_lab,text_txt};
		iup.hbox{iup.fill{},send_btn};
	};
}

function get_code()
	local file_str = file_txt.value;
	if not file_str or file_str=="" then return end
	local text_str = text_txt.value;
	if not text_str or text_str=="" then return end
	local str = '';
	str = str..'local function exe_f() \n';
	str = str..'ap_append_file('..string.format("%q",file_str)..',"'..text_str..'") \n';
	str = str..'end \n';
	str = str..'exe_f()\n';
	return str;
end

function send_btn:action()
	local user_str = user_txt.value;
	if not user_str or user_str=="" then return end
	require'sys.net.msg'.send_msg{To=user_str,Code=get_code(),Name="Append File(.txt)",Text="Open(Create) a File(.txt), and append something.",Arrived_Report=true,Read_Report=true,Confirm_Report=true}
end

function pop()
	dlg:show()
end

