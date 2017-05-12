 -- _ENV = module_seeall(...,package.seeall)
local require = require
local tonumber = tonumber
local math = math
local string = string

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


--module(...,package.seeall)
local geometry_ = require "sys.geometry";

local function deal_alignment_COLUMN_obj(mgr_obj,obj)
	mgr_obj.alignment = {};
	if obj.position.Rotation == "TOP" or obj.position.Rotation == "BELOW" then 	
		if obj.position.Depth == "BEHIND" then -- x轴正向 zhu
			mgr_obj.alignment.v = 0.5;
				if obj.position.Rotation == "BELOW" then 
					mgr_obj.alignment.v = -0.5;
				end
		elseif obj.position.Depth == "FRONT" then --x轴负向
			mgr_obj.alignment.v = -0.5
				if obj.position.Rotation == "BELOW" then 
					mgr_obj.alignment.v = 0.5
				end
		elseif obj.position.Depth == "MIDDLE" then
			mgr_obj.alignment.v = 0
		end
		if obj.position.Plane == "MIDDLE" then --y轴
			mgr_obj.alignment.h = 0;
		elseif obj.position.Plane == "LEFT"  then--y轴正向
			mgr_obj.alignment.h = -0.5
				if obj.position.Rotation == "BELOW" then 
					mgr_obj.alignment.h = 0.5
				end
		elseif obj.position.Plane == "RIGHT" then	--y轴负向
			mgr_obj.alignment.h = 0.5
				if obj.position.Rotation == "BELOW" then 
					mgr_obj.alignment.h = -0.5
				end
		end
	elseif obj.position.Rotation == "FRONT" or obj.position.Rotation == "BACK" then
		if obj.position.Depth == "BEHIND" then -- x轴正向 zhu
			mgr_obj.alignment.h = -0.5;
				if obj.position.Rotation == "BACK" then 
					mgr_obj.alignment.h = 0.5;
				end
		elseif obj.position.Depth == "FRONT" then --x轴负向
			mgr_obj.alignment.h = 0.5
				if obj.position.Rotation == "BACK" then 
					mgr_obj.alignment.h = -0.5
				end
		elseif obj.position.Depth == "MIDDLE" then
			mgr_obj.alignment.h = 0
		end
		if obj.position.Plane == "MIDDLE" then --y轴
			mgr_obj.alignment.v = 0;
		elseif obj.position.Plane == "LEFT"  then--y轴正向
			mgr_obj.alignment.v = -0.5
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.v = 0.5
			end
		elseif obj.position.Plane == "RIGHT" then	--y轴负向
			mgr_obj.alignment.v = 0.5
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.v = -0.5
			end
		end
	end
end

local function deal_alignment_beam_obj1(mgr_obj,obj)	
	mgr_obj.alignment = {};
	if obj.position.Rotation == "TOP" or obj.position.Rotation == "BELOW" then 	
		if obj.position.Depth == "BEHIND" then -- z轴正向 zhu
			mgr_obj.alignment.v = 0.5;
			if obj.position.Rotation == "BELOW" then 
				mgr_obj.alignment.v = -0.5;
			end--]]
		elseif obj.position.Depth == "FRONT" then --z轴负向
			mgr_obj.alignment.v = -0.5
				if obj.position.Rotation == "BELOW" then 
					mgr_obj.alignment.v = 0.5
				end--]]
		elseif obj.position.Depth == "MIDDLE" then
			mgr_obj.alignment.v = 0
		end
		if obj.position.Plane == "MIDDLE" then --y轴
			mgr_obj.alignment.h = 0;
		elseif obj.position.Plane == "LEFT"  then--y轴正向
			mgr_obj.alignment.h = -0.5
			if obj.position.Rotation == "BELOW" then 
				mgr_obj.alignment.h = 0.5
			end--]]
		elseif obj.position.Plane == "RIGHT" then	--y轴负向
			mgr_obj.alignment.h = 0.5
			if obj.position.Rotation == "BELOW" then 
				mgr_obj.alignment.h = -0.5
			end--]]
		end
	elseif obj.position.Rotation == "FRONT" or obj.position.Rotation == "BACK" then
		if obj.position.Depth == "BEHIND" then --z
			mgr_obj.alignment.h = -0.5;
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.h = 0.5
			end
		elseif obj.position.Depth == "FRONT" then --z轴zheng向
			mgr_obj.alignment.h = 0.5
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.h = -0.5
			end--]]
		elseif obj.position.Depth == "MIDDLE" then
			mgr_obj.alignment.h = 0
		end
		if obj.position.Plane == "MIDDLE" then --y轴
			mgr_obj.alignment.v = 0;
		elseif obj.position.Plane == "LEFT"  then--y轴正向
			mgr_obj.alignment.v = -0.5
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.v = 0.5
			end--]]
		elseif obj.position.Plane == "RIGHT" then	--y轴负向
			mgr_obj.alignment.v = 0.5
			if obj.position.Rotation == "BACK" then 
				mgr_obj.alignment.v = -0.5
			end--]]
		end
	end
