
local require  = require 
local string= string
local error = error
local type = type
local tostring = tostring

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
local lfs = require 'lfs'

local function lfs_attributes(str,mode)
	local mod = lfs.attributes(str,mode)
	return mod
end

--[[
函数名：is_there(str)
功能： 判断文件或者文件夹是否存在
参数：
	str ： 要判断的文件或者文件夹，以结尾是否有"/"或者"\\"来判断是文件还是文件夹。
返回值：	
	如果存在返回true，不存在返回nil
--]]
function is_there(str)
	if not str then return error("You need to pass a string value ！") end 
	local strState = 'file'
	str = string.gsub(str,'\\','/')
	if string.sub(str,-1,-1) == '/' then 
		strState = 'dir'
		str = string.sub(str,1,-2)
	end
	local mod = lfs_attributes(str,'mode')
	if mod then 
		if strState == 'dir' and mod=='directory' then 
			return true 
		elseif strState == 'file' and mod=='file' then 
			return true 
		elseif  (strState == 'dir' and mod=='file') or (strState == 'file' and mod=='directory') then 
			return false
		end 
	end 
end
--[[
函数名：create(str)
功能： 创建文件或者文件夹。
参数：
	str ： 待创建的文件或者文件夹的全路径或者相对路径
	switchoff : 关闭创建。（如果路径中的文件夹不存在，则不创建）。 
返回值：	
	如果目标已经存在或者创建成功则返回true
注意：
	例如：如果创建的是文件但是同名的文件夹已经存在则会创建失败返回 false
	如果创建的文件或者文件夹所在的文件夹不存在则默认递归创建所需要的文件夹。
--]]
function create(str)
	if not str then return end
	local state =  is_there(str)
	if  type(state) == 'boolean' and state == true then 
		return true 
	elseif type(state) == 'boolean' and state == false then 
		return 
	end 
	local str,num = string.gsub(str,'\\','/')
	local dir;
	if string.sub(str,-1,-1) == '/' then 
		str = string.sub(str,1,-2)
		dir = true
	end 
	local pathstr = string.match(str,'(.+)/')
	if pathstr then
		local path = '';
		for name in string.gmatch(pathstr,'[^/]+') do 
			if string.sub(name,-1,-1) == ':' then 
				path = path .. name .. '/'
			else 
				path = path .. name 
				lfs.mkdir(path)
				path = path .. '/'
			end
		end 
	end 
	if dir then 
		lfs.mkdir(str)
	else 
		local file = io.open(str,'w+')
		if not file then return false end
		file:close()
	end 
	return true 
end

local function list_filename(path,recursion,fileList,relativePath) --循环路径，是否递归，存储列表，保存的相对路径
	local fileList = fileList or {}
	local relativePath = relativePath or ''
	for name in lfs.dir(path) do 
		if name ~= '.' and  name ~= '..' then 
			local mod = lfs.attributes(path .. '/' .. name,'mode')
			if mod == 'directory' then 
				fileList[relativePath .. name] = 0
				if recursion then 
					list_filename(path .. '/' .. name,recursion,fileList,relativePath .. name .. '/') 
				end 
			else 
				local filetype = string.match(name,'.+%.([^%.]+)')
				filetype = filetype or ''
				fileList[relativePath .. name] =  filetype 
			end 
		end
	end 
	return fileList
end 
--[[
函数名：get_name_list(path,recursion)
功能： 获取文件夹内（递归包含子文件夹）的文件或者文件夹列表。
参数：
	path ： 目标文件夹 ，'a/b/c/' 或者 'a\\b\\c\\'
	recursion ： 是否递归，（只要有值存在(非nil或者false)就认为需要递归）
返回值：	
	示例：
		{
			['filename1.lua'] = '.lua'; --文件名对应的值是 该文件的类型。
			['dirname1'] = 0; -- 值是0 代表此 key 为文件夹
			--如果递归 ['dirname1/filename2.lua'] = 'lua'; --递归时key值包含相对路径，并用斜杠分离。
			。。。
		}；
注意：
	如果参数不正确或者本地磁盘文件夹不存在则返回nil值。
--]]
function get_name_list(path,recursion)
	if type(path) ~= 'string' or path  == ''  then return end 
	path = string.gsub(path,'\\','/') 
	if string.sub(path,-1,-1) == '/' then 
		path = string.sub(path,1,-2)
	end
	if string.sub(path,-1,-1) == ':' then 
		path = path .. '/'
	end 
	local attr = lfs_attributes(path,'mode')
	if not attr then return  end
	return list_filename(path,recursion)
end

