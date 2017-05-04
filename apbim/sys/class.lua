_ENV = module(...,ap.adv)

function is(T,t)
	if type(T)~="table" then return false end
	if type(t)~="table" then return false end
	repeat
		t = getmetatable(t);
		if t==T then return true end
	until not t;
	return false;
end

function met(T,t)
	if type(T)~="table" then return t end
	if type(t)~="table" then return t end
	if getmetatable(t)==T then return t end
	setmetatable(t,T);
	T.__index = T;
	return t;
end

function new(T,t)
	t = t or {};
	met(T,t);
	return t;
end

