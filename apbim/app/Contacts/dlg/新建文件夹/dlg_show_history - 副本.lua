
_ENV = module(...,ap.adv)
--package.cpath = "?.dll;?53.dll;" .. package.cpath
require "iuplua"
require "iupluacontrols"
local dlg_ = nil
local matrix_nums_ = 0
local data_ = nil
local function init_buttons()
	local wid = "100x"
	btn_close_ = iup.button{title = "Close",rastersize = wid}
	btn_exe_ = iup.button{title = "Execute",rastersize = wid}
	btn_detail_ = iup.button{title = "Detail",rastersize =wid}
end


local function init_controls()
	local wid = "120x"
	matrix_ifo_ =iup.matrix{}
	matrix_ifo_.numcol = 6
	matrix_ifo_.NUMCOL_VISIBLE = 7
	matrix_ifo_.numlin = 20
	matrix_ifo_.rasterwidth0 = 20
	matrix_ifo_.rasterwidth1 = wid
	matrix_ifo_.rasterwidth2 = wid
	matrix_ifo_.rasterwidth3 = wid
	matrix_ifo_.rasterwidth4 = 20
	matrix_ifo_.rasterwidth5 = 20
	matrix_ifo_.rasterwidth6 = 20
	matrix_ifo_.rastersize = "510x300"
	matrix_ifo_.MARKMODE = "CELL"
	matrix_ifo_.readonly = "YES"
	matrix_ifo_.MARKMULTIPLE = "NO";
	matrix_ifo_.SCROLLBAR = "YES"
	txt_msg_ = iup.text{rastersize = "200x"}
	txt_msg_.MULTILINE = "YES"
	txt_msg_.WORDWRAP = "YES"
	txt_msg_.expand = "YES"
	txt_msg_.readonly = "YES"
	txt_msg_.active = "NO"
	txt_msg_.bgcolor = ""
	frame_msg_ = iup.frame{
		iup.hbox{
			matrix_ifo_,
			iup.frame{
				iup.vbox{
					iup.hbox{iup.label{title = "Text : ",fontsize = 12}};
					txt_msg_;
					margin = "0x2";
				};
			};
		};
		margin = "0x0";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_msg_};
			iup.hbox{btn_detail_,btn_exe_,btn_close_};
			margin = "10x10";
			alignment = "ARIGHT";

		};
		title="Messages List";
		resize = "NO";
	}
end

local function init_matrix_head()
	if matrix_nums_ ~= 0 then 
		matrix_ifo_.dellin = "0-" .. matrix_nums_
	end
	matrix_nums_ = 0
	matrix_ifo_.numlin = 0
	matrix_ifo_:setcell(0,0,"No.")
	matrix_ifo_:setcell(0,1,"Title")
	matrix_ifo_:setcell(0,2,"From")
	matrix_ifo_:setcell(0,3,"Type")
	matrix_ifo_:setcell(0,4,"A")
	matrix_ifo_:setcell(0,5,"R")
	matrix_ifo_:setcell(0,6,"C")
	matrix_ifo_.redraw = "ALL"
end

local function insert_data_to_matrix(data)
	matrix_nums_ = matrix_nums_ + 1
	if tonumber(matrix_ifo_.numlin) < matrix_nums_ then 
		matrix_ifo_.numlin = matrix_nums_
	end
	matrix_ifo_:setcell(matrix_nums_,0,matrix_nums_)
	matrix_ifo_:setcell(matrix_nums_,1,data.Name)
	
	matrix_ifo_:setcell(matrix_nums_,2,data.From)
	matrix_ifo_:setcell(matrix_nums_,3,data.Channel and "Channel" or "Message")
	if data.Arrived then 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 4] = "ON"
	else 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 4] = "OFF"
	end
	
	if data.Read then 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 5] = "ON"
	else 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 5] = "OFF"
	end
	
	if data.Confirm then 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 6] = "ON"
	else 
		matrix_ifo_["TOGGLEVALUE" .. matrix_nums_ .. ":" .. 6] = "OFF"
	end
	matrix_ifo_.redraw = "ALL"
end

local function init_matrix_data()
	if  type(data_) ~= "table" then return end
	for k,v in ipairs (data_) do 
		insert_data_to_matrix(v)
	end
end

local function init_matrix()
	init_matrix_head()
	init_matrix_data()
end

local function init_sel_matrix(lin,type)
	matrix_ifo_["MARK" .. lin .. ":1"] = type
	matrix_ifo_["MARK" .. lin .. ":2"] = type
	matrix_ifo_["MARK" .. lin .. ":3"] = type
	matrix_ifo_["MARK" .. lin .. ":4"] = type
	matrix_ifo_["MARK" .. lin .. ":5"] = type
	matrix_ifo_["MARK" .. lin .. ":6"] = type
	matrix_ifo_.redraw = "ALL"
end

local function init_txt_show(lin)
	if not data_ then return end 
	txt_msg_.value = data_[lin].Text
end

local function deal_exe(lin)
	local gid = data_[lin].Gid
	local msgs = require "sys.net.msg".get_all()
	if type(msgs[gid].exe_cbf) == "function" then 
		msgs[gid].exe_cbf() 
	end
end

local function deal_tog_ifo(lin,col)
	if tonumber(col) == 7 then 
	elseif tonumber(col) == 9 then 
	end
end

local function init_callback()
	local save_sel_lin = nil
	function btn_close_:action()
		dlg_:hide()
	end
	function btn_exe_:action()
		if not save_sel_lin then return end 
		deal_exe(save_sel_lin)
	end
	function matrix_ifo_:click_cb(lin, col,  str)
		if tonumber(lin) == 0 or string.find(str,"2")   or string.find(str,"3")  then return end 
		if save_sel_lin then 
		init_sel_matrix(save_sel_lin,0)
		end 
		init_sel_matrix(lin,1)
		save_sel_lin = nil
		txt_msg_.value = ""
		if tonumber(lin) > matrix_nums_  or tonumber(lin) == 0 then return end 
		save_sel_lin = tonumber(lin)
		init_txt_show(tonumber(lin))
	end
	
	function matrix_ifo_:dropcheck_cb(lin,col)
		if tonumber(col) == 4 or tonumber(col) == 5 or tonumber(col) == 6  then 
			return iup.CONTINUE
		end
		return iup.IGNORE
	end
end
local function init_data()
	init_matrix()
	txt_msg_.value = ""
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	init_data()
	dlg_:popup()
end

local function show()
	init_data()
	dlg_:popup()
end

function pop(data)
	data_ = data
	if dlg_ then show() else init() end
end

--pop()
