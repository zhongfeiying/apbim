_ENV = module(...,ap.adv)

local iup = require "iuplua"
local iupcontrols = require "iupluacontrols"
local lfs_ = require "lfs"
local file_io_ = require "sys.io"
local file_save_ = require "sys.table"
local dlg_pos_ = "sys.load."

--local add_start_configure_dlg_ = require (dlg_pos_ .. "add_dlg")
local read_file_name_ = nil;
local save_load_path_ = nil
local dlg_ = nil
local matrix_nums_ = 0;
local matrix_nums2_ = 0

local function init_buttons()
	local wid = "80x"
	local small_wid = "30x100"
	btn_del_ = iup.button{title = "Delete",rastersize = wid}
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_up_ =  iup.button{rastersize = small_wid,fontsize = "14"}
	local str = string.gsub(dlg_pos_,"%.","\\") .. "up.bmp"
	iup.SetAttribute(btn_up_, "IMAGE", str);
	btn_down_ =  iup.button{rastersize = small_wid,fontsize = "14"}
	str = string.gsub(dlg_pos_,"%.","\\") .. "down.bmp"
	iup.SetAttribute(btn_down_, "IMAGE", str);
	
	btn_save_ = iup.button{title = "Save",rastersize = wid}
	btn_select_all_ = iup.button{title = "Select ALL",rastersize = wid}
	btn_select_none_ = iup.button{title = "Select None",rastersize = wid}

end

local function init_controls()
	matrix_ifo_ = iup.matrix{
		numlin = 20;
		numcol = 3;
		RASTERWIDTH0 = 20;
		RASTERWIDTH1 = 20;
		RASTERWIDTH2 = 200;
		RASTERWIDTH3 = 200;
		markmode = "CELL";
		rastersize = "490x270";
		readonly = "YES";
		MARKMULTIPLE = "NO";
	}

	frame_matrix_ = iup.frame{
		iup.hbox{
			matrix_ifo_;
			iup.vbox{iup.fill{},btn_up_,iup.fill{},btn_down_,iup.fill{}};
			margin = "0x0";
		}
	}
	
	txt_read_me_ = iup.text{
		rastersize = "x100";
		WORDWRAP  = "YES";
		MULTILINE="YES";
		expand = "HORIZONTAL";
		bgcolor = "240 240 240";
		readonly = "YES";
		CANFOCUS = "NO";
	};
	
	txt_save_file_name_ = iup.text{expand = "HORIZONTAL";}
	
	matrix_ifo2_ = iup.matrix{
		numlin = 10;
		NUMLIN_VISIBLE = 5;
		numcol = 1;
		RASTERWIDTH0 = 20;
		RASTERWIDTH1 = 465;
		markmode = "CELL";
		rastersize = "490x150";
		readonly = "YES";
		
	}
	frame_matrix2_ = iup.frame{
		matrix_ifo2_;
	}

	item_select_all_ = iup.item{title = "Select All"}
	item_select_none_ = iup.item{title = "Select None"}
	menu_ = iup.menu{
		item_select_all_;
		item_select_none_;
	}

end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			frame_matrix_;
			txt_read_me_;
			iup.hbox{
				txt_save_file_name_;
				btn_del_;
				btn_save_;
				btn_ok_;
				btn_cancel_;
			};
			frame_matrix2_;
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "App Solution";
		resize = "NO";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)

end

local function init_matrix_head()
	--matrix_ifo_:setcell(0,1,"Loading")
	matrix_ifo_:setcell(0,0,"ID")
	matrix_ifo_:setcell(0,1,"Sel")
	matrix_ifo_:setcell(0,2,"App")
	matrix_ifo_:setcell(0,3,"Status")
	if matrix_nums_ ~= 0 then 
		matrix_ifo_.DELLIN = "1-" .. matrix_nums_
	end
	matrix_nums_ = 0 
	matrix_ifo_.numlin = 20;
end

local function init_matrix2_head()
	matrix_ifo2_:setcell(0,0,"ID")
	matrix_ifo2_:setcell(0,1,"Solution")
	if matrix_nums2_ ~= 0 then 
		matrix_ifo2_.DELLIN = "1-" .. matrix_nums2_
		matrix_ifo2_.redraw = "ALL"
	end
	
	matrix_nums2_ = 0 
	matrix_ifo2_.numlin = 10;
end 

local function set_matrix_color(lin,color)
	matrix_ifo_["FGCOLOR" .. lin .. ":2"] = color
	matrix_ifo_["FGCOLOR" .. lin .. ":3"] = color

end

