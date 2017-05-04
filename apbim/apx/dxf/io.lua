_ENV = module(...,ap.adv)

-- arg={File=,Index=}
function Read(arg)
	local f = type(arg.Index)=='function' and arg.Index or function(k,v) return type(v)=='table' and v[arg.Index] or k end
	local dxf = require'apx.dxf.array'.Read(arg.File);
	local DXF = require'apx.dxf.DXF'.Class:new{};
	-- DXF.Index_Function = f;
	DXF.Model = require'sys.mgr'.get_all();
	DXF.IDs = require'sys.table'.index(DXF.Model,f)
	require'apx.dxf.table'.Read{dxf=dxf,DXF=DXF};
end
