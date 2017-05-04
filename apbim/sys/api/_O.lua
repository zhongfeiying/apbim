_ENV = module(...,ap.adv)

function table_key_type(t,f)
	local f = io.open(f,'w');
	local g = require"sys.table".sortk(t);
	for k,v in pairs(g) do
		f:write(tostring(v),' = ',type(t[v]),'\n');
	end
	f:close();
end