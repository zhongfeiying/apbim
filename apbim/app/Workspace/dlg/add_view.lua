

_ENV = module(...,ap.adv)
--module(...,package.seeall)

require "lfs"
require "iuplua"
require "iupluacontrols"
local file_op_ = require "app.workspace.ctr_require".file_op()
local edit_tab_ = nil
--local copy_to_target_file_ = "pdf_db\\resource\\"
local file_save_path_ = "data\\BCA.Res"
local file_save_res_path_ = "data\\BCA.Res\\Res"
lfs.mkdir(file_save_path_)
lfs.mkdir(file_save_res_path_)
local dlg_ = nil;
local matrix_lin_ = 0;
local function init_buttons()
	local wid = "100x"
	local big_wid = "200x";
	local small_wid = "50x"
	btn_ok_ =  iup.button{title = "Ok",rastersize = wid,};
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid};
	btn_add_from_pciture_ = iup.button{title = "Add Picture",rastersize = wid,};
	btn_add_from_dxf_ = iup.button{title = "Add Dxf",rastersize = wid};
	btn_add_others_file_ = iup.button{title = "Add Others",rastersize = wid}
	btn_open_ =  iup.button{title = "Open",rastersize = small_wid};
	btn_up_ = iup.button{title = "¡ü",rastersize = small_wid};
	btn_down_ = iup.button{title = "¡ý",rastersize = small_wid};
	btn_del_ =  iup.button{title = "Del",rastersize = small_wid};
	
	tog_file_dir_ = iup.toggle{title = "Add Folder",fontsize = 12};
	vbox1_= iup.vbox{iup.fill{},btn_up_,btn_down_,btn_del_,btn_open_,iup.fill{}};
	hbox1_ = iup.hbox{tog_file_dir_,iup.fill{},btn_add_others_file_,btn_add_from_pciture_,btn_add_from_dxf_,btn_ok_,btn_cancel_,alignment = "ARIGHT"};
end

local function init_controls()
	local wid = "400x"; 
	local lab_wid = "100x";
	matrix_view_ifo_ = iup.matrix{
		readonly = "YES";
		numcol = 3;
		RESIZEMATRIX= "no";
		WIDTH1 = 40;
		WIDTH2 = 100;
		WIDTH3 = 320;
		scrollbar ="yes";
		rastersize = "700x200";
		expand = "NO";
		MARKMODE = "cell";
		HIDDENTEXTMARKS= "YES";
		--MARKMULTIPLE = "YES";
		alignment = "ALEFT";
	};
	lab_title_ = iup.label{title = "Title:",rastersize = lab_wid};
	txt_title_ = iup.text{rastersize = "400x",expand = "HORIZONTAL"};
	lab_content_ = iup.label{title = "Content:",rastersize = lab_wid};
	txt_content_ = iup.text{
							rastersize = "400x100",
							expand = "yes",
							MULTILINE = "YES", --¶àÐÐ
							WORDWRAP="YES";
							scrollbar = "YES";
							};
	vbox2_ = iup.vbox{iup.hbox{lab_title_,txt_title_},iup.hbox{lab_content_,txt_content_}};
	frame_view_name_ = iup.frame{
		iup.vbox{
		vbox2_;
		iup.hbox{
				iup.frame{matrix_view_ifo_,BGCOLOR = "255 255 255"};
				vbox1_;
			};
		};
		expand = "YES";
		margin = "5x5";
		size = "525x";
	};
	file_dlg_ = iup.filedlg{
		rastersize = "800x800";
		SHOWPREVIEW = "YES";
		NOCHANGEDIR = "YES";
	}
end


function pop_file_dlg(dlgtype,type)
	file_dlg_.DIALOGTYPE = dlgtype
	if dlgtype == "OPEN" then
		if type then 
			file_dlg_.EXTFILTER =type .. " File" ..  "|*." .. type 
		else
			file_dlg_.EXTFILTER = "ALL FILES | *.*"
		end
		file_dlg_.DIRECTORY = file_save_res_path_
		file_dlg_.MULTIPLEFILES = "NO"
	end
	file_dlg_:popup()
end

