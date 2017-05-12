_ENV = module(...,ap.adv)

local db_ = {};

function init()
	db_ = {};
end

function set_item(it)
	db_[it:get_id()] = it;
	-- if it:is_deleted() then set_item_deleted(id) else set_item_undeleted(id) end
end

function get_item(k,v)
	local it = v;
	if require'sys.Item'.Class:is_class(it) and k==it:get_id() then return it; end
	it = db_[k];
	if require'sys.Item'.Class:is_class(it) and k==it:get_id() then return it; end
	
	-- it = require'sys.mgr.zip'.get_item(v); 
	-- if require'sys.Item'.Class:is_class(it) and k==it:get_id() then set_item(it); return it; end
	
	-- it = require'sys.mgr.version'.get_item(k,v); 
	-- if require'sys.Item'.Class:is_class(it) and k==it:get_id() then set_item(it); return it; end
	return nil;
end

function push_item(it)
	if not require'sys.Item'.Class:is_class(it) then trace_out("sys.mgr.db.push_item(it), it isn't a item(sys.Item class or subclass object).") return end
	it:ask_id();
	it:ask_time();
	-- local old = get(it:get_id());
	local old = db_[it:get_id()];
	if old and it:get_time() < old:get_time() then return old:get_id(); end
	set_item(it);
	require'sys.mgr.version'.push_item(it);
	return it:get_id();
end

