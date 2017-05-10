
local type = type
local ipairs = ipairs
local string = string
local io = io
local print = print
local error = error
local require = require
local table = table
local os = os
local loaded = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local str = 'sys.Controls.App.'
local file_op_ = require ('sys.Controls.file_op')
local menu_ = require (str .. 'menu')

local function file_is_exist(file)
	local file = string.gsub(file,'%.','/') .. '.lua'
	local file = io.open(file,'r')
	if file then file:close() return true end
end

local require_ = function (file,states) 
	if states and not file_is_exist(file) then 
		print(file .. ' file is not exist!')
		return 
	end
	return  require(file)  
end

local cfg_file_;-- = "cfg.app"
local solution_path_; -- = "cfg.solutions."

local function set_cfg_file(file)
	cfg_file_ = file
end

local function  set_solution_path(path)
	solution_path_ = path
end

function  init( file , solution )
	set_cfg_file(file)
	set_solution_path(solution)
end


function requier_data( filename  )
	-- body
	loaded[filename] = nil
	return require_ (filename,'exist') or {}
end
--[[
get_app_datas:
	return {
		{exist = 'OK',app = 'Edit',loadstates = 'ON'};
		{exist = "Warning:App is non-existent!";,app = 'View',loadstates = 'OFF'};
		...

	}
--]]
function get_app_datas(file)

	local function get_data(file,states)
		local t = {}
		t.exist = 'OK'
		t.app = file
		if not file_is_exist("app." .. file .. ".main") then
			t.exist = "Warning:App is non-existent!";
		end
		t.loadstates = states or 'ON'
		return t
	end
	file = file or cfg_file_
	local data = requier_data( file  ) 

	local t = {}
	
	for k,v in ipairs(data) do

		local name =  string.sub (v,5,-6)
		t[name] = get_data(name,'ON')
		
		table.insert (t,name)
	end
	
	for line in io.popen ("dir /ad /b /on " .. "app"):lines() do 
		if not t[line] then
			t[line] = get_data(line,'OFF')
			table.insert (t,line)
		end
	end
	return t
end

--[[
get_solution_datas:
	return {
		'Bim'; --cfg/solutions/Bim.lua
		'Apcad'; --cfg/solutions/Apcad.lua
		...

	}
--]]
function get_solution_datas( )
	if not solution_path_ then error('Please set solutin path !') return {} end 
	local tab = {};
	for line in io.popen ("dir /a-d /b /on " .. "\"" .. string.gsub(solution_path_,'%.','/') .. "\""):lines() do 
		local name = string.sub(line,1,-5)
		table.insert (tab,name)
		tab[string.lower(name)] = true
	end
	return tab
end

function init_app_data(init_line,data)
	if type (init_line) ~= 'function' then return end 
	for k,v in ipairs(data) do 
		v = data[v]
		init_line{loadstates = v.loadstates,app = v.app,exist= v.exist}
	end
	
end

function init_solution_data(init_line,data)
	if type (init_line) ~= 'function' then return end 
	for k,v in ipairs(data) do 
		init_line{filename = v}
	end
end 

local function pop_menu( arg )
	menu_.pop(arg)
end

local function solution_dl( arg ) --双击solution矩阵操作
	local file = solution_path_ .. arg.data 
	return get_app_datas(file)
end

local function init_callback(  )
	local callback_ = {}
	callback_.app = {}
	callback_.app.R = pop_menu
	callback_.solution = {}
	callback_.solution.DL = solution_dl
	
	return callback_
end

function matrix_click_callback(arg)
	arg = arg or {}
	if not arg.matrix then error('Please check the key !') return end 
	local callback_ = init_callback()
	local cur = callback_[arg.matrix]
	local data;
	if cur and arg.click_states and  type(cur[arg.click_states]) == 'function' then 
		data = cur[arg.click_states](arg)
	end
	if type(arg.cbf) == 'function' then 
		arg.cbf(data)
	end 
end

local function save_data( file,data )
	file = string.gsub(file,'%.','/') .. '.lua'
	file_op_.save_data(file,data)
end

function ok_action( get_data )
	if type(get_data) ~= 'function' then return end 
	local data = get_data()
	save_data(cfg_file_,data)
	require 'sys.app'.load()
end

function save_action( get_data,filename )
	if type(get_data) ~= 'function' then return end 
	local data = get_data()
	save_data(solution_path_ .. filename,data)
end

function delete_action( filename )
	local file = string.gsub(solution_path_ .. filename , '%.' , '/') .. '.lua'
	os.remove (file)
	-- body
end

