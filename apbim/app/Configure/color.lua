_ENV = module(...,ap.adv)

local iup = require "iuplua"
local iupcontrols = require "iupluacontrols"

local file_io_ = require "sys.io"
local file_save_ = require "sys.table"
local dlg_pos_ = "app.configure."
local read_file_name_ = nil;

local dlg_ = nil
local matrix_nums_ = 0;

local function init_buttons()
	local wid = "100x"
	local small_wid = "30x100"
	
	btn_add_ = iup.button{title = "Add",rastersize = wid,}
	btn_del_ = iup.button{title = "Del",rastersize = wid,}
	btn_edit_ = iup.button{title = "Edit",rastersize = wid,}
	
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_up_ =  iup.button{rastersize = small_wid,fontsize = "14"}
	local str = string.gsub(dlg_pos_,"%.","\\") .. "up.bmp"
	iup.SetAttribute(btn_up_, "IMAGE", str);
	btn_down_ =  iup.button{rastersize = small_wid,fontsize = "14"}
	str = string.gsub(dlg_pos_,"%.","\\") .. "down.bmp"
	iup.SetAttribute(btn_down_, "IMAGE", str);
	
	btn_color_select_ = iup.button{title = "Color Browser",rastersize = wid}
end

local function init_controls()
	color_ = iup.colordlg{
		SHOWALPHA="YES";
		ALPHA  = "255";
		SHOWALPHA  = "YES";
		SHOWHEX = "YES";
	}
	matrix_ifo_ = iup.matrix{
		numlin = 20;
		numcol = 6;
		RASTERWIDTH1 = 50;
		RASTERWIDTH2 = 100;
		RASTERWIDTH3 = 150;
		RASTERWIDTH4 = 100;
		RASTERWIDTH5 = 100;
		RASTERWIDTH6 = 100;
		markmode = "CELL";
		rastersize = "670x400";
		readonly = "YES";
		
	}
	local lab_wid = "100x"
	lab_color_ = iup.label{title = "Color : ",fontsize = 12};
	txt_color_name_ = iup.text{fontsize = 12,expand = "HORIZONTAL"};
	lab_color_r_ = iup.label{title = "R : ",fontsize = 12};
	lab_color_g_ = iup.label{title = "G : ",fontsize = 12};
	lab_color_b_ = iup.label{title = "B : ",fontsize = 12};
	txt_color_r_ = iup.text{rastersize = "50",fontsize = 12,expand = "HORIZONTAL"};
	txt_color_g_ = iup.text{rastersize = "50",fontsize = 12,expand = "HORIZONTAL"};
	txt_color_b_ = iup.text{rastersize = "50",fontsize = 12,expand = "HORIZONTAL"};
	lab_color_browser_ = iup.label{title = "Color Preview : ",fontsize = 12,};
	frame_color_browser_ = iup.frame{rastersize = "100x",bgcolor = "255 255 255",};
	
	frame_matrix_ = iup.frame{
		
		iup.vbox{
			iup.hbox{
				matrix_ifo_;
				iup.vbox{iup.fill{},btn_up_,iup.fill{},btn_down_,iup.fill{}};
				margin = "0x0";
			};
			iup.hbox{
				
				lab_color_,
				txt_color_name_,
				lab_color_r_,
				txt_color_r_,
				iup.fill{},
				lab_color_g_,
				txt_color_g_,
				iup.fill{},
				lab_color_b_,
				txt_color_b_,
				iup.fill{},
				btn_color_select_,
			};
			iup.hbox{
				
			
				btn_add_;
				btn_edit_;
				btn_del_;
				iup.fill{rastersize = "200x"},
				frame_color_browser_,
			};
		
			margin = "5x5";
			alignment = "ARIGHT";
		}
	}
	

end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			frame_matrix_;
			iup.hbox{
				
				btn_ok_;
				btn_cancel_;
			};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Color";
		resize = "NO";
	}
end

