package.cpath = "./?51.dll;./?.dll";
package.path="?;?.lua;";

require "iuplua"
require( "iupluacontrols")

require"sys.main";

require"crypto"

local file_path_ = ".\\data\\docs\\";
local login_dlg_ = require "app.Login.login_dlg"
local server_address_ = "www.apcad.com"
local server_port_ = 8000
local login_tab_ = nil

--server start-----------------------------------------------------------

--ct = hub_connect("127.0.0.1",8000)
--ct1 = hub_connect("127.0.0.1",8000)

--ct = hub_connect("192.168.5.142",8000)
--ct1 = hub_connect("192.168.5.142",8000)

--ct = hub_connect("192.168.5.238",8000)
--ct1 = hub_connect("192.168.5.238",8000)

--ct = hub_connect("192.168.5.223",8000)
--ct1 = hub_connect("192.168.5.223",8000)
cmds = {}
cs = {}
--[[
function init_send_connect()
	ct = hub_connect("www.apcad.com",8000)
	cs[ct] = true
	return ct
end--]]

function init_send_connect(t)
	local server = server_address_
	local port = server_port_
	if t then 
		server = t.server
		port = t.port
	end
	ct = hub_connect(server,port)
	if ct == 0 then return ct end 
	cs[ct] = true
	return ct
end
--]]
function init_down_connect()
	ct1 = hub_connect(server_address_,server_port_)
	cs[ct1] = true
	return ct1
end--]]


function send_file(content,file)
	local str = file_path_ .. file;
	local f = create_file(str,"r")
	trace_out("send_file name = " .. str .. "\n")
	
	local len = 7*1024
	lock_file(f,len,0,0,0)
	local str = read_file(f,len,0,0)
	unlock_file(f,len,0,0,0)
	local s = "trans\r\n" .. file .. "\r\n0\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	hub_send(content,prefix)
--[[
	local fs = getfilesize(f)
	local len = 7*1024
	for var=0,fs,len do
		lock_file(f,len,0,var,0)
		local str = read_file(f,len,var,0)
		unlock_file(f,len,0,var,0)
		local s = "put\r\n" .. file .. "\r\n" .. var .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
		local prefix = string.len(s) .. "\r\n" .. s
		hub_send(content,prefix)
  end
--]]
	close_file(f)
end
--[[
trace_out("11111111111111\n");
do
local str = "get\r\nhelp.pdf\r\n0\r\n0\r\n"
local s = string.len(str) .. "\r\n" .. str
hub_send(ct,s)
end

trace_out("222222222222222\n");
--]]


function cmds.get(content,line)
  
	file,start_str,len_str = string.match(line,"([^\r\n]*)\r\n(%d+)\r\n(%d+)\r\n")

	if start_str then
		start = tonumber(start_str)
  end

	if len_str then
    len = tonumber(len_str)
  end

	if file and start and len and len >0 then
		local str = file_path_ .. file;
		local f = create_file(str,"r")
		local fs = getfilesize(f)
    if start < fs then
			lock_file(f,len,0,start,0)
			local str = read_file(f,len,start,0)
			unlock_file(f,len,0,start,0)
			close_file(f)
			local data = "put\r\n" .. file .. "\r\n" .. start .. "\r\n" .. len .. "\r\n" .. str .. "\r\n"
			local	prefix = string.len(data) .. "\r\n" .. data 
			hub_send(content,prefix)
		else
			close_file(f)
		end
	elseif file and start and len and len == 0 then
		local str = file_path_ .. file;
		local f = create_file(str,"r")
		local fs = getfilesize(f)
    if start < fs then
			local c_len = 7*1024
			lock_file(f,c_len,0,start,0)
			local str = read_file(f,c_len,start,0)
			unlock_file(f,c_len,0,startt,0)
			local s = "trans\r\n" .. file .. "\r\n" .. start .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
			local prefix = string.len(s) .. "\r\n" .. s
			hub_send(content,prefix)
    else
		--trace_out("upload ok.\n");
	end

--[[
		local fs = getfilesize(f)
		len = 7*1024
		for var=start,fs,len do
			lock_file(f,len,0,var,0)
			local str = read_file(f,len,var,0)
			unlock_file(f,len,0,var,0)
			local data = "put\r\n" .. file .. "\r\n" .. var .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
			local prefix = string.len(data) .. "\r\n" .. data
      trace_out("len .. " .. string.len(prefix) .. "\n")
			hub_send(content,prefix)
    end
--]]
		close_file(f)
	else
		cs[content] = nil

		local sock = get_socket(content)
		close_socket(sock)
	end
end

function cmds.trans(content,line)
	 trace_out(" cmds.trans\n");
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
		trace_out(file .. "::" .. start .. "::" .. len .. "\n")
		--local f = create_file(file,"w")
		
		local str = file_path_ .. file;
		local f = create_file(str,"w")

		
		lock_file(f,len,0,start,0)
		write_file(f,s,start,0)
		unlock_file(f,len,0,start,0)
		close_file(f)
		
    local nextstr = "get\r\n" ..file .. "\r\n" .. start + len .. "\r\n" .. 0 .. "\r\n"
		local nextget = string.len(nextstr) .. "\r\n" .. nextstr
    hub_send(content,nextget) 
	
	else
    --trace_out("------------------------------\n")
		--trace_out(string.sub(line,-20))
    --trace_out(string.len(line) .. "\n" )
		--trace_out("cmds.put remove\r\n")
		cs[content] = nil

		local sock = get_socket(content)
		close_socket(sock)
	end
	--判断文件是否传输完毕
	trace_out("The file size = " .. len_str .. "\n");
	if tonumber(len_str) < 7168 then 
		trace_out("The file download ok.\n");
		require "app.Net.file_download".operate(file);
	end