local function init_data()
	tog_file_dir_.value = "off"
	txt_title_.value = "";
	txt_content_.value = "";
	matrix_view_ifo_:setcell(0,1,"Type")
	matrix_view_ifo_:setcell(0,2,"name")
	matrix_view_ifo_:setcell(0,3,"Information")
	matrix_view_ifo_.numlin = 0;
	matrix_lin_= 0;
	matrix_view_ifo_.redraw = "ALL";
	if edit_tab_ then
		txt_title_.value = edit_tab_.name
		txt_content_.value = edit_tab_.txt
		if type(edit_tab_.res) == "table" then
			for i=1,#edit_tab_.res do 
				matrix_lin_ = matrix_lin_ + 1
				matrix_view_ifo_.numlin = matrix_lin_
				matrix_view_ifo_:setcell(matrix_lin_,1,edit_tab_.res[i].type)
				matrix_view_ifo_:setcell(matrix_lin_,2,edit_tab_.res[i].name)
				matrix_view_ifo_:setcell(matrix_lin_,3,lfs.currentdir() .. "\\" .. string.gsub(edit_tab_.res[i].ifo,"/","\\"))
				matrix_view_ifo_.redraw = "ALL"
			end
		end 
	end 
end


local function deal_up_exchange(lin)
	local temp = {};
	temp.type = matrix_view_ifo_:getcell(lin-1,1)
	temp.name =  matrix_view_ifo_:getcell(lin-1,2)
	temp.ifo =  matrix_view_ifo_:getcell(lin-1,3)
	 matrix_view_ifo_:setcell(lin-1,1,matrix_view_ifo_:getcell(lin,1))
	 matrix_view_ifo_:setcell(lin-1,2,matrix_view_ifo_:getcell(lin,2))
	 matrix_view_ifo_:setcell(lin-1,3,matrix_view_ifo_:getcell(lin,3))
	 matrix_view_ifo_:setcell(lin,1,temp.type)
	 matrix_view_ifo_:setcell(lin,2,temp.name)
	 matrix_view_ifo_:setcell(lin,3,temp.ifo)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	matrix_view_ifo_[str1] = 0;
	matrix_view_ifo_[str2] = 0;
	matrix_view_ifo_[str3] = 0;
	local str1 = "mark" .. (lin-1) .. ":1";
	local str2 = "mark" .. (lin-1) .. ":2";
	local str3 = "mark" .. (lin-1) .. ":3";
	matrix_view_ifo_[str1] = 1;
	matrix_view_ifo_[str2] = 1;
	matrix_view_ifo_[str3] = 1;
	matrix_view_ifo_.redraw = "ALL";
end

local function deal_down_exchange(lin)
	local temp = {};
	temp.type = matrix_view_ifo_:getcell(lin+1,1)
	temp.name =  matrix_view_ifo_:getcell(lin+1,2)
	temp.ifo =  matrix_view_ifo_:getcell(lin+1,3)
	 matrix_view_ifo_:setcell(lin+1,1,matrix_view_ifo_:getcell(lin,1))
	 matrix_view_ifo_:setcell(lin+1,2,matrix_view_ifo_:getcell(lin,2))
	 matrix_view_ifo_:setcell(lin+1,3,matrix_view_ifo_:getcell(lin,3))
	 matrix_view_ifo_:setcell(lin,1,temp.type)
	 matrix_view_ifo_:setcell(lin,2,temp.name)
	 matrix_view_ifo_:setcell(lin,3,temp.ifo)
	local str1 = "mark" .. (lin) .. ":1";
	local str2 = "mark" .. (lin) .. ":2";
	local str3 = "mark" .. (lin) .. ":3";
	matrix_view_ifo_[str1] = 0;
	matrix_view_ifo_[str2] = 0;
	matrix_view_ifo_[str3] = 0;
	local str1 = "mark" .. (lin+1) .. ":1";
	local str2 = "mark" .. (lin+1) .. ":2";
	local str3 = "mark" .. (lin+1) .. ":3";
	matrix_view_ifo_[str1] = 1;
	matrix_view_ifo_[str2] = 1;
	matrix_view_ifo_[str3] = 1;
	matrix_view_ifo_.redraw = "ALL";
end 


local function 	deal_open_picture_ifo(lin,path)
	os.execute("start  \"\" " .. "\"" .. path .. "\"");
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			frame_view_name_;
			margin = "10x10";
			hbox1_;
			alignment = "ARIGHT";
		};
		title = "Add View";
	};
end