end

local function offset_rotation(mgr_obj,obj,angel)
	if angel == 0 then return end
	local ln = geometry_.Line:new();
	ln.pt1 = obj.start_pt;
	ln.pt2 = obj.end_pt;
	local pt = geometry_.Point:new(mgr_obj.spt_);
	angel = tonumber(angel);
	mgr_obj.spt_ = pt:rotate_line(angel,ln)
	pt = geometry_.Point:new(mgr_obj.ept_);
	mgr_obj.ept_ = pt:rotate_line(angel,ln)
end

local function get_column_pos(mgr_obj,obj)
	if obj.position.Depth == "BEHIND" then --tekla中水平方向向右
		mgr_obj.spt_[1] = obj.start_pt.x + obj.position.DepthOffset
		mgr_obj.ept_[1] =  obj.end_pt.x + obj.position.DepthOffset
	elseif obj.position.Depth == "FRONT" then -- tekla中水平方向向左 为正向左
		mgr_obj.spt_[1] = obj.start_pt.x - obj.position.DepthOffset
		mgr_obj.ept_[1] =  obj.end_pt.x - obj.position.DepthOffset
	elseif obj.position.Depth == "MIDDLE" then -- tekla中水平方向中间 
		mgr_obj.spt_[1] =  obj.start_pt.x - obj.position.DepthOffset
		mgr_obj.ept_[1] =  obj.end_pt.x - obj.position.DepthOffset
	end
	if obj.position.Plane == "MIDDLE" then --tekla中垂直方向(y轴方向)中间	
		mgr_obj.spt_[2] = obj.start_pt.y + obj.position.PlaneOffset
		mgr_obj.ept_[2] = obj.end_pt.y + obj.position.PlaneOffset
	elseif obj.position.Plane == "LEFT" then -- tekla中垂直方向向上
		mgr_obj.spt_[2] =  obj.start_pt.y+ obj.position.PlaneOffset
		mgr_obj.ept_[2] = obj.end_pt.y + obj.position.PlaneOffset
	elseif obj.position.Plane == "RIGHT" then -- tekla中垂直方向向下
		mgr_obj.spt_[2] =  obj.start_pt.y  - obj.position.PlaneOffset ;
		mgr_obj.ept_[2] = obj.end_pt.y  - obj.position.PlaneOffset ;
	end
end

local function column_obj(mgr_obj,obj)
	local angel =  obj.position.RotationOffset;
	mgr_obj.beta = obj.position.RotationOffset
	if obj.position.Rotation == "TOP" or obj.position.Rotation == "BELOW" then 	
		mgr_obj.beta = obj.position.RotationOffset + 90;
	end
	if obj.position.Rotation == "FRONT" or obj.position.Rotation == "BACK" then		
		mgr_obj.beta = mgr_obj.beta
		if obj.position.Rotation == "BACK" then 
			mgr_obj.beta = mgr_obj.beta + 180;
		end
	elseif obj.position.Rotation == "TOP" or obj.position.Rotation == "BELOW" then
		mgr_obj.beta = obj.position.RotationOffset + 90;
		if obj.position.Rotation == "BELOW" then
			mgr_obj.beta = mgr_obj.beta + 180;
		end
	end
	--trace_out("here\n")
	--trace_out("here\n")
	get_column_pos(mgr_obj,obj)
	offset_rotation(mgr_obj,obj,angel)
end

