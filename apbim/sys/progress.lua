_ENV = module(...,ap.adv)



--arg={title="Progress",text=true,count=0,time=1};
function create(arg)
	return require"sys.api.progress".create(arg);
end


----Sample-------------------------------------------------------------
--[[

local show = require"sys.progress".create{title="Progress",count=10000,time=1};
for i=1,10000 do
	...
	show();
end

--]]



