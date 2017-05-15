_ENV = module(...,ap.adv)  
local iup = require "iuplua"
function list_dropdown(arg)
	arg= arg or {dropdown = "YES",expand = "HORIZONTAL",}
	arg.dropdown = arg.dropdown or "YES"
	return iup.list(arg)
end

function list(arg)
	arg = arg or {expand = "YES",}
	return iup.list(arg)
end