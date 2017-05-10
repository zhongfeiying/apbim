
-- require 'iup_dev'
---------------------------------------------------------------------
local require  = require 
local tonumber = tonumber
local type = type
local print = print
local io = io
local table = table
local pairs = pairs
local string = string
local frm_hwnd_ = frm_hwnd

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local iup = require "iuplua"
require "iupluacontrols"
local image_pos_ = 'sys.controls.app.'
---------------------------------------------------------------------
--define controls 
local btn_wid_ = "80x"
local small_wid = "30x100"
--local image_pos_ = 'sys.load.'

local btn_del_ = iup.button{title = "Delete",rastersize = btn_wid_}
local btn_ok_ = iup.button{title = "Ok",rastersize = btn_wid_}
local btn_cancel_ = iup.button{title = "Cancel",rastersize = btn_wid_}
local btn_up_ =  iup.button{rastersize = small_wid,image = string.gsub(image_pos_,"%.","\\") .. "up.bmp"}

local btn_down_ =  iup.button{rastersize = small_wid,IMAGE = string.gsub(image_pos_,"%.","\\") .. "down.bmp"}
-- str = string.gsub(dlg_pos_,"%.","\\") .. "down.bmp"
-- iup.SetAttribute(btn_down_, "IMAGE", str);
local btn_save_ = iup.button{title = "Save",rastersize = btn_wid_}
local btn_select_all_ = iup.button{title = "Select ALL",rastersize = btn_wid_}
local btn_select_none_ = iup.button{title = "Select None",rastersize = btn_wid_}


local matrix_app_ = iup.matrix{
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
	HIDDENTEXTMARKS = 'YES';
	RESIZEMATRIX = 'YES';
}



local txt_readme_ = iup.text{
	rastersize = "x100";
	WORDWRAP  = "YES";
	MULTILINE="YES";
	expand = "HORIZONTAL";
	bgcolor = "240 240 240";
	readonly = "YES";
	CANFOCUS = "NO";
};

local txt_solution_ = iup.text{expand = "HORIZONTAL";}

local matrix_solution_ = iup.matrix{
	numlin = 10;
	NUMLIN_VISIBLE = 5;
	numcol = 1;
	RASTERWIDTH0 = 20;
	RASTERWIDTH1 = 465;
	markmode = "CELL";
	rastersize = "490x150";
	readonly = "YES";
	HIDDENTEXTMARKS = 'YES';
	RESIZEMATRIX = 'YES';
}



local tem_select_all_ = iup.item{title = "Select All"}
local item_select_none_ = iup.item{title = "Select None"}
local menu_ = iup.menu{
	item_select_all_;
	item_select_none_;
}

--------------------------------------------------------------------------

local dlg_;
local frame_cfg_;
local frame_file_;
local app_nums_ = 0;
local solution_nums_ = 0;


local function init()
	local function  init_frame()
		frame_cfg_ = iup.frame{
			iup.hbox{
				matrix_app_;
				iup.vbox{iup.fill{},btn_up_,iup.fill{},btn_down_,iup.fill{}};
				margin = "0x0";
			}
		}
		frame_file_ = iup.frame{
			matrix_solution_;
		}
	end

	local function init_dlg ()
		dlg_ = iup.dialog{
			iup.vbox{
				frame_cfg_;
				txt_readme_;
				iup.hbox{
					txt_solution_;
					btn_del_;
					btn_save_;
					btn_ok_;
					btn_cancel_;
				};
				frame_file_;
				margin = "10x10";
				alignment = "ARIGHT";
			};
			title = "App Solution";
			resize = "NO";
		}
		dlg_.NATIVEPARENT = frm_hwnd_
	end

	init_frame()
	init_dlg()
end
--------------------------------------------------------


local init_app;
local init_solution;

local init_matrix_color;
local add_app_line;
local add_solution_line;
local init_app_line;

local save_app_select_;
local save_solution_select_;
local init_select_app;


local function  init_matrix()

	local function init_app_head()
		matrix_app_:setcell(0,0,"ID")
		matrix_app_:setcell(0,1,"Sel")
		matrix_app_:setcell(0,2,"App")
		matrix_app_:setcell(0,3,"Status")
	end
	local function init_solution_head()
		matrix_solution_:setcell(0,0,"ID")
		matrix_solution_:setcell(0,1,"Solution")
	end

	init_app = function ()
		if app_nums_ ~= 0 then 
			matrix_app_.DELLIN = "1-" .. app_nums_
		end
		app_nums_ = 0 
		matrix_app_.numlin = 10;
	end
	init_solution =  function ()
		if solution_nums_ ~= 0 then 
			matrix_solution_.DELLIN = "1-" .. solution_nums_
			matrix_solution_.redraw = "ALL"
		end
		solution_nums_ = 0 
		matrix_solution_.numlin = 10;
	end

	init_app_head()
	init_solution_head()
	init_app()
	init_solution()
end


