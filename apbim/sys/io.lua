_ENV = module(...,ap.adv)

-- t={src=,dst=}
function copy_file(t)
require"sys.table".totrace{t};
	local r = io.open(t.src,'r');
	if not r then return end
	local w = io.open(t.dst,'w');
	if not w then return end
	w:write(r:read("*all"));
	r:close();
	w:close();
end

-- t={src=,dst=}
function copy_file_name(t)
	local r = io.open(t.src,'r');
	if not r then return end
	local w = io.open(t.dst,'w');
	if not w then return end
	w:write(r:read("*all"));
	r:close();
	w:close();
end

-- t={file=}
function get_file_str(t)
	local f = io.open(t.file,"r");
	if not f then return end;
	local str = f:read("*all")
	f:close();
	return str;
end


-- t={file=}
function is_there_file(t)
	local file = type(t)=='string' and t or type(t)=='table' and type(t.file)=='string' and t.file;
	if not file then return end;
	local f = io.open(file,"r");
	if not f then return end;
	f:close();
	return true;
end

-- t={file=""}/""
function get_length(t)
	local file = type(t)=='string' and t or type(t)=='table' and type(t.file)=='string' and t.file;
	if not file then return end;
	local f = io.open(file,"r");
	if not f then return end;
	local len = f:seek('end');
	f:close();
	return len;
end

-- t={file=}
function is_there_module(t)
	if require"sys.api.dir".is_there_file(t.file) and type(require(t.file))=="table" then return true end
end

-- t={file=,functionname}
function is_there_function(t)
	if require"sys.api.dir".is_there_file(t.file) and type(require(t.file))=="table" and type(require(t.file)[t.functionname])=="function" then return true end
end

-- t={file=}
function readfile(t)
	local f = loadfile(t.file);
	if type(f)~="function" then --[[trace_out("io.readfile("..t.file.."), it isn't a valid file\n")--]] return end;
	return f();
end

-- arg={file=,key=}
function read_file(arg)
	if not is_there_file{file=arg.file} then return end
	local f = loadfile(arg.file);
	if type(f)~="function" then trace_out("io.read_file(arg), arg.file = "..arg.file.." isn't a function.\n") return end
	local env = {};
	-- setfenv(f,env);
	-- f._ENV = env;
	local result = f();
	if arg.key then return env[arg.key] end
	return result;
end

-- arg={file=,key=}
function read_file(arg)
	if not is_there_file{file=arg.file} then return end
	local f = io.open(arg.file,'r')
	if not f then return end
	local str = f:read('*all');
	f:close();
	local env = {};
	local f = load(str,'io_read_file','bt',env);
	if type(f)~="function" then trace_out("io.read_file(arg), arg.file = "..arg.file.." isn't a function.\n") return end
	-- setfenv(f,env);
	local result = f();
	if arg.key then return env[arg.key] end
	return result;
end


function get_filename_list(folder,recursion)
	return require"sys.api.io".get_filename_list(folder,recursion);
end

function clear_file(arg)
	local f = io.open(arg.file,'w');
	if f then f:close() end;
end