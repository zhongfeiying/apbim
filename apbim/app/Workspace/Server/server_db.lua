
_ENV = module(...,ap.adv)

--module(...,package.seeall)

local file_op_ = require "app.workspace.ctr_require".file_op()

function return_download_file_db()
	return file_op_.get_download_tab()
end

function return_upload_file_db()
	return file_op_.get_upload_tab()
end  

function append_del_status(value)
	file_op_.save_download_str(value)
end 

function download_push_first(data) --下载队列从队列头添加数据
	local value = ""
	value = value .. "if not db then db = {} db[\"first\"] = 1 db[\"last\"] = 0 end "
	value = value .. "if not db[\"last\"] then db[\"last\"] = 0 end "
	value = value .. "if not db[\"first\"] then db[\"first\"] = 1 end "
	value = value .. "db[\"first\"] = db[\"first\"] - 1 " 
 
	value = value .. "db[db[\"first\"]] = {} "
	for k,v in pairs (data) do 
		if type(v) ~= "table" or type(v) ~= "userdata"  or type(v) ~= "function" then
		value = value .. "db[db[\"first\"]][\"".. k .. "\"] = \"" .. tostring(v) .. "\" "
		end 
	end 
	--value = value .. "if not db[\"ids\"][\"" .. data.id .. "\"] then db[\"ids\"][\"" .. data.id .. "\"] = \"\" "
	file_op_.save_download_str(value)
end

function download_push_last(data) --下载队列从队列尾添加数据
	local value = ""
	value = value .. "if not db then db = {} db[\"first\"] = 1 db[\"last\"] = 0 end "
	value = value .. "if not db[\"last\"] then db[\"last\"] = 0 end "
	value = value .. "if not db[\"first\"] then db[\"first\"] = 1 end "
	value = value .. "db[\"last\"] = db[\"last\"] + 1 " 
	value = value .. "db[db[\"last\"]] = {} "
	for k,v in pairs (data) do 
		if type(v) ~= "table" or type(v) ~= "userdata"  or type(v) ~= "function" then
		value = value .. "db[db[\"last\"]][\"".. k .. "\"] = \"" .. tostring(v) .. "\" "
		end 
	end 
	--"{ id = \"" .. data.id .. "\" ,type = \"" .. data.type .. "\"}"  
	file_op_.save_download_str(value)
end

function upload_push_first(data) --上传队列从队列头添加数据
	local value = ""
	value = value .. "if not db then db = {} db[\"first\"] = 1 db[\"last\"] = 0 end "
	value = value .. "if not db[\"last\"] then db[\"last\"] = 0 end "
	value = value .. "if not db[\"first\"] then db[\"first\"] = 1 end "
	value = value .. "db[\"first\"] = db[\"first\"] - 1 " 
	value = value .. "db[db[\"first\"]] = {} "
	for k,v in pairs (data) do 
		if type(v) ~= "table" or type(v) ~= "userdata"  or type(v) ~= "function" then
		value = value .. "db[db[\"first\"]][\"".. k .. "\"] = \"" .. tostring(v) .. "\" "
		end 
	end 
	file_op_.save_upload_str(value)
end

function upload_push_last(data) --上传队列从队列尾添加数据
	local value = ""
	value = value .. "if not db then db = {} db[\"first\"] = 1 db[\"last\"] = 0 end "
	value = value .. "if not db[\"last\"] then db[\"last\"] = 0 end "
	value = value .. "if not db[\"first\"] then db[\"first\"] = 1 end "
	value = value .. "db[\"last\"] = db[\"last\"] + 1 " 
	value = value .. "db[db[\"last\"]] = {} "
	for k,v in pairs (data) do 
		if type(v) ~= "table" or type(v) ~= "userdata"  or type(v) ~= "function" then
		value = value .. "db[db[\"last\"]][\"".. k .. "\"] = \"" .. tostring(v) .. "\" "
		end 
	end 
	--trace_out("value = " .. value .. "\n")
	file_op_.save_upload_str(value)
end

function upload_pop_first() --上传队列从队列头删除数据
	local db = file_op_.get_upload_tab()
	if not db then return end 
	local value = ""
	if tonumber(db.first) > tonumber(db.last) then  return   		
	end 
	value = value .. "db[db[\"first\"]] = nil "  
	value = value .. "db[\"first\"] = db[\"first\"] + 1" 
	file_op_.save_upload_str(value)
end

function upload_pop_last() --上传队列从队列尾删除数据
	local db = file_op_.get_upload_tab()
	if not db then return end 
	local value = ""
	if tonumber(db.first) > tonumber(db.last) then  return   	
	end 
	value = value .. "db[db[\"last\"]] = nil "  
	value = value .. "db[\"last\"] = db[\"last\"] - 1 "
	file_op_.save_upload_str(value)
end

function download_pop_first() --下载队列从队列头删除数据
	local db = file_op_.get_download_tab()
	if not db then return end 
	local value = ""
	if tonumber(db.first) > tonumber(db.last) then  return    	
	end 
	value = value .. "db[db[\"first\"]] = nil "  
	value = value .. "db[\"first\"] = db[\"first\"] + 1 "
	file_op_.save_download_str(value)
end

function download_pop_last() --下载队列从队列尾删除数据
	local db = file_op_.get_download_tab()
	if not db then return end 
	local value = ""
	if tonumber(db.first) > tonumber(db.last) then  return    	
	end 
	value = value .. "db[db[\"last\"]] = nil "  
	value = value .. "db[\"last\"] = db[\"last\"]  - 1 "
	file_op_.save_download_str(value)
end

function init_upload_file() 
	local db = {}
	db.first = 1
	db.last = 0
	file_op_.save_upload_tab(db)
end 

function init_download_file() 
	local db = {}
	db.first = 1
	db.last = 0
	file_op_.save_download_tab(db)
end 

function append_content_upload_file(value)
	file_op_.save_upload_str(value)
end 


