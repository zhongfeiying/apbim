_ENV = module(...,ap.adv)
local workspace_ =require "app.workspace.ctr_require".Workspace()
local dlg_ = nil
local TreeDatas_ = nil
local LinksDatas_ = nil
local function init_buttons()
	local wid = "100x"
--	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_location_ = iup.button{title = "Location",rastersize = wid}
	btn_update_ = iup.button{title = "Update",rastersize = wid}
end

local function init_controls()
	list_locations_ = iup.list{}
	list_locations_.rastersize = "300x400"
	frame_list_location_ = iup.frame{
		list_locations_;
		title = "Links List";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{
				frame_list_location_;
				margin = "5x0";
			};
			iup.hbox{
				btn_update_,
				btn_location_,
				btn_cancel_;
			};
			alignment = "ARIGHT";
			MARGIN = "10X10";
		};	
		title = "Location Node";
		resize = "NO";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)

end

local function init_data()
	list_locations_[1] = nil
	if LinksDatas_ then 
		for k,v in ipairs (LinksDatas_) do
			list_locations_.appenditem = v.treetitle
		end
	end
end



local function deal_update_msg()
	if not TreeDatas_ then return end 
	local curs = require "sys.mgr".curs()
	local linkslist = {}
	local status = false 
	for k, v in ipairs (TreeDatas_) do
		local curstatus = false
		for m,n in pairs(v.ifo) do
			if curs[m] then status = true curstatus = true break end 
		end
		if curstatus then table.insert(linkslist,v) end
	end
	if not status then iup.Message("Warning","No association of nodes ! Please re-choose !") return end
	LinksDatas_ = linkslist
	init_data()
end

local function deal_location_msg(item)
	local path = LinksDatas_[item].treepath
	local tree =  workspace_.get_tree()
	for k,v in ipairs (path) do 
		tree["state" .. v] = "EXPANDED"
		tree["MARKED" .. v] = "YES"
	end
end

local function init_msg()
	local save_select_list_item_ = nil
	function btn_update_:action()
		deal_update_msg()
	end

	function btn_location_:action()
		if not save_select_list_item_ then iup.Message("Warning","Please select item !") return end 
		deal_location_msg(save_select_list_item_)
	end

	function btn_cancel_:action()
		dlg_:hide()
	end

	function list_locations_:action(text,item,state)
		if state  == 1 then 
			save_select_list_item_ = tonumber(item)
		end
	end

	function list_locations_:button_cb(button,pressed,x,y,status)
		if not save_select_list_item_ then return end 
		if string.find(status,"1") and string.find(status,"D") then 
			deal_location_msg(save_select_list_item_)
		end
	end
end


local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	dlg_:map()
	init_data()
	dlg_:popup()
	
end

function pop()
	if  dlg_ then show() else init() end
end

function set_data(LinksDatas,TreeDatas)
	TreeDatas_ = TreeDatas
	LinksDatas_ = LinksDatas 
end