local function init_matrix_head()
	matrix_ifo_:setcell(0,1,"ID")
	matrix_ifo_:setcell(0,2,"Color")
	matrix_ifo_:setcell(0,3,"Name")
	matrix_ifo_:setcell(0,4,"R")
	matrix_ifo_:setcell(0,5,"G")
	matrix_ifo_:setcell(0,6,"B")
	if matrix_nums_ ~= 0 then 
		matrix_ifo_.DELLIN = "1-" .. matrix_nums_
	end
	matrix_nums_ = 0 
	matrix_ifo_.numlin = 20;
end

local function init_color(data,lin)
	matrix_ifo_["bgcolor" .. lin .. ":2"] = data[1] .. [[ ]] ..  data[2]  .. [[ ]] .. data[3]
	--matrix_ifo_["fgcolor" .. lin .. ":*"] = data[1] .. [[ ]] ..  data[2]  .. [[ ]] .. data[3]
	matrix_ifo_.redraw = "ALL"
end

local function init_matrix_data(data,lin)
	
	local cur_lin = nil;
	if not lin then 
		matrix_nums_ = matrix_nums_ + 1;
		if matrix_nums_ > tonumber(matrix_ifo_.numlin) then 
			matrix_ifo_.numlin = matrix_nums_
		end
		cur_lin = matrix_nums_
	else 
		cur_lin = lin
	end 
	matrix_ifo_:setcell(cur_lin,1,cur_lin)
	matrix_ifo_:setcell(cur_lin,3,data.name)
	matrix_ifo_:setcell(cur_lin,4,data[1])
	matrix_ifo_:setcell(cur_lin,5,data[2])
	matrix_ifo_:setcell(cur_lin,6,data[3])
	init_color(data,cur_lin)
	matrix_ifo_.redraw = "ALL"
end

local function init_txt_ifo()
	txt_color_name_.value = ""
	txt_color_r_.value = ""
	txt_color_g_.value = ""
	txt_color_b_.value = ""
	frame_color_browser_.bgcolor = "255 255 255"
end

local function init_data()
	init_matrix_head()
	local t = file_io_.readfile{file = read_file_name_}
	if not t then return end 
	for k,v in ipairs (t) do
		--local cur_show = string.sub(v,5,-6)
		init_matrix_data(v)
	end 
	init_txt_ifo()
end

local function init_select_matrix(lin,num)
	
	matrix_ifo_["mark" .. lin .. ":1"] = num
	matrix_ifo_["mark" .. lin .. ":2"] = num
	matrix_ifo_["mark" .. lin .. ":3"] = num
	matrix_ifo_["mark" .. lin .. ":4"] = num
	matrix_ifo_["mark" .. lin .. ":5"] = num
	matrix_ifo_["mark" .. lin .. ":6"] = num
	matrix_ifo_.redraw = "ALL"
end

local function deal_ok_action()
	local t = {}
	for i = 1,matrix_nums_ do 
		table.insert(t,
			{
				tonumber(matrix_ifo_:getcell(i,4)),
				tonumber(matrix_ifo_:getcell(i,5)),
				tonumber(matrix_ifo_:getcell(i,6)),
				name = matrix_ifo_:getcell(i,3)
			}
		) 
	end
	file_save_.tofile{file = read_file_name_,src = t}
end

