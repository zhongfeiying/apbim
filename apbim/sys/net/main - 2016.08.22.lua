require"sys.net.comma"

local cs = {}
local cmds = {}

local TRANS_SIZE = 64*1024;

--hub_start("192.168.5.224",8000,10,30) --ip port max_accept max_accept_seconds

-- hub_start("10.105.46.193",8000,10,60)

-- get\r\nfile\r\nstart\r\nlength\r\n
-- put\r\nfile\r\nstart\r\nlength\r\n......\r\n
-- trans\r\nfile\r\nstart\r\nlength\r\n......\r\n
-- putkey\r\nid\r\nvalue\r\n
-- putkey\r\nid\r\nvalue\r\ngid\r\n
-- endof\r\nfile\r\n
-- filesize\r\nfile\r\ngid\r\n

-- sendmsg\r\ntouser\r\nmsg\r\n
-- subscribe\r\nchannelid\r\n
-- sendchannel\r\ntchannelid\r\nmsg\r\n
-- rcvchannel\r\nfrom\r\ntchannelid\r\nmsg\r\ntime\r\n
-- subscribe 是订阅通道信息
-- sendchannel 是向某个通道发送消息
-- rcvchannel 是收到通道信息的格式

--[[
do
local str = 'putkey\r\ngexiangying\r\ndb=db or {}\ndb["name"]="gexiangying"\ndb["age"]=44\nreturn 12\r\rn123\r\n'
local s = string.len(str).."\r\n"..str
hub_send(ct,s)
end
--]]


--[[
function cmds.login(content,line)
	local user,pass = string.match(line,"([^\r\n]*)\r\n([^\r\n]*)\r\n")
	local usr = {} 
	local func = loadfile("passwd")
	if(func) then
		setfenv(func,usr)
		func()
	end
	local str = "login\r\n"
	if user and pass and usr[user] and usr[user].pass and pass == usr[user].pass and usr[user].gid then
		str = str .. usr[user].gid .. "\r\n"	
	else
		str = str .. "-1\r\n"
	end
	local prefix = string.len(str) .. "\r\n" .. str
	hub_send(content,prefix)
end

function cmds.passwd(content,line)
	local user,pass,newpass = string.match(line,"([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)\r\n")
	local usr = {} 
	local func = loadfile("passwd")
	if(func) then
		setfenv(func,usr)
		func()
	end
	local str = "passwd\r\n"		
	if user and usr[user] and usr[user].pass == pass then
		usr[user].pass = newpass
		str = str .. "ok\r\n"
		comma.save_file("passwd",usr)
	else
		str = str .. "error\r\n"
	end
	local prefix = string.len(str) .. "\r\n" .. str
	hub_send(content,prefix)
end

function cmds.reg(content,line)
	local user,pass,gid,mail,phone = string.match(line,"([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)\r\n")
	local usr = {} 
	local func = loadfile("passwd")
	if(func) then
		setfenv(func,usr)
		func()
	end
	local str = "reg\r\n"
	if user and usr[user] then
		str = str .. "error\r\n"	
	elseif user then
		usr[user] = {}
		usr[user].name = user
		usr[user].pass = pass
		usr[user].gid = gid
		usr[user].mail = mail
		usr[user].phone = phone
		comma.save_file("passwd" ,usr)	
		str = str .. "ok\r\n"
	end
	local prefix = string.len(str) .. "\r\n" .. str
	hub_send(content,prefix)
end
--]]

function process_cmd_imp(content,line)
	local fun,l = string.match(line,"([^\r\n]-)\r\n(.*)")
	if fun and l  and cmds[fun] then
		cmds[fun](content,l)
	else
		-- local sock = get_socket(content)
		-- close_socket(sock)
		local ip,port = hub_addr(content)
		trace_out("unkown command :" .. fun .. "@" .. ip .. ":" .. port .. "\n");
	end
end

