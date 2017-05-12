_ENV = module(...,ap.adv)

local config_file_name_ = "login/login.cfg";
local user_ = nil;

local function create_config()
	io.open(config_file_name_,"a"):close();
end

function set_statusbar(arg)
	arg = arg or user_;
	statusbar_set_text(frm,3,arg.name)
end

--arg={name=,pass=}
function write_config(arg)
	arg = arg or user_;
	io.output(config_file_name_);
	io.write("username = [["..arg.name.."]]\n");
	io.write("password = [["..arg.pass.."]]\n");
	io.close();
end

function read_config()
	create_config();
	dofile(config_file_name_);
	return {name=username,pass=password};
end

--arg={name=,pass=}
function set(arg)
	user_ = arg;
	trace_out("user = "..tostring(arg.name).."\n");
	-- require"function_all".cmd_download_interface_file();
	return true;
end

function get()
	return user_ or {name="",pass=""};
end

function login_test(arg)
	arg = arg or user_;
	return require"netex".login_test(arg);
end




