_ENV = module(...,ap.adv)
--package.cpath = "?53.dll;" .. package.cpath
--package.path = "?.lua;" .. package.path
require "iuplua"
local dlg_assign_view_ = require "app.workspace.ctr_require".dlg_assign_view()

local datas_ = nil
local return_datas_ = nil
local list_datas_ = nil
local dlg_ = nil
local function init_buttons()
	local wid = "70x"
	local smallwid = "100x"
	btn_show_ = iup.button{title = "Show",rastersize = wid}
	btn_edit_ = iup.button{title = "Edit",rastersize = wid}
	btn_del_ = iup.button{title = "Delete",rastersize = wid}
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	local wid = "100x"
	list_name_ = iup.list{rastersize = "300x300",expand = "YES"}
	frame_list_ = iup.frame{
		iup.vbox{
			iup.hbox{list_name_};
			alignment = "ARIGHT";
			MARGIN = "2X2";
		};
		title = "Name List";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_list_};
			iup.hbox{btn_show_,btn_edit_,btn_del_,btn_ok_,btn_cancel_};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Show Assign";
		resize = "NO";
		--TOPMOST = "YES";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)

end

local function deal_ok_msg()
	return_datas_ = list_datas_	
end

local function deal_edit_cb(save_select_list_)
	local t = list_datas_[save_select_list_]
	dlg_assign_view_.set_data(t)
	dlg_assign_view_.pop()
	list_name_[save_select_list_] =t.title 
end

function show_all_model(name)
	local sc = require "sys.mgr".new_scene{name =sc}
	local ents = require "sys.mgr".get_all()
	if type(ents) ~= "table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1,update=false};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.mgr".redraw(v,sc);
		run();
		--require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	end
	 require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	 require "sys.mgr".select_none({redraw = true})
	 require"sys.mgr".update(sc);
end

function assign_view_member(save_select_list_)
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then return end 
	local CurSceneAll = require "sys.mgr".get_scene_all(sc)
	if not CurSceneAll then return end 
	local ents = {}
	for k,v in pairs (list_datas_[save_select_list_].ifo) do 
		local ent = require "sys.mgr".get_table(k)
		ents[k] = ent
	end
	local newents = {}
	local status = false 
	require "sys.mgr".select_none({redraw = true})
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1,update=false};
	for k,v in pairs (ents) do 
		if  CurSceneAll[k] then
			 status = true
			 require "sys.mgr".select(v,true)
			 require "sys.mgr".redraw(v)
			 newents[k] = v
			 run();
		end
	end
	if status then 
		require "sys.mgr".scene_to_fit{scene=sc,ents = newents}
		require "sys.mgr".update()
	end



	--show_all_model()
	-- local ents = {}
	-- for k,v in pairs (list_datas_[save_select_list_].ifo) do 
		-- local ent = require "sys.mgr".get_table(k)
		-- require "sys.mgr".select(ent,true)
		-- require "sys.mgr".redraw(ent)
		-- ents[k] = ent
	-- end
	-- require"sys.mgr".scene_to_fit{scene=sc,ents=ents};
	-- require "sys.mgr".update()
end

local function init_msg()
	local save_select_list_ = nil
	function btn_edit_:action()
		if not save_select_list_ then return end 
		deal_edit_cb(save_select_list_)
	end

	function btn_del_:action()
		if not save_select_list_ then return end 
		list_name_.removeitem = save_select_list_
		table.remove(list_datas_,save_select_list_)
		save_select_list_ = nil
	end

	function btn_ok_:action()
		deal_ok_msg()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end

	function btn_show_:action()
		if not save_select_list_ then return end 
		if not list_datas_ then return end 
		if list_datas_[save_select_list_].type == "View" then 
			for k,v in pairs (list_datas_[save_select_list_].ifo) do 
				local sdm = require "sys.mgr".get_table(k)
				if type(sdm) ~= "table" then return end 
				sdm:open{name = sdm.Name}
			end
		elseif list_datas_[save_select_list_].type == "Member" then
			assign_view_member(save_select_list_)
		end
	end

	function list_name_:action(text,item,state)
		if state == 1 then 
			save_select_list_ = tonumber(item)
		end

	end

 	function list_name_:button_cb(button,pressed,x,y,status)
		if not save_select_list_ then return end 
		if string.find(status,"1") and string.find(status,"D") then 
			deal_edit_cb(save_select_list_)
		end
	end
end

local function deep_copy_table(s,d)
	for k,v in pairs (s) do 
		if type(v) ~= "table" then 
			d[k] = v
		else 
			d[k] = {}
			deep_copy_table(v,d[k])
		end
	end
end

local function init_data()
	list_name_[1] = nil
	return_datas_ = nil
	list_datas_ = {}
	if datas_ then 
		for k,v in ipairs (datas_) do 
			list_name_.appenditem = v.title
		end
		deep_copy_table(datas_,list_datas_)
	end
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

local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end

function pop()
	if dlg_ then show() else init() end	
end

function set_data(data)
	datas_ = data
end

function get_data()
	return return_datas_ 
end

--set_data({{title =2},{title =3},})
--pop()
