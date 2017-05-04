_ENV = module(...,ap.adv)


local db_ = {
};--{[1],[2],...}
local temp_ = nil

function way_name_path_str(way,name,path)
	local str = (way or "").."|"..(name or "").."|"..(path or "");
	return str;
end

function push(way,name,path)
	db_[#db_+1] = {way,name,path};
	add_progress();
end

function pop()
	local n = #db_;
	if n<=0 then return nil end
	local str = db_[n]
	db_[n] = nil;
	local way,name,path = str[1],str[2],str[3];
	return way,name,path;
end

function get()
	if temp_ then return temp_[1],temp_[2],temp_[3] end
	local n = #db_;
	if n<=0 then return nil end
	local str = db_[n]
	db_[n] = nil;
	temp_ = str; ------------------------------------
	local way,name,path = str[1],str[2],str[3];
	return way,name,path;
end

function pop()
	temp_ = nil;
end

function trace()
	require"sys.table".totrace(db_);
end

function show_progress(t)
	t = t or {}
	local title = t.way and 'Loading('..t.way..') ... ' or 'Loading ... ';
	require'sys.net.progress'.show{title=title,n=#db_}
end

function add_progress()
	require'sys.net.progress'.add{title="Calculating ... ",n=#db_}
end

-- t={file=,size=}
function set_size_progress(t)
	require'sys.net.progress'.set_size(t)
end

