local require  = require 
local string = string
local io = io
local print = print
local type =type
local loaded = package.loaded
local pairs = pairs

local M = {}
local modname = ...
_G[modname] = M
loaded[modname] = M
_ENV = M

local str = 'sys.Controls.'
local dat_ = require 'sys.toolbar.dat'
local file_op_ = require (str .. 'file_op')
local lfs_ = require 'lfs'
local toolbar_ = require 'sys.toolbar'

local styles_path_ = 'cfg\\ToolbarStyles\\'
local toolbar_style_file_ = 'cfg.toolbar'

lfs_.mkdir(styles_path_)


local function file_is_exist(file)
	local file = string.gsub(file,'%.','/') .. '.lua'
	local file = io.open(file,'r')
	if file then file:close() return true end
end

local require_ = function (file) 
	if  not file_is_exist(file) then 
		print(file .. ' file is not exist!')
		return 
	end
	loaded[file]=nil;
	return  require(file)  
end
--------------------------------------------------------


local function dir_content(path,rule)
	local dir =  lfs_.dir
	for line in dir(path) do
		if line ~= "." and  line ~= ".." then 
			if type(rule) == 'function' then rule(line)  end
		end
	end
end 


function get_style_files()
	local t = {}
	local function rule(str)
		local name =  string.sub(str,1,-5)
		local file = string.gsub(styles_path_,'\\','.') .. name
		t[name] = {name =name,file = file}
	end 
	dir_content(styles_path_,rule)
	return t;
end

function get_menu_data()
	local t = file_op_.deepcopy(dat_.get_all())
	for k,v in pairs(t) do
		if v.fixed then 
			t[k] = nil
		end
	end
	return t
	
end

function get_menu_style()
	
	return require_ (toolbar_style_file_)
end

----------------------------------------------------------
function on_save(arg)
	local filename = arg.name .. '.lua'
	local file = styles_path_ .. filename
	file_op_.save_data(file,arg.data)
	return string.gsub(styles_path_,'\\','.') .. arg.name
end

function on_ok(arg)
	local file = string.gsub(toolbar_style_file_,'%.','\\') .. '.lua'
	file_op_.save_data(file,arg.data)
	toolbar_.update()
end 

function on_dbclick_list(arg)
	local file = arg  and arg.file;
	return  require_ (file)
end