function process_data(content,line)
	--trace_out(string.sub(line,1,30) .. "\n")
	local len,l = string.match(line,"^(%d+)\r\n(.*)")
	--trace_out("len = " .. len .. "l.len=" .. string.len(l) .."\n")
	
	local num = 0

  if len then num = tonumber(len)
  end

	if len and l and num < string.len(l) then
      local str = string.sub(l,1,num)
			local left = string.sub(l,num +1)
			cs[content] = left
      process_cmd_imp(content,str)
			-- trace_out(num .. "::" .. string.len(l) .. "   left\n")
      return false,left
	elseif len and l and num == string.len(l) then
      process_cmd_imp(content,l)
			cs[content] = true
			-- trace_out(num .. "=\n")
			return true
  elseif len and l and num > string.len(l) then
			cs[content] = line
			-- trace_out(num .. "need more\n")
			return true
  elseif len and tonumber(len) > 8*1024 then
			-- trace_out("max data\n")
			local sock = get_socket(content)
			close_socket(sock)
			return true
  elseif string.len(line) > 10 then
			-- trace_out("no len \n")
			local sock = get_socket(content)
			close_socket(sock)
			return true
  end
	return true
end

--local total_num = 0
function process_cmd(content,line)
--total_num = total_num + string.len(line)
--trace_out("recv len = " .. total_num .. "\n")
  local str 
  if type(cs[content]) == "boolean" then
		str = line
	elseif type(cs[content]) == "string" then
		str = cs[content] ..line
	end
	
  local result = false
  local s = str
	local s1
  repeat 
	  result,s1 = process_data(content,s)	
		s = s1
  until result == true
end

function on_hubquit(content)
-- require'sys.str'.totrace("on_hubquit()\n");
require'sys.str'.totrace('on_hubquit(content:'..tostring(content)..')\n');
	if cs[content] then  --houjia
		cs[content] = nil 

		local sock = get_socket(content)
		close_socket(sock)
	end  --houjia
	require"sys.net.file".breakdown();
end

function on_hubmsg(content,str)
-- trace_out("on_hubmsg()\n");
-- require"sys.str".totrace("on_hubmsg:\n"..str.."\n");
	cs[content] = true
	process_cmd(content,str)
end

-------------------------------------------------------------------------------------

function cmds.get(content,line)
-- trace_out("cmds.get()\n");

	file,start_str,len_str = string.match(line,"([^\r\n]*)\r\n(%d+)\r\n(%d+)\r\n")

	if start_str then
		start = tonumber(start_str)
	 end

	if len_str then
		len = tonumber(len_str)
	  end

	if file and start and len and len >0 then
		-- local dir = string.sub(file,1,2)
		-- mkdir(dir)
		local dir = require"sys.net.file".get_path("send",file);
		local path_name = require"sys.net.file".get_path_name("send",file);
		local f = create_file(path_name,"r")
		--local f = create_file(file,"r")
		local fs = getfilesize(f)
		if start < fs then
			lock_file(f,len,0,start,0)
			local str = read_file(f,len,start,0)
			unlock_file(f,len,0,start,0)
			close_file(f)
			local data = "put\r\n" .. file .. "\r\n" .. start .. "\r\n" .. len .. "\r\n" .. str .. "\r\n"
			local	prefix = string.len(data) .. "\r\n" .. data 
			-- hub_send(content,prefix)
		else
			close_file(f)
		end
	elseif file and start and len and len == 0 then
		-- local dir = string.sub(file,1,2)
		-- mkdir(dir)
		local dir = require"sys.net.file".get_path("send",file);
		local path_name = require"sys.net.file".get_path_name("send",file);
		local f = create_file(path_name,"r")
		local fs = getfilesize(f)
		if start < fs then
			local c_len = TRANS_SIZE
			lock_file(f,c_len,0,start,0)
			local str = read_file(f,c_len,start,0)
			unlock_file(f,c_len,0,startt,0)
			local s = "trans\r\n" .. file .. "\r\n" .. start .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
			local prefix = string.len(s) .. "\r\n" .. s
			hub_send(content,prefix)
			close_file(f)
		else
			close_file(f)
			require"sys.net.file".endof("send",file);
			-- require"sys.net.queue".pop_cb(file);
			-- require"sys.net.file".get_cbf(file)(file);
		end

		-- close_file(f)
	else
		local sock = get_socket(content)
		close_socket(sock)
	end
	require'sys.net.queue'.set_size_progress{file=file,size=start+len};