end

function cmds.endof(content,line)
	file = string.match(line,"([^\r\n]*)\r\n")
	if file then 
		trace_out("endof file : " .. file .. "\n")
	end
end 




function cmds.put(content,line)
	 
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
		--trace_out(file .. start .. len .. str)
		local str = file_path_ + file;
		local f = create_file(str,"w")
		trace_out("file = " .. str .. "\n")
		lock_file(f,len,0,start,0)
		write_file(f,s,start,0)
		unlock_file(f,len,0,start,0)
		close_file(f)
	else
    --trace_out("------------------------------\n")
		--trace_out(string.sub(line,-20))
    --trace_out(string.len(line) .. "\n" )
		--trace_out("cmds.put remove\r\n")
		cs[content] = nil

		local sock = get_socket(content)
		close_socket(sock)
	end
end

function process_cmd_imp(content,line)
	local fun,l = string.match(line,"([^\r\n]-)\r\n(.*)")
	if fun and l  and cmds[fun] then
		cmds[fun](content,l)
	else
		cs[content] = nil

		local sock = get_socket(content)
		close_socket(sock)
	end
end

function process_data(content,line)
	--trace_out(string.sub(line,1,32) .. "\n")
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
			trace_out(num .. "::" .. string.len(l) .. "   left\n")
      return false,left
	elseif len and l and num == string.len(l) then
      process_cmd_imp(content,l)
			cs[content] = true
			trace_out(num .. "=\n")
			return true
  elseif len and l and num > string.len(l) then
			cs[content] = line
			trace_out(num .. "need more\n")
			return true
  elseif len and tonumber(len) > 8*1024 then
			trace_out("max data\n")
			cs[content] = nil

		local sock = get_socket(content)
		close_socket(sock)
			return true
  elseif not len then
			trace_out("no len \n")
            trace_out(string.sub(line,1,32) .. "\n")
			cs[content] = nil

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
  until result 
end


function on_hubquit(content)
   cs[content] = nil 

		local sock = get_socket(content)
		close_socket(sock)
end

function on_hubmsg(content,str)
	process_cmd(content,str)
end

function get_hash_id(f)
	local file = io.open(f,"rb");
	local s = file:read("*all");
	local dig = crypto.digest;
	local d = dig.new("sha1");
	local s1 = d:final(s);
	--trace_out(s1);
	d:reset();
	file:close();
	
end

function get_file(f)
	trace_out("get_file start.\n");
	do
		local str = "get\r\n"..f.."\r\n0\r\n0\r\n"
		trace_out("f = " .. f .."\n")
		local s = string.len(str) .. "\r\n" .. str
		local res = hub_send(ct,s)

		return res;
	end
	trace_out("get_file end.\n");
	
end



function cmds.login(content,line)
	trace_out("line = " .. line .. "\n")
	local msg = string.match(line,"([^\r\n]*)\r\n")
	trace_out("login:" .. msg .. "\r\n")
	login_dlg_.set_status(msg)
	on_hubquit(content)
end
function cmds.reg(content,line)
	local msg = string.match(line,"([^\r\n]*)\r\n")
	trace_out("reg:" .. msg .. "\r\n")
	login_dlg_.set_reg_status(msg)
	on_hubquit(content)
end
function cmds.passwd(content,line)
	local msg = string.match(line,"([^\r\n]*)\r\n")
	trace_out("passwd:" .. msg .. "\r\n")
	require "sys.function".set_passwd_status(msg)
	on_hubquit(content)
end
--info={
--	user="zgb",
--	passwd="123456",
--	gid="sdfasdfasdfas",
--	mail="zgb@qq.com",
--	phone="13998511231",
--};
function user_reg(info)
	--trace_out("herer\n")
	local str = "reg\r\n".. info.user .. "\r\n"..info.passwd .. "\r\n" .. info.gid .. "\r\n" .. info.mail .. "\r\n" .. info.phone .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	hub_send(ct,s)	
end

function user_login(info)
	local str = "login\r\n".. info.user .. "\r\n".. info.passwd .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	hub_send(ct,s)	
end
function user_change_passwd(info)
	local str = "passwd\r\n".. info.user .. "\r\n".. info.passwd .. "\r\n" .. info.newpass .. "\r\n";
	local s = string.len(str) .. "\r\n" .. str
	hub_send(ct,s)	
end

function user_putkey(id,value)
	local str = "putkey\r\n".. id.. "\r\n".. value.. "\r\n" 
	local s = string.len(str) .. "\r\n" .. str
	hub_send(ct,s)	
	--trace_out("value = " .. value  .. "\n")
	return id,value
end

--server end-----------------------------------------------------------
function pop_login()

	require "app.Login.set_server_dlg".pop()
	local t = require "app.Login.set_server_dlg".get_db()
	if t then 
		server_address_ = t.server
		server_port_ = t.port
	end 
	login_dlg_.pop()
	login_tab_ = login_dlg_.return_db()
	if not login_tab_ then  
		os.exit()
	end
end 
pop_login()

function create_dlgtree()
	require "app.Workspace.main".create(login_tab_);
end

function frmclose()
	os.exit()
end



