_ENV = module(...,ap.adv)


local iup = require"iuplua"

local lab = iup.label{title='Test'};

local dlg = iup.vbox{
	tabtitle = "Test";
	margin = "5x5";
	alignment = "aRight";
	-- size = "50x";
	iup.vbox{
		iup.hbox{lab};
	};
}



-- t={filter=}
function pop(t)
	return dlg;
end

