--module(...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
local print = print
local require = require
local pairs=pairs
local table = table
local string = string
local tonumber = tonumber
local os_date_ = os.date
local os_time_ = os.time
local dofile = dofile
local type =type
local loadfile = loadfile
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

--edit_status: add edit delete
local geo_ = require "sys.geometry"
local mssage_ = require "sys.tree.message";

tekla_model_ = {
	fittings = {};
};



local cur_date = {};
local cur_time = {};
local cur_date_all = {};
local function check(tekla_id)	
	for k,v in pairs(require"sys.mgr".get_all()) do		
		if(v.tekla_id == nil)then
			return nil;
		elseif(v.tekla_id == tekla_id)then
			return v;
		end
	end
	return nil;
end
local function check_obj(tekla_id,edit_status)	
	for k,v in pairs(require"sys.mgr".get_all()) do		
		local val = require "sys.mgr".get_table(k,v);
		if(val.tekla_id == nil)then
			return "new";
		elseif(val.tekla_id == tekla_id)then
			if(val.edit_status == "edit")then
				return "edit",v;
			else
				return "NO_DEAL",v;--对于其它不是编辑的，保持数据不变
			end
			return val;
		end
	end
	
	return "new";
end
local function get_color_rgb(class)
	if(class == "1")then--浅灰色
		return {125/255.0,125/255.0,125/255.0};		
	elseif(class == "0")then--红色
		return {r=1,g=0,b=0};	
	elseif(class == "2")then--红色
		return {r=1,g=0,b=0};	
	elseif(class == "3")then--绿色
		return {r=0,g=1,b=0};	
	elseif(class == "4")then--蓝色
		return {r=0,g=0,b=1};	
	elseif(class == "5")then--青绿色
		return {r=0,g=1,b=1};	
	elseif(class == "6")then--黄色
		return  {r=1,g=1,b=0};
	elseif(class == "7")then --红紫色
		return {r=1,g=0,b=1};	
	elseif(class == "8")then--灰色
		return {r=0.5,g=0.5,b=0.5};	
	elseif(class == "9")then--玫瑰红色
		return {r=1,g=0,b=128/255.0};	
	elseif(class == "10")then--水银色
		return {r=128/255.0,g=1,b=0};	
	elseif(class == "11")then--浅绿色
		return {r=0,g=128/255.0,b=1};	
	elseif(class == "12")then--粉红色
		return {r=1,g=128/255.0,b=1};	
	elseif(class == "13")then--橘黄色
		return {r=1,g=128/255.0,b=0};	
	elseif(class == "14")then--浅蓝色
		return {r=0,g=128/255.0,b=1};	
	elseif(class == "99")then
		return {r=0.513,g=0.513,b=0.549};	
	else
		return {r=0.75,g=0.75,b=0.75};		
	end
end

local function get_color(class)
	if(class == "1")then--浅灰色
		return {125,125,125};		
	elseif(class == "0")then--红色
		return {r=255,g=0,b=0};	
	elseif(class == "2")then--红色
		return {r=255,g=0,b=0};	
	elseif(class == "3")then--绿色
		return {r=0,g=255,b=0};	
	elseif(class == "4")then--蓝色
		return {r=0,g=0,b=255};	
	elseif(class == "5")then--青绿色
		return {r=0,g=255,b=255};	
	elseif(class == "6")then--黄色
		return  {r=255,g=255,b=0};
	elseif(class == "7")then --红紫色
		return {r=255,g=0,b=255};	
	elseif(class == "8")then--灰色
		return {r=128,g=128,b=128};	
	elseif(class == "9")then--玫瑰红色
		return {r=255,g=0,b=128};	
	elseif(class == "10")then--水银色
		return {r=128,g=255,b=0};	
	elseif(class == "11")then--浅绿色
		return {r=0,g=128,b=255};	
	elseif(class == "12")then--粉红色
		return {r=255,g=128,b=255};	
	elseif(class == "13")then--橘黄色
		return {r=255,g=128,b=0};	
	elseif(class == "14")then--浅蓝色
		return {r=0,g=128,b=255};	
	elseif(class == "99")then
		return {r=128,g=128,b=128};	
	else
		return {r=180,g=180,b=180};		
	end
end
local function format_bolt_positions(bolts_array)
	local pts = {};
	for i=1,#bolts_array.BoltPositions do
		local pt = 	geo_.Point:new{bolts_array.BoltPositions[i].x,bolts_array.BoltPositions[i].y,bolts_array.BoltPositions[i].z}
		table.insert(pts,pt);		
	end
	return pts;
	
end
local function add_bolts(pl,bolts)
	local v = require "BoltArray" .new();
	v:set_bolts(bolts);	
		
	v:set_plate(pl);
	
	v.color_ = {100,111,110};

	--require"sys.mgr".add(v);				
	return v;
end
local function add_bolts_on_mem(mem,bolts)

	local v = require "BoltArray_OnMem" .new();
	v:set_bolts(bolts);	
		
	v:set_member(mem);
	
	--require"sys.mgr".add(v);				
	return v;
end

local function equal(mgr_obj,obj)
	if(obj.section ~= nil)then		
		mgr_obj.Section = require"app.Tekla.string_deal".string_ansi(obj.section);	
		mgr_obj:add_info{Section = require"app.Tekla.string_deal".string_ansi(obj.section)};
	end		
	if(obj.class ~= nil)then
		mgr_obj.Color = get_color(obj.class);
	end	
	--mgr_obj.color_ = {1,0,0};
	mgr_obj.spt_ = {obj.start_pt.x+obj.StartPointOffset.Dx,obj.start_pt.y+obj.StartPointOffset.Dy,obj.start_pt.z+obj.StartPointOffset.Dz};
	mgr_obj.ept_ = {obj.end_pt.x+obj.EndPointOffset.Dx,obj.end_pt.y+obj.EndPointOffset.Dy,obj.end_pt.z+obj.EndPointOffset.Dz};
	
	mgr_obj:add_pt(mgr_obj.spt_);
	mgr_obj:add_pt(mgr_obj.ept_);
	
	
	if(obj.tekla_id ~= nil)then
		mgr_obj.tekla_id = obj.tekla_id;
		mgr_obj:add_info{Tekla_id = obj.tekla_id};
	end	

	if(obj.name ~= nil)then
		mgr_obj.name = require"app.Tekla.string_deal".string_ansi(obj.name);
		mgr_obj:add_info{Name = require"app.Tekla.string_deal".string_ansi(obj.name)};
	end	
	
	if(obj.assembly_number ~= nil)then
		mgr_obj:add_info{Assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number)};
		mgr_obj.assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number);
	end	
	if(obj.part_number ~= nil)then
		mgr_obj:add_info{Part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number)};
		mgr_obj.part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number);
	end	
	if(obj.material ~= nil)then
		mgr_obj:add_info{Material = require"app.Tekla.string_deal".string_ansi(obj.material)};
		mgr_obj.material = require"app.Tekla.string_deal".string_ansi(obj.material);
	end	
	if(obj.class ~= nil)then
		mgr_obj.class = obj.class;
	end	
	if(obj.edit_status ~= nil)then
		mgr_obj:add_info{Edit_status = require"app.Tekla.string_deal".string_ansi(obj.edit_status)};
		mgr_obj.edit_status = obj.edit_status;
	end	
	if(obj.user ~= nil)then
		mgr_obj:add_info{User = require"app.Tekla.string_deal".string_ansi(obj.user)};
		mgr_obj.user = obj.user;
	end	
	if(obj.producer_ ~= nil)then
		mgr_obj:add_info{Producer = require"app.Tekla.string_deal".string_ansi(obj.producer_)};
		mgr_obj.producer_ = obj.producer_;
	end	
	if(obj.date ~= nil)then
		mgr_obj:add_info{Date = require"app.Tekla.string_deal".string_ansi(obj.date)};
		mgr_obj.date = obj.date;
	end	
	if(obj.weight ~= nil)then
		mgr_obj:add_info{Weight = require"app.Tekla.string_deal".string_ansi(obj.weight)};
		mgr_obj.weight = obj.weight;
	end	
	if(obj.weight_net ~= nil)then
		mgr_obj:add_info{Weight_net = require"app.Tekla.string_deal".string_ansi(obj.weight_net)};
		mgr_obj.weight_net = obj.weight_net;
	end	
	
	if(obj.position ~= nil)then

		if( obj.position.Rotation == "FRONT") then
			mgr_obj.beta = obj.position.RotationOffset - 90.0;	
		elseif( obj.position.Rotation == "BACK") then
			mgr_obj.beta = obj.position.RotationOffset + 90.0;
		elseif( obj.position.Rotation == "BOTTOM") then
		
			mgr_obj.beta = obj.position.RotationOffset + 180.0;
		end

		
	end	
	mgr_obj.time = cur_time;	
	mgr_obj.time_str = cur_date_all;	
	mgr_obj:add_info{time_str = cur_date_all};

	
	require "app.Tekla.precise_pos" .deal_pos(mgr_obj,obj);

	mgr_obj.bolts = {};
	if obj.bolts then 	
		for i=1,#obj.bolts do
			mgr_obj.bolts[i] = obj.bolts[i];
			
			local pts = format_bolt_positions(mgr_obj.bolts[i]);
			mgr_obj.bolts[i].BoltPositions = pts;
		end	
	end

	--local bolt = add_bolts_on_mem(mgr_obj,mgr_obj.bolts);	


	return mgr_obj,bolt;

	
