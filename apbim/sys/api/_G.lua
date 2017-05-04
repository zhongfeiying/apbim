
local f = io.open('../_G.lua','w');
local g = require"sys.table".sortk(_G);
for k,v in pairs(g) do
	f:write(tostring(v),' = ',type(_G[v]),'\n');
end
f:close();
