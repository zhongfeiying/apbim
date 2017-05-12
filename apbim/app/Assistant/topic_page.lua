_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local name_lab_ = iup.label{title="Title:",rastersize="50X"};
local name_txt_ = iup.text{expand="Horizontal"};
local text_lab_ = iup.label{title="Text:",rastersize="50X"};
local text_txt_ = iup.text{expand="Horizontal"};
local reply_lab_ = iup.label{title="Reply:",rastersize="50X"};
local reply_txt_ = iup.text{expand="Horizontal"};
local list_ = iup.list{expand="Yes",READONLY="YES",resizematrix="YES"};
local ok_ = iup.button{title="OK",rastersize="60x"};
local reply_ = iup.button{title="Reply",rastersize="60X"};

local dlg = iup.vbox{
	title = "Topic";
	tabtitle = "Topic";
	margin = "5x5";
	alignment = "aRight";
	rastersize = "480X600";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{name_lab_};
				iup.hbox{name_txt_};
				iup.hbox{text_lab_};
				iup.hbox{text_txt_};
				iup.hbox{iup.fill{},ok_};
			};
		};
		iup.frame{
			iup.vbox{
				iup.hbox{reply_lab_};
				iup.hbox{reply_txt_};
				iup.hbox{iup.fill{},reply_};
				iup.hbox{list_};
			};
		};
	};
}

function pop(t)
	
	function init_mat()
		local cur = require'sys.mgr'.cur();
		if type(cur)~='table' then return end
		local s = require"sys.mgr".get_class_all(require"app.Assistant.Reply".Class);
		s = require'sys.table'.filter(s,function(k,v) if v.Topic == cur.mgrid then return true else return false end end)
		require'sys.api.iup.list'.init{list=list_,dat=s,textf=function(k,v,s) return v.Text end,sortf=function(k) return s[k].Time end};
	end
	
	local function init()
		local cur = require'sys.mgr'.cur();
		if type(cur)~='table' then return end
		name_txt_.value = cur.Title;
		text_txt_.value = cur.Text;
		init_mat();
		dlg:show();
	end
	
	local function on_ok()
		local cur = require'sys.mgr'.cur();
		if type(cur)~='table' then return end
		cur.Title = name_txt_.value;
		cur.Text = text_txt_.value;
		cur:update_data();
		require'sys.mgr'.add(cur);
		require'sys.mgr'.redraw(cur);
		require'sys.mgr'.update();
		-- dlg:hide();
	end

	local function on_reply()
		local cur = require'sys.mgr'.cur();
		if type(cur)~='table' then return end
		local the = require'app.Assistant.Reply'.Class:new{Text=reply_txt_.value,Topic=cur.mgrid};
		require'sys.mgr'.add(the);
		init_mat();
	end

	local function on_select_lin()
		require'sys.api.iup.matrix'.select_lin{mat=mat_}
	end
	

	function ok_:action()on_ok()end
	function reply_:action()on_reply()end

	init();
	-- require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_look};
	-- require'sys.net.msg'.resgister_rcvf(init);
	return dlg;
end