local function deal_offset_pos(mgr_obj,obj,type)
	if type ==1 then
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x + obj.StartPointOffset.Dx
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dy
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z + obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dx;
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dy;
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 2 then 
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x - obj.StartPointOffset.Dx
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dy
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dx;
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dy;
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 3 then 
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x - obj.StartPointOffset.Dy
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dx
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dy;
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dx;
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 4 then 
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x + obj.StartPointOffset.Dy
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dx
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dy;
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dx;
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 5 then 
		local dis_sd =  math.sqrt(( obj.start_pt.x - obj.end_pt.x)^2 + ( obj.start_pt.z - obj.end_pt.z)^2 + ( obj.start_pt.y - obj.end_pt.y)^2)
		local angel =math.asin(( - obj.start_pt.y + obj.end_pt.y)/dis_sd)
		local angel2 = math.sin((obj.start_pt.z - obj.end_pt.z)/dis_sd)
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x + obj.StartPointOffset.Dx*math.cos(angel)
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dx*math.sin(angel)
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dy*math.cos(angel)
			obj.start_pt.x = obj.start_pt.x  -  obj.StartPointOffset.Dy*math.sin(angel)
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dx*math.cos(angel);
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dx*math.sin(angel);
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dy*math.cos(angel);
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dy*math.sin(angel);
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 6 then 
		local dis_sd =  math.sqrt(( obj.start_pt.x - obj.end_pt.x)^2 + ( obj.start_pt.z - obj.end_pt.z)^2 + ( obj.start_pt.y - obj.end_pt.y)^2)
		local angel =math.asin((  obj.start_pt.y - obj.end_pt.y)/dis_sd)
		local angel2 = math.sin((obj.start_pt.z - obj.end_pt.z)/dis_sd)
		--trace_out("new_angel 1= " .. (90 - math.deg(angel)) .. "\n")
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x + obj.StartPointOffset.Dx*math.cos(angel)
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dx*math.sin(angel)
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)))
			obj.start_pt.x = obj.start_pt.x +  obj.StartPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)))
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dx*math.cos(angel);
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dx*math.sin(angel);
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)));
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)));
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 7 then 
		local dis_sd =  math.sqrt(( obj.start_pt.x - obj.end_pt.x)^2 + ( obj.start_pt.z - obj.end_pt.z)^2 + ( obj.start_pt.y - obj.end_pt.y)^2)
		local angel =math.asin((-obj.start_pt.y + obj.end_pt.y)/dis_sd)
		local angel2 = math.sin((obj.start_pt.z - obj.end_pt.z)/dis_sd)
		--trace_out("new_angel 1= " .. (90 - math.deg(angel)) .. "\n")
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x - obj.StartPointOffset.Dx*math.cos(angel)
			obj.start_pt.y = obj.start_pt.y + obj.StartPointOffset.Dx*math.sin(angel)
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)))
			obj.start_pt.x = obj.start_pt.x -  obj.StartPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)))
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dx*math.cos(angel);
			obj.end_pt.y = obj.end_pt.y + obj.EndPointOffset.Dx*math.sin(angel);
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)));
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)));
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	elseif type == 8 then 
		local dis_sd =  math.sqrt(( obj.start_pt.x - obj.end_pt.x)^2 + ( obj.start_pt.z - obj.end_pt.z)^2 + ( obj.start_pt.y - obj.end_pt.y)^2)
		local angel =math.asin((obj.start_pt.y - obj.end_pt.y)/dis_sd)
		local angel2 = math.sin((obj.start_pt.z - obj.end_pt.z)/dis_sd)
		if obj.StartPointOffset.Dx ~= 0  then 
			obj.start_pt.x = obj.start_pt.x - obj.StartPointOffset.Dx*math.cos(angel)
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dx*math.sin(angel)
		end
		if obj.StartPointOffset.Dy ~= 0  then 
			obj.start_pt.y = obj.start_pt.y - obj.StartPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)))
			obj.start_pt.x = obj.start_pt.x +  obj.StartPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)))
		end
		if obj.StartPointOffset.Dz ~= 0  then 
			obj.start_pt.z = obj.start_pt.z +obj.StartPointOffset.Dz
		end
		if obj.EndPointOffset.Dx ~= 0  then 
			obj.end_pt.x = obj.end_pt.x - obj.EndPointOffset.Dx*math.cos(angel);
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dx*math.sin(angel);
		end
		if obj.EndPointOffset.Dy ~= 0  then 
			obj.end_pt.y = obj.end_pt.y - obj.EndPointOffset.Dy*math.sin(math.rad(90 - math.deg(angel)));
			obj.end_pt.x = obj.end_pt.x + obj.EndPointOffset.Dy*math.cos(math.rad(90 - math.deg(angel)));
		end
		if obj.EndPointOffset.Dz ~= 0  then 
			obj.end_pt.z = obj.end_pt.z + obj.EndPointOffset.Dz;
		end
	end
	
	obj.start_pt.x = tonumber(string.format("%.2f",obj.start_pt.x))
	obj.start_pt.y = tonumber(string.format("%.2f",obj.start_pt.y))
	obj.start_pt.z = tonumber(string.format("%.2f",obj.start_pt.z))
	obj.end_pt.x = tonumber(string.format("%.2f",obj.end_pt.x))
	obj.end_pt.y = tonumber(string.format("%.2f",obj.end_pt.y))
	obj.end_pt.z = tonumber(string.format("%.2f",obj.end_pt.z))
	
	mgr_obj.spt_[1] = obj.start_pt.x;
	mgr_obj.spt_[2] = obj.start_pt.y;
	mgr_obj.spt_[3] = obj.start_pt.z;
	mgr_obj.ept_[1] = obj.end_pt.x;
	mgr_obj.ept_[2] = obj.end_pt.y;
	mgr_obj.ept_[3] = obj.end_pt.z;