end
local function modify_obj(mgr_obj,obj)		
	return equal(mgr_obj,obj);	
end



local function deal_plate(plate,obj)
	for k,v in pairs (plate.contour) do 
		v[1] = string.format("%.2f",tostring(v[1]))
		v[2] = string.format("%.2f",tostring(v[2]))
		v[3] = string.format("%.2f",tostring(v[3]))
	end 
	
	local tab = {x = 0,y = 0,z =0 };
	local value = 0;
	if obj.position.Depth == "BEHIND" then 
		value = - tonumber(obj.position.DepthOffset) - tonumber(string.sub(obj.section,string.find(obj.section,"%d+")))/2
	elseif obj.position.Depth == "FRONT" then 
		value = tonumber(obj.position.DepthOffset) + tonumber(string.sub(obj.section,string.find(obj.section,"%d+")))/2
	end
	if tonumber(plate.contour[1][3]) == tonumber(plate.contour[2][3]) and  tonumber(plate.contour[2][3]) == tonumber(plate.contour[3][3])  then 
		tab.z = tab.z + value;
	elseif tonumber(plate.contour[1][1]) == tonumber(plate.contour[2][1]) and  tonumber(plate.contour[2][1] )== tonumber(plate.contour[3][1])  then 
		tab.x = tab.x - value;
	elseif tonumber(plate.contour[1][2]) ==tonumber(plate.contour[2][2]) and  tonumber(plate.contour[2][2]) == tonumber(plate.contour[3][2])  then 
		tab.y = tab.y - value;
	end 
	plate:on_move(tab)
