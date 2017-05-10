

------------------------------------------------------------------------------------------------------
-- require "iup_dev"
-- local table_ = require 'app.MenuControl.tableAPI'
local str = 'sys.Controls.'
local table_ = require (str .. 'tableAPI')

local trace_out = trace_out
local require  = _G.require
--local write_file = write_file
local io = _G.io
local loadfile = _G.loadfile
local load = _G.load
local type = _G.type
local error = _G.error
local table = _G.table
local string = _G.string
local pairs = _G.pairs
local lfs = require "lfs"
local os = os
local tostring = tostring
local loadfile = loadfile
local _G = _G
-- _ENV = module(...)
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


--local create_file = _G.create_file
--local unlock_file = _G.unlock_file
--local close_file = _G.close_file



local function basicSerialize(o,saved)
if type(o) == "number" then
return tostring(o)
elseif type(o) == "table" then
return saved[o]
elseif type(o) == "boolean" then
return tostring(o)
else
return string.format("%q",o)
end
end

local function save(f,name,value,saved)

if not name then return end
saved = saved or {}
write_file(f,name .. " = ",-1,0)
if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then
	write_file(f,basicSerialize(value) .. "\n",-1,0)
elseif type(value) == "table" then
	if saved[value] then
		write_file(f,saved[value] .. "\n")
	else
		saved[value] = name
		write_file(f,"{}\n",-1,0)
		for k,v in pairs(value) do
			k = basicSerialize(k,saved)
			if k then 
				local fname =  string.format("%s[%s]",name,k)
				save(f,fname,v,saved)
			end
		end
	end
else
	error("cannot save a "..type(value))
end

end



function save_file(file,content,key)

local f = create_file(file,"w")
local t = {}
lock_file(f,1024,0,0)
if key then
  save(f,key,content,t)
else
	for k,v in pairs(content) do
		save(f,k,v,t)
	end
end
unlock_file(f,1024,0,0)
close_file(f)
end


local function lua_save(name,value,saved)
	if not name then return end
	saved = saved or {}
	io.write(name," = ")
	if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then

	io.write(basicSerialize(value),"\n")	
	elseif type(value) == "table" then
	if saved[value] then
	io.write(saved[value],"\n")

	else
	saved[value] = name
	--io.write("{}")
	--else 
	io.write("{}\n")
	--end 
	for k,v in pairs(value) do
	k = basicSerialize(k,saved)
	if k then 
	local fname =  string.format("%s[%s]",name,k)
	lua_save(fname,v,saved)
	end
	end
	end
	else
	error("cannot save a "..type(value))
	end
end

local function lua_save_pretreatment_tab(tab,name,value,saved)
	if not name then return end
	saved = saved or {}
	table.insert(tab,"")
	if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then
	elseif type(value) == "table" then
	if saved[value] then
	else
	saved[value] = name
	for k,v in pairs(value) do
	k = basicSerialize(k,saved)
	if k then 
	local fname =  string.format("%s[%s]",name,k)
	lua_save_pretreatment_tab(tab,fname,v,saved)
	end
	end
	end
	else
	error("cannot save a "..type(value))
	end
end 

local function pretreatment_tab(content)
	local tab = {}
	table.insert(tab,"")
	for k,v in pairs(content) do
		if type(k) == "number" then 
			lua_save_pretreatment_tab(tab,"db[" .. k .. "]",v,t)
		else
			lua_save_pretreatment_tab(tab,"db[\"" .. k .. "\"]",v,t)
		end
	end
	return #tab
end 

function save_file_l(file,content,key)
	if type(content) ~= "table" then print(file .. " is error !\n") return end 
	local temp = io.output()
	io.output(file)
	local t = {}
	if key then
	   lua_save(key,content,t)
	else
		lua_save("db",{},t)
		for k,v in pairs(content) do
			if type(k) == "number" then 
				lua_save("db[" .. k .. "]",v,t)
			else
				lua_save("db[\"" .. k .. "\"]",v,t)
			end
		end
	end
	io.flush()
	io.output():close()
	io.output(temp)
end


function append_contact(cur_path,value)
	if _G.db then _G.db = nil end
	local info = {}
	do
		local func = loadfile(cur_path,"bt",info)		
		if(func) then
			func()
		end
		func = load(value,"info.lua","bt",info)
		if(func) then
			func()
		end
	end
	return info.db
end


----------------------------------------------------------------------------------------------------------


function is_exist_local(AllPath)
	if not AllPath then error("Missing parameter!") return end 
	local t = lfs.attributes(AllPath,attr)
	if t then
		return true
	end 
	return false 
end

function del_file_read_attr(AllPath) 
	if type(AllPath) ~= "string" then trace_out("Function (del_file_read_attr) Lost parameter ! \n") return end 
	if is_exist_local(AllPath) then
		os.execute("ATTRIB -R \"" .. AllPath .. "\"")
		return true 
	end
end


function save_data(FileAllPath,tab)
	if type(FileAllPath) ~= "string" or type(tab)~= "table" then trace_out("Function (save_t) Lost parameter ! \n") return end 
	local status = del_file_read_attr(FileAllPath) 
	if not status then 
		local file = io.open(FileAllPath,"w+")
		file:close()
	end 
	-- save_file_l2(FileAllPath,tab)
	table_.tofile{file = FileAllPath, src = tab}
end 

function get_data(FileAllPath)
	local db_ = {}
	if is_exist_local(FileAllPath) then
		dofile(FileAllPath)
		db_ = db or {}
		_G.db = nil
	end
	return db_
end


