local type = type
local error = error
local getmetatable = getmetatable
local setmetatable = setmetatable
local pairs = pairs
local string = string
local table = table
local io = io
local ipairs = ipairs
local require = require 
local os = os



-- _ENV = module(...)
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local lfs = require 'lfs'

local type_={};
local level_=nil
local result_=nil;
local endl_ = "\n";
----
local function str_scale(str,scale)
	local result=" ";
	for i=1,scale do
		result=result..str;
	end
	return result;
end

local function get_tip(tip)
	local str = str_scale(" \t",level_);
	if type(tip)=="string" then tip = "[\""..tip.."\"]" end;
	if type(tip)=="number" then tip = "["..tip.."]" end;
	str = str..(tip and tip..' = ' or '');
	return str;
end

local function tostrt_(tip,src)
	if not type_[type(src)] then error(tip.."' is a "..type_[type(src)].."."..endl_) end;
	type_[type(src)](tip,src);
	return result_;
end

local function tostrt_without_somekey(k,v)
	if k=="__index" then return end;
	tostrt_(k,v);
end

local function with_met(src)
	local met = getmetatable(src);
	if met then
		with_met(met);
	end
	for k,v in pairs(src) do
		tostrt_without_somekey(k,v);
	end
end
----
type_.string = function(tip,src)
	local str = get_tip(tip);
	local str = str..string.format("%q",src)..';'..endl_;
	table.insert(result_,str);
end
type_.number = function(tip,src)
	local str = get_tip(tip);
	local str = str..tostring(src)..';'..endl_;
	table.insert(result_,str);
end
type_.boolean = type_.number;
type_['nil'] = type_.number;
type_.table = function(tip,src)
	local str = get_tip(tip);
	local str = str..'{'..endl_;
	level_=level_+1;
	table.insert(result_,str);
	with_met(src);
	level_=level_-1;
	table.insert(result_,str_scale(" \t",level_)..'};'..endl_);
end
type_["function"] = function(tip,src)
end
type_.userdata = function(tip,src)
	error(tip.." is a userdata."..endl_);
end
----

local function tostrt(src)
	level_ = 0;
	result_={};
	return tostrt_(nil,src);
end

-------------------------------

function tostr(src)
	return table.concat(tostrt(src));
end

-- arg={file=,tip=,src=}
function tofile(arg)
	local strt = tostrt(arg.src);
	local f = io.open(arg.file,arg.mode or "w");
	if not f then return end
	local tip = arg.key or arg.tip;
	f:write(tip and tip.." = " or "return ");
	for k,v in ipairs(strt) do
		f:write(v);
	end
	f:close();
end

function deepcopy(src)
    local lookup_table = {}
    local function _copy(src)
        if type(src) ~= "table" then
            return src
        elseif lookup_table[src] then
            return lookup_table[src]
        end
        local new_table = {}
        lookup_table[src] = new_table
        for index, value in pairs(src) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(src))
    end
    return _copy(src)
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
	tofile{file = FileAllPath, src = tab}
end 


