

 _ENV = module(...,ap.adv)
require "iuplua"
require "iupluacontrols"


local dlg_ = nil
local data_ = nil

local cur_select_=nil;

local function init_buttons()
	local wid = "100x"
	btn_open_ = iup.button{title = "Show",rastersize = wid}
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end

local function init_controls()
	matrix_ = iup.matrix{}
	frame_matrix_ = iup.frame{
		matrix_;
		bgcolor = "255 255 255";
	}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_matrix_};
			iup.hbox{
				iup.fill{};
				btn_open_,
				iup.fill{};
				btn_close_;
				iup.fill{};
			};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Tekla Import";
		resize = "NO";
	}
end

local function init_select(lin)
	matrix_["MARK" .. lin .. ":1"] = 1
	matrix_["MARK" .. lin .. ":2"] = 1
	matrix_["MARK" .. lin .. ":3"] = 1
end

local function init_msg()
	function btn_open_:action()
		if(cur_select_ == nil)then
			iup.Message("Warning","Please select the item!");
			return;		
		end	
		
		local cur_data = matrix_:getcell(cur_select_,1);	
		
		
		require "app.ApSteel.model_op".show_by_data(cur_data);	
	
	end
	function btn_close_:action()
		dlg_:hide()
	end
	function matrix_:click_cb(lin, col, str)
		if tonumber(lin) == 0 then return end 
		init_select(lin)
		cur_select_ = lin;
		
	end
end


local function init_matrix_head_ifo()
	matrix_.rastersize = "400x400"
	matrix_.readonly = "yes"
	matrix_.numcol = 2
	matrix_.numlin = 20
	matrix_.READONLY = "YES"
	matrix_.RASTERWIDTH0 = "50x"
	matrix_.RASTERWIDTH1 = "150x"
	matrix_.RASTERWIDTH2 = "150x"
	matrix_.MARKMODE = "LIN"
	matrix_:setcell(0,0,"ID")
	matrix_:setcell(0,1,"Date")
	matrix_:setcell(0,2,"Count")
	matrix_.NUMCOL_VISIBLE = 2
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
	matrix_:setcell(matrix_nums_,0,matrix_nums_)
	matrix_:setcell(matrix_nums_,1,data.data)
	matrix_:setcell(matrix_nums_,2,data.count)
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

	local import_mgr = require "app.ApSteel.model_op".get_class("app/Tekla/import_mgr");
	local tabs = {};
	if(import_mgr ~= nil)then
		for i=1,#import_mgr.historys_ do
			local item = {name="1",count = "",gid = "2",data=import_mgr.historys_[i]};
			table.insert(tabs,item);
		end
	end	

	set_data(tabs)

	init_matrix_data()
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	set_data(tab)
	
	dlg_:popup()
end


local function show()
	init_data()
	dlg_:popup()
end


function set_data(tab)
	data_ = tab
end

function pop()
	if dlg_ then show() else init() end
end

--   测试 shuju 
local tab = {
	{name = "C-1",count = 10,gid = "11213",date = "2016年1月19日13:13:57"},
	{name = "C-2",count = 12,gid = "11213",date = "2016年1月19日13:13:57"},
	{name = "C-3",count = 13,gid = "11213",date = "2016年1月19日13:13:57"},
	{name = "C-4",count = 14,gid = "11213",date = "2016年1月19日13:13:57"},

	{name = "C-1",count = 10,gid = "11213"},

	
}
--set_data(tab)
