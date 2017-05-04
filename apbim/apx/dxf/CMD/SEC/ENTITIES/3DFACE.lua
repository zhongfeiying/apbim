_ENV = module(...,ap.adv)

local function Get_Value(this,index,code)
	return index[code] and this[index[code]].Value;
end

function Read(dxf,seck,selfi,DXF)
	--8:图层名
	--62:颜色号
	-- local sc = require"sys.mgr".get_cur_scene();
	if not require"sys.io".is_there_file{file="app/Steel/Member.lua"} then return end
	
	local this = dxf[seck][selfi]
	local index = require'sys.table'.index(this,function(k,v) return type(v)=='table' and v.Code or nil end)
	local color = Get_Value(this,index,62) or DXF:Get_Color_ID_By_Layer(Get_Value(this,index,8));
	local id = Get_Value(this,index,1000)
	local item = DXF:Get_Item_By_Key(id) or require"app.Steel.Member".Class:new{Type="3DFACE",Color=color};
	item:add_pt{Get_Value(this,index,10),Get_Value(this,index,20),Get_Value(this,index,30)};
	item:add_pt{Get_Value(this,index,11),Get_Value(this,index,21),Get_Value(this,index,31)};
	local color = require'sys.geometry'.Color:new(color):get_gl();
	local pts = {};
	local wireframe = {surfaces={}}
	local rendering = {surfaces={}}
	table.insert(pts,{color.r,color.g,color.b,1,1,Get_Value(this,index,10),Get_Value(this,index,20),Get_Value(this,index,30)});
	table.insert(pts,{color.r,color.g,color.b,1,1,Get_Value(this,index,11),Get_Value(this,index,21),Get_Value(this,index,31)});
	table.insert(pts,{color.r,color.g,color.b,1,1,Get_Value(this,index,12),Get_Value(this,index,22),Get_Value(this,index,32)});
	table.insert(pts,{color.r,color.g,color.b,1,1,Get_Value(this,index,13),Get_Value(this,index,23),Get_Value(this,index,33)});
	local wireframe_surface = {points=pts,lines={{1,2},{2,3},{3,4},{4,1}}};
	local rendering_surface = {points=pts,outer={1,2,3,4}};
	table.insert(wireframe.surfaces,wireframe_surface);
	table.insert(rendering.surfaces,rendering_surface);
	item:set_shape_wireframe(wireframe);
	item:set_shape_rendering(rendering);
	require"sys.mgr".add(item);
	-- require"sys.mgr".draw(item,sc);
end

