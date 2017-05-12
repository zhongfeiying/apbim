_ENV = module(...,ap.adv)

local function Get_Value(this,index,code)
	return index[code] and this[index[code]].Value;
end

function Read(dxf,seck,selfi,DXF)
	--2:图层名
	--62:颜色号
	local this = dxf[seck][selfi]
	local index = require'sys.table'.index(this,function(k,v) return type(v)=='table' and v.Code or nil end)
	DXF.TABLES = DXF.TABLES or {}
	DXF.TABLES.LAYERS = DXF.TABLES.LAYERS or {}
	DXF.TABLES.LAYERS[Get_Value(this,index,2)] = {
		COLORID = Get_Value(this,index,62)
	}
end
