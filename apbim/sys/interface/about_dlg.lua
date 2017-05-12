_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"
local time_file_ = "pubtime.lua";

local img_ = iup.label{title="Abaut:",image='res\\rei.bmp',flat = "YES",expand="Yes"};
local lab_ = iup.label{title="Date:"};
local ok_ = iup.button{title="OK",size="60x"};

local dlg_ = iup.dialog{
	title = "Abaut";
	resize = "NO";
	size = "360";
	margin = "5x5";
	iup.vbox{
		iup.frame{
			iup.vbox{
				iup.hbox{img_};
				iup.hbox{iup.fill{},lab_};
			};
		};
		iup.hbox{ok_};
		alignment="aRight";
	};
};

local function init()
	local dt = require'sys.io'.read_file{file=time_file_};
	-- if type(dt)~="table" then dt = {}; end
	local str = require'sys.dt'.date_text(dt);
	lab_.title = str;
end

local function on_ok()
	dlg_:hide();
end

local k_any_={};
k_any_[iup.K_CR] = on_ok;
k_any_[iup.K_ESC] = on_ok;

function pop()
	function ok_:action()
		on_ok();
	end
	function dlg_:k_any(n)
		if k_any_[n] then k_any_[n]() end
	end

	init();
	dlg_:show();
end
