_ENV = module(...,ap.adv)
--package.cpath = "?53.dll;" .. package.cpath
--package.path = "?.lua;" .. package.path
require "iuplua"
local dlg_assign_view_ = require "app.workspace.ctr_require".dlg_assign_view()
local dlg_show_files_ = require "app.workspace.ctr_require".dlg_show_files()
local datas_ = nil
local list_datas_ = nil
local dlg_ = nil
local matrix_nums_ = 0
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
	--list_name_ = iup.list{rastersize = "300x300",expand = "YES"}
	matrix_list_ = iup.matrix{}
	matrix_list_.MARKMODE = "LIN"
	matrix_list_.numcol = 2
	matrix_list_.numlin = 10
	matrix_list_.readonly = "YES"
	matrix_list_.rasterwidth1 = 150
	matrix_list_.rasterwidth2 = 150
	matrix_list_.rastersize = "320x300"
	matrix_list_:setcell(0,1,"Name")
	matrix_list_:setcell(0,2,"Type")
	matrix_list_.HIDDENTEXTMARKS = "YES"
	matrix_list_.RESIZEMATRIX = "YES"
	matrix_list_.ALIGNMENT1 = "ALEFT"
	frame_list_ = iup.frame{
		iup.vbox{
			iup.hbox{matrix_list_};
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

local function table_is_empty(t)
	return _G.next(t) == nil
end

local function deal_ok_msg()
	datas_ = list_datas_	
end

local function edit_data(t,lin)
	dlg_assign_view_.set_data(t)
	dlg_assign_view_.pop()
	matrix_list_:setcell(lin,1,t.title)
	matrix_list_.redraw = "ALL"
end

local function deal_edit_cb(lin)
	if not lin then return end 
	if matrix_list_:getcell(lin,2) == "View" then 
		local t = list_datas_.LinkViews[lin]
		edit_data(t,lin)
	elseif matrix_list_:getcell(lin,2) == "Entities" then
		local dpos = lin
		if list_datas_.LinkViews then 
			dpos = dpos - #list_datas_.LinkViews 
		end
		local t = list_datas_.LinkEntities[dpos]
		edit_data(t,lin)
	elseif matrix_list_:getcell(lin,2) == "File" then 
		return 
	end	
end

local function init_matrix_head()
	if matrix_nums_ and matrix_nums_ ~= 0 then 
		matrix_list_.dellin = "1-" .. matrix_nums_ 
	end
	matrix_nums_ = 0
	matrix_list_:setcell(0,1,"Name")
	matrix_list_:setcell(0,2,"Type")
	matrix_list_.numlin = 20
	matrix_list_.redraw = "ALL"

end


local function deal_add_matrix(title,type)
	matrix_nums_ = matrix_nums_ + 1
	if matrix_nums_ > tonumber(matrix_list_.numlin) then 
		matrix_list_.numlin = matrix_nums_
	end
	matrix_list_:setcell(matrix_nums_,1,title)
	matrix_list_:setcell(matrix_nums_,2,type)
end

local function init_matrix_data(datas)
	if datas.LinkViews then 
		for k,v in ipairs (datas.LinkViews) do
			deal_add_matrix(v.title,"View")
		end
	end
	if datas.LinkEntities then 
		for k,v in ipairs (datas.LinkEntities) do
			deal_add_matrix(v.title,"Entities")
		end
	end

	if datas.res then 
		for k,v in ipairs (datas.res) do
			local name = v.name
			deal_add_matrix(name,"File")
		end

	end
end

local function init_matrix_select(lin,type)
	matrix_list_["mark" .. lin .. ":1"] = type
	matrix_list_["mark" .. lin .. ":2"] = type
	matrix_list_.redraw = "ALL"
end

local function deal_show_view(lin)
	local title = matrix_list_:getcell(lin,1) .. lin
	local datas = list_datas_.LinkViews[lin].ifo
	for k,v in pairs (datas) do
		local sdm = require "sys.mgr".get_table(k)
		if type(sdm) ~= "table" then return end 
		sdm.Name = title .. k
		local t = require "sys.mgr".find_scene{name = sdm.Name}
		if table_is_empty(t) then 
			sdm:open{name = sdm.Name}
		else
			require "sys.mgr".set_active_scene(t[1])
		end
	end
end

local function deal_show_members_all(sc,pos)
	local ents = require "sys.mgr".get_all()
	if type(ents) ~= "table" then return end
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(ents),time=1,update=false};
	for k,v in pairs (ents) do
		v = require "sys.mgr".get_table(k,v)
		require"sys.mgr".redraw(v,sc);
		run();
	end
	local newents = {}
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(list_datas_.LinkEntities[pos].ifo),time=1,update=false};
	for k,v in pairs (list_datas_.LinkEntities[pos].ifo) do
		local ent = require "sys.mgr".get_table(k)
		require "sys.mgr".select(ent,true)
		require"sys.mgr".redraw(ent,sc);
		run();
		newents[k] = ent
	end
	require"sys.mgr".scene_to_fit{scene=sc,ents=newents};
	require "sys.mgr".update(sc)
end