end 


local function add_plate(obj)
	local v = require "Plate" .new();
	v.tekla_id = obj.tekla_id;		
	v.thick = 	 tonumber(string.sub(obj.section,string.find(obj.section,"%d+")))
	v.section = require"app.Tekla.string_deal".string_ansi(obj.section);
	--v.contour = obj.contour;
	v.contour = {};
	for i=1,#obj.contour do
		local pt = 	geo_.Point:new{obj.contour[i].x,obj.contour[i].y,obj.contour[i].z}
		table.insert(v.contour,pt);
	end	

	deal_plate(v,obj)

	--v.color_ = get_color(obj.class);
	
		v.color_ = {100,111,110};

	v.assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number);
	v.part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number);
	v.material = require"app.Tekla.string_deal".string_ansi(obj.material);
	v.user = obj.user;	
	v.edit_status = obj.edit_status;	
	v.name = require"app.Tekla.string_deal".string_ansi(obj.name);
	
	v.time = cur_time;	
	v.time_str = cur_date_all;	
	
	if( obj.position.Rotation == "TOP")then
		v.beta = 90.0;
	end
	
	v.bolts = obj.bolts;

	v.bolts = {};
	if obj.bolts then 	
		for i=1,#obj.bolts do
			v.bolts[i] = obj.bolts[i];
			
			local pts = format_bolt_positions(v.bolts[i]);
			v.bolts[i].BoltPositions = pts;
		end	
	end 


	local bolt = add_bolts(v,v.bolts);	
	return v,bolt;	
end