end


local function get_mgr_obj_type_1_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	end
end

local function get_mgr_obj_type_2_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		if obj.start_pt.y > obj.end_pt.y then 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		else 
			mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
			mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		end
	end
end

local function get_mgr_obj_type_3_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + ( obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	end
end

local function get_mgr_obj_type_4_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + ( obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - ( obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.cos(math.rad(angel3))
		if obj.start_pt.x > obj.end_pt.x then 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] + ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		else 
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.PlaneOffset)*math.sin(math.rad(angel3))
			mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.sin(math.rad(angel3))
		end
	end
end

local function get_mgr_obj_type_5_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - obj.position.PlaneOffset*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - obj.position.PlaneOffset*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	end
end

local function get_mgr_obj_type_6_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + obj.position.PlaneOffset*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + obj.position.PlaneOffset*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	end
end

local function get_mgr_obj_type_7_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - obj.position.PlaneOffset*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - obj.position.PlaneOffset*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	end
end

local function get_mgr_obj_type_8_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Plane == "RIGHT" then	
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "MIDDLE" then
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - obj.position.PlaneOffset*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + obj.position.PlaneOffset*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + obj.position.PlaneOffset*math.sin(math.rad(angel2))
	elseif obj.position.Plane == "LEFT" then   
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.PlaneOffset)*math.cos(math.rad(angel2))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.PlaneOffset)*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_1_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_2_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset  )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_3_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_4_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_5_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_6_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_7_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
local function deal_z_type_8_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	if obj.position.Depth == "BEHIND" then 
		mgr_obj.spt_[3] = mgr_obj.spt_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] - (obj.position.DepthOffset )*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] - (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] + (obj.position.DepthOffset )*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	elseif  obj.position.Depth == "FRONT" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + ( obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - ( obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))		
	elseif  obj.position.Depth == "MIDDLE" then
		mgr_obj.spt_[3] = mgr_obj.spt_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.ept_[3] = mgr_obj.ept_[3] + (obj.position.DepthOffset)*math.cos(math.rad(angel1))
		mgr_obj.spt_[1] = mgr_obj.spt_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.ept_[1] = mgr_obj.ept_[1] + (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.cos(math.rad(angel2))
		mgr_obj.spt_[2] = mgr_obj.spt_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
		mgr_obj.ept_[2] = mgr_obj.ept_[2] - (obj.position.DepthOffset)*math.sin(math.rad(angel1))*math.sin(math.rad(angel2))
	end
end
--梁的起始点和终止点位置关系为 y轴相等x轴不等且起始点的x小于终止点的x
local function get_beam_top_pts_pos(mgr_obj,obj,type,angel1,angel2,angel3)
	--trace_out("type = " .. type .. "\n")
	if type == 1 then 
		get_mgr_obj_type_1_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_1_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 2 then
		get_mgr_obj_type_2_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_2_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 3 then
		get_mgr_obj_type_3_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_3_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 4 then
		get_mgr_obj_type_4_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_4_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 5 then
		get_mgr_obj_type_5_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_5_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 6 then
		get_mgr_obj_type_6_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_6_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 7 then
		get_mgr_obj_type_7_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_7_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	elseif type == 8 then
		get_mgr_obj_type_8_new_pos(mgr_obj,obj,angel1,angel2,angel3)
		deal_z_type_8_new_pos(mgr_obj,obj,angel1,angel2,angel3)
	end 
	mgr_obj.spt_[1] = tonumber(string.format("%.2f",mgr_obj.spt_[1]))
	mgr_obj.spt_[2] = tonumber(string.format("%.2f",mgr_obj.spt_[2]))
	mgr_obj.spt_[3] = tonumber(string.format("%.2f",mgr_obj.spt_[3]))
	mgr_obj.ept_[1] = tonumber(string.format("%.2f",mgr_obj.ept_[1]))
	mgr_obj.ept_[2] = tonumber(string.format("%.2f",mgr_obj.ept_[2]))
	mgr_obj.ept_[3] = tonumber(string.format("%.2f",mgr_obj.ept_[3]))
end


local function beam_obj_rotation(mgr_obj,obj,type)
	local angel = obj.position.RotationOffset
	local dis_pts = math.sqrt((mgr_obj.spt_[1] - mgr_obj.ept_[1])^2+(mgr_obj.spt_[2] - mgr_obj.ept_[2])^2+(mgr_obj.spt_[3] - mgr_obj.ept_[3])^2)
	local dis_pts1 = math.sqrt((mgr_obj.spt_[1] - mgr_obj.ept_[1])^2+(mgr_obj.spt_[2] - mgr_obj.ept_[2])^2)
	local angel2 = math.abs(math.deg(math.asin((obj.start_pt.y - obj.end_pt.y)/(dis_pts1))))
	angel2 = tonumber(string.format("%.5f",(angel2)))	
	local angel1 = math.abs(math.deg(math.asin((obj.start_pt.z - obj.end_pt.z)/(dis_pts))))
	angel1 = tonumber(string.format("%.5f",(angel1)))
	local angel3 = math.abs(math.deg(math.asin((obj.start_pt.x - obj.end_pt.x)/(dis_pts1))))
	angel2 = tonumber(string.format("%.5f",(angel2)))		
	mgr_obj.beta = obj.position.RotationOffset;
	if obj.position.Rotation == "FRONT" or obj.position.Rotation == "BACK" then		
		mgr_obj.beta = mgr_obj.beta - 90;
		if obj.position.Rotation == "BACK" then 
			mgr_obj.beta = mgr_obj.beta +180;
		end
	elseif obj.position.Rotation == "TOP" or obj.position.Rotation == "BELOW" then
		if obj.position.Rotation == "BELOW" then
			mgr_obj.beta = mgr_obj.beta + 180;
		end
	end
	get_beam_top_pts_pos(mgr_obj,obj,type,angel1,angel2,angel3)
	offset_rotation(mgr_obj,obj,angel)
	mgr_obj.spt_[1] = string.format("%.2f",mgr_obj.spt_[1])
	mgr_obj.ept_[1] = string.format("%.2f",mgr_obj.ept_[1])
	mgr_obj.spt_[2] = string.format("%.2f",mgr_obj.spt_[2])
	mgr_obj.ept_[2] = string.format("%.2f",mgr_obj.ept_[2])
	mgr_obj.spt_[3] = string.format("%.2f",mgr_obj.spt_[3])
	mgr_obj.ept_[3] = string.format("%.2f",mgr_obj.ept_[3])
end

local function deal_beam_obj_top(mgr_obj,obj)
	if tonumber(obj.start_pt.y) == tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) ~= tonumber(obj.end_pt.x) then 
		if tonumber(obj.start_pt.x) < tonumber(obj.end_pt.x) then 
			deal_offset_pos(mgr_obj,obj,1);	
			beam_obj_rotation(mgr_obj,obj,1)
		elseif tonumber(obj.start_pt.x) > tonumber(obj.end_pt.x) then
			deal_offset_pos(mgr_obj,obj,2);	
			beam_obj_rotation(mgr_obj,obj,2)
		end
	elseif (obj.start_pt.y) ~= (obj.end_pt.y) and (obj.start_pt.x) == (obj.end_pt.x) then 
		if tonumber(obj.start_pt.y) < tonumber(obj.end_pt.y) then 
			deal_offset_pos(mgr_obj,obj,3);
			beam_obj_rotation(mgr_obj,obj,3)
		elseif tonumber(obj.start_pt.y) > tonumber(obj.end_pt.y) then
			deal_offset_pos(mgr_obj,obj,4);
			beam_obj_rotation(mgr_obj,obj,4)
		end
	elseif tonumber(obj.start_pt.y) ~= tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) ~= tonumber(obj.end_pt.x) then 
		if tonumber(obj.start_pt.y) < tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) < tonumber(obj.end_pt.x) then 
			deal_offset_pos(mgr_obj,obj,5);
			beam_obj_rotation(mgr_obj,obj,5)
		elseif tonumber(obj.start_pt.y) > tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) < tonumber(obj.end_pt.x) then
			deal_offset_pos(mgr_obj,obj,6);
			beam_obj_rotation(mgr_obj,obj,6)
		elseif tonumber(obj.start_pt.y) < tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) > tonumber(obj.end_pt.x) then
			deal_offset_pos(mgr_obj,obj,7);
			beam_obj_rotation(mgr_obj,obj,7)
		elseif tonumber(obj.start_pt.y) > tonumber(obj.end_pt.y) and tonumber(obj.start_pt.x) > tonumber(obj.end_pt.x) then
			deal_offset_pos(mgr_obj,obj,8);
			beam_obj_rotation(mgr_obj,obj,8)
		end
	end
