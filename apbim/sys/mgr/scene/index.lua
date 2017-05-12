_ENV = module(...,ap.adv)

local oids_ = {};--{sc={[entid]=objid,...},...};
local eids_ = {};--{[objid]=entid,...};
local max_index_ = 0;


function init()
	max_index_ = 0;
	oids_ = {};
	eids_ = {};
end

function get_objid(eid,sc)
	sc = sc or require"sys.mgr".get_cur_scene();
	if not sc then return nil end
	oids_[sc] = oids_[sc] or {}; 
	if oids_[sc][eid] then return oids_[sc][eid] end
	max_index_ = max_index_ +1;
	local oid = max_index_;
	oids_[sc][eid] = oid;
	eids_[oid] = eid;
	return oid;
end

function get_mgrid(oid)
	return eids_[oid];
end
