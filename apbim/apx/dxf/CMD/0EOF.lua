_ENV = module(...,ap.adv)

function Read(dxf,Read_Line)
	table.insert(dxf,{Code=0,Value="EOF"});
	-- dxf["EOF"] = dxf["EOF"] or {Code=0,Value="EOF"};
	return true;
end
