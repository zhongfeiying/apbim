_ENV = module(...,ap.adv)

local Flag_ = 0;

function Read(sec,Read_Line)
	while true do
		local k,v = Read_Line();
		if require"apx.dxf.Tools".Is_Sec_End(k,v) then break end
		if k==Flag_ then 
			table.insert(sec,{Code=k,Value=v}) 
		end
		if #sec==0 then sec[1]={}end
		table.insert(sec[#sec],{Code=k,Value=v});
	end
end
