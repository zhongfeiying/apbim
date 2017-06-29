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


function hash_string(str)
	local dig = require"crypto".digest;
	if not dig then return nil end
	local d = dig.new("sha1");
	local s = d:final(str);
	d:reset();
	return s;
end

function hash_file(file)
	if type(file)~='string' then return end
	local f = io.open(file,"rb");
	if not f then return nil end
	local str = f:read("*all");
	f:close();
	return hash_string(str);
end

function gid_version_data(arg)
	return {
		time = os_time_;
		hid = arg.hid;
		msg = arg.msg;
	}
end

function gid_data(arg)
	return {gid = arg.gid,name = arg.name,attributes = arg.attributes,versions = arg.versions or {}}
end