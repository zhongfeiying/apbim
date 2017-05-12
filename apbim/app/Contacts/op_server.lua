_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local file_op_ = require_files_.file_op()
local temp_ = ".tmp"

function send_file(name,path,f,datas)
	require"sys.net.file".send{name=name;path=path,
		cbf = function()
			if type(f)=='function' then f(datas) end
		end
	}
end

function putkey_file(name,path,f)
	require"sys.net.file".putkey{
		name=name;
		path=path,
		cbf = f
	}
end




local function tempf(t)
	local name = t and t.name or contact_path_
	local path = t and t.path or path_
	if type(path) ~= "string" then return end 
	local allpath = string.gsub(path,"/","\\") .. name
	if not file_op_.is_exist_local(allpath) then
		if file_op_.is_exist_local(allpath .. temp_) then 
			os.rename(allpath .. temp_,allpath)
		end 
		return
	end 
	local file = loadfile (allpath)
	if  file then 
		os.remove(allpath .. temp_)
	else 
		os.remove(allpath)
		os.rename(allpath .. temp_,allpath)
	end 
end

function get(name,path,f,datas)
	local name = name or contact_path_
	local path = path or path_
	
	local allpath = string.gsub(path,"/","\\") .. name
	if file_op_.is_exist_local(allpath) then 
		os.rename(allpath,allpath .. temp_)
	end
	require"sys.net.file".get{
		name = name;
		path = path;
		cbf = function(t)
			if type(f)=='function' then 
				tempf(t) 
				f(datas) 
			end
		end
	}
	
end

function get_hid(name,path,f,datas)
	require"sys.net.file".get{
		name=name;
		path=path,
		cbf = function(t)
			if type(f)=='function' then 
				f(datas) 
			end
		end
	}
end

function get_s(ts,f,datas)
	require"sys.net.file".get_s(ts,
		function()
			if type(f)=='function' then 
				f(datas) 
			end
		end 
	)
end 

function putkey(name,str,cfg)
	local s = "putkey\r\n" .. name .. "\r\n" .. str .. "\r\n"..name.."\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	local ct = content();
	hub_send(ct,prefix)
end

function send()
end

function subscribe(id)
	require "sys.net.main".subscribe(id)
end

function unsubscribe(id)
	require "sys.net.main".unsubscribe(id)
end


function send_msg(t)
	require "sys.net.msg".send_msg(t)
end

function send_channel(t)
	require "sys.net.msg".send_channel(t)
end




