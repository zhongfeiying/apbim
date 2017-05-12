_ENV = module(...,ap.adv)

local matrix_msg_;
local btn_close_;
local exist_dlg_;

--arg = {Datas = ,}
function pop(arg)
	if exist_dlg_ then 
		exist_dlg_:hide()
		exist_dlg_ = nil
	end
	local dlg_;
	local wid100 = '100x'
	
	local function init_buttons()
		btn_close_ = iup.button{title = 'Close',rastersize = wid100}
	end
	
	local function init_controls()
		matrix_msg_ = iup.matrix{}
		matrix_msg_.numlin = 20;
		matrix_msg_.numcol = 2;
		matrix_msg_.NUMLIN_VISIBLE = 10;
		matrix_msg_.NUMCOL_VISIBLE = 2;
		matrix_msg_.readonly = 'YES';
		matrix_msg_.expand = 'YES';
		matrix_msg_.MARKMODE = 'LIN';
		matrix_msg_.RASTERWIDTH1 = '200x'
		matrix_msg_.RASTERWIDTH2 = '200x'
		expand = 'YES';
	end
	
	local function init_dlg()
		dlg_ = iup.dialog{
			iup.vbox{
				iup.hbox{matrix_msg_};
				iup.hbox{btn_close_};
				alignment = 'ARIGHT';
				margin = '5x5';
			};
			title = 'Joint Attributes';
			resize = 'NO';
			
			rastersize = 'x400'
			
		}
		iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
	end 
	
	local function init_select(lin,val)
		matrix_msg_['MARK' .. lin .. ":1"] = val
		matrix_msg_['MARK' .. lin .. ":2"] = val
	end
	
	local function init_callback()
		function btn_close_:action()
			dlg_:hide()
			exist_dlg_ = nil
		end
		
		function dlg_:close_cb()
			exist_dlg_ = nil
		end
		
		function matrix_msg_:click_cb(lin, col,str)
			if string.find(str,'1') then 
				init_select(lin,1)
			end
		end
	end 
	
	local function init_matrix_head()
		matrix_msg_:setcell(0,1,'Attribute')
		matrix_msg_:setcell(0,2,'Value')
		matrix_msg_.redraw = 'all'
	end
	
	local function init_matrix_data()
		if not arg.Datas then return end 
		local num = 1
		for k,v in pairs (arg.Datas) do 
			if num > tonumber(matrix_msg_.numlin) then matrix_msg_.numlin = num end
			if type(v) == 'string' or type(v) == 'number' then 
			matrix_msg_:setcell(num,1,k)
			matrix_msg_:setcell(num,2,v)
			num = num + 1
			end 
		end 
		matrix_msg_.redraw = 'ALL'
	end
	
	local function init_data()
		init_matrix_head()
		init_matrix_data()
	end

	local function init()
		init_buttons()
		init_controls()
		init_dlg()
		init_callback()
		dlg_:map()
		init_data()
		
		exist_dlg_ = dlg_
	end
	
	init()
	dlg_:show()
end