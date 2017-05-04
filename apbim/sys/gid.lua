_ENV = module(...,ap.adv)

local flag_ = '_apcad_apgid'
local sample_ = '23oAwzKcX2E8EwNly6AxZU'


function is(str)
	if type(str)~='string' then return false end
	local pos = string.len(sample_);
	local begin = pos+1;
	local last = pos+string.len(flag_);
	local sub = string.sub(str,begin,last)
	return sub==flag_;
end

function get()
	return require"luaext".guid()..flag_;
end

