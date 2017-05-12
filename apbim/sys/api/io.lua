_ENV = module(...,ap.adv)

function is_there_file(str)
	local f = io.open(str,"r");
	if not f then return end;
	f:close();
	return true;
end

function get_filename_list(folder,recursion)
	local cmd = 'dir "'..folder..'" '..(recursion and '/s' or '')..' /b /a-d';
	local files, popen = {}, io.popen;
	for filename in popen(cmd):lines() do
		files[filename] = true
	end
	return files;
end

-- arg={file=,key=}
function read_file(arg)
	local file = type(arg)=='table' and arg.file or arg;
	local key = type(arg)=='table' and arg.key or nil;

	if not is_there_file(file) then return end
	local f = loadfile(file);
	if type(f)~="function" then return nil end
	local env = {};
	setfenv(f,env);
	local t = f();
	if key then t=env[key] end
	return t;
end

