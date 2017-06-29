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


local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local zip_ = require 'luazip'
local sys_zip_ = require 'sys.zip'

--arg = {zip=,file=,key=}
function read(arg)
	return sys_zip_.read(arg)
end

-- function add_file(ar,src,dst)
	-- ar:add(dst, "file", src)
-- end

-- function add_str_to_file(ar,str,dst)
	-- ar:add(dst, "string", str)
-- end

-- function add_zip_file(ar,file,mode,src)
	-- local fdx = get_fdx(ar,file);
	-- if fdx then ar:replace(fdx,mode,src) return end
	-- ar:add(file,mode,src);
-- end

function open(zipfile)
	local ar = zip_.open(zipfile,zip_.CREATE)
	local f =function() ar:close() end 
	return ar,f
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