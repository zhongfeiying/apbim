_ENV = module(...,ap.adv)

local function Get_Value(this,index,code)
	return index[code] and this[index[code]].Value;
end

function Read(dxf,seck,selfi,DXF)
	--8:图层名
	--62:颜色号
	-- local sc = require"sys.mgr".get_cur_scene();
	if not require"sys.io".is_there_file{file="app/Graphics/Line.lua"} then return end
	local this = dxf[seck][selfi]
	local index = require'sys.table'.index(this,function(k,v) return type(v)=='table' and v.Code or nil end)
	local color = Get_Value(this,index,62) or DXF:Get_Color_ID_By_Layer(Get_Value(this,index,8));
	local item = require"app.Graphics.Line".Class:new{Type="LINE",Color=color};
	item:add_pt{Get_Value(this,index,10),Get_Value(this,index,20),Get_Value(this,index,30)};
	item:add_pt{Get_Value(this,index,11),Get_Value(this,index,21),Get_Value(this,index,31)};
	item:update_data();
	require"sys.mgr".add(item);
	-- require"sys.mgr".draw(item,sc);
end
