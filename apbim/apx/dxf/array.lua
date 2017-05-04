_ENV = module(...,ap.adv)

-- arg=dxf_file
function Read(arg)
	local f_ = io.open(arg,'r')
	if not f_ then return end
	local dxf_ = {};
	
	local run,close = require"sys.progress".create{title="DXF",time=0.1,statusbar=false};
	local function Read_Line()
		local code = tonumber(f_:read());
		local value = f_:read();
		run()
		return code,value;
	end
	
	while true do
		local k,v = Read_Line();
		if not k and not v then break end
		if not k or not v then table.insert(dxf_,{Code=k,Value=v})break end
		local f = require'apx.dxf.Tools'.Get_CMD_Read_Functon(k..v);
		if f then 
			f(dxf_,Read_Line)
		else
			table.insert(dxf_,{Code=k,Value=v});
		end
	end
	close()
	
	f_:close()
	return dxf_ 
end

