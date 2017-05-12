

 _ENV = module(...,ap.adv)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil
local data_ = nil
local matrix_nums_ = 0

local function init_buttons()
	local wid = "100x"
	btn_open_model_ = iup.button{title = "Open Model",rastersize = wid}
	btn_create_draw_ = iup.button{title = "Create Draw",rastersize = wid}
	btn_open_draw_ = iup.button{title = "Open Draw",rastersize = wid}
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end

local function init_controls()
	matrix_ = iup.matrix{}
	frame_matrix_ = iup.frame{
		matrix_;
		bgcolor = "255 255 255";
	}
	tog_draw_ = iup.toggle{title = "Have Draw",fontsize =12}
end


local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_matrix_};
			iup.hbox{tog_draw_,iup.fill{}};
			iup.hbox{
				iup.fill{},
				btn_open_model_,
				iup.fill{},
				btn_create_draw_,
				iup.fill{},
				btn_open_draw_,
				iup.fill{},
				btn_close_,
				iup.fill{},
			};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		resize = "NO";
		title = "Cut Plane";
	}
end

local function init_select(lin)
	matrix_["MARK" .. lin .. ":1"] = 1
	matrix_["MARK" .. lin .. ":2"] = 1
	matrix_["MARK" .. lin .. ":3"] = 1
end

local function change_color(lin)
	matrix_["BGCOLOR" .. lin .. ":*"] = "0 255 0"
end

local function init_msg()
	local select_lin_ = nil
	function btn_open_model_:action()
		
	end
	function btn_create_draw_:action()
		if not select_lin_ then return end 
		change_color(select_lin_)
		--创建图纸
		require "app.ApSteel.drawing".create_drawing("A-1");
	end
	function btn_open_draw_:action()
		
	end
	function btn_close_:action()
		dlg_:hide()
	end
	
	function matrix_:click_cb(lin, col, str)
		lin = tonumber(lin)
		if lin == 0 then return end 
		init_select(lin)
		select_lin_ = lin
	end
	
	function tog_draw_:valuechanged_cb()
		if tog_draw_.value == "ON" then 
			print("tog_draw_.value = " .. tog_draw_.value )
		else 
			print("tog_draw_.value = " .. tog_draw_.value )
		end
	end
end

local function init_matrix_head_ifo()
	matrix_.rastersize = "500x400"
	matrix_.readonly = "yes"
	matrix_.numcol = 3
	matrix_.numlin = 20
	matrix_.READONLY = "YES"
	matrix_.RASTERWIDTH1 = "150x"
	matrix_.RASTERWIDTH2 = "150x"
	matrix_.RASTERWIDTH3 = "150x"
	matrix_.MARKMODE = "LIN"
	matrix_:setcell(0,1,"Name")
	matrix_:setcell(0,2,"Count")
	matrix_:setcell(0,3,"ID")
	matrix_.NUMCOL_VISIBLE = 3
	matrix_.NUMLIN_VISIBLE = 20
end

local function clear_matrix_data()
	matrix_["DELLIN"] = "1-" .. matrix_.numlin
	matrix_.numlin = 20
end

local function add_data_in_matrix(data)
	if matrix_nums_ > tonumber(matrix_.numlin) then 
		matrix_.numlin = matrix_nums_  
	end 
	matrix_nums_ = matrix_nums_ + 1 --矩阵当前行数
	matrix_:setcell(matrix_nums_,1,data.name)
	matrix_:setcell(matrix_nums_,2,data.count)
	matrix_:setcell(matrix_nums_,3,data.gid)
	matrix_.redraw = "ALL"
end 

local function init_matrix_data()
	if not data_ then return end 
	clear_matrix_data()
	matrix_nums_ = 0
	for k,v in ipairs (data_) do 
		add_data_in_matrix(v)
	end
end

local function init_data()
	init_matrix_head_ifo()
	--[[
	local import_mgr = require "app.ApSteel.model_op".get_class("app/Tekla/import_mgr");
	local tabs = {};
	if(import_mgr ~= nil)then
		for(i=1,#import_mgr.historys_)do
			local item = {}
		end
	end	
	set_data(tabs)
	--]]
	init_matrix_data()
	
	
end
local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:popup()
end
--   测试 shuju 
local tab = {
	{name = "C-1",count = 10,gid = "11213"},
	{name = "C-2",count = 12,gid = "11213"},
	{name = "C-3",count = 13,gid = "11213"},
	
}

local function show()
	init_data()

	
	
	dlg_:popup()
end

function pop()
	if dlg_ then show() else init() end
end

function set_data(tab)
	data_ = tab
end

--set_data(tab)
--pop()