local function init_matrix_data(arg)
	
	local function set_matrix_color(lin,color)
		matrix_app_["FGCOLOR" .. lin .. ":2"] = color
		matrix_app_["FGCOLOR" .. lin .. ":3"] = color
	end

	init_matrix_color =  function (data)
		local color;
		if data.exist and data.exist == "Warning:App is non-existent!"  then 
			color = "255 0 0"
			set_matrix_color(data.curLine,color)
		else 
			if data.loadstates == "ON" then 
				color = "0 0 255"
				set_matrix_color(data.curLine,color)
				matrix_app_:setcell(data.curLine,3,"OK")
			else 
				color = "0 0 0"
				set_matrix_color(data.curLine,color)
				matrix_app_:setcell(data.curLine,3,"Cancel")
			end
		end
	end

	init_app_line = function  (lin,data)
		matrix_app_:setcell(lin,0,lin)
		matrix_app_["TOGGLEVALUE" .. lin .. ":1"] = data.loadstates
		matrix_app_:setcell(lin,2,data.app)
		matrix_app_:setcell(lin,3,data.exist)
		init_matrix_color{curLine = lin,loadstates = data.loadstates,exist = data.exist}
		matrix_app_.redraw = "L" .. lin
	end

	add_app_line = function  (data)
		app_nums_ = app_nums_ + 1
		if app_nums_ > tonumber(matrix_app_.numlin) then 
			matrix_app_.numlin = app_nums_
		end
		init_app_line(app_nums_,data)
	end

	add_solution_line = function  ( data )
		-- body
		solution_nums_ = solution_nums_ + 1
		if solution_nums_ > tonumber(matrix_solution_.numlin) then 
			matrix_solution_.numlin = solution_nums_
		end
		matrix_solution_:setcell(solution_nums_,0,solution_nums_)
		matrix_solution_:setcell(solution_nums_,1,data.filename)
		matrix_solution_.redraw = 'L' .. solution_nums_
	end
	if type(arg.init_app_data) == 'function' then 
		 arg.init_app_data(add_app_line,arg.appDatas)
	end

	if type(arg.init_solution_data) == 'function' then 
		 arg.init_solution_data(add_solution_line,arg.solutionDatas)
	end
end
--------------------------------------------------------

local function load_app_datas( ... )
	local t = {}
	for i = 1,app_nums_ do 
		if matrix_app_["TOGGLEVALUE" .. i .. ":1"] == "ON" then
			table.insert(t,"app." .. matrix_app_:getcell(i,2) .. ".main")
		end
	end
	return t
end

local function  action_button( arg )
	function btn_up_:action()
		if not save_app_select_  then iup.Message("Warning","Please select in the app matrix firstly !") return end 
		if save_app_select_ > app_nums_ or save_app_select_ <=1 then return end 
		local save_name = matrix_app_:getcell(save_app_select_,2)
		init_app_line(save_app_select_,arg.appDatas[matrix_app_:getcell(save_app_select_-1,2)])
		init_select_app(save_app_select_,0)
		save_app_select_ = save_app_select_ - 1
		init_app_line(save_app_select_,arg.appDatas[save_name])
		init_select_app(save_app_select_,1)
	end

	function btn_down_:action()
		if not save_app_select_  then iup.Message("Warning","Please select in the app matrix firstly !") return end 
		if  save_app_select_ >= app_nums_ or save_app_select_ < 1 then return end 
		local save_name = matrix_app_:getcell(save_app_select_,2)
		init_app_line(save_app_select_,arg.appDatas[matrix_app_:getcell(save_app_select_+1,2)])
		init_select_app(save_app_select_,0)
		save_app_select_ = save_app_select_ + 1
		init_app_line(save_app_select_,arg.appDatas[save_name])
		init_select_app(save_app_select_,1)
	end

	function btn_save_:action()
		if not string.find(txt_solution_.value,'%S+')  then return end 
		if type(arg.save_action) == 'function' then
			local name = txt_solution_.value
			if arg.solutionDatas[string.lower(name)] then 
				local alarm = iup.Alarm('Notice','The file already exists , Do you want to update it ? ','Yes' ,'No')
				if alarm ~= 1 then return end 
			else 
				table.insert(arg.solutionDatas,name)
				arg.solutionDatas[arg.solutionDatas] =  true
				add_solution_line{filename = name}
			end
			arg.save_action(load_app_datas,name)  
			txt_solution_.value = '';
			
			
			
		end
	end

	function btn_ok_:action()
		if type(arg.ok_action) == 'function' then
			 arg.ok_action(load_app_datas)
		end
		dlg_:hide();
	end

	function btn_cancel_:action()
		dlg_:hide();
	end

	local function delete_op( lin )
		matrix_solution_.DELLIN = lin
		solution_nums_ = solution_nums_  - 1
		init_select_app(save_solution_select_,1)
		for i = lin , solution_nums_ do 
			matrix_solution_:setcell(i,0,i)
		end
		matrix_solution_.redraw = 'C0'
	end

	function btn_del_:action()
		if not save_solution_select_ then iup.Message("Warning","Please select in the solution matrix firstly !") return end 
		if save_solution_select_ > solution_nums_ or save_solution_select_ < 1 then return end 
		local alarm = iup.Alarm("Notice","Are you sure you want to delete it?","Yes","No")
		if alarm  ~= 1 then return end 
		if type(arg.delete_action) == 'function' then
			local name =  matrix_solution_:getcell(save_solution_select_,1)
			delete_op(save_solution_select_)
			txt_solution_.value = ''
			arg.delete_action(name,arg)
			table.remove(arg.solutionDatas,save_solution_select_)
			arg.solutionDatas[string.lower(name)] = nil
		end


	end