-- require"sys.table".totrace{f="get2",file=file,start=start,len=len};
end

function cmds.endof(content,line)
-- trace_out("cmds.endof()\n");

	file = string.match(line,"([^\r\n]*)\r\n")
	if file then 
	local old_file = require"sys.net.temp".get_temp_path()..file;
	local new_file = require"sys.net.file".get_path_name("get",file);
		os.remove(new_file);
		os.rename(old_file,new_file);
		require"sys.net.file".endof("get",file);
		-- trace_out("endof file : " .. file .. "\n")
		-- require"sys.net.queue".pop_cb(file);
		-- require"sys.net.file".get_cbf(file)(file);
	end
end 

function cmds.result(content,line)
-- trace_out("cmds.result()\n");
	local gid,result = string.match(line,"(.*)\r\n(.*)\r\n")
-- require"sys.table".totrace{gid=gid,result=result};
	if result and gid then
		-- trace_out("result = " .. result .. "::gid = " .. gid .. "\n")
		require"sys.net.file".endof("putkey",gid);
	end
end

function cmds.trans(content,line)
-- trace_out("cmds.trans()\n");
	local file,start_str,len_str,str = string.match(line,"([^\r\n]*)\r\n(%d+)\r\n(%d+)\r\n(.*)")

	local start,len,s

	if start_str then
		start = tonumber(start_str)
	end

	if len_str and str then
		len = tonumber(len_str)
		s = string.sub(str,1,len)
	end

	if file and start and len and str then
		-- trace_out("trans  " .. file .. "::" .. start .. "::" .. len .. "\n")

		-- local dir = string.sub(file,1,2)
		-- mkdir(dir)
		local dir = require"sys.net.file".get_path("get",file);
		-- local path_name = require"sys.net.file".get_path_name("get",file);
		local path_name = require"sys.net.temp".get_temp_path()..file;
		-- trace_out(dir .. file.."\n")
		local f = create_file(path_name,"w")
		--local f = create_file(file,"w")
		lock_file(f,len,0,start,0)
		write_file(f,s,start,0)
		unlock_file(f,len,0,start,0)
		close_file(f)
		local nextstr = "get\r\n" ..file .. "\r\n" .. start + len .. "\r\n" .. 0 .. "\r\n"
		local nextget = string.len(nextstr) .. "\r\n" .. nextstr
		hub_send(content,nextget) 
	else
 		local sock = get_socket(content)
		close_socket(sock)
	end
	require'sys.net.queue'.set_size_progress{file=file,size=start+len};
-- require"sys.table".totrace{f="trans",file=file,start=start,len=len};
end


function cmds.put(content,line)
trace_out("cmds.put()\n");
	 
	local file,start_str,len_str,str = string.match(line,"([^\r\n]*)\r\n(%d+)\r\n(%d+)\r\n(.*)")

	local start,len,s

	if start_str then
		start = tonumber(start_str)
	end

	if len_str and str then
		len = tonumber(len_str)
		s = string.sub(str,1,len)
	end

	if file and start and len and str then
		-- trace_out(file .. "::" .. start .. "::" .. len .. "\n")

		-- local dir = string.sub(file,1,2)
		-- mkdir(dir)
		local dir = require"sys.net.file".get_path(file);
		local f = create_file(dir .. file,"w")
		--local f = create_file(file,"w")
		lock_file(f,len,0,start,0)
		write_file(f,s,start,0)
		unlock_file(f,len,0,start,0)
		close_file(f)
	else
 		local sock = get_socket(content)
		close_socket(sock)
	end
