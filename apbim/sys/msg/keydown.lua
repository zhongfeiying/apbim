_ENV = module(...,ap.adv)

-- Esc
-- _M[require"sys.api.ascii".Esc()] = require"sys.load".init;
-- Del
-- shortcutkey[require"sys.api.ascii".Del()] = require"function".edit_delete;
-- Ctrl + A
-- shortcutkey[string.byte('A')] = function() if not is_ctr_down() then return end require"function".select_all() end;
-- Ctrl + I
-- shortcutkey[string.byte('I')] = function() if not is_ctr_down() then return end require"function".zoomin() end;
-- Ctrl + O
-- shortcutkey[string.byte('O')] = function() if not is_ctr_down() then return end require"function".zoomout() end;

local keys_ = {};

function Alt()
	return "is_alt_down";
end

function Ctrl()
	return "is_ctr_down";
end

function Shift()
	return "is_shf_down";
end

-- t={Alt(),Ctrl(),Shift(),key=,f=}
function set(t)
	if type(t)~="table" then trace_out("keydown.set(t), t isn't a table") return end
	if type(t.key)~="number" then trace_out("keydown.set(t), t.key isn't a number") return end
	if type(t.f)~="function" then trace_out("keydown.set(t), t.f isn't a function") return end
	keys_[t.key] = t;
end


local function call_gfunction(name)
	if type(_G[name])~="function" then return end
	return _G[name]();
end

function call(sc,key)
	if not keys_[key] then return end
	local t = keys_[key];
	for i,v in ipairs(t) do
		if not call_gfunction(v) then return end
	end
	t.f(sc);
end