local function add_marix_data(type,name,info)
	matrix_lin_ = matrix_lin_ + 1
	if matrix_lin_ > tonumber(matrix_view_ifo_.numlin) then 
		matrix_view_ifo_.numlin = matrix_lin_
	end
	matrix_view_ifo_:setcell(matrix_lin_,1,type)
	matrix_view_ifo_:setcell(matrix_lin_,2,name)
	matrix_view_ifo_:setcell(matrix_lin_,3,info)
	matrix_view_ifo_.redraw = "ALL"
	if not string.find(txt_title_.value,"%S+") then
		txt_title_.value = name .. "." .. type 
	end
end


local function deal_dir_ifo(filepath,type)
	filepath = string.match(filepath,"(.+[^\\])")
	for line in lfs.dir(filepath) do
		local attr = lfs.attributes(filepath .. "\\" .. line)
		if attr.mode == "file" then 
			if type then 
				if string.sub(line,-4,-1) and string.lower(string.sub(line,-4,-1)) == "." .. type then 
					add_marix_data(type,string.sub(line,1,-5),filepath .. "\\" .. line)
				end
			else 
				local type = string.match(line,".+%.(.+)")
				if type then
					local name = string.sub(line,1,#line - #type - 1)
					add_marix_data(type,name,filepath .. "\\" .. line)
				else
					add_marix_data("",line,filepath .. "\\" .. line)
				end
			end
		end
	end
end

local function init_matrix_select(lin,type)
	local str1 = "mark" .. lin .. ":1";
	local str2 = "mark" .. lin .. ":2";
	local str3 = "mark" .. lin .. ":3";
	matrix_view_ifo_[str1] = type;
	matrix_view_ifo_[str2] = type;
	matrix_view_ifo_[str3] = type;
	matrix_view_ifo_.redraw = "ALL"
end


local function deal_open_ifo(lin,kind,ifo)
	os.execute("start  \"\" " .. "\"" .. ifo .. "\"");
end

function copyfile(source,destination)
	sourcefile = io.open(source,r)
	destinationfile = io.open(destination,w)
	for line in sourcefile:lines() do
		destinationfile:write(line)
	end
	sourcefile:close()
	destinationfile:close()
end

local function copy_files()
	if not (matrix_lin_ and matrix_lin_ > 0 ) then return end 
	for i = 1,matrix_lin_ do 
		local str =  matrix_view_ifo_:getcell(i,3)
		local filename = string.match(str,".+\\(.+)")
		local copy_file = "copy /y "  .. "\"".. str .. "\"" .. " " .. "\"" .. file_save_res_path_ .. "\"" ;
		os.execute(copy_file);
		matrix_view_ifo_:setcell(i,3,file_save_res_path_ .. "\\" .. filename)
	end
end

local function save_file_datas(status)
	local file_name = "Resource.lua"
	local value = ""
	if not edit_tab_ then edit_tab_ ={} end
	edit_tab_.name = txt_title_.value
	edit_tab_.txt = txt_content_.value
	edit_tab_.res = {}
	value = value .. "if not db then db = {} end "
	value = value .. "db[#db+1] = {} "
	value = value .. "db[#db][\"name\"] = \"" .. txt_title_.value .. "\" "
	value = value .. "db[#db][\"txt\"] = \"" .. txt_content_.value .. "\" "
	value = value .. "db[#db][\"res\"] = {} "
	for i = 1,matrix_lin_ do 
		value = value .. "db[#db].res[#db[#db].res + 1] = {} "
		value = value .. "db[#db].res[#db[#db].res].type = \"" .. matrix_view_ifo_:getcell(i,1) .. "\" "
		value = value .. "db[#db].res[#db[#db].res].name = \"" .. matrix_view_ifo_:getcell(i,2) .. "\" "
		value = value .. "db[#db].res[#db[#db].res].ifo = \"" .. string.gsub(matrix_view_ifo_:getcell(i,3),"\\","/") .. "\" "
		local tab = {}
		tab.type = matrix_view_ifo_:getcell(i,1)
		tab.name = matrix_view_ifo_:getcell(i,2)
		tab.ifo = string.gsub(matrix_view_ifo_:getcell(i,3),"\\","/")
		table.insert(edit_tab_.res,tab)
	end
	
	file_name = file_save_path_ .. "\\" .. file_name
	file_op_.save_str_to_file(file_name,value)
end

local function msg_ok()
	copy_files()
	save_file_datas()
end

local function msg()
	local num = 0;
	local cur_matrix_select_lin = nil;
	function btn_ok_:action()
		if not string.find(txt_title_.value,"%S+") then 
			iup.Message("Warning","You do not input the title !")
			return 
		end
		msg_ok()
		dlg_:hide();
	end
	
	function btn_cancel_:action()
		edit_tab_ = nil
		dlg_:hide();
	end
	
	function btn_add_from_pciture_:action()
		local file_dir = nil;
		if tog_file_dir_.value == "ON" then 
			pop_file_dlg("DIR")
			file_dir = "YES";
		elseif  tog_file_dir_.value == "OFF" then 
			pop_file_dlg("OPEN","jpg")
		end 
		local file_path = file_dlg_.value
		
		if file_path then 
			file_dlg_.DIRECTORY =file_path
			if file_dir == "YES" then 
				deal_dir_ifo(file_path,"jpg");
			else 
				local name = string.match(file_path,".+\\([^%.]+)")
				add_marix_data("jpg",name,file_path)
			end	
		end
	end
	function btn_add_from_dxf_:action()	
		local file_dir = nil;
		if tog_file_dir_.value == "ON" then 
			pop_file_dlg("DIR")
			file_dir = "YES";
		elseif  tog_file_dir_.value == "OFF" then 
			pop_file_dlg("OPEN","dxf")
		end 
		local file_path = file_dlg_.value
		if file_path then 
			file_dlg_.DIRECTORY =file_path
			if file_dir == "YES" then 
				deal_dir_ifo(file_path,"dxf");
			else 
				local name = string.match(file_path,".+\\([^%.]+)")
				add_marix_data("dxf",name,file_path)
			end	
		end
	end

	function btn_add_others_file_:action()
		local file_dir = nil
		if tog_file_dir_.value == "ON" then 
			pop_file_dlg("DIR")
			file_dir = "YES"
		elseif tog_file_dir_.value == "OFF" then 
			pop_file_dlg("OPEN")
		end
		local filepath = file_dlg_.value
		if filepath then 
			file_dlg_.DIALOGTYPE = filepath
			if file_dir == "YES" then 
				deal_dir_ifo(filepath)
			else
				local name = string.match(filepath,".+\\([^%.]+)")
				local type = string.match(filepath,".+%.(.+)")
				add_marix_data(type,name,filepath)
			end
		end
	end

	function matrix_view_ifo_:click_cb(lin,col,str)
		if lin == 0 then lin = 1 end 
		cur_matrix_select_lin = lin;
		init_matrix_select(lin,1)
	end


	function btn_up_:action()
		if not cur_matrix_select_lin or cur_matrix_select_lin == 1 then 
			return
		else 
			deal_up_exchange(cur_matrix_select_lin);
			cur_matrix_select_lin = cur_matrix_select_lin -1;
		end 
	end
	function btn_down_:action()
		if  not cur_matrix_select_lin or cur_matrix_select_lin == tonumber(matrix_view_ifo_.NUMLIN) then 
			return
		else 
			deal_down_exchange(cur_matrix_select_lin);
			cur_matrix_select_lin = cur_matrix_select_lin + 1;
		end 
	end
	function btn_del_:action()
		if not cur_matrix_select_lin  then return end 
		if tonumber(cur_matrix_select_lin) <= 0 then cur_matrix_select_lin = nil return end 
		matrix_view_ifo_.DELLIN = cur_matrix_select_lin;
		if tonumber(cur_matrix_select_lin) == matrix_lin_ then 
			cur_matrix_select_lin = matrix_lin_ - 1
		end
		if matrix_lin_ >= 1 then 
			matrix_lin_ = matrix_lin_ - 1;
		end 
		init_matrix_select(cur_matrix_select_lin,1)
	end
	function btn_open_:action()
		if not cur_matrix_select_lin then return end 
		local view_path = matrix_view_ifo_:getcell(cur_matrix_select_lin,3)
		local view_type = matrix_view_ifo_:getcell(cur_matrix_select_lin,1)
		if view_path and view_path ~= "" then 
			deal_open_ifo(cur_matrix_select_lin,view_type,view_path);
		end
	end
	
	function dlg_:close_cb()
		edit_tab_ = nil
	end
end

local function init()
	init_buttons();
	init_controls();
	init_data();
	init_dlg();
	msg();
	dlg_:popup();
end

local function show()
	init_data();
	dlg_:popup();
end


function set_data(tab)
	edit_tab_ = tab
end

function pop()
	if dlg_ then show() else init() end
end

function get_data()
	return edit_tab_
end
