
_ENV = module(...,ap.adv)
local lfs_ = require "lfs"
local dlg_ = nil
local data_ = nil
local list_datas_ = {}

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_delete_ = iup.button{title = "Delete",rastersize = wid}
	btn_import_files_ = iup.button{title = "Add",rastersize = wid}
	btn_import_dir_ = iup.button{title = "Import Folder",rastersize = wid}
end

local function init_controls()
	list_files_ = iup.list{}
	list_files_.rastersize = "400x400"
	list_files_.DROPFILESTARGET = "YES"
	list_files_.MULTILINE="YES"
	list_files_.expand = "YES"
	file_dlg_ = iup.filedlg{}
	file_dlg_.rastersize = "800x800"
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{list_files_};
			iup.hbox{btn_import_files_,btn_delete_,btn_ok_,btn_cancel_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Select files";
	}
	iup.SetAttribute(dlg_,"NATIVEPARENT",frm_hwnd)
end

local function table_is_empty(t)
	return _G.next(t) == nil
end

local function deal_ok_action()
	data_ = list_datas_
end

local function init_callback()
	function list_files_:dropfiles_cb(filename,num,x,y)
		local attr = lfs_.attributes(filename)
		if attr and attr.mode == "file" then 
			local name = string.match(filename,".+\\(.+)")
			table.insert(list_datas_,{AllPath = filename,FileName = name})
			list_files_.APPENDITEM = name 
		end 
	end

	function btn_import_files_:action()
		file_dlg_.DIALOGTYPE = 	"OPEN"
		file_dlg_.MULTIPLEFILES = "YES"
		file_dlg_:popup()
		local val = file_dlg_.value
		if not val then return end 
		local path = string.match(val,"(.+)\\.+") .. "\\"
		local filenames = string.match(val,".+\\(.+)")
		if string.find(filenames,"|") then 
			local nums = 0
			for str in string.gmatch(filenames,"[^|]+") do 
				nums = nums+ 1
				if nums == 1 then 
					path = path .. str .. "\\"
				else
					table.insert(list_datas_,{AllPath = path .. str,FileName = str})
					list_files_.APPENDITEM = str
				end 
			end
		else 
			table.insert(list_datas_,{AllPath = val,FileName = filenames})
			list_files_.APPENDITEM = filenames
		end
	end

	function btn_import_dir_:action()
		file_dlg_.DIALOGTYPE = 	"DIR"
		file_dlg_.MULTIPLEFILES = "no"
		file_dlg_:popup()
		local val = file_dlg_.value
		if not val then return end 
		
	end

	function btn_ok_:action()
		deal_ok_action()
		dlg_:hide()
	end

	function btn_cancel_:action()
		dlg_:hide()
	end
	
	local save_sel_item = nil
	function list_files_:action(text, item, state)
		if state  == 1 then 
			save_sel_item = tonumber(item)
		end
	end

	function btn_delete_:action()
		if not save_sel_item  then return end 
		list_files_.REMOVEITEM = save_sel_item
		table.remove(list_datas_,save_sel_item)
	end

end

local function init_data()
	list_files_[1] = nil
	list_datas_ = {}
	if data_ then 
		for k,v in ipairs(data_) do
			table.insert(list_datas_,{AllPath = v.AllPath,FileName = v.FileName})
			list_files_.APPENDITEM = v.FileName
		end
	end
	data_ = nil
end


local function init()
	
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()

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

function set_data(data)
	data_ = data
end

function get_data()
	return data_
end

