_ENV = module(...,ap.adv)

local function Get_Value(this,index,code)
	return index[code] and this[index[code]].Value;
end

function Read(dxf,seck,selfi,DXF)
	--8:图层名
	--62:颜色号
	local this = dxf[seck][selfi]
	local index = require'sys.table'.index(this,function(k,v) return type(v)=='table' and v.Code or nil end)
	local color = Get_Value(this,index,62) or DXF:Get_Color_ID_By_Layer(Get_Value(this,index,8));
	local id = Get_Value(this,index,1000)
	local item = DXF:Get_Item_By_Key(id) or require'sys.Entity'.Class:new{Type='DXF-POLYLINE'};
	-- local item = DXF:Get_Item_By_Key(id) if type(item)~='table' then return end
	local color = require'sys.geometry'.Color:new(color):get_gl();
	local unit = 1;
	
	local pts = {};
	local wireframe = {surfaces={}}
	local rendering = {surfaces={}}
	local i = selfi+1;
	while true do
		local this =  dxf[seck][i];
		if this.Value~='VERTEX' then break end
		local index = require'sys.table'.index(this,function(k,v) return type(v)=='table' and v.Code or nil end)
		if tonumber(Get_Value(this,index,70))==192 then
			local x,y,z = tonumber(Get_Value(this,index,10)),tonumber(Get_Value(this,index,20)),tonumber(Get_Value(this,index,30));
			x,y,z = x*unit,y*unit,z*unit;
			if type(item.Points)~='table' then item.Points={{x,y,z}} end
			table.insert(pts,{color.r,color.g,color.b,1,1,x,y,z});
		else
			local surface_points = {};
			local wireframe_surface = {points=surface_points,lines={}};
			local rendering_surface = {points=surface_points,outer={}};
			local ids = {Get_Value(this,index,71),Get_Value(this,index,72),Get_Value(this,index,73),Get_Value(this,index,74)};
			for i,v in ipairs(ids) do
				local h = i==1 and #ids or i-1;
				local hv = tonumber(ids[h]);
				local iv = tonumber(ids[i]);
				local bline = hv>0;
				hv,iv = math.abs(hv),math.abs(iv);
				table.insert(surface_points,pts[iv]);
				if hv~=iv then
					table.insert(rendering_surface.outer,i);
					if bline then
						table.insert(wireframe_surface.lines,{h,i});
					end
				end
			end
			table.insert(wireframe.surfaces,wireframe_surface);
			table.insert(rendering.surfaces,rendering_surface);
		end
		i = i + 1;
	end
	item.Shape = item.Shape or {};
	item.Shape.Wireframe = wireframe;
	item.Shape.Rendering = rendering;
	require'sys.mgr'.add(item);
	-- DXF:Add_Model_Item_Shape(id,Shape);
end
