local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local ipairs = ipairs
local pairs = pairs
local type = type
local table = table
local string = string
local print = print
local load = load


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local zip_ = require 'luazip'
local sys_zip_ = require 'sys.zip'


function open(zipfile)
	local ar = zip_.open(zipfile,zip_.CREATE)
	local f =function() ar:close() end 
	return ar,f
end

local function get_size(ar,file)
	-- local expect = {
		-- name = "test/text.txt",
		-- index = 2,
		-- crc = 635884982,
		-- size = 14,
		-- mtime = 1296450278,
		-- comp_size = 14,
		-- comp_method = 0,
		-- encryption_method = 0,
	-- }
	local s = ar:stat(file)
	return s and s.size;
end

local function read_zipfile(t)
	if type(t) ~= 'table' or not t.zip or not t.file then return  end
	local ar,close = open(t.zip)
	if not ar then return end
	local file_idx = ar:name_locate(t.file)
	if not file_idx then return end
	local file = ar:open(file_idx);
	local str;
	if file then 
		str = file:read(get_size(ar,t.file));
		file:close()
	end
	close()
	if str then 
		local env = {};
		local f = load(str,'read_zip','bt',env);
		if type(f)~='function' then return nil end
		local result = f();
		if t.key then return env[t.key] else return result end
	end
end

--arg = {zip=,file=,key=}
function read(arg)
	return read_zipfile(arg) 
end


function add(ar,file,mode,src)
	sys_zip_.add(ar,file,mode,src)
end

function create(zipfile,str)
	zipfile = string.gsub(zipfile,'/','\\')
	local ar,close = open(zipfile)
	add(ar,'Files/__index.lua','string',str)
	close();
end