local function init_color(exist,loadstates,lin)
	if exist == "Warning:App is non-existent!"  then 
		local color = "255 0 0"
		set_matrix_color(lin,color)
	else 
		if loadstates == "ON" then 
			local color = "0 0 255"
			set_matrix_color(lin,color)
			matrix_ifo_:setcell(lin,3,"OK")
		else 
			local color = "0 0 0"
			set_matrix_color(lin,color)
			matrix_ifo_:setcell(lin,3,"Cancel")
		end
	end
	matrix_ifo_.redraw = "ALL"
end

local function init_matrix_data(file_path,exist,loadstates)
	matrix_nums_ = matrix_nums_ + 1;
	if matrix_nums_ > tonumber(matrix_ifo_.numlin) then 
		matrix_ifo_.numlin = matrix_nums_
	end
	matrix_ifo_:setcell(matrix_nums_,0,matrix_nums_)
	matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":1"] = loadstates  
	matrix_ifo_:setcell(matrix_nums_,2,file_path)
	matrix_ifo_:setcell(matrix_nums_,3,exist)
	init_color(exist,loadstates,matrix_nums_)
	matrix_ifo_.redraw = "ALL"
end


local function deal_get_resource_db(t)
	for k,v in ipairs (t) do
		v = string.sub(v,5,-6)
		t[v] = ""
	end
	local tab,new_tab = {},{};
	for line in io.popen("dir /ad /b /on " .. "app"):lines() do 
		table.insert(tab,line)
	end
	for k,v in ipairs (tab) do 
		if not t[v] then 
			table.insert(new_tab,{name = v ,states = "Cancel"})
			if  not file_io_.is_there_file{file = "app/" .. v .. "/main.lua"} then 
				new_tab[#new_tab].states = "Warning:App is non-existent!"
			end
		end
	end
	
	return new_tab 
end

local function init_matrix2_data()
	
	if not save_load_path_ then return end
	local tab = {};
	for line in io.popen("dir /a-d /b /on " .. "\"" .. save_load_path_ .. "\""):lines() do 
		table.insert(tab,line)
	end
	for k,v in ipairs (tab) do 
		matrix_nums2_ = matrix_nums2_ + 1
		if matrix_nums2_ > tonumber(matrix_ifo2_.numlin) then 
			matrix_ifo2_.numlin = matrix_nums2_
		end
		matrix_ifo2_:setcell(matrix_nums2_,0,matrix_nums2_)
		matrix_ifo2_:setcell(matrix_nums2_,1,string.sub(v,1,-5))
	end
	matrix_ifo2_.redraw = "ALL"
end 

local function init_data()
	txt_read_me_.value = "";
	init_matrix_head()
	local t = file_io_.readfile{file = read_file_name_}
	if not t then t = {} end 
	for k,v in ipairs (t) do 
		local file_status = "Warning:App is non-existent!";
		if file_io_.is_there_file{file = v .. ".lua"} then 
			file_status = "OK"
		end
		local cur_show = string.sub(v,5,-6)
		init_matrix_data(cur_show,file_status,"ON")
	end 
	local tab = deal_get_resource_db(t)
	for k,v in ipairs (tab) do 
		init_matrix_data(v.name,v.states,"OFF")
	end
	init_matrix2_head()
	init_matrix2_data()
end

local function init_select_matrix(lin,num)
	
	matrix_ifo_["mark" .. lin .. ":1"] = num
	matrix_ifo_["mark" .. lin .. ":2"] = num
	matrix_ifo_["mark" .. lin .. ":3"] = num
	matrix_ifo_.redraw = "ALL"
end

local function init_select_matrix2(lin,num)
	matrix_ifo2_["mark" .. lin .. ":1"] = num
	matrix_ifo_.redraw = "ALL"
end

local function deal_ok_action()
	local t = {}
	for i = 1,matrix_nums_ do 
		if matrix_ifo_["TOGGLEVALUE" .. i .. ":1"] == "ON" then
			table.insert(t,"app/" .. matrix_ifo_:getcell(i,2) .. "/main")
		end
	end
	file_save_.tofile{file = read_file_name_,src = t}
end


local function deal_btn_up_action(lin)
	
	local temp = {};
	temp.file_name = matrix_ifo_:getcell(lin-1,2)
	temp.file_status =  matrix_ifo_:getcell(lin-1,3)
    temp.file_load = matrix_ifo_["TOGGLEVALUE" .. (lin - 1 ) .. ":1"]
	matrix_ifo_["TOGGLEVALUE" .. ( lin - 1 ).. ":1"] = matrix_ifo_["TOGGLEVALUE" .. lin .. ":1"] 
	matrix_ifo_:setcell(lin-1,2,matrix_ifo_:getcell(lin,2))
	matrix_ifo_:setcell(lin-1,3,matrix_ifo_:getcell(lin,3))
	init_color(matrix_ifo_:getcell(lin,3),matrix_ifo_["TOGGLEVALUE" .. ( lin - 1 ).. ":1"],lin-1)
	matrix_ifo_["TOGGLEVALUE" .. ( lin ).. ":1"] = temp.file_load 
	matrix_ifo_:setcell(lin,2,temp.file_name)
	matrix_ifo_:setcell(lin,3,temp.file_status)
	init_color(temp.file_status,temp.file_load,lin)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	matrix_ifo_[str1] = 0;
	matrix_ifo_[str2] = 0;
	matrix_ifo_[str3] = 0;
	local str1 = "mark" .. (lin-1) .. ":1";
	local str2 = "mark" .. (lin-1) .. ":2";
	local str3 = "mark" .. (lin-1) .. ":3";
	matrix_ifo_[str1] = 1;
	matrix_ifo_[str2] = 1;
	matrix_ifo_[str3] = 1;
	matrix_ifo_.redraw = "ALL"
end 

local function deal_btn_down_action(lin)
	local temp = {};
	temp.file_name = matrix_ifo_:getcell(lin+1,2)
	temp.file_status =  matrix_ifo_:getcell(lin+1,3)
    temp.file_load = matrix_ifo_["TOGGLEVALUE" .. (lin + 1 ) .. ":1"]
	matrix_ifo_["TOGGLEVALUE" .. ( lin + 1 ).. ":1"] = matrix_ifo_["TOGGLEVALUE" .. (lin) .. ":1"] 
	matrix_ifo_:setcell(lin+1,2,matrix_ifo_:getcell(lin,2))
	matrix_ifo_:setcell(lin+1,3,matrix_ifo_:getcell(lin,3))
	init_color(matrix_ifo_:getcell(lin,3),matrix_ifo_["TOGGLEVALUE" .. ( lin ).. ":1"],lin+1)
	matrix_ifo_["TOGGLEVALUE" .. ( lin ).. ":1"] = temp.file_load 
	matrix_ifo_:setcell(lin,2,temp.file_name)
	matrix_ifo_:setcell(lin,3,temp.file_status)
	init_color(temp.file_status,temp.file_load,lin)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	matrix_ifo_[str1] = 0;
	matrix_ifo_[str2] = 0;
	matrix_ifo_[str3] = 0;
	local str1 = "mark" .. (lin+1) .. ":1";
	local str2 = "mark" .. (lin+1) .. ":2";
	local str3 = "mark" .. (lin+1) .. ":3";
	matrix_ifo_[str1] = 1;
	matrix_ifo_[str2] = 1;
	matrix_ifo_[str3] = 1;
	matrix_ifo_.redraw = "ALL"
end 

local function deal_select_ifo(lin)
	txt_read_me_.value = "";
	local str = "app/" .. matrix_ifo_:getcell(lin,2) .. "/readme.txt"
	local file = io.open(str,"r")
	if not file then 
		return 
	else 
		txt_read_me_.value = file:read("*all")
		file:close();
	end
end

local function show_file_configure(all_path)
	init_matrix_head()
	local t = file_io_.readfile{file = all_path}
	if not t then t = {} end 
	for k,v in ipairs (t) do 
		local file_status = "Warning:App is non-existent!";
		if file_io_.is_there_file{file = v .. ".lua"} then 
			file_status = "OK"
		end
		local cur_show = string.sub(v,5,-6)
		init_matrix_data(cur_show,file_status,"ON")
	end 
	local tab = deal_get_resource_db(t)
	for k,v in pairs (tab) do 
		init_matrix_data(v.name,v.states,"OFF")
	end
end

local function deal_select__configure_file(lin)
	local file_name = matrix_ifo2_:getcell(lin,1)
	if not save_load_path_ then return end 
	local all_path = save_load_path_ .. file_name .. ".lua"
	local file = io.open(all_path,"r")
	if not file then 
		return 
	else
		file:close();
		dofile(all_path)
		show_file_configure(all_path)
	end
end 

local function deal_save()
	if not save_load_path_ then return end 
	local all_path = save_load_path_ .. txt_save_file_name_.value .. ".lua"
	local t = {}
	for i = 1,matrix_nums_ do 
		if matrix_ifo_["TOGGLEVALUE" .. i .. ":1"] == "ON" then
			table.insert(t,"app/" .. matrix_ifo_:getcell(i,2) .. "/main")
		end
	end
	file_save_.tofile{file = all_path,src = t}
	init_matrix2_head()
	init_matrix2_data()
end 

local function file_exist()
	local filename = txt_save_file_name_.value
	
	for i = 1,matrix_nums2_ do 
		if filename == matrix_ifo2_:getcell(i,1) then
			local t = iup.Alarm("Warning","File has been exist,Do you want change it ?","Yes","No") 
			if t and t == 1 then
				return false 
			else 
				return true 
			end  
		end
	end 
	return false 
end 

local function deal_select_all_ifo(status)
	for i = 1, matrix_nums_ do 
		matrix_ifo_["TOGGLEVALUE" .. i .. ":1"] = status
		init_color(matrix_ifo_:getcell(i,3),status,i)
	end
	matrix_ifo_.redraw = "ALL"
end


local function msg()
	local save_sel_lin = nil;
	local save_sel_lin_2 = nil
	function matrix_ifo_:click_cb(lin, col,str)
		if lin == 0 or string.find(str,"2")  then return end 
		if  string.find(str,"3") and string.find(str,"D")  then return end 
		if save_sel_lin then
			init_select_matrix(save_sel_lin,0)
		end
		save_sel_lin = tonumber(lin);
		init_select_matrix(lin,1)
		if string.find(str,"3") then 
			return menu_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
			
		end
		if tonumber(col) == 1 then
			if matrix_ifo_["TOGGLEVALUE" .. lin .. ":" .. col] ~= "ON" then
				matrix_ifo_["TOGGLEVALUE" .. lin .. ":" .. col] = "ON"
			else
				matrix_ifo_["TOGGLEVALUE" .. lin .. ":" .. col] = "OFF"
			end
			init_color(matrix_ifo_:getcell(lin,3),matrix_ifo_["TOGGLEVALUE" .. lin .. ":" .. col],lin)
			matrix_ifo_.REDRAW = "all"
		end
		if tonumber(lin) >  matrix_nums_ then 
			save_sel_lin = nil;
			txt_read_me_.value = "";
		else 
			deal_select_ifo(lin)
		end
		
	end
	
	function matrix_ifo2_:click_cb(lin, col,str)
		if lin == 0 or string.find(str,"2") or string.find(str,"3") then return end 
		save_sel_lin_2 = tonumber(lin)
		init_select_matrix2(lin,1)
		if tonumber(lin) >  matrix_nums2_ then return end 
		txt_save_file_name_.value= self:getcell(lin,1) 
		if string.find(str,"1") and string.find(str,"D") then 
			deal_select__configure_file(lin)
		end
	end 
	
	function btn_up_:action()
		if not save_sel_lin then
			iup.Message("Warning","Please select a line with data in matrix!")
			return
		end
		if save_sel_lin <= 1 then return end 
		matrix_ifo_.SHOW = save_sel_lin - 1
		deal_btn_up_action(save_sel_lin)
		save_sel_lin = save_sel_lin - 1

	end
	
	function btn_down_:action()
		if not save_sel_lin then
			iup.Message("Warning","Please select a line with data in matrix!")
			return
		end 
		if save_sel_lin >= matrix_nums_ then return end 
		matrix_ifo_.SHOW = save_sel_lin + 1
		deal_btn_down_action(save_sel_lin) 
		save_sel_lin = save_sel_lin + 1
	end
	
	function btn_save_:action()
		if not string.find(txt_save_file_name_.value,"%S+") then iup.Message("Warning","File name can not be empty string !") return end 
		if string.find(txt_save_file_name_.value,"%.") then iup.Message("Warning","File name extension is not allowed to appear !") return end 
		if  file_exist() then  return end
		deal_save()
		txt_save_file_name_.value = "" 
	end 
	
	function btn_ok_:action()
		deal_ok_action()
		require "sys.main".reload()
		dlg_:hide();
	end
	
	function btn_cancel_:action()
		dlg_:hide();
	end
	

	function matrix_ifo_:dropcheck_cb(lin,col)
		if tonumber(col) == 1 then 
			return iup.CONTINUE
		end
		return iup.IGNORE
	end

	function item_select_all_:action()
		deal_select_all_ifo("ON")
	end

	function item_select_none_:action()
		deal_select_all_ifo("OFF")
	end

	function btn_del_:action()
		if not save_sel_lin_2 then return end 
		local alarm = iup.Alarm("Notice","Are you sure you want to delete it?","Yes","No")
		if alarm  ~= 1 then return end 
		local str = matrix_ifo2_:getcell(save_sel_lin_2,1)
		if not str then return end 
		local all_path = save_load_path_ .. str .. ".lua"
		os.remove (all_path)
		txt_save_file_name_.value = ""
		init_matrix2_head()
		init_matrix2_data()

	end
	
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	msg()
	dlg_:map()
	init_data()
	dlg_:popup()
end

local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end

local function get_load_path(dir)
	if type(dir) ~= "string" then save_load_path_ = nil return end 
	save_load_path_ = string.gsub(dir,"/","\\")
	if string.sub(save_load_path_,-1,-1) ~= "\\" then 
		save_load_path_ = save_load_path_ .. "\\"
	end 
end 
function pop(name,dir)
	read_file_name_ = name
	get_load_path(dir)
	
	if not read_file_name_ then trace_out("Error,Incorrect parameters!") end
	
	if dlg_ then show() else init() end 
end
