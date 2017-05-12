_ENV = module(...,ap.adv)

function init()
end


function add(sc,id)
	if not sc then return end
	if type(id)~="string" then return end
	local vw = require"sys.mgr.scene".get_view(sc);
	if not require"sys.View".Class:is_class(vw) then return end
	vw:add_state(id);
end

function del(sc,id)
	if not sc then return end
	if type(id)~="string" then return end
	local vw = require"sys.mgr.scene".get_view(sc);
	if not require"sys.View".Class:is_class(vw) then return end
	vw:del_state(id);
end

function get_sc_id_ks(sc)
	if not sc then return {} end;
	local vw = require"sys.mgr.scene".get_view(sc);
	if not require"sys.View".Class:is_class(vw) then return {} end
	return vw.States;
end

function get_id_sc_ks(id)
	if type(id)~="string" then return {} end
	local vws = require"sys.mgr.scene".get_all();
	if type(vws)~="table" then return {} end
	local scs = {};
	for k,v in pairs(vws) do
		if type(v)=="table" and type(v.States)=="table" and v.States[id] then
			scs[k] = true;
		end
	end
	return scs;
end