local function add_plate_new(obj)

	local v = require "app.Steel.Plate".Class:new();

	v.tekla_id = obj.tekla_id;	
	v:add_info{Tekla_id = require"app.Tekla.string_deal".string_ansi(obj.tekla_id)};
	
		
	v.Thick = 	 tonumber(string.sub(obj.section,string.find(obj.section,"%d+")))
	v:add_info{Thick = require"app.Tekla.string_deal".string_ansi(obj.thick)};

	v.Section = require"app.Tekla.string_deal".string_ansi(obj.section);
	v:add_info{Section = require"app.Tekla.string_deal".string_ansi(obj.section)};
	
	
	--v.contour = obj.contour;
	v.contour = {};
	for i=1,#obj.contour do
		local pt = 	geo_.Point:new{obj.contour[i].x,obj.contour[i].y,obj.contour[i].z}
		table.insert(v.contour,pt);
		
		v:add_pt(pt);		
	end	

	--deal_plate(v,obj)

	
	--v.color_ = {100,111,110};
	if(obj.class ~= nil)then
		v.Color = get_color(obj.class);
	end	


	v.assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number);
	v:add_info{assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number)};

	v.part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number);
	v:add_info{part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number)};

	v.material = require"app.Tekla.string_deal".string_ansi(obj.material);
	v:add_info{material = require"app.Tekla.string_deal".string_ansi(obj.material)};
	
	v.user = obj.user;	
	v:add_info{user = require"app.Tekla.string_deal".string_ansi(obj.user)};
	
	v.edit_status = obj.edit_status;	
	v:add_info{edit_status = require"app.Tekla.string_deal".string_ansi(obj.edit_status)};

	v.name = require"app.Tekla.string_deal".string_ansi(obj.name);
	v:add_info{name = require"app.Tekla.string_deal".string_ansi(obj.name)};
	
	v.time = cur_time;	
	
	v.time_str = cur_date_all;	
	v:add_info{time_str = require"app.Tekla.string_deal".string_ansi(obj.time_str)};
	
	if( obj.position.Rotation == "TOP")then
		v.beta = 90.0;
	end
	
	--[[v.bolts = obj.bolts;

	v.bolts = {};
	
	if obj.bolts then 	
		for i=1,#obj.bolts do
			v.bolts[i] = obj.bolts[i];
			
			local pts = format_bolt_positions(v.bolts[i]);
			v.bolts[i].BoltPositions = pts;
		end	
	end 


	local bolt = add_bolts(v,v.bolts);	
--]]
	return v,bolt;
	
				
	
end
local function add_ploybeam(obj)
	--local v = require "PolyBeam" .new();
	
	local v = require "app.Steel.Member".Class:new();	

	v.tekla_id = obj.tekla_id;			
	v.section = require"app.Tekla.string_deal".string_ansi(obj.section);
	v:add_info{Section = require"app.Tekla.string_deal".string_ansi(obj.section)};
	--v.contour = obj.contour;
	v.contour = {};
	for i=1,#obj.contour do
		local pt = 	geo_.Point:new{obj.contour[i].x,obj.contour[i].y,obj.contour[i].z}
		table.insert(v.contour,pt);
	
		v:add_pt(pt);
	end	

	--deal_plate(v,obj)

	v.color_ = get_color(obj.class);
	v:add_info{Color = v.color_};
	
	v.assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number);
	v:add_info{Assembly_number = require"app.Tekla.string_deal".string_ansi(obj.assembly_number)};
	
	
	v.part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number);
	v:add_info{Part_number = require"app.Tekla.string_deal".string_ansi(obj.part_number)};

	v.material = require"app.Tekla.string_deal".string_ansi(obj.material);
	v:add_info{Material = require"app.Tekla.string_deal".string_ansi(obj.material)};

	v.user = obj.user;	
	v:add_info{User = require"app.Tekla.string_deal".string_ansi(obj.user)};

	v.edit_status = obj.edit_status;	
	v:add_info{Edit_status = require"app.Tekla.string_deal".string_ansi(obj.edit_status)};

	v.name = require"app.Tekla.string_deal".string_ansi(obj.name);
	v:add_info{Name = require"app.Tekla.string_deal".string_ansi(obj.name)};
	
	v.time = cur_time;	
	v.time_str = cur_date_all;	
	v:add_info{Time = require"app.Tekla.string_deal".string_ansi(obj.time_str)};
	
	if( obj.position.Rotation == "TOP")then
		v.beta = 90.0;
	end
	
	v.bolts = obj.bolts;

	v.bolts = {};
	if obj.bolts then 	
		for i=1,#obj.bolts do
			v.bolts[i] = obj.bolts[i];
			
			local pts = format_bolt_positions(v.bolts[i]);
			v.bolts[i].BoltPositions = pts;
		end	
	end 


	--local bolt = add_bolts_on_mem(v,v.bolts);	
	return v,bolt;
	
				
	
