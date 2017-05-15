
local require  = require 
local table = table
local type = type


local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV =M
-- _ENV = module_seeall(...,package.seeall)
local lfs = require 'lfs'
local pipe = require 'luaext.pipe'
 
local path_ = 'app.RevitConvert.savefile'
local filename = "app\\RevitConvert\\savefile.lua"
local sys_io_ =require 'sys.io'
local dir_src_;
local dir_dst_;
local db_;

function init()
	local t = sys_io_.read_file{file = filename} or {}
	db_= {}
	dir_dst_ = t.dst
	dir_src_ = t.src
end

function init_txt()
	return dir_src_,dir_dst_
end

function init_src_files(f)
	local dir = dir_src_
	if not dir then return  end 
	db_ = {}
	for name in lfs.dir(dir) do 
		local filename = dir .. name
		local attr =  lfs.attributes(filename)
		if attr and attr.mode == 'file' then 
			if not db_[filename] then 
				db_[filename] = true
				table.insert(db_,{name = name,path = dir})
				f()
			end 
		end
	end 
end

function on_src(f,dir)
	dir_src_ = dir or dir_src_
	
	return init_src_files(f)
end

function on_dst(dir)
	dir_dst_ = dir or dir_dst_
end

local function save_file()
	local t = {}
	t.dst = dir_dst_
	t.src = dir_src_
	require 'sys.table'.tofile{src = t,file = filename,}
end 

local function turn_string(file)
	file = string.gsub(file,'\\+','/')
	local newstr;
	local nums= 0
	for dir in string.gmatch(file,"[^/]+") do 
		if nums == 0 then 
			newstr = dir
		else 
			newstr = newstr .. "/" .. '"' .. dir .. '"'
		end 
		nums = nums + 1
	end
	if not newstr then newstr = file end 
	return newstr
end 

function shell_exec(cmd)
	local p_dir = pipe.new(cmd)
	if not p_dir then return  end  
	local line = p_dir:getline()
	if line then 
		p_dir:closeout()
		p_dir:closein()
		return line
	end
	
end

function on_ok(f)
	if not dir_dst_ then return end 
	if not dir_src_ then return end 
	save_file()
	for k,v in ipairs (db_) do 
		local name = v.name
		local path = v.path
		local src_file = v.path .. v.name
		local tempname = string.sub(v.name,1,-5)
		local dst_file = dir_dst_ .. tempname .. '.bmp'
		src_file = turn_string(src_file)
		dst_file = turn_string(dst_file)
		local str = 'convert -identify ' ..  src_file .. ' ' .. src_file
		local line = shell_exec(str)
		if line then 
				local w,h = string.match(line,'%s+(%d+)x(%d+)%s+') 
				--print(line,w,h)
				local size;
				if w and h then 
					size =tonumber( w ) > tonumber( h ) and (h .. 'x' .. h .. '!') or  (w .. 'x' .. w .. '!')
				else
					size = '512x512!'
				end
				str = 'convert -resize  ' .. size  .. '  ' ..  src_file .. ' ' .. dst_file
				shell_exec(str)
		else 
			print(src_file)
		end
		f()
	end 
	return true
end

