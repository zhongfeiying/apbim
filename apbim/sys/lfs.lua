local require =require
local package_loaded_ = package.loaded
local table = table
local string = string
local error =error


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M


local lfs = require 'lfs'


function attributes(file,mod)
	return lfs.attributes(file,mod)
end

--return file¡¢directory¡¢
function get_mode(file)
	return attributes(file,'mode')
end

function get_time(file)
	local attr = attributes(file)
	if not attr then return end 
	return {modify = attr.modification,status = attr.change,access = attr.access} 
end

function get_size(file)
	return attributes(file,'size')
end

local function dir_list(path,recursive)
	local tempt,pos= {},1
	for line in lfs.dir(path) do 
		if line ~= '.' and line ~= '..' then 
			local file = path .. '/' .. line
			local t = {name = line,data = {path = path .. '/',name = line,attr = attributes(file)}}
			if get_mode(file) == 'directory'  then
				table.insert(tempt,pos,t)
				pos = pos + 1
				if recursive then 
					t[1] = dir_list(file,recursive)
				end
			else
				tempt[#tempt+1] = t
			end
		end
	end
	return tempt
end

function get_folder_content(path,recursive,cur)
	if not path or path == '' then return end 
	path = string.gsub(path,'\\','/')
	if string.sub(path,-1,-1) == '/' and string.sub(path,-1,-2) ~= ':/' then
		path = string.sub(path,1,-2)
	end
	if get_mode(path) ~= 'directory' then error('check dir is exist or not dir') return end 
	local data = dir_list(path,recursive)
	if cur then 
		local t = {}
		local cur_path,name = string.match(path,'(.+/)[^/]+'),string.match(path,'.+/([^/]+)')
		t[1] = {name = name,data = {path = cur_path,name = name,attr = attributes(path)}}
		t[1][1] = data
		return t
	else 
		return data
	end
end


