_ENV = module(...,ap.adv)

local sc2id_ = {};--{sc={id=true,...},...}
local id2sc_ = {};--{id={sc=true,...},...}

function init()
	sc2id_ = {};
	id2sc_ = {};
end



local function set_sc_id_table(sc,id)
	sc2id_[sc] = sc2id_[sc] or {};
	id2sc_[id] = id2sc_[id] or {};
end

------------------------------------

function get_sc_id_ks(sc)
	if not sc then return nil end;
	return sc2id_[sc];
end

function get_id_sc_ks(id)
	if not id then return nil end;
	return id2sc_[id];
end

function add(sc,id)
	set_sc_id_table(sc,id);
	sc2id_[sc][id] = true;
	id2sc_[id][sc] = true;
end

function del(sc,id)
	set_sc_id_table(sc,id);
	sc2id_[sc][id] = nil;
	id2sc_[id][sc] = nil;
end

-- function reset(ent)
	-- if type(ent)~="table" then trace_out("sys.mgr.draw.reset(ent,sc): ent isn't a table\n") return end
	-- local scs = get_id_sc_ks(ent.mgrid);
	-- if type(scs)~="table" then return end
	-- for k,v in pairs(scs) do
		-- set(ent,light,k);
	-- end
-- end

