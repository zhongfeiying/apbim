_ENV = module(...,ap.adv)

function callf(f,arg)
	if type(f)=='function' then f(arg) end
end
