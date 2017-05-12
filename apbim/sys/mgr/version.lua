_ENV = module(...,ap.adv)

local function get_name(id)
	return id..require'sys.mgr'.get_db_exname();
end

local function get_path()
	return require'sys.mgr'.get_db_path();
end

local function get_file(id)
	return get_path()..get_name(id);
end

local function get_key()
	return require'sys.mgr'.get_db_key();
end

function get_gids(gid)
	if not gid then return end
	local gids = require'sys.io'.read_file{file=get_file(gid);key=require'sys.mgr'.get_db_key()};
	-- if type(gids)~='table' then require'sys.net.file'.get{name=gid_file_name,path=gid_file_path}; return nil; end		-- must putkey before get
	if type(gids)~='table' then return nil; end
	local ary = require'sys.table'.sortk(gids);
	return gids,ary;
end

--(gid,hid)
function get_hid(gid,vid)
	if not gid then return end
	if require'sys.hid'.is(vid) then return vid end
	local gids,ary = get_gids(gid);
	if type(gids)~='table' then return nil; end
	vid = type(vid)=='number' and vid>0 and vid<=#ary and vid or #ary;
	return gids[ary[vid]];
end

function add_to_gids(gid,hid,time)
	if not gid then return end
	local gids,ary = get_gids(gid) or {},{};
	if gids[ary[#ary]] == hid then return end;
	time = time or os.time();
	gids[time] = hid;
	if type(gids)~='table' then return nil; end
	require'sys.table'.save{file=get_file(gid),src=gids};
	require'sys.net.temp'.del_record(get_name(gid));
end

--(hid)
--(nil,hid)
--(gid,hid)
--(gid,num)
function get_item(gid,vid)
	local hid = require'sys.hid'.is(gid) and gid or get_hid(gid,vid);
	if not hid then return nil; end
	local it = require'sys.io'.read_file{file=get_file(hid);key=require'sys.mgr'.get_db_key()};
	if type(it)~='table' then require'sys.net.file'.get{name=get_name(hid),path=get_path()}; return nil; end
	it = require'sys.mgr.ifo'.new(it);
	return it;
end

function push_item(it)
	local hid = get_hid(it:get_id());
	if it:is_committed() and hid and require'sys.io'.is_there_file(require'sys.mgr'.get_db_path()..hid..require'sys.mgr'.get_db_exname()) then return hid end
	it:set_committed();
	
	local temp = '.temp';
	local gid = it:get_id();
	local old_file =get_file(gid)..temp;
	if not require'sys.io'.is_there_file(old_file) then require'sys.table'.tofile{file=old_file,src=it,key=require'sys.mgr'.get_db_key()};end
	
	local hid = require'sys.hid'.get_by_file(old_file);
	local new_file = get_file(hid);
	if not require'sys.io'.is_there_file(new_file) then os.rename(old_file,new_file);end
	
	add_to_gids(gid,hid,it:get_time());
	return hid;
end

-- arg=gid/{id=}
function upload_item(arg)
	local gid = type(arg)=='string' and arg or type(arg)=='table' and type(arg.id)=='string' and arg.id or nil;
	if not gid then return end;
	if require'sys.net.temp'.is_record(get_name(gid)) then return end
	local gids = require'sys.io'.read_file{file=get_file(gid);key=require'sys.mgr'.get_db_key()};
	if type(gids)~='table' then return nil; end
	require'sys.net.file'.putkey{path=require'sys.mgr'.get_db_path(),name=gid..require'sys.mgr'.get_db_exname()};
	for k,v in pairs(gids) do
		require'sys.net.file'.send{path=require'sys.mgr'.get_db_path(),name=v..require'sys.mgr'.get_db_exname()};
	end
end

-- arg=gid/{id=}
function update_item(arg)
	local gid = type(arg)=='string' and arg or type(arg)=='table' and type(arg.id)=='string' and arg.id or nil;
	if not gid then return end;
	local gids,ary = get_gids(gid)
	if type(gids)~='table' then return; end
	local hid = gids[ary[#ary]];
	return hid;
end


-- t={update=,gid=,hid=,cbf=}
function download_item(t)
	local function result(hid)
		require'sys.cbf'.callf(t.cbf,hid);
	end
	
	local function download_hid(hid)
		hid = hid or t.hid or t.gid and get_hid(t.gid);
		if not hid then result();return; end
		require'sys.net.file'.get{
			name = get_name(hid);
			path = get_path();
			cbf = function() result(hid) end
		};
	end
	
	
	local function download_gid()
		if not t.gid then return; end
		
		local function get_load_ts()
			if not t.gid then return{},nil; end
			local gids,ary = get_gids(t.gid)
			if type(gids)~='table' then return; end
			local ts = {};
			for i,k in ipairs(ary) do
				ts[i] = {
					name = get_name(gids[k]), 
					path = get_path(), 
					typef = require'sys.net.file'.get
				};
			end
			local hid = gids[ary[#ary]];
			return ts,hid;
		end
		
		require'sys.net.file'.putkey{
			name = get_name(t.gid);
			path = get_path();
			cbf = function()
				require'sys.net.file'.get{
					name = get_name(t.gid);
					path = get_path();
					cbf = function()
						local ts,hid = get_load_ts();
						require'sys.net.file'.load_s(ts,function()require'sys.cbf'.callf(t.cbf,hid)	end);
					end
				};
			end
		};
	end
	
	if t.gid and t.update then download_gid() return end
	if t.hid then download_hid() return end
	local hid = get_hid(t.gid)
	if hid then download_hid(hid) return end
	download_gid();
end
	
