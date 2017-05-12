

_ENV = module(...,ap.adv)

local get_file = require'sys.net.main'.get_file;
local send_file = require'sys.net.main'.send_file;
local putkey_file = require'sys.net.main'.putkey_file;

local way_function_ = {send=send_file,putkey=putkey_file,get=get_file};
function get_function(way)return way_function_[way] or function() end end

local PATH_DEFAULT_ = "DB/";
local way_name_path_ = {send={},putkey={},get={}};--{send={name=path};putkey={name=path};get={name=path};}
function set_path(way,name,path) way_name_path_[way][name] = path end
function get_path(way,name) return way_name_path_[way][name] or PATH_DEFAULT_ end
function get_path_name(way,name) if string.sub(get_path(way,name),-1)=='\\' or string.sub(get_path(way,name),-1)=='/' then return get_path(way,name)..name else return get_path(way,name) end end

local way_name_path_cbf_ = {};
local function WAY_NAME_PATH_FUNCTION_(way,name,path)
	-- trace_out(require'sys.net.queue'.way_name_path_str(way,name,path)..", there isn't function\n")
end
function set_cbf(way,name,path,cbf) way_name_path_cbf_[require'sys.net.queue'.way_name_path_str(way,name,path)] = cbf  end
function get_cbf(way,name,path) return way_name_path_cbf_[require'sys.net.queue'.way_name_path_str(way,name,path)] or function() WAY_NAME_PATH_FUNCTION_(way,name,path) end end


local running_ = nil;

local function is_run()
	return running_
end

local function begin_run()
	running_=true
end

local function end_run()
	running_ = nil
end


function breakdown()
	end_run()
	start();
end

function start()
	if is_run() then return end
	begin_run();
	-- if type(require'sys.net.main')~='table' then 
		-- _G.package.loaded["sys.net.main"] = nil;
		-- get_file = require'sys.net.main'.get_file;
		-- send_file = require'sys.net.main'.send_file;
		-- putkey_file = require'sys.net.main'.putkey_file;
	-- end
	run();
end

--[[
local running_ = nil;

local function run()
	-- if not running_ then return end
	local way,name,path = require"sys.net.queue".pop();
	if not way then running_ = nil return end
	get_function(way)(name,path);
end

-- function breakdown()
	-- running_ = nil;
-- end

function start()
	if running_ then return else running_ = true end
	run();
end
--]]

-- local endof_ = {
	-- pos = "__temp"
	-- flag = ".ed"
	-- putkey = function(name)
		
	-- end
-- };

function run()
	-- if not running_ then return end
	local way,name,path = require"sys.net.queue".get();
-- require"sys.table".totrace{f="run()",way=way,name=name,path=path,cbf=type(get_cbf(way,name,path))};
	if not way then end_run() return end
	get_function(way)(name,path);
end


function endof(way,name)
	local path = get_path(way,name);
-- require"sys.table".totrace{f="endof()",way=way,name=name,path=path,cbf=tostring(get_cbf(way,name,path))};
-- require'sys.statusbar'.show_text('Finish');
	require'sys.net.temp'.add_record(name)
	get_cbf(way,name,path){name=name,path=path,way=way};
	local way,name,path = require"sys.net.queue".pop();
	require'sys.net.queue'.show_progress{way=way,name=name,path=path};
	run();
end

-- function endof_putkey(name)
	-- endof("putkey",name)
-- end

-- function endof_send(name)
	-- endof("send",name)
-- end

-- function endof_get(name)
	-- endof("get",name)
-- end

-- t={name=,path=}
function need_putkey(t)
	if not require'sys.io'.is_there_file{file=require'sys.str'.get_pathname(t.path,t.name)} then return false; end
	return true;
end
-- t={name=,path=,cbf=}
function putkey(t)
-- require"sys.table".totrace{f="putkey()",name=t.name,path=t.path,cbf=tostring(t.cbf)};
	if not need_putkey(t) then require'sys.type'.call_function(t.cbf,t.name) return end
	require"sys.net.queue".push("putkey",t.name,t.path);
	set_cbf("putkey",t.name,t.path,t.cbf);
	start();
end

-- t={name=,path=}
function need_send(t)
	if not require'sys.io'.is_there_file{file=require'sys.str'.get_pathname(t.path,t.name)} or require'sys.hid'.is_hid_file(t.name) and require'sys.net.temp'.is_record(t.name) then return false; end
	return true;
end
-- t={name=,path=,cbf=}
function send(t)
-- require"sys.table".totrace{f="send()",name=t.name,path=t.path,cbf=tostring(t.cbf)};
	if not need_send(t) then require'sys.type'.call_function(t.cbf,t.name) return end
	require"sys.net.queue".push("send",t.name,t.path);
	set_cbf("send",t.name,t.path,t.cbf);
	start();
end

-- t={name=,path=}
function need_get(t)
	if require'sys.io'.is_there_file{file=require'sys.str'.get_pathname(t.path,t.name)} and require'sys.hid'.is_hid_file(t.name) and require'sys.net.temp'.is_record(t.name) then return false; end
	return true;
end
-- t={name=,path=,cbf=}
function get(t)
-- require"sys.table".totrace{f="get()",name=t.name,path=t.path,cbf=tostring(t.cbf)};
	if not need_get(t) then require'sys.type'.call_function(t.cbf,t.name) return end
	require"sys.net.queue".push("get",t.name,t.path);
	set_cbf("get",t.name,t.path,t.cbf);
	start();
end

-- ts={{name=,path=},...}
function putkey_s(ts,endf)
	local n = 0;
	n = require'sys.table'.count(ts);
	for k,v in pairs(ts) do
		putkey{name=v.name,path=v.path,cbf=function() n=n-1 if n<=0 and type(endf)=='function' then endf() end end}
	end
end

-- ts={{name=,path=},...}
function send_s(ts,endf)
	local n = 0;
	n = require'sys.table'.count(ts);
	for k,v in pairs(ts) do
		send{name=v.name,path=v.path,cbf=function() n=n-1 if n<=0 and type(endf)=='function' then endf() end end}
	end
end

-- ts={{name=,path=},...}
function get_s(ts,endf)
	local n = 0;
	n = require'sys.table'.count(ts);
	for k,v in pairs(ts) do
		get{name=v.name,path=v.path,cbf=function() n=n-1 if n<=0 and type(endf)=='function' then endf() end end}
	end
end

-- ts={{name=,path=,typef=},...}
function load_s(ts,endf)
	local n = 0;
	n = require'sys.table'.count(ts);
	for k,v in pairs(ts) do
		v.typef{name=v.name,path=v.path,cbf=function() n=n-1 if n<=0 and type(endf)=='function' then endf() end end}
	end
end

