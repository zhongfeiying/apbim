_ENV = module(...,ap.adv)

function Read(sec,Read_Line)
	while true do
		local k,v = Read_Line();
		if require"apx.dxf.Tools".Is_Sec_End(k,v) then break end
		table.insert(sec,{Code=k,Value=v}) 
	end
end
