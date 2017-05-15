local require  = require 
local tonumber = tonumber
local string = string
local type =type



local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
-- _ENV = module_seeall(...,package.seeall)
local iup = require 'iuplua'
require 'iupluacontrols'

local lab_src_ = iup.label{title = 'Src : ',rastersize = '70x'}
local lab_dst_ = iup.label{title = 'Dst : ',rastersize = '70x'}

local txt_src_ = iup.text{expand = 'HORIZONTAL',readonly = 'yes'}
local txt_dst_ = iup.text{expand = 'HORIZONTAL',readonly = 'yes'}

local btn_src_ =  iup.button{title = ' ... '}
local btn_dst_ =  iup.button{title = ' ... '}
local lab_sep_ = iup.label{SEPARATOR  = 'HORIZONTAL'}

local btn_close_ = iup.button{title = 'Close',rastersize = '100x'}
local btn_start_ = iup.button{title = 'Start',rastersize = '100x'}

local lab_progress_ =  iup.label{title = 'Progress : ',rastersize = '70x'}
local gauge_ = iup.gauge{rastersize = '600x',FLAT = 'YES',FLATCOLOR = '255 0 0'}

local dirdlg_ = iup.filedlg{title = 'Dir',DIALOGTYPE = 'DIR',}

local dlg_;

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{lab_src_,txt_src_,btn_src_};
			iup.hbox{lab_dst_,txt_dst_,btn_dst_};
			iup.hbox{lab_progress_,gauge_};
			iup.hbox{btn_start_,btn_close_};
			alignment = 'ARIGHT';
			margin = '10x10';
		};
		
		title = 'Convert Data';
	}
end 



local function src_callback(arg,dir)
	local src_file_num_ =0 
	local function init_gauge_control()
		src_file_num_ = src_file_num_ + 1
		gauge_.text =0 .. ' / ' .. src_file_num_
	end 
	dlg_.active = 'no'
	gauge_.text =0 .. ' / ' .. src_file_num_
	arg.on_src(init_gauge_control,dir)
	gauge_.max =  src_file_num_ 
	dlg_.active = 'yes'
end 

local function init_ifo()
	gauge_.MAX = 0
	gauge_.MIN  = 0
	gauge_.TEXT = '0 / 0' 
	gauge_.VALUE = 0
end

local function init_callback(arg)
	

	function btn_close_:action()
		dlg_:hide()
	end
	
	function btn_start_:action()
		--dlg_:hide()
		if self.title ~= 'Start' then return end 
		self.title = 'Running'
		
		if type(arg.on_ok) == 'function' then
			dlg_.active = 'no'
			local function f()
				gauge_.value = tonumber(gauge_.value ) +1
				gauge_.text = tonumber(gauge_.value) .. ' / ' ..  tonumber(gauge_.max)
				dlg_:show()
			end
			if arg.on_ok(f) then 
				self.title = 'Start'
				dlg_.active = 'yes'
			end
		end 
	end
	
	function btn_src_:action()
		dirdlg_.DIRECTORY = txt_src_.value
		dirdlg_:popup()
		local val = dirdlg_.value
		if val then 	
			val = string.gsub(val,'\\','/')
			if string.sub(val,-1,-1) ~= '/' then 
				val = val .. '/'
			end 
			txt_src_.value =  val
			init_ifo()
			src_callback(arg,val)
		end
	end
	
	function btn_dst_:action()
		dirdlg_.DIRECTORY = txt_dst_.value
		dirdlg_:popup()
		local val = dirdlg_.value
		if val then 
			
			val = string.gsub(val,'\\','/')
			if string.sub(val,-1,-1) ~= '/' then 
				val = val .. '/'
			end 
			txt_dst_.value =  val
			if type(arg.on_dst) == 'function' then 
				arg.on_dst(val)
			end
			
		end
	end
end 

local function init_data(arg)
	
	init_ifo()
	if type(arg.init_txt) == 'function' then 
		txt_src_.value,txt_dst_.value = arg.init_txt()
	end 
	if type(arg.on_src) == 'function' and txt_src_.value ~= '' then 
		src_callback(arg)
	end
end

function pop(arg)
	arg = arg or {}
	local function init()
		init_dlg()
	end
	
	local function show()
		init_callback(arg)
		dlg_:showxy(iup.RIGHT,iup.RIGHT)
		init_data(arg)
		iup.MainLoop()
	end

	if not dlg_ then init() end 
	show() 
end
