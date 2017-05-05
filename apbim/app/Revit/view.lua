
local ipairs = ipairs
local pairs = pairs
local string = string
local require = require
local type = type
local table = table
local tonumber = tonumber
local print = print
local add_texture = add_texture
local frm = frm
local os_execute_ = os.execute



local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
 -- _ENV = module_seeall(...,package.seeall)

local textures_db_ = require 'app.Revit.textures_db'
local Polymesh_ = require "app.Revit.objects.Polymesh"



function gmatch_str(str,doit,mode)
	local cur_str;
	repeat
		if type(str) ~= 'string' then 
			cur_str = str()
			if cur_str then 
				doit(cur_str)
			end 
		else 
			cur_str = true;
			str = str:gmatch(mode)
		end
	until not cur_str
end

local function string_to_table(str,kind)
	if string.find(str,'%(') then 
		local t = {}
		local function get(str)
			local tempt = {}
			local function get(str)
				str = tonumber(str)
				if kind == 'Facets' then 
					str = str +1
				end
				table.insert(tempt,str)
			end
			gmatch_str(str,get,'[^,^%(^%)]+') 
			table.insert(t,tempt)
		end
		gmatch_str(str,get,'%b()')
		return t
	else 
		return str
	end 
end

local function turn_data(data)
	local turnData = {}
	for k,v in pairs(data) do 
		turnData[k] = string_to_table(v,k)
	end 
	return turnData
end 

--arg = {data = v,color = cr,bitmapIndex = index}
local function deal_polymesh(arg)
	local polymesh = Polymesh_.Class:new{Type="RevitElementInstance"}
	local data = turn_data(arg.data)
	polymesh:set_data(data)
	polymesh:set_color(arg.color)
	polymesh:set_BitmapIndex(arg.bitmapIndex)
	polymesh:set_mode_rendering();
	require 'sys.mgr'.add(polymesh)
	require"sys.mgr".draw(polymesh,sc);
end

-- local function deal_element_instance(data)
	-- local cr;
	-- for k,v in ipairs(data) do 
		-- if v.kind == "Material" then 
			-- cr = {v.Red,v.Green,v.Blue}
		-- elseif 
		-- elseif  v.kind == "Polymesh" then 
			-- if not cr then cr = {data[1].Red,data[1].Green,data[1].Blue} end 
			-- deal_polymesh(v,cr)
		-- end
	-- end 
-- end
local loaded_bitmaps_ok_ = {}
local loaded_bitmaps_false_ = {}
local bmp_id_ = 0

local function add_bitmap(name)
	if loaded_bitmaps_ok_[name] then return  loaded_bitmaps_ok_[name] end 
	local getfile =  textures_db_.get(name)  
	if not getfile  then 
		if loaded_bitmaps_false_[name] then return end 
		-- print('Unloaded name = ',name)
		loaded_bitmaps_false_[name]  = true
		return 
	end
	
	bmp_id_ = bmp_id_ + 1
	local filename = bmp_id_ .. '.bmp'
	getfile = string.gsub(getfile,'/','\\')
	os_execute_('copy ' .. getfile .. ' ' .. filename)	
	local indexid = bmp_id_
	-- print(name,filename)
	add_texture(frm,{name = filename, index = indexid,type = 1})
	loaded_bitmaps_ok_[name] = indexid
	return indexid
end

local function deal_bitmap( data )

	local str =   data.unifiedbitmap_Bitmap
	if not str then return end 
	str = 'Test\\' .. str
	local bmpName = str;
	if 	string.find(str,'|') then	
		bmpName = string.match(str,'([^|]+)|')
	end
	bmpName = string.gsub(bmpName,'/','\\')
	if 	string.find(str,'\\') then	
		bmpName = string.match(bmpName,'.+\\([^\\]+)') 
	end
	bmpName = string.sub(bmpName,1,-5)
	-- print('Needed bmpName = ',bmpName)
	local index =  add_bitmap(bmpName)
	return index
end

local function deal_faces(data)
	local cr,bmpIndex;
	for k,v in ipairs (data) do 
		if v.kind == "Material" then 
			cr = {v.Red,v.Green,v.Blue}
			bmpIndex =  deal_bitmap(v) or bmpIndex
		elseif  v.kind == 'Element_Instance' then 
			deal_faces(v)
		elseif v.kind == "Polymesh" then 
			deal_polymesh{data = v,color = cr,bitmapIndex = bmpIndex}
		end
	end 
end 

local function init() 
	bmp_id_ = 0
	loaded_bitmaps_ok_ = {}
	loaded_bitmaps_false_ = {}
	textures_db_.create()
end 

function add_view(data)
	init()
	for k,v in ipairs(data) do 
		if v.kind == 'Element' then 
			if #v~= 0  then
				deal_faces(v)
			end
		end
	end 
end