end


function cmds.putkey(content,line)
trace_out("cmds.putkey()\n");

	id,value = string.match(line,"(.*)\r\n(.*)\r\n")
	if id  and value then
		-- local dir = string.sub(id,1,2)
		-- mkdir(dir)
		local dir = require"sys.net.file".get_path("putkey",id);
		--trace_out("dir:" ..dir .. "\n")
		local info = {}
		do
			local func = loadfile(dir .. "\\" .. id)		
			if(func) then
				setfenv(func,info)
				func()
			end
			func = loadstring(value)
			if(func) then
				setfenv(func,info)
				func()
			end
		end

		comma.save_file(dir .. "\\" .. id,info)	
	else
		local sock = get_socket(content)
		close_socket(sock)
	end
end

-----------------------------------------------------------

function cmds.login(content,line)
	-- trace_out("line = " .. line .. "\n")
	local msg = string.match(line,"([^\r\n]*)\r\n")
	-- trace_out("login:" .. msg .. "\r\n")
	require'sys.net.user'.endof_login(msg)
	-- on_hubquit(content)
end

function cmds.reg(content,line)
	local msg = string.match(line,"([^\r\n]*)\r\n")
	-- trace_out("reg:" .. msg .. "\r\n")
	require'sys.net.user'.endof_reg(msg)
	-- on_hubquit(content)
end

function cmds.passwd(content,line)
	local msg = string.match(line,"([^\r\n]*)\r\n")
	trace_out("passwd:" .. msg .. "\r\n")
	require'sys.net.user'.endof_passwd(msg)
	-- on_hubquit(content)
end

-----------------------------------------------------------

function cmds.rcvmsg(content,line)
-- trace_out("cmds.rcvmsg()\n");
-- require"sys.str".totrace("cmds_rcvmsg:\n"..line.."\n");
	local from,msg,time = string.match(line,"([^\r\n]*)\r\n(.*)\r\n([^\r\n]*)\r\n")
	if from and msg and time then
		local rcvtime = os.date("%x %X",tonumber(time))
		-- trace_out(from .. ':"' .. msg .. '"' .. "  @" .. rcvtime .. "\n")
		-- require"sys.str".totrace("cmds_rcvmsg:\n"..msg.."\n");
		require'sys.net.msg'.rcv_msg{Code=msg,From=from}
	end
end

function cmds.rcvchannel(content,line)
-- require"sys.str".totrace("cmds_rcvchannel:\n"..line.."\n");
	local from,channelid,msg,time = string.match(line,"([^\r\n]*)\r\n([^\r\n]*)\r\n(.*)\r\n([^\r\n]*)\r\n")
	if from and channelid and msg and time then
		local rcvtime = os.date("%x %X",tonumber(time))
		-- trace_out(from .. ':"' .. channelid .. "--" .. msg .. '"' .. "  @" .. rcvtime .. "\n")
		-- require"sys.str".totrace("cmds_rcvchannel:\n"..msg.."\n");
		require'sys.net.msg'.rcv_channel{Code=msg,From=channelid}
	end
end

-------------------------------------------------------------------------------------------------------------
_ENV = module(...,ap.adv)

---[[
local ct_ = nil;
local function content()
	if ct_ and cs[ct_] then return ct_ end
-- require'sys.str'.totrace('content()\n');
	local cfg = require"sys.io".read_file{file="cfg/net.lua"};
	local ip = cfg and cfg.ip or "www.apcad.com";
	local port = cfg and cfg.port or 8000;
	ct_ = hub_connect(ip,port);
	require'sys.str'.totrace('Content:'..tostring(ct_)..'\n');
	if not ct_ then require'sys.net.file'.breakdown() return end
	cs[ct_] = true
	return ct_;
end
--]]

