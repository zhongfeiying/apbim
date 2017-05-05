--[[

{
kind = "Polymesh",
Transform = "(7,2,3)(7,1,2)(3,4,5)(6,7,3)(0,1,7)(3,5,6)",
Facets = "6",
Points = "8",
UVs = "8",
Normals = "1",
Facets = "(7,2,3)(7,1,2)(3,4,5)(6,7,3)(0,1,7)(3,5,6)",
Points = "(22.547901154, -74.262008667, 0.000000000)(22.386852264, -74.722267151, 0.000000000)(21.809713364, -75.000198364, 0.000000000)(21.232574463, -74.722267151, 0.000000000)(21.071523666, -74.262008667, 0.000000000)(21.232574463, -73.801757813, 0.000000000)(21.809713364, -73.523826599, 0.000000000)(22.386852264, -73.801757813, 0.000000000)",
Normals = "(0.000000000, 0.000000000, -1.000000000)",
UVs = "(-0.738188976, 0.000000000)(-0.577139382, -0.460253299)(0.000000000, -0.738188976)(0.577139382, -0.460253299)(0.738188976, 0.000000000)(0.577139382, 0.460253299)(0.000000000, 0.738188976)(-0.577139382, 0.460253299)",
};

--]]

local require = require 
local ipairs = ipairs
local type = type
local table = table
local tonumber = tonumber
local print = print
local tostring = tostring
local trace_out = trace_out
 -- _ENV = module_seeall(...,package.seeall)
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


Class = {}

Class = {
	Classname = "app/Revit/objects/Polymesh";
	-- Points = {[1],[2]};
	-- Color = {255,255,255};
};

require"sys.Entity".Class:met(Class);

function Class:set_data(data)
	self.data = data
end

function Class:set_color(cr)
	self.Color = cr or {0,0,0}
end

function Class:set_BitmapIndex(index)
	self.BitmapIndex = index
end






function  Class:init_points(points,uvs)
	points = type(points) == 'table' and points or {}
	local t = {}
	local cr =  require"sys.geometry".Color:new(self.Color):get_gl()
	local r,g,b,u,v = cr[1],cr[2],cr[3],self.u or 1,self.v or 1 
	--print(r,g,b)
	for k,pt in ipairs(points) do 
		pt[1] = tonumber(pt[1]) 
		pt[2] = tonumber(pt[2]) 
		pt[3] = tonumber(pt[3]) 
		table.insert(t,{r,g,b,uvs[k][1],uvs[k][2],pt[1],pt[2],pt[3]})
		t[tostring(#t)] = {1,1,1,uvs[k][1],uvs[k][2],pt[1],pt[2],pt[3]}
	end
	return t
end

function Class:init_surfaces(data,line)
	local surfaces = {}
	local pts = self:init_points(data.Points,data.UVs)
	data.Facets = type(data.Facets) == 'table' and data.Facets or {}
	for k,v in ipairs(data.Facets) do 
		
		local surface = {}
		surface.textured = self.BitmapIndex
		surface.outer = {}
		surface.points = {}
		surface.lines = {}
		for m,n in ipairs(v) do 
			n = tonumber(n)
			table.insert(surface.points,m,pts[n])
			if not line then 
				table.insert(surface.outer,m)
			end
			if m~= #v then 
				table.insert(surface.lines,{m,m+1})
			else 
				table.insert(surface.lines,{#surface.points,1})
			end
		end
		table.insert(surfaces,surface)
	end
	return surfaces
end 

function Class:on_draw_rendering()
	if not self.data then return end 
	
	local obj = {}
	obj.surfaces = self:init_surfaces(self.data) or {}
	self:set_shape_rendering(obj)
end

function Class:on_draw_diagram()
	if type(self.data) ~= 'table' then return end 
	local obj = {}
	obj.surfaces = self:init_surfaces(self.data,'line') or {}
	self:set_shape_diagram(obj)
end