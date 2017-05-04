_ENV = module(...,ap.adv)

local iup_ = require"iuplua";

-- t={list=}
function clear(t)
	local list = t.list;
	local n = list.count;
	list[0] = nil;
	for i=0,n do
		list[i] = nil;
	end
end

-- t={list=,dat=,textf=,sortf=,linkf=}
function init(t)
	local list = t.list;
	local dat = t.dat;
	local textf = t.textf;
	local sortf = t.sortf;
	local linkf = t.linkf;
	clear(t)
	local link = {};
	if type(dat)~="table" then return end
	if type(textf)~="function" then return end
	local ary = type(sortf)=="function" and require"sys.table".sortv(dat, sortf) or require"sys.table".sortk(dat);
	if type(ary)~="table" then return end
	for i,k in ipairs(ary) do
		list[i] = tostring(textf(k,dat[k],dat));
		if type(linkf)=='function' then link[i]=linkf(k,dat[k],dat) end
	end
	return link;
end

-- t={list=,}
function get_selection_item(t)
	local list = t.list;
	return tonumber(list.value);
end