end
local function add_grid(obj)
	local v = require "Grid" .new();
	v.tekla_id = obj.tekla_id;			
	v.name = obj.name;	
	v.color_ = {0,0,1};	
	v.CoordinateX = obj.CoordinateX;	
	v.CoordinateY = obj.CoordinateY;	
	v.CoordinateZ = obj.CoordinateZ;	
	
	v.ExtensionLeftX = obj.ExtensionLeftX;	
	v.ExtensionLeftY = obj.ExtensionLeftY;	
	v.ExtensionLeftZ = obj.ExtensionLeftZ;	
	
	v.ExtensionRightX = obj.ExtensionRightX;	
	v.ExtensionRightY = obj.ExtensionRightY;	
	v.ExtensionRightZ = obj.ExtensionRightZ;
		
	v.LabelX = obj.LabelX;	
	v.LabelY = obj.LabelY;	
	v.LabelZ = obj.LabelZ;	
				
	return v;
end
local function add_fitting(obj)
	local v = require "Fitting" .new();
	v.tekla_id = obj.tekla_id;			
	v.Father = obj.Father;	
	v.color_ = {0,0,1};	
	v.Plane = obj.Plane;	
	v.coord = obj.coord;	
	if(obj.main_obj)then
		v.main_obj = obj.main_obj;
	end


				
	return v;
end
local function add_cutplane(obj)
	local v = require "CutPlane".new();
	v.tekla_id = obj.tekla_id;			
	v.main_obj = obj.main_obj;	
	v.Identifier = obj.Identifier;	
--[[	v.Origin = {x=obj.Origin.x,x=obj.Origin.y,x=obj.Origin.z};	
	v.AxisX = {x=obj.AxisX.x,x=obj.AxisX.y,x=obj.AxisX.z};	
	v.AxisY = {x=obj.AxisY.x,x=obj.AxisY.y,x=obj.AxisY.z};	
--]]
	v.Plane = obj.Plane
	
	v.user = obj.user;	
	v.weight = obj.weight;	
	v.weight_net = obj.weight_net;	
	
	v.type = obj.type;	
	
				
	return v;
end

local function add_cut_sons(mgr_objs,cut_sons)
	--2014-5-6 隐藏，不出切割构件
	for i=1,#cut_sons do		
		if (cut_sons[i].OperativePart_type == "Tekla.Structures.Model.Beam")then
			local m = require "Member" .new();
			m = equal(m,cut_sons[i].OperativePart);	
			if(cut_sons[i].main_obj)then
				m.main_obj = cut_sons[i].main_obj;
			end
			table.insert(mgr_objs,m);
		elseif (cut_sons[i].OperativePart_type == "Tekla.Structures.Model.ContourPlate")then
			local pl,bolt = add_plate(cut_sons[i].OperativePart);	
			if(cut_sons[i].main_obj)then
				bolt.main_obj = cut_sons[i].main_obj;
			end
			if(cut_sons[i].main_obj)then
				pl.main_obj = cut_sons[i].main_obj;
			end
			table.insert(mgr_objs,pl);
			table.insert(mgr_objs,bolt);					
		elseif (cut_sons[i].kind == "CutPlane")then
			

			local cut = add_cutplane(cut_sons[i]);
			table.insert(mgr_objs,cut);
		else
		--trace_out("add_cut_sons kind = : " .. tostring(cut_sons[i].kind).. "  ;OperativePart_type = " ..tostring(cut_sons[i].OperativePart_type) .. "can't import.\n");
		end
	end


end
--处理Tekla中的节点
---2016-8-16 处理节点	
local model_jnts_ = {};

