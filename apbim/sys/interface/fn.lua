_ENV = module(...,ap.adv)

local fns_ = {};

function init()
	fns_ = {};
end

--[[
t={
	appname = "";
	fname = "";
	f = ;
};
--]]
function set(t)
	if type(t.name)~="table" then return end
	fns_[t.name] = t.f;
end

function get()
	return fns_;
end

