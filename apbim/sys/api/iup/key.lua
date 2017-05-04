_ENV = module(...,ap.adv)

local iup_ = require"iuplua";

----------------------------------------------------------------------------------

-- t={dlg=,cbfs={[iup.K_CR]=function},...}
function register_k_any(t)
	function t.dlg:k_any(n)
		if t[n] then t[n](t.arg) end
	end
end