local function deal_btn_up_action(lin)
	
	local temp = {};
	temp.name = matrix_ifo_:getcell(lin-1,3)
	temp[1] =  matrix_ifo_:getcell(lin-1,4)
	temp[2] = matrix_ifo_:getcell(lin-1,5)
	temp[3] = matrix_ifo_:getcell(lin-1,6)
	
	local temp2 = {}
	temp2.name = matrix_ifo_:getcell(lin,3)
	temp2[1] = matrix_ifo_:getcell(lin,4)
	temp2[2] = matrix_ifo_:getcell(lin,5)
	temp2[3] = matrix_ifo_:getcell(lin,6)
	matrix_ifo_:setcell(lin-1,3,matrix_ifo_:getcell(lin,3))
	matrix_ifo_:setcell(lin-1,4,matrix_ifo_:getcell(lin,4))
	matrix_ifo_:setcell(lin-1,5,matrix_ifo_:getcell(lin,5))
	matrix_ifo_:setcell(lin-1,6,matrix_ifo_:getcell(lin,6))
	init_color(temp2,lin-1)
	matrix_ifo_:setcell(lin,3,temp.name)
	matrix_ifo_:setcell(lin,4,temp[1])
	matrix_ifo_:setcell(lin,5,temp[2])
	matrix_ifo_:setcell(lin,6,temp[3])
	init_color(temp,lin)
	--init_color(temp.file_status,temp.file_load,lin)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	local str4 = "mark" .. (lin) .. ":4";
	local str5 = "mark" .. (lin) .. ":5";
	local str6 = "mark" .. (lin) .. ":6";
	matrix_ifo_[str1] = 0;
	matrix_ifo_[str2] = 0;
	matrix_ifo_[str3] = 0;
	matrix_ifo_[str4] = 0;
	matrix_ifo_[str5] = 0;
	matrix_ifo_[str6] = 0;
	local str1 = "mark" .. (lin-1) .. ":1";
	local str2 = "mark" .. (lin-1) .. ":2";
	local str3 = "mark" .. (lin-1) .. ":3";
	local str4 = "mark" .. (lin-1) .. ":4";
	local str5 = "mark" .. (lin-1) .. ":5";
	local str6 = "mark" .. (lin-1) .. ":6";
	matrix_ifo_[str1] = 1;
	matrix_ifo_[str2] = 1;
	matrix_ifo_[str3] = 1;
	matrix_ifo_[str4] = 1;
	matrix_ifo_[str5] = 1;
	matrix_ifo_[str6] = 1;
	matrix_ifo_.redraw = "ALL"
end 

local function deal_btn_down_action(lin)
	local temp = {};
	temp.name = matrix_ifo_:getcell(lin+1,3)
	temp[1] =  matrix_ifo_:getcell(lin+1,4)
	temp[2] = matrix_ifo_:getcell(lin+1,5)
	temp[3] = matrix_ifo_:getcell(lin+1,6)
	
	local temp2 = {}
	temp2.name = matrix_ifo_:getcell(lin,3)
	temp2[1] = matrix_ifo_:getcell(lin,4)
	temp2[2] = matrix_ifo_:getcell(lin,5)
	temp2[3] = matrix_ifo_:getcell(lin,6)
	matrix_ifo_:setcell(lin+1,3,matrix_ifo_:getcell(lin,3))
	matrix_ifo_:setcell(lin+1,4,matrix_ifo_:getcell(lin,4))
	matrix_ifo_:setcell(lin+1,5,matrix_ifo_:getcell(lin,5))
	matrix_ifo_:setcell(lin+1,6,matrix_ifo_:getcell(lin,6))
	init_color(temp2,lin+1)
	matrix_ifo_:setcell(lin,3,temp.name)
	matrix_ifo_:setcell(lin,4,temp[1])
	matrix_ifo_:setcell(lin,5,temp[2])
	matrix_ifo_:setcell(lin,6,temp[3])
	init_color(temp,lin)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	local str4 = "mark" .. (lin) .. ":4";
	local str5 = "mark" .. (lin) .. ":5";
	local str6 = "mark" .. (lin) .. ":6";
	matrix_ifo_[str1] = 0;
	matrix_ifo_[str2] = 0;
	matrix_ifo_[str3] = 0;
	matrix_ifo_[str4] = 0;
	matrix_ifo_[str5] = 0;
	matrix_ifo_[str6] = 0;
	local str1 = "mark" .. (lin+1) .. ":1";
	local str2 = "mark" .. (lin+1) .. ":2";
	local str3 = "mark" .. (lin+1) .. ":3";
	local str4 = "mark" .. (lin+1) .. ":4";
	local str5 = "mark" .. (lin+1) .. ":5";
	local str6 = "mark" .. (lin+1) .. ":6";
	matrix_ifo_[str1] = 1;
	matrix_ifo_[str2] = 1;
	matrix_ifo_[str3] = 1;
	matrix_ifo_[str4] = 1;
	matrix_ifo_[str5] = 1;
	matrix_ifo_[str6] = 1;
	matrix_ifo_.redraw = "ALL"