local function add_obj(obj,mgr_objs)
	
	if (obj.kind == "ContourPlate")then
		local bolt = {};
		--local pl,bolt = add_plate(obj);	
		local pl,bolt = add_plate_new(obj);	
		table.insert(mgr_objs,pl);
		--table.insert(mgr_objs,bolt);
	
		if(obj.cut_sons ~= nil)then
			--add_cut_sons(mgr_objs,obj.cut_sons);		
		end
		
	elseif (obj.kind == "PolyBeam")then
		local pl,bolt = add_ploybeam(obj);	
		table.insert(mgr_objs,pl);
		--table.insert(mgr_objs,bolt);
	
		if(obj.cut_sons ~= nil)then
		--	add_cut_sons(mgr_objs,obj.cut_sons);		
		end
	elseif (obj.kind == "Grid")then
		--local grid = add_grid(obj);	
		--table.insert(mgr_objs,grid);
	elseif (obj.kind == "Fitting")then
		--trace_out("Fitting\n");		
		--local cut = add_cutplane(obj);
		--table.insert(mgr_objs,cut);	
		--local v = add_fitting(obj);			
		--table.insert(tekla_model_.fittings,v);		
		--table.insert(mgr_objs,v);		
	elseif (obj.kind == "CutPlane")then
		--local cut = add_cutplane(obj);
		--table.insert(mgr_objs,cut);
	---2016-8-16 处理节点	
	elseif (obj.kind == "Connection")then
		table.insert(model_jnts_,obj);
				
	elseif (obj.kind == "Beam")then
		local bolt = {};
		local m = require "app.Steel.Member".Class:new();
		m,bolt = equal(m,obj);			
		
		table.insert(mgr_objs,m);
		--table.insert(mgr_objs,bolt);
		
		if(obj.cut_sons ~= nil)then
			--add_cut_sons(mgr_objs,obj.cut_sons);		
		end
	else
	end
end

local msgs_g = {{name="Show",fun=mssage_.rclk_menu_show},{name="Hide",fun=mssage_.rclk_menu_hide},};


local function create_items(mgr_objs)
	--去掉重复的构件号
	local items = {};
	local haves = {};
	for k,v in pairs(mgr_objs) do
		if(haves[v.assembly_number] == nil)then		
			local it = require "sys.tree.item".create_item();
			it.name = v.assembly_number;
			it.link = v;
			it.nm_click = mssage_.nm_click_g;
			it.nm_dbclick = mssage_.nm_dbclick_g;
			it.rclk_menu = msgs_g;
			table.insert(items,it);
			haves[it.name] = it.name;
		end
	end
	table.sort(items,function(x,y) return x.name > y.name end);
	return items;
end	

---2016-8-16 处理节点
local function create_joints(mgrid_by_teklaid,model_jnts)
	for k,v in pairs(model_jnts) do
		--local jnt = require "app.Steel.Joint".Class:new();
		
		local jnt =require"app.Steel.Joint".Class:new{Type="Joint",Color={0,255,0}};
		
		--取得节点的位置
		local main_mem_mgrid = mgrid_by_teklaid[v.tekla_id_main];
		local mem = require"sys.mgr".get_item(main_mem_mgrid);
		jnt:add_pt(mem.Points[1]);
			
		--值
		jnt.kind = v.kind;
		jnt.tekla_id = v.tekla_id;
		jnt.name = v.name;
		jnt.Code = v.Code;
		jnt.AutoDirectionType = v.AutoDirectionType;
		jnt.Number = v.Number;
		jnt.PositionType = v.PositionType;
		jnt.user = v.user;
		jnt.tekla_id_main = v.tekla_id_main;
		jnt.tekla_ids_seconds = v.tekla_ids_seconds;
		jnt.children = v.children;
		 
		jnt:add_part(mgrid_by_teklaid[v.tekla_id_main]);
		for i=1,#v.tekla_ids_seconds do
			jnt:add_part(mgrid_by_teklaid[v.tekla_ids_seconds[i].tekla_id_sec]);		
		end		
		--信息
		jnt:add_info{Kind = require"app.Tekla.string_deal".string_ansi(v.kind)};
		jnt:add_info{Tekla_id = require"app.Tekla.string_deal".string_ansi(v.tekla_id)};
		jnt:add_info{Name = require"app.Tekla.string_deal".string_ansi(v.name)};
		jnt:add_info{Code = require"app.Tekla.string_deal".string_ansi(v.Code)};
		jnt:add_info{AutoDirectionType = require"app.Tekla.string_deal".string_ansi(v.AutoDirectionType)};
		jnt:add_info{Number = require"app.Tekla.string_deal".string_ansi(v.Number)};
		jnt:add_info{PositionType = require"app.Tekla.string_deal".string_ansi(v.PositionType)};
		jnt:add_info{User = require"app.Tekla.string_deal".string_ansi(v.user)};
		
		jnt:add_info{Tekla_id_main = require"app.Tekla.string_deal".string_ansi(v.tekla_id_main)};
		for i=1,#v.tekla_ids_seconds do		
			jnt:add_info{Tekla_id_second = require"app.Tekla.string_deal".string_ansi(v.tekla_ids_seconds[i].tekla_id_sec)};					
		end			
		require"sys.mgr".add(jnt);
	end	
	
