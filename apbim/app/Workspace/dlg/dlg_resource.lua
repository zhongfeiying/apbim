
_ENV = module(...,ap.adv)
--module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
require "lfs"
local add_view_ = require "app.workspace.ctr_require".add_view()
local file_op_ = require "app.workspace.ctr_require".file_op()

local matrix_nums_ = 0;
local dlg_ = nil;
local matrix_db_list_ = {}
local assign_datas_ = nil

local function init_buttons()
	local btn_size = "100x"
	local small_btn_size_ = "50x"
	btn_cancel_ = iup.button{title= "Close",rastersize = btn_size}
	btn_add_resource_ = iup.button{title= "Assigning",rastersize = btn_size}
	btn_add_ = iup.button{title = "Add",rastersize = small_btn_size_}
	btn_edit_ = iup.button{title = "Edit",rastersize = small_btn_size_}
	btn_del_ = iup.button{title = "Del",rastersize = small_btn_size_}
	btn_preview_ = iup.button{title = "Pre",rastersize = small_btn_size_}
end 

local function init_controls()
	matrix_resource_ = iup.matrix{
		numcol = 1;
		RESIZEMATRIX= "YES";
		NUMCOL_VISIBLE = 1;
		RASTERWIDTH0 = "30";
		RASTERWIDTH1 = "200";
		NUMLIN = 20;
		scrollbar ="Yes";
		HEIGHTDEF = "10";
		MARKMODE = "LIN";
		readonly = "YES";
		ALIGNMENT = "ALEFT";
		HIDDENTEXTMARKS = "YES";
		rastersize = "250";
		MARKMULTIPLE = "NO";
	}
	frame_matrix_ = iup.frame{
		matrix_resource_;
		rastersize = "x400";
		bgcolor = "255 255 255";
	}
	item_add_view_ = iup.item{title = "Add"}
	item_edit_view_ = iup.item{title = "Edit",}
	item_del_view_ = iup.item{title = "Del",}
	item_pre_view_ = iup.item{title = "Pre",}
	menu_right_key_ = iup.menu{
		item_add_view_,
		item_edit_view_,
		item_del_view_,
		item_pre_view_,
	}
	frame_op_ = iup.frame{
		iup.hbox{
			frame_matrix_,
			iup.vbox{
				iup.fill{};
				btn_add_;
				iup.fill{};
				btn_edit_;
				iup.fill{};
				btn_del_;
				iup.fill{};
				btn_preview_;
				iup.fill{};
			};
		};
		margin = "5x0";
		title = "Operation";
	}
	zbox_ = iup.zbox{
		btn_add_resource_;
		btn_create_;
		value = btn_add_resource_;
	};
end

-----------------------------------------------------------------------

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame_op_},
			iup.hbox{iup.fill{},btn_add_resource_,iup.fill{},btn_cancel_,iup.fill{}},
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Resource Data Base";
		expand = "YES";
		RESIZE = "NO";		
	};
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	
end 


local function add_matrix_data(t)
	matrix_nums_ = matrix_nums_ + 1
	matrix_resource_.numlin = matrix_nums_
	matrix_resource_:setcell(matrix_nums_,0,matrix_nums_)
	matrix_resource_:setcell(matrix_nums_,1,t.name)
	matrix_resource_.redraw = "ALL"
end

local function init_matrix_head()
	matrix_resource_:setcell(0,0,"ID")
	matrix_resource_:setcell(0,1,"Title");
	matrix_nums_ = 0;
	matrix_resource_.numlin = 0
end

local function init_matrix_data()
	matrix_nums_ = 0;
	matrix_resource_.numlin = 0
	local fileallpath = "data\\BCA.Res\\Resource.lua"
	local data  = file_op_.get_file_data(fileallpath)
	if not data then return end
	matrix_db_list_ = data	
	for i=1,#data do 
		add_matrix_data(data[i])
	end
end

local function init_data()
	matrix_db_list_ = {}
	assign_datas_ = nil
	init_matrix_head()
	init_matrix_data()
end


local function init_select_states(lin,type)
	local str1 = "mark" .. lin .. ":0";
	local str2 = "mark" .. lin .. ":1";
	matrix_resource_[str1] = type;
	matrix_resource_[str2] = type;