end 

local function deal_select_ifo(lin)
	txt_color_name_.value = matrix_ifo_:getcell(lin,3)
	txt_color_r_.value = matrix_ifo_:getcell(lin,4)
	txt_color_g_.value = matrix_ifo_:getcell(lin,5)
	txt_color_b_.value = matrix_ifo_:getcell(lin,6)
	frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
end

local function deal_get_color()
	
	local r,g,b = 255,255,255
	if txt_color_r_.value and txt_color_r_.value ~= "" then 
		r = tonumber(txt_color_r_.value)
	end
	if txt_color_g_.value and txt_color_g_.value ~= "" then 
		g = tonumber(txt_color_g_.value)
	end
	if txt_color_b_.value and txt_color_b_.value ~= "" then 
		b = tonumber(txt_color_b_.value)
	end
	r1,g1,b1 =iup.GetColor(100,100,r,g,b)
	r1,g1,b1 = r1 or r,g1 or g ,b1 or b 
	txt_color_r_.value = r1
	txt_color_g_.value = g1
	txt_color_b_.value = b1
	frame_color_browser_.bgcolor = r1 .. [[ ]] .. g1 .. [[ ]] .. b1
	
end 

local function deal_warning_ifo(data)
	if  data[1] == "" or string.find(data[1],"%D+") then  iup.Message("Warning","Please input R number!") txt_color_r_.value = "" return true end 
	if tonumber(data[1]) > 255 or  tonumber(data[1]) < 0  then  iup.Message("Warning","Please input R 0~255 number!") txt_color_r_.value = "" return true end 
	if  data[2] == "" or string.find(data[2],"%D+") then  iup.Message("Warning","Please input G number!") txt_color_g_.value = "" return true end 
	if tonumber(data[2]) > 255 or  tonumber(data[2]) < 0  then  iup.Message("Warning","Please input G 0~255 number!") txt_color_g_.value = "" return true end 
	if  data[3] == "" or string.find(data[3],"%D+") then  iup.Message("Warning","Please input B number!") txt_color_b_.value = "" return true end 
	if tonumber(data[3]) > 255 or  tonumber(data[3]) < 0  then  iup.Message("Warning","Please input B 0~255 number!") txt_color_b_.value = ""  return true end 
	return false
end


local function deal_add_ifo()
	local data = {}
	data.name = txt_color_name_.value 
	if txt_color_name_.value  == ""  then iup.Message("Warning","Please input color name !")  return  end 
	data[1] = txt_color_r_.value 
	data[2] = txt_color_g_.value 
	data[3] = txt_color_b_.value
	if deal_warning_ifo(data) then return end 
	init_matrix_data(data)
	init_txt_ifo()
end

local function deal_edit_ifo(lin)
	
	if txt_color_name_.value  == ""  then iup.Message("Warning","Please input color name !")  return  end 
	local data = {}
	data.name = txt_color_name_.value 
	data[1] = txt_color_r_.value 
	data[2] = txt_color_g_.value 
	data[3] = txt_color_b_.value
	if deal_warning_ifo(data) then return end 
	init_matrix_data(data,lin)
end

local function deal_del_ifo(lin)
	
	matrix_ifo_.DELLIN = lin
	matrix_ifo_.numlin = matrix_ifo_.numlin + 1;
	matrix_nums_ = matrix_nums_ - 1
	if tonumber(lin) <= tonumber(matrix_nums_) then 
		for i = tonumber(lin),matrix_nums_ do 
			matrix_ifo_:setcell(i,1,i)
		end
	end
	matrix_ifo_.redraw = "ALL"
end