end

local function beam_obj(mgr_obj,obj)
	deal_alignment_beam_obj1(mgr_obj,obj)
	deal_beam_obj_top(mgr_obj,obj);
end

local function change_mgr_obj(mgr_obj,obj)
		if obj.kind == "Beam" or obj.kind == "BEAM"  then 		
			if obj.start_pt.x == obj.end_pt.x  and  obj.start_pt.y == obj.end_pt.y  then 
				deal_alignment_COLUMN_obj(mgr_obj,obj)		
				column_obj(mgr_obj,obj)
			else
				beam_obj(mgr_obj,obj)
			end
		end
end

local function deal_limit_pt(pt)
	if not pt then return end	
	pt = string.format("%.2f",pt);
	return tonumber(pt);
end


local function deal_pt_ifo(mgr_obj,obj)
	mgr_obj.spt_[1] = (deal_limit_pt(mgr_obj.spt_[1]));
	mgr_obj.spt_[2] = (deal_limit_pt(mgr_obj.spt_[2]));
	mgr_obj.spt_[3] = (deal_limit_pt(mgr_obj.spt_[3]));
	mgr_obj.ept_[1] = (deal_limit_pt(mgr_obj.ept_[1]));
	mgr_obj.ept_[2] = (deal_limit_pt(mgr_obj.ept_[2]));
	mgr_obj.ept_[3] = deal_limit_pt(mgr_obj.ept_[3]);
	mgr_obj.beta = deal_limit_pt(mgr_obj.beta);
	obj.start_pt.x = deal_limit_pt(obj.start_pt.x);
	obj.start_pt.y = deal_limit_pt(obj.start_pt.y);
	obj.start_pt.z = deal_limit_pt(obj.start_pt.z);
	obj.end_pt.x = deal_limit_pt(obj.end_pt.x);
	obj.end_pt.y = deal_limit_pt(obj.end_pt.y);
	obj.end_pt.z = deal_limit_pt(obj.end_pt.z);
	obj.position.RotationOffset = deal_limit_pt(obj.position.RotationOffset);
	obj.position.PlaneOffset = deal_limit_pt(obj.position.PlaneOffset);
	obj.position.DepthOffset = deal_limit_pt(obj.position.DepthOffset)
	obj.StartPointOffset.Dx = deal_limit_pt(obj.StartPointOffset.Dx)
	obj.StartPointOffset.Dy = deal_limit_pt(obj.StartPointOffset.Dy)
	obj.StartPointOffset.Dz = deal_limit_pt(obj.StartPointOffset.Dz)
	obj.EndPointOffset.Dx = deal_limit_pt(obj.EndPointOffset.Dx)
	obj.EndPointOffset.Dy = deal_limit_pt(obj.EndPointOffset.Dy)
	obj.EndPointOffset.Dz = deal_limit_pt(obj.EndPointOffset.Dz)
end
function deal_pos(mgr_obj,obj)
	--local str = string.sub(obj.section,string.find(obj.section,"%a+")); 
	deal_pt_ifo(mgr_obj,obj);
	change_mgr_obj(mgr_obj,obj)
end