local function show_members_all(lin,pos)
	local title = matrix_list_:getcell(lin,1) .. pos .. "_all"
	local t = require "sys.mgr".find_scene{name = title}
	if table_is_empty(t) then 
		local sc = require "sys.mgr".new_scene{name = title}
		deal_show_members_all(sc,pos)
	else
		require "sys.mgr".set_active_scene(t[1])
	end
end

local function deal_show_members(sc,pos)
	local run = require"sys.progress".create{title="Draw ... ",count=require"sys.table".count(list_datas_.LinkEntities[pos].ifo),time=1,update=false};
	for k,v in pairs (list_datas_.LinkEntities[pos].ifo) do 
		local ent = require "sys.mgr".get_table(k)
		require "sys.mgr".select(ent,true)
		require"sys.mgr".redraw(ent,sc);
		run()
	end
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	require "sys.mgr".update()
end

local function show_members(lin,pos)
	local title = matrix_list_:getcell(lin,1) .. pos
	local t = require "sys.mgr".find_scene{name = title}
	if table_is_empty(t) then 
		local sc = require "sys.mgr".new_scene{name = title}
		deal_show_members(sc,pos)
	else
		require "sys.mgr".set_active_scene(t[1])
	end
end

local function deal_show_memebers(lin)
	local dpos = lin
	if list_datas_.LinkViews then 
		dpos = dpos - #list_datas_.LinkViews 
	end
	local alarm = iup.Alarm("Notice","Do you want to show all members !","Yes","No")
	if alarm == 1 then 
		show_members_all(lin,dpos)
		return 
	end
	show_members(lin,dpos)
end

local function deal_show_files(lin)
	local dpos = lin
	if list_datas_.LinkViews then 
		dpos = dpos - #list_datas_.LinkViews 
	end
	if list_datas_.LinkEntities then 
		dpos = dpos - #list_datas_.LinkEntities
	end
	local data = list_datas_.res[dpos]
	if not data then return end 
	local str = string.gsub(data.ifo,"/","\\")
	local file = io.open(str,"r")
	if not file then 
		iup.Message("Warning","File is not exist !Please check first!")
		dlg_show_files_.set_datas(list_datas_.res)
		dlg_show_files_.pop()
	else 
		file:close()
		os.execute("start \"\" \"" .. string.gsub(data.ifo ,"/","\\") .. "\"")
	end
end

local function deal_ldb_click(lin)
	if matrix_list_:getcell(lin,2) == "View" then 
		deal_show_view(lin)
	elseif matrix_list_:getcell(lin,2) == "Entities" then 
		deal_show_memebers(lin)
	elseif matrix_list_:getcell(lin,2) == "File" then 
		deal_show_files(lin)
	end
end

local function deal_del_msg(lin)
	if matrix_list_:getcell(lin,2) == "View" then 
		table.remove(list_datas_.LinkViews,lin)
	elseif matrix_list_:getcell(lin,2) == "Entities" then
		local pos = lin
		if list_datas_.LinkViews then 
			pos = pos - #list_datas_.LinkViews
		end
		table.remove(list_datas_.LinkEntities,pos)
	elseif matrix_list_:getcell(lin,2) == "File" then 
		local pos = lin
		if list_datas_.LinkViews then 
			pos = pos - #list_datas_.LinkViews
		end
		if list_datas_.LinkEntities then 
			pos = pos - #list_datas_.LinkEntities
		end
		table.remove(list_datas_.res,pos)
	end
	matrix_list_.dellin = lin
	matrix_nums_ = matrix_nums_ - 1
	if tonumber(matrix_list_.numlin) < 20 then 
		matrix_list_.numlin = 20
	end
	
end

local function init_msg()
	local save_select_lin = nil
	function btn_edit_:action()
		--if not save_select_lin then return end 
		if not save_select_lin or save_select_lin > matrix_nums_ then return end
		deal_edit_cb(save_select_lin)
	end

	function btn_del_:action()
		--if not save_select_lin then return end 
		if not save_select_lin or save_select_lin > matrix_nums_ then return end
		deal_del_msg(save_select_lin)
	end

	function btn_ok_:action()
		deal_ok_msg()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end

	function btn_show_:action()
		if not save_select_lin or save_select_lin > matrix_nums_ then return end
		deal_ldb_click(save_select_lin)
	end
	
	function matrix_list_:click_cb(lin, col, str)
		if string.find(str,"2") or string.find(str,"3") then return end 
		if save_select_lin then init_matrix_select(save_select_lin,0) end 
		init_matrix_select(lin,1)
		save_select_lin = tonumber(lin)
		if self:getcell(lin,2) == "File" or save_select_lin > matrix_nums_ then 
			btn_edit_.active = "NO"
		else
			btn_edit_.active = "YES"
		end
		if string.find(str,"D") then 
			deal_ldb_click(save_select_lin)
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
	list_datas_ = {}
	init_matrix_head()
	btn_edit_.active = "NO"
	if datas_ then 
		deep_copy_table(datas_,list_datas_)
		init_matrix_data(list_datas_)
		matrix_list_.redraw = "ALL"
	end
	datas_ = nil
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
	return datas_ 
end

--set_data({{title =2},{title =3},})
--pop()