local function msg()
	local save_sel_lin = nil;
	function matrix_ifo_:click_cb(lin, col,str)
		if lin == 0 or string.find(str,"2") or string.find(str,"3") then return end 
		save_sel_lin = tonumber(lin);
		init_select_matrix(lin,1)
		
		if tonumber(lin) <=  matrix_nums_ and tonumber(lin) > 0 then 
			deal_select_ifo(lin)
		else 
			init_txt_ifo()
			save_sel_lin = nil;
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
	
	function btn_ok_:action()
		deal_ok_action()
		dlg_:hide();
	end
	
	function btn_cancel_:action()
		dlg_:hide();
	end
	
	function btn_add_:action()
		deal_add_ifo()
		
	end
	
	function btn_edit_:action()
		if not save_sel_lin or (save_sel_lin and tonumber(save_sel_lin) > matrix_nums_) then iup.Message("Warning","Please select a line with data in matrix!") return end 
		deal_edit_ifo(save_sel_lin)
	end
	
	function btn_del_:action()
		
		if not save_sel_lin or (save_sel_lin and tonumber(save_sel_lin) > matrix_nums_) then iup.Message("Warning","Please select a line with data in matrix!") return end 		
		deal_del_ifo(save_sel_lin)
		init_txt_ifo()
		init_select_matrix(save_sel_lin,1)
		deal_select_ifo(save_sel_lin)
		frame_color_browser_.bgcolor = "255 255 255"
	end
	
	function btn_color_select_:action()
		deal_get_color()
	end
	
	function txt_color_r_:valuechanged_cb()
		if txt_color_g_.value == "" then 
			txt_color_g_.value = 0
		end 
		if txt_color_b_.value == "" then 
			txt_color_b_.value = 0
		end 
		if  txt_color_r_.value == ""  or string.find(txt_color_r_.value,"%D+") then
			iup.Message("Warning","Please input R number!")
			txt_color_r_.value = ""
			frame_color_browser_.bgcolor = 0 .. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
			return true
		end  
		if tonumber(txt_color_r_.value) > 255 or  tonumber(txt_color_r_.value) < 0  then
			iup.Message("Warning","Please input R 0~255 number!")
			txt_color_r_.value = ""
			frame_color_browser_.bgcolor = 0 .. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
			return true
		end  
		frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
	end
	
	function txt_color_g_:valuechanged_cb()
		if txt_color_b_.value == "" then 
			txt_color_b_.value = 0
		end 
		if txt_color_r_.value == "" then 
			txt_color_r_.value = 0
		end 
		if txt_color_g_.value == ""  or string.find(txt_color_g_.value,"%D+") then  
			iup.Message("Warning","Please input G number!")
			txt_color_g_.value = ""
			frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. 0 .. [[ ]] .. txt_color_b_.value
			return true 
		end 
		if tonumber(txt_color_g_.value) > 255 or  tonumber(txt_color_g_.value) < 0  then
			iup.Message("Warning","Please input G 0~255 number!")
			txt_color_g_.value = ""
			frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. 0 .. [[ ]] .. txt_color_b_.value
			return true
		end  
		frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
	end

	function txt_color_b_:valuechanged_cb()
		if txt_color_g_.value == "" then 
			txt_color_g_.value = 0
		end 
		if txt_color_r_.value == "" then 
			txt_color_r_.value = 0
		end 
		if txt_color_b_.value == ""  or  string.find(txt_color_b_.value,"%D+") then
			iup.Message("Warning","Please input B number!")
			txt_color_b_.value = ""
			frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. 0
			return true
		end  
		if  (tonumber(txt_color_b_.value) > 255 or  tonumber(txt_color_b_.value) < 0 ) then
			iup.Message("Warning","Please input B 0~255 number!")
			txt_color_b_.value = ""
			frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. 0
			return true
		end  
		frame_color_browser_.bgcolor = txt_color_r_.value.. [[ ]] .. txt_color_g_.value .. [[ ]] .. txt_color_b_.value
	end
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	msg()
	init_data()
	dlg_:show()
end

local function show()
	init_data()
	dlg_:show()
end

function pop(name)
	read_file_name_ = name
	if not read_file_name_ then trace_out("Error,Incorrect parameters!") end
	if dlg_ then show() else init() end 
end