_ENV = module(...,ap.adv)

local iup = require"iup"

local name_label_ = iup.label{title = "Classname = "};
local name_text_ = iup.text{expand="Horizontal", value="app/Graphics/Rect"};
local pname_label_ = iup.label{title = "Parent Classname = "};
local pname_text_ = iup.text{expand="Horizontal",value="sys/Entity"};
local all_ = iup.list{expand="Yes","on_write_info","on_draw_diagram","on_draw_wireframe","on_draw_rendering"};
local cur_ = iup.list{expand="Yes","on_draw_diagram","on_draw_rendering"};


local dlg_ = iup.dialog{
	title = "Class Wizard";
	rastersize = "480X640"; 
	-- iup.frame{get_tab();};
	margin="10x10";
};

function get_tab()
	return iup.vbox{
		iup.hbox{name_label_,name_text_};
		iup.hbox{pname_label_,pname_text_};
		iup.hbox{all_,cur_};
		alignment="ARIGHT"
	};
end

function pop(sc)
require"sys.table".totrace{};
	dlg_:show();
end
