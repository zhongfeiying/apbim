_ENV = module(...,ap.adv)
local workspace_ = require "app.workspace.ctr_require".Workspace()
local zip_op_ = require "app.workspace.ctr_require".zip_op()
local rmenu_op_ = require "app.workspace.ctr_require".rmenu_op()
require "iuplua"
require "iupluacontrols"
local dlg_ = nil
local matrix_nums_ = 0;

local function init_buttons()
	local wid = "80x"
	local small_wid = "30x100"
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_open_ = iup.button{title = "Open",rastersize = wid}
	btn_check_ = iup.button{title = "Check",rastersize = wid}
end

local function init_controls()
	matrix_ifo_ = iup.matrix{
		numlin = 20;
		numcol = 2;
		RASTERWIDTH1 = 200;
		RASTERWIDTH2 = 400;
		markmode = "CELL";
		rastersize = "635x270";
		readonly = "YES";
		MARKMULTIPLE = "NO";
		alignment = "ALEFT";
	}

	frame_matrix_ = iup.frame{
		iup.hbox{
			matrix_ifo_;
			margin = "0x0";
		}
	}
	filedlg_ = iup.filedlg{
		rastersize = "800x800";
		SHOWPREVIEW = "YES";
		NOCHANGEDIR = "YES";
	}
	
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			frame_matrix_;
			iup.hbox{btn_check_,btn_open_,btn_cancel_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "App Solution";
		resize = "NO";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)

end

local function init_matrix_head()
	matrix_ifo_:setcell(0,1,"File Name")
	matrix_ifo_:setcell(0,2,"Link Path")
	if matrix_nums_ ~= 0 then 
		matrix_ifo_.DELLIN = "1-" .. matrix_nums_
	end
	matrix_nums_ = 0 
	matrix_ifo_.numlin = 20;
end


local function init_matrix_data(FileName,LinkPath)
	matrix_nums_ = matrix_nums_ + 1;
	if matrix_nums_ > tonumber(matrix_ifo_.numlin) then 
		matrix_ifo_.numlin = matrix_nums_
	end
	matrix_ifo_:setcell(matrix_nums_,1,FileName)
	matrix_ifo_:setcell(matrix_nums_,2,LinkPath)
	matrix_ifo_.redraw = "ALL"
end

local function init_data()
	init_matrix_head()
	if datas_  then 
		for k,v in ipairs (datas_) do
			init_matrix_data(v.name,string.gsub(v.ifo,"/","\\"))
		end
	end
end


local function init_select_matrix(lin,type)
	matrix_ifo_["mark" .. lin .. ":1"] = type
	matrix_ifo_["mark" .. lin .. ":2"] = type
	matrix_ifo_.redraw = "ALL"
end

local function open_msg(lin)
	if not datas_ then return end
	local data = datas_[lin]
	local filepath = string.gsub(data.ifo,"/","\\")
	local file = io.open(filepath)
	if file then 
		file:close()
		os.execute("start \"\" " .. "\"" .. filepath .. "\"")
	else 
		iup.Message("Notice","The disk file is not exist , Please check it to the disk from Project !")
	end
end

local function msg()
	local save_sel_lin = nil;
	function matrix_ifo_:click_cb(lin, col,str)
		if lin == 0 or string.find(str,"2") or string.find(str,"3")  then return end 
		if save_sel_lin then
			init_select_matrix(save_sel_lin,0)
		end
		save_sel_lin = tonumber(lin);
		init_select_matrix(lin,1)
		if tonumber(lin) >  matrix_nums_ then 
			save_sel_lin = nil;
		else 
			if string.find(str,"D") then 
				open_msg(save_sel_lin)
			end
		end
		
	end
	

	function btn_open_:action()
		if not save_sel_lin then return end 	
		open_msg(save_sel_lin)
	end
	
	function btn_cancel_:action()
		dlg_:hide();
	end
	
	function btn_check_:action()
		if not save_sel_lin then return end 
		filedlg_.DIALOGTYPE = "DIR"
		filedlg_:popup()
		local val = filedlg_.value
		if not val then return end 
		--local file = workspace_.get_proname()
		-- local file = require "sys.mgr.model".get_zipfile() 
		-- if not file then return end 
		local file = workspace_.get_cur_zip_file()
		if not file then return end 
		local ar = zip_op_.zip_create(file)
		if not ar then return end 
		if datas_ and datas_[save_sel_lin] and datas_[save_sel_lin].hid then 
			local data = datas_[save_sel_lin] 
			rmenu_op_.zip_to_local(ar,"projects\\res\\" .. data.hid,val .. "\\" .. data.name)
			data.ifo = string.gsub(val,"\\","/") .. "/" .. data.name
			matrix_ifo_:setcell(save_sel_lin,2, string.gsub(data.ifo,"/","\\"))
			matrix_ifo_.redraw = "ALL"
		end
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

function pop()
	if dlg_ then show() else init() end 
end

function set_datas(data)
	datas_ = data
end
