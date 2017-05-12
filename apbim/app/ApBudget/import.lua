 _ENV = module(...,ap.adv)



local usa_section_lib_ =require 'app.steel.section.section_lib'


local function get_alignment(Rotation,Depth,Plane)
	local h,v = 0,0;
	
	if Rotation == 'TOP' then 
		if Depth == 'FRONT' then 
			v = -0.5
		elseif  Depth == 'BEHIND' then 
			v = 0.5
		end 
		if Plane == 'LEFT' then
			h = -0.5;
		elseif Plane == 'RIGHT' then
			h = 0.5;
		end 
	elseif  Rotation == 'BELOW' then
		if Depth == 'FRONT' then 
			v = 0.5
		elseif  Depth == 'BEHIND' then 
			v = -0.5
		end 
		if Plane == 'LEFT' then
			h = 0.5;
		elseif Plane == 'RIGHT' then
			h = -0.5;
		end 
	elseif  Rotation == 'FRONT' then 
		if Depth == 'FRONT' then 
			h = 0.5
		elseif  Depth == 'BEHIND' then 
			h = -0.5
		end 
		if Plane == 'LEFT' then
			v = -0.5;
		elseif Plane == 'RIGHT' then
			v = 0.5;
		end 
	elseif  Rotation == 'BACK' then 
		if Depth == 'FRONT' then 
			h = -0.5
		elseif  Depth == 'BEHIND' then 
			h = 0.5
		end 
		if Plane == 'LEFT' then
			v = 0.5;
		elseif Plane == 'RIGHT' then
			v = -0.5;
		end 
	end 
	return h,v
end
 
function add_model(mems,mgr_objs)	
	for i=1,#mems do
		local obj = mems[i];
		--require 'sys.table'.totrace(obj)
		-- if i == 1 then 
		-- iup.Message('Warning','')
		-- end 
		local mgr_obj = require "app.Steel.Member".Class:new();
		--测试用
		-- obj.position={
		-- Depth = "BEHIND",
		-- DepthOffset = "0",
		-- Plane = "MIDDLE",
		-- PlaneOffset = "0",
		-- Rotation = "TOP",
		-- RotationOffset = "0",
		-- }
		--mgr_obj.Section = 'HSS1.660X0.140'
		--mgr_obj.Section = 'HSS10X3-1/2X1/2'
		--mgr_obj.Section = 'MC10X22'
		--mgr_obj.Section = 'MT2.5X9.45'
		--mgr_obj.Section = 'Pipe1-1/2STD'

		--mgr_obj.Section = 'S10X25.4'
		--mgr_obj.Section = 'ST1.5X2.85'
	--	mgr_obj.Section = 'W10X100'
		--mgr_obj.Section = 'WT10.5X100.5'
		--mgr_obj.Section = 'HSS8X8X1/2'
		
		--trace_out('mgr_obj.Section = ' .. mgr_obj.Section .. '\n')
		--mgr_obj:add_info{Section = require"app.Tekla.string_deal".string_ansi(mgr_obj.Section)};
	--	mgr_obj.Section =	usa_section_lib_.get(mgr_obj.Section)
		-- trace_out('mgr_obj.Section = ' .. mgr_obj.Section .. '\n')
		
		
		mgr_obj.Section =	usa_section_lib_.get( require"app.Tekla.string_deal".string_ansi(obj.section))
		mgr_obj:add_info{Section = require"app.Tekla.string_deal".string_ansi(obj.section)};
		trace_out('mgr_obj.Section = ' .. mgr_obj.Section .. '\n')
		if(obj.color ~= nil)then
			mgr_obj.Color = obj.color;
		end	
		

		mgr_obj.spt_ = {obj.pt[1].x,obj.pt[1].y,obj.pt[1].z};
		mgr_obj.ept_ = {obj.pt[2].x,obj.pt[2].y,obj.pt[2].z};
 
		mgr_obj:add_pt(mgr_obj.spt_);
		mgr_obj:add_pt(mgr_obj.ept_);
	
		if(obj.index ~= nil)then
			mgr_obj.index = require"app.Tekla.string_deal".string_ansi(obj.index);
			mgr_obj:add_info{Index = require"app.Tekla.string_deal".string_ansi(obj.index)};
		end	
		if(obj.parent_index ~= nil)then
			mgr_obj.parent_index = require"app.Tekla.string_deal".string_ansi(obj.parent_index);
			mgr_obj:add_info{parent_index = require"app.Tekla.string_deal".string_ansi(obj.parent_index)};
		end	

		if(obj.name ~= nil)then
			mgr_obj.name = require"app.Tekla.string_deal".string_ansi(obj.name);
			mgr_obj:add_info{Name = require"app.Tekla.string_deal".string_ansi(obj.name)};
		end	
		if(obj.material ~= nil)then
			mgr_obj:add_info{Material = require"app.Tekla.string_deal".string_ansi(obj.material)};
			mgr_obj.material = require"app.Tekla.string_deal".string_ansi(obj.material);
		end	
		if(obj.group ~= nil)then
			mgr_obj:add_info{Group = require"app.Tekla.string_deal".string_ansi(obj.group)};
			mgr_obj.group = require"app.Tekla.string_deal".string_ansi(obj.group);
		end	
		if(obj.category ~= nil)then
			mgr_obj:add_info{Category = require"app.Tekla.string_deal".string_ansi(obj.category)};
			mgr_obj.category = require"app.Tekla.string_deal".string_ansi(obj.category);
		end	
		if(obj.is_vertical ~= nil)then
			mgr_obj:add_info{Is_vertical = require"app.Tekla.string_deal".string_ansi(obj.is_vertical)};
			mgr_obj.is_vertical = require"app.Tekla.string_deal".string_ansi(obj.is_vertical);
		end	
		if(obj.length ~= nil)then
			mgr_obj:add_info{Length = require"app.Tekla.string_deal".string_ansi(obj.length)};
			mgr_obj.length = require"app.Tekla.string_deal".string_ansi(obj.length);
			--2016-8-17 UGLY for demo
			if(mgr_obj.length == "0")then
				mgr_obj.Color = "3";
			else
				mgr_obj.Color = "6";
			end
		end	

		-- if(obj.position ~= nil)then
			-- local h,v;
			-- if( obj.position.Rotation == "FRONT") then
				-- mgr_obj.Beta = obj.position.RotationOffset + 90.0;	
				-- h,v = get_alignment(obj.position.Rotation,obj.position.Depth,obj.position.Plane)
			-- elseif( obj.position.Rotation == "BACK") then
				-- mgr_obj.Beta = obj.position.RotationOffset - 90.0;
				-- h,v = get_alignment(obj.position.Rotation,obj.position.Depth,obj.position.Plane)
			-- elseif( obj.position.Rotation == "BELOW") then
				-- mgr_obj.Beta = obj.position.RotationOffset ;
				-- h,v = get_alignment(obj.position.Rotation,obj.position.Depth,obj.position.Plane)
			-- elseif( obj.position.Rotation == "TOP") then
				----mgr_obj.Beta = obj.position.RotationOffset + 180 ;
				-- mgr_obj.Beta = obj.position.RotationOffset + 180 ;
				-- h,v = get_alignment(obj.position.Rotation,obj.position.Depth,obj.position.Plane)
			-- end
			-- mgr_obj.Alignment = {h = h,v = v}	
		-- end	
		table.insert(mgr_objs,mgr_obj);
	end