end



local function msg_add_reourece()
	add_view_.set_data()
	add_view_.pop()
	local data = add_view_.get_data()
	if not data then return end 
	matrix_db_list_[#matrix_db_list_+1] = data
	add_matrix_data(data)
end

local function change_matrix_data(data,lin)
	matrix_resource_:setcell(lin,1,data.name)
	matrix_resource_.redraw = "ALL"
	local fileallpath =  "data\\BCA.Res\\Resource.lua" 
	matrix_db_list_[lin] = data
	file_op_.save_table_to_file(fileallpath,matrix_db_list_)
end

local function msg_edit_view(lin)
	local curt = matrix_db_list_[lin]
	local newt = {}
	for k,v in pairs (curt) do 
		if type(v) ~= "table" then 
			newt[k] = v
		else
			newt[k] = {}
			for m,n in ipairs (v) do 
				newt[k][m] = n
			end 
		end
	end 
	add_view_.set_data(newt)
	add_view_.pop()
	local data = add_view_.get_data()
	if not data then return end
	change_matrix_data(data,lin)
end

local function msg_del_view(lin)
	table.remove(matrix_db_list_,lin)
	local fileallpath =  "data\\BCA.Res\\Resource.lua" 
	file_op_.save_table_to_file(fileallpath,matrix_db_list_)
	matrix_resource_.DELLIN = "1-" .. matrix_nums_
	matrix_resource_.redraw = "ALL"
	matrix_nums_ = 0;
	matrix_resource_.numlin = 0
	for i=1,#matrix_db_list_ do 
		add_matrix_data(matrix_db_list_[i])
	end
end

local function msg_preview_view(lin)
	local tab = matrix_db_list_[lin]
	if tab.res then 
		for k,v in ipairs (tab.res) do 
			os.execute("start  \"\" " .. "\"" .. lfs.currentdir() .. "\\" .. string.gsub(v.ifo,"/","\\") .. "\"");
		end 
	end 
end

local function deal_right_key()
	local save_item_ = nil;
	local save_txt_ = nil;
	local save_matrix_lin = nil;
	local save_matrix_str = nil;
	function btn_cancel_:action()
		dlg_:hide();
	end

	function matrix_resource_:click_cb(lin,col,str)
		if string.find(str,"2")  or tonumber(lin) ==0  then return end
		if save_matrix_lin then
			init_select_states(save_matrix_lin,0)
		end 
		init_select_states(lin,1)
		save_matrix_lin = tonumber(lin)
		if string.find(str,"3") and not string.find(str,"D") then 
			menu_right_key_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
		end 
		if string.find(str,"1") and string.find(str,"D") then
			assign_datas_ = matrix_db_list_[save_matrix_lin]
			dlg_:hide()
		end
	end

	function item_add_view_:action()
		msg_add_reourece()	
	end
	
	function item_edit_view_:action()
		if not save_matrix_lin then return end 
		msg_edit_view(save_matrix_lin)
	end
	
	function item_del_view_:action()
		if not save_matrix_lin then return end 
		msg_del_view(save_matrix_lin)
	end
	
	function btn_add_resource_:action()
		if not save_matrix_lin then return end 
		--assign_datas_ = {}
		assign_datas_ = matrix_db_list_[save_matrix_lin]
		dlg_:hide();
	end
	
	function item_pre_view_:action()
		if not save_matrix_lin then return end 
		msg_preview_view(save_matrix_lin)
	end

	function btn_add_:action()
		msg_add_reourece()
	end

	function btn_edit_:action()
		if not save_matrix_lin then return end 
		msg_edit_view(save_matrix_lin)
	end

	function btn_del_:action()
		if not save_matrix_lin then return end 
		msg_del_view(save_matrix_lin)
	end

	function btn_preview_:action()
		if not save_matrix_lin then return end 
		msg_preview_view(save_matrix_lin)
	end


	
	function dlg_:close_cb()
	end
end

local function msg()
	deal_right_key()

end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_data()
	msg();
	dlg_:popup();
end

local function show()
	init_data()
	dlg_:popup();
end 



function pop()
	if dlg_ then show() else init() end 
end
function get_data()
	return assign_datas_
end
