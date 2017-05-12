_ENV = module(...,ap.adv)

local md_ = nil;

--------------------------------------------------------

function init()
	md_ = nil;
	require'sys.mgr.zip'.init();
	require'sys.mgr.db'.init();
end

function get()
	if not require'sys.Group'.Class:is_class(md_) then md_ = require'sys.Group'.Class:new() end
	md_:ask_id();
	-- require'sys.mgr.db'.push_item(md_);
	return md_;
end

function set(md)
	if not require'sys.Group'.Class:is_class(md) then return end
	md_ = md;
end

function trace()
	local md = get();
	require'sys.str'.totrace('model.mgrid = '..(md.mgrid or 'nil'));
	local ids = md:get_ids() or {};
	for k,v in pairs(ids) do
		require'sys.str'.totrace(k..' = '..v);
	end
end

--------------------------------------------------------

-- function ask_id()
	-- get():ask_id();
-- end

-- function set_id(str)
	-- get():set_id(str);
-- end

-- function get_id()
	-- return get():get_id();
-- end

-- function set_name(str)
	-- get():set_name(str);
-- end

-- function get_name() 
	-- return get():get_name();
-- end

--------------------------------------------------------

function push_item(it)
	it = require'sys.mgr.ifo'.new(it);
	local id = require'sys.mgr.db'.push_item(it);
	if id==get():get_id() then set(it) else get():add_id(id); end
	return id;
end

function add_item(it)
	require"sys.Item".Class.add(it);
	return push_item(it);
end

function del_item(it)
	require"sys.Item".Class.del(it);
	return push_item(it);
end

--------------------------------------------------------

function get_item(k,v)
	local it = require'sys.mgr.db'.get_item(k,v);
	if require'sys.Item'.Class:is_class(it) and k==it:get_id() then require'sys.mgr.db'.set_item(it); return it; end
	
	it = require'sys.mgr.zip'.get_item(v); 
	if require'sys.Item'.Class:is_class(it) and k==it:get_id() then require'sys.mgr.db'.set_item(it); return it; end
	
	-- it = require'sys.mgr.version'.get_item(k,v); 
	-- if require'sys.Item'.Class:is_class(it) and k==it:get_id() then require'sys.mgr.db'.set_item(it); return it; end
	
	return nil;
end

-- t={update=true,gid=,hid=,cbf=}
function download_item(t)
	require'sys.mgr.version'.download_item{
		update = t.update;
		gid = t.gid;
		hid = t.hid;
		cbf = function(hid)
			if type(t.cbf)=='function' then t.cbf(hid) end
		end
	};
end

-- ts={gid=,hid=},endf=
-- function download_items(ts,endf)
	-- local n = 0;
	-- n = require'sys.table'.count(ts);
	-- for k,v in pairs(ts) do
		-- get_item{gid=v.gid,hid=v.hid,cbf=function() n=n-1 if n<=0 and type(endf)=='function' then endf() end end}
	-- end
-- end

--------------------------------------------------------

function get_all()
	return get():get_ids();
end

function get_undeleted()
	local its = {};
	local all = get():get_ids();
	local run = require"sys.progress".create{title="Calculating ... ",count=require"sys.table".count(all),time=0.1,update=false};
	for k,v in pairs(all) do
		local it = require'sys.mgr'.get_item(k,v);
		if not require"sys.Item".Class.is_deleted(it) then 
			its[k] = it;
		end
		run();
	end
	return its;
end

function get_unsaved()
	local its = {};
	local all = get():get_ids();
	local run = require"sys.progress".create{title="Calculating ... ",count=require"sys.table".count(all),time=0.1,update=false};
	for k,v in pairs(all) do
		if not require"sys.mgr.db".is_item_saved(k) then 
			its[k] = v;
		end
		run();
	end
	return its;
end

--------------------------------------------------------

function open()
	local file = require'sys.mgr.zip'.get_file();
	if not file then return end
	local id = require'sys.zip'.read{zip=require'sys.mgr.zip'.get_file(),file=require'sys.mgr'.get_zip_model()..require'sys.mgr'.get_zip_index()..require'sys.mgr'.get_db_exname()};
	local md = require'sys.mgr.zip'.get_item(id);
	if require'sys.Group'.Class:is_class(md) then require'sys.mgr.model'.set(md) else get():set_id(id) end
end

function save()
	local file = require'sys.mgr.zip'.get_file();
	if not file then return end
	local ar = require'sys.zip'.open(file);
	if not ar then return end
	local md = require'sys.mgr.model'.get();
	md:ask_id();
	md:commit{};
	md:save{archive=ar};
	-- require'sys.zip'.add(ar,require'sys.mgr'.get_zip_model()..require'sys.mgr'.get_zip_index()..require'sys.mgr'.get_db_exname(),'string','return "'..require'sys.mgr'.get_model_id()..'"\n');
	require'sys.zip'.add(ar,require'sys.mgr'.get_zip_model()..require'sys.mgr'.get_zip_index()..require'sys.mgr'.get_db_exname(),'string','return "'..require'sys.mgr.version'.get_hid(require'sys.mgr'.get_model_id())..'"\n');
	require'sys.zip'.close(ar);
end

function commit()
	local md = require'sys.mgr.model'.get();
	md:ask_id();
	-- md:commit{};
	push_item(md);
end

function update()
	local gid = require'sys.mgr.model'.get():get_id();
	if not gid then return end;
	local hid = require'sys.mgr.version'.update_item(gid);
	if not hid then return end;
	local md = require'sys.io'.read_file{file=require'sys.mgr'.get_db_path()..hid..require'sys.mgr'.get_db_exname(),key=require"sys.mgr".get_db_key()};
	md = require'sys.mgr.ifo'.new(md);
	if not require'sys.Group'.Class:is_class(md) then return end
	md:ask_id();
	push_item(md);
end

-- arg=id/{id=,}
function upload(arg)
-- require'sys.table'.totrace{'mgr.model.upload()'}
	local id = type(arg)=='string' and arg or type(arg)=='table' and type(arg.id)=='string' and arg.id or nil;
	local it = id and require'sys.mgr.model'.get_item(id) or require'sys.mgr.model'.get();
-- require'sys.table'.totrace{'ask_id'}
	it:ask_id();
-- require'sys.table'.totrace{'commit'}
	it:commit{};
-- require'sys.table'.totrace{'upload'}
	it:upload{};
-- require'sys.table'.totrace{'upload start'}
end

-- t={gid=,hid=,open=true,update=true}
function download(t)
	local md = require'sys.mgr.model'.get();
	-- md:commit{};
	local gid = t.gid or md:get_id();
	local hid = t.hid;
	download_item{
		update = t.update;
		gid = gid;
		hid = hid;
		cbf = function(hid)
			if not hid then require'sys.cbf'.callf(t.cbf) return end
			local it = require'sys.io'.read_file{file=require'sys.mgr'.get_db_path()..hid..require'sys.mgr'.get_db_exname(),key=require"sys.mgr".get_db_key()}
			it = require'sys.mgr.ifo'.new(it);
			if require'sys.Group'.Class:is_class(it) then 
				if t.open then set(it) end
				it:download{update=t.update} 
			end
		end
	}
end


