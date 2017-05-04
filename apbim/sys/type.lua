_ENV = module(...,ap.adv)

function call_function(f,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10)
	if type(f)=='function' then f(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10) end
end
