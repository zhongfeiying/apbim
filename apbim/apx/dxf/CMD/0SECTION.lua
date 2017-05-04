_ENV = module(...,ap.adv)

function Read(dxf,Read_Line)
	local k,v = Read_Line();
	table.insert(dxf,{Code=k,Value=v});
	local sec = dxf[#dxf];
	-- dxf[v] = dxf[v] or {Code=k,Value=v};
	-- local sec = dxf[v];
	-- table.insert(sec,{Code=k,Value=v});
	local f = require'apx.dxf.Tools'.Get_SEC_Read_Functon(k..v);
	if f then 
		f(sec,Read_Line) 
	else 
		require'apx.dxf.CMD.SEC.__Default'.Read(sec,Read_Line) 
	end
	return true;
end
