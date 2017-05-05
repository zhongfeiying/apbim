--module(...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
local require = require
local tostring = tostring
local trace_out = trace_out
local dofile = dofile
local loadfile = loadfile
local error = error
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

--edit_status: add edit delete
local geo_ = require "sys.geometry"
local mssage_ = require "sys.tree.message";

local function add_mesh(mesh,mgr_objs)	
	
	trace_out(tostring(mesh) .. "  ====== add_mesh\n");
end
local function add_meshs(meshs,mgr_objs)	
	trace_out("add_meshs\n");
	for i=1,#meshs do		
		add_mesh(meshs[i],mgr_objs);
	end				
end
local function add_faces(face,mgr_objs)	
	trace_out("add_faces\n");
	if (face.meshs)then	
		add_meshs(face.meshs,mgr_objs);	
	end
end
local function add_solid(solid,mgr_objs)	
	trace_out("add_solid\n");
	if (solid.Faces)then	
		add_faces(solid.Faces,mgr_objs);	
	end
end
local function add_geometries(elements,mgr_objs)	
	trace_out("add_geometries\n");
	if (elements.Kind == "solid")then	
		add_solid(obj.solid,mgr_objs);	
	end
end

local function add_floor(obj,mgr_objs)	
	if (obj.geo_elements)then	
		add_geometries(obj.geo_elements,mgr_objs);	
	end
end

local function add_obj(obj,mgr_objs)	
	
	if (obj.kind == "Floor")then	
		add_floor(obj,mgr_objs);
	elseif (obj.kind == "Beam")then	
	elseif (obj.kind == "View")then	
		-- require 'sys.table'.totrace(obj)
		require 'app.revit.view'.add_view(obj)
	else
		trace_out(tostring(obj.kind) .. "\n");
	
	end
end

function open_model(file)	
	revit_model = nil;
	local fun = {}
	local f = loadfile(file,'bt',fun)
	if f then 
		f();
	end 

	revit_model = fun and fun.revit_model
	if not revit_model then error('revit_model is not exist !') return end 
	local mgr_objs = {};	
	for i=1,#revit_model do		
		add_obj(revit_model[i],mgr_objs);
	end			
	require"sys.mgr".update();	
	revit_model = nil;	
end