end
function open_model(file)	
	-- dlgtree_show(frm,true);  
	--require("sys.mgr").update();	
	tekla_model = nil;
	dofile(file)
	local fun = {}
	local f = loadfile(file,'bt',fun)
	if f then 
		f();
	end 
	tekla_model = fun and fun.tekla_model
	cur_date = os_date_("*t", os_time_());
	cur_time = os_time_({year = cur_date.year,month=cur_date.month,day=cur_date.day,hour=cur_date.hour,min=cur_date.min,sec=cur_date.sec})
	cur_date_all = {year = cur_date.year,month=cur_date.month,day=cur_date.day,hour=cur_date.hour,min=cur_date.min,sec=cur_date.sec};	
	
--[[
	local import_mgr = require "app.ApSteel.model_op".get_class("app/Tekla/import_mgr");
	if(import_mgr == nil)then
		import_mgr = require "app.Tekla.import_mgr".Class:new();
		import_mgr:add(cur_date_all);
		require "sys.mgr".add(import_mgr);
	else
		import_mgr:add(cur_date_all);
	end	
--]]
	
	print('tekla_model = ',tekla_model)
	if type(tekla_model) ~= 'table' then return end 
	
	local mgr_objs = {};	
	for i=1,#tekla_model do		
		local status,mgr_obj = check_obj(tekla_model[i].tekla_id,tekla_model[i].edit_status);
		if(status == "edit") then
			modify_obj(mgr_obj,tekla_model[i]);								
		elseif(status == "NO_DEAL")then
			--保持该数据不变
			--trace_out("NO_DEAL_obj\n");
		elseif(status == "new")then
			add_obj(tekla_model[i],mgr_objs);
		end	
	end			
	
	-- local submodel = require"app.Model.Submodel".Class:new{Name=require "app.Tekla.iupex".get_file_name(file)};
	
	local run = require"sys.progress".create{title="Importing ... ",count=#(mgr_objs),time=1};
	
	local mgrid_by_teklaid = {};
	for k,v in pairs(mgr_objs) do
		require"sys.mgr".add(v);
		---2016-8-16 处理节点	
		--设置映射关系
		mgrid_by_teklaid[v.tekla_id] = v.mgrid;
		--v:set_mode_rendering();
		
		-- require"sys.mgr".draw(v);
		-- submodel:add_id(v.mgrid);
		run();
		--require("sys.mgr").update();
	end
	
	---2016-8-16 处理节点	
	create_joints(mgrid_by_teklaid,model_jnts_);
	
	-- require"sys.mgr".add(submodel);
	
	-- submodel:open();


	local it = require "sys.tree.item".create_item();
	it.index = 10;
	it.name = require "app.Tekla.iupex".get_file_name(file);
	it.link = "Memeber3";
	it.sons = create_items(mgr_objs);
	require"app.Workspace.table_op".add_branch("Model Page",0,it);
	for k,v in pairs(it.sons) do
		require"app.Workspace.table_op".add_item("Model Page",1,v);
	end
	
	
	
	
	-- require"sys.mgr".redraw_all();
	require"sys.mgr".update();
	--处理切割
	--require "app.cut.model_cut".deal_cuts();
	--iup.Message("congratulate","Complete Improting!")
	
	tekla_model = nil;

	
end