end

function ltog_pt(pts,axis)		
	local coord = require "sys.geometry".Coord:new();
	coord:set_base(axis.org);
	coord:set_xy_normal(axis.x,axis.y);
	
	
	pts[1] = coord:l2g(pts[1]);
	pts[2] = coord:l2g(pts[2]);
end

local function get_data(str)
	local t = {}
	for val in string.gmatch(str,'[^X+]+') do 
		table.insert(t,val)
	end 
	return t
end

local function get_pt(pt1,pt3) --对角点
	local pt = {}
	pt.x = pt1.x > pt3.x and pt1.x - ( pt1.x - pt3.x )/2 or pt3.x - ( pt3.x - pt1.x )/2
	pt.y = pt1.y > pt3.y and pt1.y - ( pt1.y - pt3.y )/2 or pt3.y - ( pt3.y - pt1.y )/2
	pt.z = 0
	return pt
end 

local function get_symmetric_point(pts) --取对称点
	local pt1,pt2 = pts[1],pts[#pts/2 + 1]
	
	return pt1,pt2
end

local function get_column_pt(member)
	local pts = member.pt
	local pt1,pt2 = get_symmetric_point(pts)
	local shape = string.match(member.section,'(%w+)%d+') 
	pts[1] = get_pt(pt1,pt2)
	pts[2] = {x = pts[1].x,y = pts[1].y,z = 0}
end

function ltog(mems,axis)	
	for i=1,#mems do
		if(mems[i].is_vertical == "1")then
			-- trace_out('start = ')
			-- require 'sys.table'.totrace(mems[i].pt)
			get_column_pt(mems[i])
			mems[i].pt[2].z = mems[i].pt[2].z + mems[i].length;	
			-- trace_out('end = ')
			-- require 'sys.table'.totrace(mems[i].pt)
		end	
		ltog_pt(mems[i].pt,axis);
		
	end
end

function open_model(file)	
	trace_out("open_model\n");
	apbudget_model_ = nil;
	
	dofile(file);	
	
	trace_out("Views'count = " .. #apbudget_model_ .. "\n");
	local mgr_objs={};
	for i=1,#apbudget_model_ do		
		local axis = apbudget_model_[i].axis;
		local mems = apbudget_model_[i].member;
		ltog(mems,axis);
		
		
		add_model(mems,mgr_objs);
	end		 
	
	local run = require"sys.progress".create{title="Importing ... ",count=#(mgr_objs),time=1};
	trace_out("Members'count = " .. #mgr_objs .. "\n");
	for k,v in pairs(mgr_objs) do
		require"sys.mgr".add(v);	
		--require"sys.mgr".redraw(v,sc);
		run();	
	end	
	require"sys.mgr".update();
	
	local sc = require"sys.mgr".new_scene{name="Model"};
	local ents = require"sys.mgr".get_all();
	if type(ents)~="table" then return end
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Rendering);
		require"sys.mgr".redraw(v,sc);
		run();
	end
	require"sys.mgr".scene_to_fit{scene=sc,ents=require"sys.mgr".get_scene_all(sc)};
	require"sys.mgr".update(sc);
	--require"sys.mgr".draw_all(sc)
	
end








