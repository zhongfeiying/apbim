
local require  =  require 
local print = print
local string = string
local tonumber = tonumber

local M = {}
local name = ...
_G[name] = M
package.loaded[name] = M
_ENV = M
 -- _ENV = module_seeall(...,package.seeall)

local path_ =  "app\\Revit\\textures\\"
local lfs = require 'lfs'

local db_={};


--[[
db = {
	['102'] = path_ .. name
	['103'] = path_ .. name
	...
}
--]]

local function turn_string(file)
	local newstr;
	local nums= 0
	for dir in string.gmatch(file,"[^/]+") do 
		if nums == 0 then 
			newstr = dir
		else 
			newstr = newstr .. "/" .. "\"" .. dir .. "\""
			-- newstr = newstr .. dir
		end 
		nums = nums + 1
	end
	if not newstr then newstr = "\"" .. file .. "\"" end 
	return newstr
end 

function add(name,filename)
	filename = string.gsub(filename,'\\','/')
	filename = turn_string(filename)
	name = string.sub(name,1,-5)
	db_[name] =filename
end
 

function get(name)
	return db_[name]
	-- local file = db_[name]
	-- if not file then return end 
	-- print(name,file)
	-- os.execute('cp ' .. db_[name] .. ' \"' .. name .. '.bmp\"')
	-- return  name .. '.bmp'
end

local function init_db()
	for name in lfs.dir(path_) do 
		local filename = path_ .. name
		local attr =  lfs.attributes(filename)
		if attr and attr.mode == 'file' then 
			add(name,filename)
			
		end
	end
end



function create(files_path)
	path_ = files_path or path_
	db_= {}
	init_db()
end


