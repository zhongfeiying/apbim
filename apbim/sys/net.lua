require "comma"

cs = {}
cmds = {}

--hub_start("192.168.5.224",8000,10,30) --ip port max_accept max_accept_seconds

hub_start("10.105.46.193",8000,10,60)

-- get\r\nfile\r\nstart\r\nlength\r\n
-- put\r\nfile\r\nstart\r\nlength\r\n......\r\n
-- trans\r\nfile\r\nstart\r\nlength\r\n......\r\n
-- putkey\r\nid\r\nvalue\r\n



function send_file(content,file)
	local f = create_file(file,"r")
	local len = 7*1024
	lock_file(f,len,0,0,0)
	local str = read_file(f,len,0,0)
	unlock_file(f,len,0,0,0)
	local s = "trans\r\n" .. file .. "\r\n0\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	hub_send(content,prefix)
	close_file(f)
end

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

function cmds.get(content,line)
  
	file,start_str,len_str = string.match(line,"([^\r\n]*)\r\n(%d+)\r\n(%d+)\r\n")

	if start_str then
		start = tonumber(start_str)
  end

	if len_str then
    len = tonumber(len_str)
  end

	if file and start and len and len >0 then
		local dir = string.sub(file,1,2)
		mkdir(dir)
		local f = create_file(dir .. "\\" .. file,"r")
		--local f = create_file(file,"r")
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
		local dir = string.sub(file,1,2)
		mkdir(dir)
		local f = create_file(dir .. "\\" .. file,"r")
		local fs = getfilesize(f)
    if start < fs then
			local c_len = 7*1024
			lock_file(f,c_len,0,start,0)
			local str = read_file(f,c_len,start,0)
			unlock_file(f,c_len,0,startt,0)
			local s = "trans\r\n" .. file .. "\r\n" .. start .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
			local prefix = string.len(s) .. "\r\n" .. s
			hub_send(content,prefix)
    end

		close_file(f)
	else
		local sock = get_socket(content)
		close_socket(sock)
	end
end

function cmds.trans(content,line)
	 
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
		trace_out("trans  " .. file .. "::" .. start .. "::" .. len .. "\n")

		local dir = string.sub(file,1,2)
		mkdir(dir)
		local f = create_file(dir .. "\\" .. file,"w")
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
		trace_out(file .. "::" .. start .. "::" .. len .. "\n")

		local dir = string.sub(file,1,2)
		mkdir(dir)
		local f = create_file(dir .. "\\" .. file,"w")
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
	id,value = string.match(line,"(.*)\r\n(.*)\r\n")
	if id  and value then
		local dir = string.sub(id,1,2)
		--trace_out("dir:" ..dir .. "\n")
		mkdir(dir)
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

function process_cmd_imp(content,line)
	local fun,l = string.match(line,"([^\r\n]-)\r\n(.*)")
	if fun and l  and cmds[fun] then
		cmds[fun](content,l)
	else
		local sock = get_socket(content)
		close_socket(sock)
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
			local sock = get_socket(content)
			close_socket(sock)
			return true
  elseif string.len(line) > 10 then
			trace_out("no len \n")
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

function accept(content,str)
  --accept_s[get_socket(content)] = nil
	cs[content] = true
	process_cmd(content,str)
end

function do_accept(content,str)
	--ip,port = hub_addr(content)
	--trace_out("thread : " .. thread_num .. "\n")
	--trace_out("lua accept at " ..ip .. ":"  ..port .."  info:" .. str .. "\n")
	--hub_send(content,"welcome!")
	--trace_out("thread:" .. thread_num .. " in thread\n")
	--redirect(2,0,"accept",content,str)
	accept(content,str)
end

function do_recv(content,str)
	--redirect(2,0,"recv",content,str)
	recv(content,str)
end

function recv(content,str)
	process_cmd(content,str)
end

function socket_quit(content)
	ip,port = hub_addr(content)
  trace_out("client exit @" .. ip .. ":" .. port .. "\n")
	cs[content] = nil
end

function on_quit()
  for k,v in cs do
		remove_content(k)
	end	
end

