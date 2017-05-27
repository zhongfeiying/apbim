--module(...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
local print = print
local require = require
local table = table
local ipairs = ipairs
local string = string
local type = type
local tonumber = tonumber
local os_time_ = os.time
local loadfile = loadfile
local pairs = pairs

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local save_obj_ = require 'app.SketchUp.save_obj'

local units = {
	mm = 1;
	m = 1000;
	km=1000000;
}
local points_ = {}
local faces_ = {}
local edges_ = {}

local function turn_points(data)
	local points = {}
	for k,v in ipairs (data) do 
		local t = points_[v]
		if not t then print(v) return false end 
		table.insert(points,t)
	end 
	return points
end 

local nums = 0
local function deal_add_face(data)
	local obj = require 'app.sketchup.objects.object'.Class:new{Type="SketchUpObject"}
	local points = turn_points(data)
	if not points then nums = nums+1  return end 
	obj:set_points(points)
	obj:set_loop(data.outer,data.inners)
	obj:set_color(data.color)
	obj:set_mode_rendering()
	require 'sys.mgr'.add(obj)
	require"sys.mgr".draw(obj,sc)
end 


local function init()
	points_ = {}
	faces_ = {}
	typenames_= {}
end 

--arg = {vertices,line,to_s}
local function Edge(arg)
	if type(arg) ~= 'table' then return end 
	if not arg.vertices or not arg.line then return end 
	local key = string.match(arg.vertices,'Vertex:([^%>]+)')
	
	if not points_[key] then 
		local str = string.sub(string.match(arg.line,'%b()'),2,-2)
		points_[key] ={x = tonumber(string.match(str,'[^,]+'))*unit,y = tonumber(string.match(str,',([^,]+),'))*unit,z = tonumber(string.match(str,'.+,([^,]+)'))*unit}
	end 
end

local function deal_pt(ptstr)
	local x = string.match(ptstr,'[^(^)^,]+')
	local y = string.match(ptstr,',([^,]+),')
	local z = string.match(ptstr,'.+,([^(^)^,]+)')
	local unit = string.match(x,'([^%d^%.]+)')
	unit = units[unit] or 1
	x,y,z= tonumber(string.match(x,'[%d%.]+'))*unit,tonumber(string.match(y,'[%d%.]+'))*unit,tonumber(string.match(z,'[%d%.]+'))*unit
	return {x = x,y=y,z=z}
end 

local face_material_ = {}
face_material_.color = function(color,t)
	t.color = color
 end 


--arg = {vertices = {"","",}}
local function Face(arg)
	if type(arg) ~= 'table' then return end 
	if not arg.loops then return end 
	
	local t = {}
	t.outer = {}
	t.inners = {}
	for k,v in ipairs(arg.loops) do 
		local temp ;
		if v.isouter == 'true' then
			temp = t.outer
		else 
			local  pos= #t.inners+1
			t.inners[pos] = {}
			temp = t.inners[pos] 
		end 
		for m,n in ipairs(v) do 
			local str = n.key
			str = string.match(str,'Vertex:([^%>]+)')
			if not points_[str] then points_[str] =  deal_pt(n.pt) end 
			table.insert(t,str)
			table.insert(temp,#t)
		end 
		
	end 
	if arg.material then
		for k,v in pairs (arg.material) do 
			if type(face_material_[k]) == 'function' then 
				face_material_[k](v,t)
			end 
		end 
	end
	table.insert(faces_,t)
end

local function TypeName(name)
	typenames_[name] = true
end

function open_model(file)	
	init()
	sc = sc or require"sys.mgr".new_scene();
--	save_obj_.init()
	local info = {}
	local func = loadfile(file,"bt",info)
	info.Edge = Edge
	info.Face = Face
	info.TypeName = TypeName
	if func then 
		func()
	end
	for k,v in ipairs (faces_) do 
		 print('cur : ' .. k,'Total : ' .. #faces_)
		deal_add_face(v)
	end 

	require 'sys.mgr'.update()
	--save_obj_.endof()
	 require 'sys.table'.totrace(typenames_)
end








