--module(...,package.seeall)
_ENV = module(...,ap.adv)
require"iuplua";
require"iupluacontrols";
local dlg = nil
local pages_ = {TABTYPE="BOTTOM",expand="YES",showclose = "NO"};
local tabs = nil

function get_tabs()
	return tabs
end

local function create_page(hwnd)
	table.insert(pages_,hwnd)
	tabs = iup.tabs(pages_)
	dlg = iup.dialog{iup.vbox{tabs; margin="5x5"};BORDER="NO",MAXBOX="NO", MINBOX="NO", MENUBOX="NO",CONTROL = "YES",expand = "Yes",rastersize="450X"}
	iup.SetAttribute(dlg,"NATIVEPARENT",frm_hwnd)
	function dlg:close_cb()
		iup.MainLoop()
	end
	function dlg:show_cb(status)
		if status == 0 then
		    hdlgtree = iup.GetAttributeData(dlg,"HWND")
			add_dlgtree(frm,hdlgtree)
			
		end
	end
	function tabs:tabclose_cb(pos)
		--trace_out("pos = " .. pos .. "\n")
	end 
	dlg:show()
	dlgtree_show(frm,false); 
	dlgtree_show(frm,true); 
end

local function add_one_page(hwnd) 
	table.insert(pages_,hwnd)
	iup.Append(tabs,hwnd) 
	iup.Map(hwnd)
	iup.Refresh(dlg)
end

function add_page(hwnd)
	if not hwnd then return end 
	if dlg then 
		add_one_page(hwnd)
	else 
		create_page(hwnd)
	end
end



function del_page(hwnd)
	iup.Detach(hwnd) 
	for k,v in ipairs (pages_) do 
		if v == hwnd then 
			table.remove(pages_,k)
		end 
	end 
end

function get_dlg()
	return dlg 
end
