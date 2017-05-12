_ENV = module(...,ap.adv)

local function split(str)
	local ss = {};
	local l = 1024;
	local n = string.len(str);
	local b,e=0,0;
	while e<n do
		b=e+1;
		e=e+l;
		table.insert(ss,string.sub(str,b,e));
	end
	return ss;
end

function totrace(str,newline)
	if not str then return end
	if type(str)~="string" then str=tostring(str) end
	local ss = split(str);
	for i,v in ipairs(ss) do
		trace_out(v);
	end
	if newline == false then return end
	trace_out('\n');
end

function tofile(str,file)
	if not str then return end
	if type(str)~="string" then str=tostring(str) end
	local ss = split(str);
	local f = io.open(file,"w");
	if not f then return end
	for i,v in ipairs(ss) do
		f:write(v);
	end
	f:close()
end

function tosend(str,ct)
	if not str then return end
	if type(str)~="string" then str=tostring(str) end
	local ss = split(str);
	for i,v in ipairs(ss) do
		hub_send(ct,v);
	end
end

-- arg={str=,key=}
function read_string(arg)
	if type(arg.str)~="string" then return end
	local f = loadstring(arg.str);
	if type(f)~="function" then return end
	local env = {};
	setfenv(f,env);
	local result = f();
	if arg.key then result = env[arg.key] end
	return result;
end

-- D:\\ABC\\t1.lua --> t1.lua
function get_filename(file)
	local name = string.match(file,".+[/\\](.+)")
	return name and name or file
end

-- D:\\ABC\\t1.lua --> lua
function get_exname(file)
	local name = string.match(file,".+[.](.+)")
	-- return name and name or file
	return name
end

-- D:\\ABC\\t1.lua --> t1
function get_prename(file)
	local filename = get_filename(file)
	local exname = get_exname(file)
	return string.sub(filename,1,string.len(exname)-2)
end

function get_pathname(path,name) 
	if string.sub(path,-1)=='\\' or string.sub(path,-1)=='/' then return path..name else return path end 
end


-- t={str=,key=}
function read(t)
	t = t or {};
	if not t.str then return nil end
	local env = {};
	local f = load(t.str,'sys.str.read()','bt',env);
	if type(f)~='function' then return nil end
	local result = f();
	if t.key then return env[t.key] else return result end
end

-- t={str=,key=}
function toifo(t)
	return require"sys.mgr.ifo".new(read(t));
end
