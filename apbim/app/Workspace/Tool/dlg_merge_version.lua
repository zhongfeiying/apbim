module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil;
local db_ = nil
local sel_ver_ = nil
local cur_path_ = nil
local matrix_nums_ = 0
local cur_ver_ = nil


local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_open_ = iup.button{title = "...",rastersize = "50x"}
end 

local function init_controls()
	local wid = "100x"
	lab_work_path_ = iup.label{title = "Work Path :",rastersize = wid}
	txt_work_path_ =  iup.text{expand = "HORIZONTAL",readonly = "YES"}
	matrix_ver_ = iup.matrix{}
	matrix_ver_.MARKMULTIPLE = "YES"
	file_dlg_ = iup.filedlg{}
	file_dlg_.DIALOGTYPE = "DIR"
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			--iup.hbox{lab_work_path_,txt_work_path_,btn_open_};
			iup.hbox{matrix_ver_};
			iup.hbox{btn_ok_};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Select Verion";
		rastersize = "740x400";
		resize = "NO";
	}
end 

local function msg_ok(lin)
	sel_ver_ = db_[lin]
	cur_path_ = txt_work_path_.value
end 

local function matrix_select(lin, col,type)
	matrix_ver_["MARK" .. lin .. ":0"] = type
	matrix_ver_["MARK" .. lin .. ":1"] = type
	matrix_ver_["MARK" .. lin .. ":2"] = type
	matrix_ver_["MARK" .. lin .. ":3"] = type
	matrix_ver_["MARK" .. lin .. ":4"] = type
	matrix_ver_["MARK" .. lin .. ":5"] = type
end


local function init_msg()
	local save_sel_lin = 1
	function btn_ok_:action()
		if not save_sel_lin then 
			iup.Message("Warning","Please select data !")
			return 
		end
		if not string.find(txt_work_path_.value,"%S+") then 
			iup.Message("Warning","Path error !")
			return 
		end 		
		msg_ok()
		dlg_:hide();
	end 
	function matrix_ver_:click_cb(lin, col, status)
		save_sel_lin  = nil
		if  tonumber(lin) > matrix_nums_  then
			matrix_select(lin, col,0)  
		else 
			matrix_select(lin, col,1)
			--save_sel_lin = tonumber(lin)
		end
	end 
	
	function btn_open_:action()
		file_dlg_:popup()
		local val = file_dlg_.value
		if not val then return end 
		if not string.find(val,"%w+") then return end 
		if string.sub(val,-1,-1) ~= "\\" then val = val .. "\\" end 
		txt_work_path_.value = val
	end
end

local function init_matirx_control()
	matrix_ver_.numcol = 5
	matrix_ver_.numlin = 10
	matrix_ver_.HIDDENTEXTMARKS = "YES"
	matrix_ver_.READONLY = "YES"
	matrix_ver_.MARKMULTIPLE = "YES"
	matrix_ver_.RASTERWIDTH0 = "50x"
	matrix_ver_.RASTERWIDTH1 = "200x"
	matrix_ver_.RASTERWIDTH2 = "200x"
	matrix_ver_.RASTERWIDTH3 = "200x"
	matrix_ver_.RASTERWIDTH4 = "300x"
	matrix_ver_.RASTERWIDTH5 = "400x"
	matrix_ver_.MARKMODE = "CELL"
	matrix_ver_:setcell(0,0,"Id")
	matrix_ver_:setcell(0,1,"User")
	matrix_ver_:setcell(0,2,"Time")
	matrix_ver_:setcell(0,3,"Name")
	matrix_ver_:setcell(0,4,"Verion")
	matrix_ver_:setcell(0,5,"Msg")
	matrix_ver_.NUMCOL_VISIBLE = 3
end  

local function set_cell(v,col)
	matrix_nums_ = 0
	for m,n in ipairs (v) do 
		if m > tonumber(matrix_ver_.numlin) then 
			matrix_ver_.numlin = m
		end 
		matrix_ver_:setcell(m,0,m)
		matrix_ver_:setcell(m,col,n)
		matrix_nums_ = matrix_nums_ + 1
	end 
end 

local function init_matrix()
	local matri_show_data = {}
	for k,v in ipairs (db_) do 
		for m,n in pairs (v) do 
			if not matri_show_data[m] then
				matri_show_data[m] = {}
			end 
			table.insert(matri_show_data[m],n)
		end 
	end 
	for k,v in pairs(matri_show_data) do 
		if k == "user" then 
			
			set_cell(v,1)
		end 
		if k == "time" then
			set_cell(v,2)
		end 
		if k == "name" then 
			set_cell(v,3)
		end
		if k == "hid" then 
			set_cell(v,4)
		end 

		if k == "msg" then 
			set_cell(v,5)
		end		
	end 
	 matrix_select(1, col,1)
	matrix_ver_.redraw  = "ALL"
end 

local function init_data()
	sel_ver_ = nil
	matrix_nums_ = 0
	init_matirx_control()
	init_matrix()
	if cur_path_ then 
		txt_work_path_.value = cur_path_
		cur_path_ = nil
	end 
end 

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:popup()
end

local function show()
	init_data()
	dlg_:popup()
end



function pop()
	if dlg_ then show() else init() end 
end 

function set_data(t,path)
	db_ = t
	cur_path_ = path
end 

function get_data()
	return sel_ver_,cur_path_
end 