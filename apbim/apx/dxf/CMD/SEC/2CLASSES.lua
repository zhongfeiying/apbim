_ENV = module(...,ap.adv)

local Flag_ = 0;
local Begin_ = 'CLASS'

function Read(sec,Read_Line)
	while true do
		local k,v = Read_Line();
		if require"apx.dxf.Tools".Is_Sec_End(k,v) then break end
		if k==Flag_ and v==Begin_ then 
			local k,v = Read_Line();
			table.insert(sec,{Code=k,Value=v}) 
			table.insert(sec[#sec],{Code=k,Value=v});
		else
			if #sec==0 then sec[1]={}end
			table.insert(sec[#sec],{Code=k,Value=v});
		end
	end
end