end

init_select_app = function (lin,num)
	matrix_app_["mark" .. lin .. ":1"] = num
	matrix_app_["mark" .. lin .. ":2"] = num
	matrix_app_["mark" .. lin .. ":3"] = num
	matrix_app_.redraw = "L" .. lin
end

local function init_select_solution(lin,num)
	matrix_solution_["mark" .. lin .. ":1"] = num
	matrix_solution_.redraw = "L" .. lin
end


local function deal_select_states( status )
	for i = 1, app_nums_ do 
		matrix_app_["TOGGLEVALUE" .. i .. ":1"] = status
		init_matrix_color{curLine = i,loadstates = status,exist = matrix_app_:getcell(i,3)}
	end
	matrix_app_.redraw = "ALL"
end

local function  show_readme( lin )
	txt_readme_.value = "";
	local str = "app/" .. matrix_app_:getcell(lin,2) .. "/readme.txt"
	local file = io.open(str,"r")
	if not file then 
		return 
	else 
		txt_readme_.value = file:read("*all")
		file:close();
	end
end

local function  change_solution(arg,data)
	if not data then error('Data error !(change_solution)') return end 
	init_app()
	if type(arg.init_app_data) == 'function' then 
		arg.init_app_data(add_app_line,data)
	end

	
end

local function  action_matrix(arg)

	function matrix_app_:dropcheck_cb(lin,col)
		if tonumber(col) == 1 then 
			return iup.CONTINUE
		end
		return iup.IGNORE
	end

	
	function matrix_app_:click_cb(lin, col,str)
		
		local function init_check()
			if tonumber(col) ~= 1 then return end
			if self["TOGGLEVALUE" .. lin .. ":" .. col] ~= "ON" then
				self["TOGGLEVALUE" .. lin .. ":" .. col] = "ON"
			else
				self["TOGGLEVALUE" .. lin .. ":" .. col] = "OFF"
			end
			local loadstates = self["TOGGLEVALUE" .. lin .. ":" .. col]
			init_matrix_color{curLine = lin,loadstates = loadstates,exist = matrix_app_:getcell(lin,3)}
			arg.appDatas[matrix_app_:getcell(lin,2)].loadstates = loadstates
			self.REDRAW = "L" .. lin
		end

		local function  lclick()
			init_select_app(save_app_select_ or lin,0)
			init_select_app(lin,1)
			if tonumber(lin) >  app_nums_ then return end 
			init_check()
			show_readme(lin)
		end

		local function rclick()
			init_select_app(save_app_select_ or lin,0)
			init_select_app(lin,1)
			if tonumber(lin) >  app_nums_ then return end 
			show_readme(lin)
		end
		
		if type (arg.matrix_click_callback) == 'function' then
			local cbf,click_states;
			if string.find(str,'1')  then 
				lclick()
				click_states = 'L'
			elseif string.find(str,'3') then 
				rclick()
				click_states = 'R'
				cbf = deal_select_states;
			end
			arg.matrix_click_callback{
				matrix = 'app',
				click_states = click_states,
				cbf = cbf,
			}
			save_app_select_ = tonumber(lin)
		end
	end

	function matrix_solution_:click_cb(lin, col,str)
		local function  lclick()
			init_select_solution(lin,1)
			if tonumber(lin) >  solution_nums_ then return end 
			txt_solution_.value= self:getcell(lin,1) 
		end

		local function  dlclick(data)
			if tonumber(lin) >  solution_nums_ then return end 
			arg.appDatas = data
			change_solution(arg,data)
		end
		
		if type (arg.matrix_click_callback) == 'function' then
			local data,click_states,cbf;
			if string.find(str,'1')  then 
				click_states = 'L'
				lclick()
				if string.find(str,'D') then 
					click_states = 'DL'
					cbf = dlclick
					data = self:getcell(lin,1) 
				end 
			end
			arg.matrix_click_callback{matrix = 'solution',click_states = click_states,cbf = cbf,data = data}
			save_solution_select_ = tonumber(lin)
		end
	end
end

function pop(arg)
	local arg = arg or {}

	local function init_data(arg)
		txt_readme_.value = ""
		txt_solution_.value = ""
		init_matrix()
		init_matrix_data(arg)

	end
	
	local function init_callback(arg)
		action_button(arg)
		action_matrix(arg)
	end
	
	local function show()
		init_callback(arg)
		dlg_:map()
		init_data(arg)
		dlg_:show()
	end

	if not dlg_ then  init() end
	show()
end