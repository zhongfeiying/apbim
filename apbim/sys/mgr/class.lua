_ENV = module(...,ap.adv)

function get_all(T)
	local all = require"sys.mgr".get_all();
	if type(all)~="table" then return end
	local ts = {};
	for k,v in pairs(all) do
		if T:is(v) then ts[k]=v end
	end
	return ts;
end
