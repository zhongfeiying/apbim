module(...,package.seeall)
local dir=nil;
local t = {}
local bulid_tree_=false
local list_ =false
local recursive_=false
local cur_type_ = "dir"


local function init_buttons()
	local wid = "100x"
	btn_add_ = iup.button{title="OK",rastersize=wid};
	btn_close_ = iup.button{title="Cancel",rastersize=wid};
	btn_open_dir_ = iup.button{title = "Browse...",rastersize = "70x"}
end

local function init_controls()
	--lab_global_id_ = iup.label{title = "Global ID:",rastersize = "100x"}
	--txt_global_id_ = iup.text{rastersize = "245x"}
	local txt_wid = "300x"
	local wid = "70x"
	lab_message_ = iup.label{title = "Message:",rastersize = wid}
	txt_message_ = iup.text{rastersize = txt_wid}
	lab_to_ = iup.label{title = "	To: ",rastersize = wid}
	txt_to_ = iup.text{rastersize = "230x",}
	tog_bulid_tree_ = iup.toggle{title = "Build Tree",};
	tog_list_ = iup.toggle{title = "List",};
	tog_recursive_ = iup.toggle{title = "Recursive",};
	radio_ass_ = iup.radio{iup.hbox{tog_bulid_tree_,iup.fill{},tog_list_},value = tog_bulid_tree_};
end


local function init_dlg()

	dlg_= iup.dialog{
		iup.frame{
			iup.vbox{
				--iup.hbox{lab_message_,txt_message_,},
				iup.hbox{lab_to_,txt_to_,btn_open_dir_},
				iup.frame{
					iup.hbox{radio_ass_,iup.fill{}};
				    title="Check File Style";
					size="200x20";
				};
			
				iup.hbox{tog_recursive_,iup.fill{}};
				iup.hbox{btn_add_,iup.fill{},btn_close_,},
				alignment = "ARIGHT",
			},
		},
		title = "Check Out",
		resize = "NO", 
		margin="8x8",
	};
  --iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
end

local function deal_add_action()
	t = {}
--	t.message = txt_message_.value
	t.to= txt_to_.value
	t.bulid_tree_=bulid_tree_
	t.list_=list_
	t.recursive_=recursive_
end 
	
local function open_file_dlg()
		local dlg_ = iup.filedlg{DIALOGTYPE = "dir" }
		local dir = "";
		dlg_:popup()
		if dlg_.status ~= "-1" then
			dir = dlg_.value;
		end
		return string.sub(dir,-1)=="\\" and dir or dir.."\\";
end

local function get_info()
	txt_to_.value=dir
		
end

function set_info(str)
   -- if  str  then iup.Message("Warning","Please enter dir !")  return end 
    dir=str
	--trace_out("pull file = " .. str.. "\n");  
	
end

function set_type(str)
	cur_type_ = str
end 

local function msg()

   	function btn_open_dir_:action()
			--open_file_dir()	--´ò¿ªÂ·¾¶
			txt_to_.value=nil
			txt_to_.value=open_file_dlg()
	end
	function btn_add_:action()
	--	if not string.find(txt_message_.value,"%S+") then iup.Message("Warning","Please enter message !") return end 
		if not string.find(txt_to_.value,"%S+") then iup.Message("Warning","Please enter dir !") return end 
		if tog_bulid_tree_.value=="ON" then
			bulid_tree_=true
		else
			bulid_tree_=false
		end
		if tog_list_ .value=="ON" then
			list_ =true
		else 
		    list_ =false
		end

		if tog_recursive_ .value=="ON" then
			recursive_ =true
			else
			recursive_ =false
		end
		deal_add_action()
		dlg_:hide()
	end
	
	function btn_close_:action()
		t = nil
		dlg_:hide()
	end
	
	function dlg_:close_cb()
		t = nil
	end
end

local function init_active(type)
	tog_recursive_.active  = type
	radio_ass_.active  = type
end

local function init_data()
	t = nil;
	--txt_message_.value=""
	txt_to_.value=""
	tog_bulid_tree_.value="true" 
	tog_list_.value="false"
	tog_recursive_.value="ON"
	 get_info()
	 init_active("YES")
	if cur_type_ == "file" then 
		init_active("NO")
	end 
end


local function show()
	--get_db();
	--init_data(get_db());
	
	 init_data()
	dlg_:popup() 
end


local function init() 
	init_buttons();
	init_controls();
	init_dlg();
	--get_db();
	--if tab1 then init_user(tab1) end
  
	msg();
	init_data()
	--init_data(get_db())
	dlg_:popup();
end

function return_db()
	return t
end

function pop()	
	if dlg_ then 
	
		show() 
	else

		init()
	end
end

