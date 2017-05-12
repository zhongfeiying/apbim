--[[
	File description:
		Interface : save 
		parameter : 
			The parameter type is 'table';
		for example :
			require 'table_save'.save{file = 'test.lua',  data= {},key = 'db';returnKey = true}
--]]

-- _ENV = module_seeall(...,package.seeall) 
local io = io
local tostring = tostring
local type = type
local string = string
local pairs = pairs
local error = error

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

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

local function lua_save(name,value,saved)
	if not name then return end
	io.write(name,' = ')
	if type(value) == "number" or type(value) == "string" or type(value) =="boolean" then
		io.write(basicSerialize(value),"\n")	
	elseif type(value) == "table" then
		saved = saved or {}
		if saved[value] then
			io.write(saved[value],"\n")
		else
			saved[value] = name
			io.write("{}\n")
			for k,v in pairs(value) do
				k = basicSerialize(k,saved)
				if k then 
					local fname =  string.format("%s[%s]",name,k)
					lua_save(fname,v,saved)
				end
			end
		end
	-- else
		-- error("cannot save a "..type(value))
	end
end

local function save_table(file,content,key,returnKey)
	local temp = io.output()
	io.output(file)
	local t = {}
	local key = key or 'db'
	if type(content) == 'table' then 
		lua_save( key,{},t)
		for k,v in pairs(content) do
			if type(k) == "number" then 
				lua_save(key .. "[" .. k .. "]",v,t)
			else
				lua_save(key .. "[\"" .. k .. "\"]",v,t)
			end
		end
		if returnKey  then 
			io.write('return ',key)
		end 
	else 
		if type(content) == "number" or type(content) == "string" or type(content) =="boolean" then
			io.write(basicSerialize(content),"\n")	
		end
	end
	io.flush()
	io.output():close()
	io.output(temp)
end

--arg = {key,file,data,returnKey}
function save(arg)
	arg = arg or {}
	if not arg.file or not arg.data then return end 
	save_table(arg.file,arg.data,arg.key,arg.returnKey)
end
