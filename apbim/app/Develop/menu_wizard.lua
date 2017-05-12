_ENV = module(...,ap.adv)

local iup = require"iuplua"

local all_ = iup.tree{expand="Yes"};
local cur_lable_ = iup.label{title="Menu Text:"};
local cur_text_ = iup.text{expand="Horizontal",value="This is a Test Menu"};
local cbf_lable_ = iup.label{title="Callback Function Name:"};
local cbf_text_ = iup.text{expand="Horizontal",value="Test_Menu"};
local cbf_frame_toggle_ = iup.toggle{title="Frame"};
local cbf_view_toggle_ = iup.toggle{title="View"};
local add_ = iup.button{title="Add",size="60x15"};
local del_ = iup.button{title="Delete",size="60x15"};

all_.title0 = "Test";

-- local tab_ = iup.tabs{
	-- iup.vbox{
		-- tabtitle = "App";
		-- iup.hbox{txt_};
	-- };
	-- iup.vbox{
		-- tabtitle = "C";
		-- iup.hbox{txt2_};
	-- };
-- };

local dlg_ = iup.dialog{
	title = "Menu Wizard";
	rastersize = "480X640"; 
	iup.vbox{
		all_;
		iup.hbox{cur_lable_,cur_text_};
		iup.hbox{cbf_lable_,cbf_text_};
		iup.hbox{cbf_frame_toggle_,cbf_view_toggle_,add_,del_};
		margin="10x10";
		alignment="ARIGHT"
	};
};


function pop(sc)
	dlg_:show();
all_.addbranch0 = "T1";
all_.addleaf1 = "11";
all_.addleaf1 = "12";
all_.insertbranch1 = "T2";
all_.addleaf4 = "21";
all_.addleaf4 = "22";
-- all_.insertleaf1 = "2";
end