function putkey_file(name,path)
-- trace_out("putkey_file()\n");
	if path then require"sys.net.file".set_path("putkey",name,path) else path = require"sys.net.file".get_path("putkey",name) end
	-- if require'sys.hid'.is_hid_file(name) and require'sys.net.temp'.is_record(name) and require'sys.io'.is_there_file{file=require'sys.str'.get_pathname(path,name)} then require"sys.net.file".endof("get",file) return end
	local path_name = require"sys.net.file".get_path_name("putkey",name);
	-- local path_name = path..name;
	local f = io.open(path_name,"r");
	if not f then return end
	local str = f:read("*all");
	f:close();
	local s = "putkey\r\n" .. name .. "\r\n" .. str .. "\r\n"..name.."\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	local ct = content();
	hub_send(ct,prefix)
	-- require"socket".sleep(1);
	-- require"sys.net.file".endof("putkey",name);
	require'sys.net.queue'.set_size_progress{file=path_name,size=string.len(s)};
end

-- require"sys.net.file".endof("send",file);
function send_file(name,path)
	if path then require"sys.net.file".set_path("send",name,path) else path = require"sys.net.file".get_path("send",name) end
	-- if require'sys.hid'.is_hid_file(name) and require'sys.net.temp'.is_record(name) then require"sys.net.file".endof("send",file) return end
	local path_name = require"sys.net.file".get_path_name("send",name);
	-- local path_name = path..name;
	local f = create_file(path_name,"r")
	local len = TRANS_SIZE
	lock_file(f,len,0,0,0)
	local str = read_file(f,len,0,0)
	unlock_file(f,len,0,0,0)
	local s = "trans\r\n" .. name .. "\r\n0\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	local ct = content();
	hub_send(ct,prefix)
	close_file(f)
end

-- require"sys.net.file".endof("get",file);
function get_file(name,path)
	if path then require"sys.net.file".set_path("get",name,path) else path = require"sys.net.file".get_path("get",name) end
	-- local path_name = require"sys.net.file".get_path_name("get",name);
	local path_name = require"sys.net.temp".get_temp_path()..name;
	-- local path_name = path..name;
	-- if require'sys.hid'.is_hid_file(name) and require'sys.io'.is_there_file{file=path_name} then require"sys.net.file".endof("get",name) return end
	os.remove(path_name);
	local ct = content();
	local str = "get\r\n"..name.."\r\n0\r\n0\r\n"
	local s = string.len(str) .. "\r\n" .. str
	hub_send(ct,s)
end

function user_login(user,password)
	local str = "login\r\n".. user .. "\r\n".. password .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

function user_reg(user,password,gid,mail,phone)
	local str = "reg\r\n".. user .. "\r\n"..password .. "\r\n" .. gid .. "\r\n" .. mail .. "\r\n" .. phone .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

function user_change_password(username,password,password_new)
	local str = "passwd\r\n".. username .. "\r\n".. password .. "\r\n" .. password_new .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

function send_msg(user,msg)
	local str = "sendmsg\r\n".. user .. "\r\n".. msg .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
	-- require'sys.net.msg'.add_msg{Code=msg,From=require"sys.mgr".get_user(),To=user,Time=os.time()}
-- trace_out("send_msg()\n");
end

-- subscribe\r\nchannelid\r\n
function subscribe(id)
	if not id then return end;
	local str = "subscribe\r\n".. id .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

-- unsubscribe\r\nchannelid\r\n
function unsubscribe(id)
	if not id then return end;
	local str = "unsubscribe\r\n".. id .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

-- sendchannel\r\ntchannelid\r\nmsg\r\n
function send_channel(id,msg)
	local str = "sendchannel\r\n".. id .. "\r\n".. msg .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	local ct = content();
	hub_send(ct,s)	
end

