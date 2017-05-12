 _ENV = module(...,ap.adv)

local file_op_ = require "app.workspace.ctr_require".file_op()
local server_db_ = require "app.workspace.ctr_require".server_db()
local luaext_ = require "app.workspace.ctr_require".luaext()
local send_max_size_ =  7*1024
local temp_data_ = nil


function download_file(ct,t)
	local f = t.id
	if not f then trace_out("download_file data error!\n") return true end
	-- local s = "filesize\r\n"..f.."\r\n123\r\n"
	-- local res = hub_send(ct,s)
	local str = "get\r\n"..f.."\r\n0\r\n0\r\n"
	local s = string.len(str) .. "\r\n" .. str
	local res = hub_send(ct,s)
	if not res then return true  end 
end

function get_send_max_size()
	return send_max_size_
end

local function upload_temp_data(str,f,fs)
	temp_data_ = {}
	temp_data_.f = f
	temp_data_.fs = fs
	temp_data_.file =  string.gsub(str,"\\","/")
end



function pre_file(content,t)
	
	local file = t.id
	local str = file_op_.get_version_all_path(file) 
	if not str then return end 
	local f = create_file(str,"r")
	local fs = getfilesize(f)
	upload_temp_data(str,f,fs)
end

function send_file(content,t)
	if not temp_data_ then return true end 
	local size = tonumber(t.fpos or  0)
	local f = temp_data_.f
	lock_file(f,send_max_size_,0,size,0)
	local str = read_file(f,send_max_size_,size,0)
	unlock_file(f,send_max_size_,0,size,0)
	local file = temp_data_.file
	local cur_file = string.reverse(string.sub(string.reverse(file),1,string.find(string.reverse(file),"/")-1))
	local s ;
	if not t.fpos then 
	s = "trans\r\n" .. cur_file .. "\r\n0\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
	else 
	s = "put\r\n" .. cur_file .. "\r\n" .. size .. "\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
	end 
	local prefix = string.len(s) .. "\r\n" .. s
	--hub_send(content,prefix)
	local res =  hub_send(content,prefix)
	if not res then return true  end
	
	if tonumber(temp_data_.fs) > (send_max_size_ + size) then 
		local db = server_db_.return_upload_file_db()
		if not db then return true end 
		--trace_out("cur_id = " .. t.id .. "\n")
		local value = ""
		value = value .. "db[" .. db.first .. "][\"fpos\"] = \"" .. (send_max_size_ + size) .. "\" "
		value = value .. "db[" .. db.first .. "][\"fmaxsize\"] = \"" .. (temp_data_.fs) .. "\" "
		server_db_.append_content_upload_file(value)
		t.fpos = (send_max_size_ + size)
	else 
		local value = ""
		value = value .. "db[" .. db.first .. "][\"fpos\"] = nil "
		server_db_.append_content_upload_file(value)
		if t.fpos then
			t.end_upload = true
		end 
		t.fpos = nil
		
	end 
end

function send_finish(f)
	close_file(f)
	temp_data_ = nil
end
--[[
function upload_file(content,t)
	if  not t.fpos then 
		pre_file(content,t)
	end 
	-- local str = file_path_ .. file;
	if send_file(content,t) then temp_data_ = nil return true end 
	if not t.fpos then 
		send_finish(temp_data_.f)
	end 
end
--]]
--[[
function upload_file(content,t)
	local file = t.id
	local str = file_op_.get_version_all_path(file) 
	if not str then return end 
	local f = create_file(str,"r")
	local fs = getfilesize(f)
	--trace_out("send_file name = " .. str .. "\n")
	
	local len = send_max_size_
	lock_file(f,len,0,0,0)
	local newstr = read_file(f,len,0,0)
	unlock_file(f,len,0,0,0)
	local new_file =  string.gsub(str,"\\","/")
	local cur_file = string.reverse(string.sub(string.reverse(new_file),1,string.find(string.reverse(new_file),"/")-1))
	local s = "trans\r\n" .. cur_file .. "\r\n0\r\n" .. string.len(newstr) .. "\r\n" .. newstr .. "\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	hub_send(content,prefix)
	close_file(f)
end


--]]

function upload_append(ct,t)
	local gid =  "1"
	local str = "putkey\r\n".. t.id.. "\r\n".. t.value.. "\r\n" .. gid .. "\r\n" 
	local s = string.len(str) .. "\r\n" .. str
	local res = hub_send(ct,s)	
	if not res then return true,gid  end 
	return false,gid
end

function download_file_size(ct,t)
	local gid =  "2"
	local str = "filesize\r\n" .. t.id .. "\r\n" .. gid .. "\r\n"
	local s = string.len(str) .. "\r\n" .. str
	local res = hub_send(ct,s)
	if not res then return true,gid  end 
	return false,gid
end

function upload_file(ct,t)
	trace_out("here\n")
	if not t.path then return end
	if not t.name then return end 
	local str = string.gsub(t.path,"/","\\")
	local name = t.name
	str = string.gsub(str,"/","\\")
	local f = create_file(str,"r")
	local len = send_max_size_
	lock_file(f,len,0,0,0)
	local newstr = read_file(f,len,0,0)
	unlock_file(f,len,0,0,0)
	local s = "trans\r\n" .. name .. "\r\n0\r\n" .. string.len(newstr) .. "\r\n" .. newstr .. "\r\n"
	local prefix = string.len(s) .. "\r\n" .. s
	hub_send(content,prefix)
	close_file(f)
end
