 _ENV = module(...,ap.adv)
local server_db_ = require "app.workspace.ctr_require".server_db()
local server_base_ = require "app.workspace.ctr_require".server_base()
local file_op_ = require "app.workspace.ctr_require".file_op()
local rmenu_op_ = require "app.workspace.ctr_require".rmenu_op()
local tree_op_ = require "app.workspace.ctr_require".tree_op()

local download_ct_ = nil;

local download_status_ = nil;
local upload_status_ = nil

local download_ok_tag_ = nil

function get_download_status()
	return download_status_
end 

function get_upload_status()
	return upload_status_
end 

local function upload_ok(cmd)
	if cmd and cmd == "finish_add_version" then 
		rmenu_op_.finish_add_version()
	elseif cmd and cmd == "finish_submit_version" then 
		rmenu_op_.finish_submit_version()
	--elseif cmd and cmd == "finish_add_folder" then 
	--	rmenu_op_.finish_add_folder()
	elseif cmd and cmd == "finish_reg" then 
		rmenu_op_.finish_reg()
	end
end

local function is_end_upload(db,data)
	if  not db.first or (tonumber(db.first) > tonumber(db.last)) then
		server_db_.init_upload_file()
		upload_status_ = nil
		upload_ok(data.cmd)
		return true 
	end 
	return	 false
end

function upload_file(data)
	local db = server_db_.return_upload_file_db()
	if is_end_upload(db,data,states) then return end 
	local ct = init_send_connect()
	if not ct or ct == 0 then iup.Message("Warning","Net work stop !") return  end 
	local res = nil;
	local t = db[db.first]
	if t.value then 
		res = server_base_.upload_append(ct,t)
	else 
		res = server_base_.upload_file(ct,t)
	end
	if res then --res ?
		upload_file(data)
	else 
		return true 
	end 
end 


local update_status_ = false
local function del_file(id)
	if not id then return end 
	if #id > 30 then return end 
	file_op_.delete_file(file_op_.get_version_all_path(id))
end

local checkout_download_ = false
local function download_ok(cmd)
	if download_ok_tag_ == "Update_User" then 
		rmenu_op_.user_login_finish()
	elseif download_ok_tag_ == "branchopen_finish" then  
		rmenu_op_.branchopen_finish()
	elseif download_ok_tag_ == "finish_checkout" then  
		rmenu_op_.finish_checkout()
	-------------------------------------------
	elseif cmd and cmd == "import_id" then 
		rmenu_op_.finish_import()
	elseif cmd and cmd == "Update_User" then 
		rmenu_op_.user_login_finish()
	elseif cmd and cmd == "branch_open" then 
		rmenu_op_.branchopen_finish()
	elseif cmd and cmd == "update" then 
		rmenu_op_.update_finish()
	elseif cmd and cmd == "update_project" then 
		rmenu_op_.update_finish_project()
	elseif cmd and cmd == "checkout" then 
		rmenu_op_.finish_checkout()
	elseif cmd and cmd == "expand_all" then 
		rmenu_op_.finish_expand_all()
	elseif cmd and cmd == "finish_import_id" then 
		rmenu_op_.finish_import_id() 
	-- elseif cmd and cmd == "finish_add_folder" then 
		-- rmenu_op_.finish_add_folder()
	
	end 
	
	download_ok_tag_ = nil
end 

local function is_end_download(db,cmd)
	if  not db or not db.first or (tonumber(db.first) > tonumber(db.last)) then
		download_ok(cmd)
		server_db_.init_download_file()  
		download_status_ = nil
		return true 
	end 
	return	 false
end
function download_file(cmd)
	local db = server_db_.return_download_file_db()
	
	if is_end_download(db,cmd) then return end 
	local ct = init_send_connect()
	download_status_ = true
	if not ct or ct == 0 then iup.Message("Warning","Net work stop !") return  end 
	local t = db[db.first]
	del_file(t.id)
	--rmenu_op_.new_progress_bar(t)
	local res;
	if t.GetSize then	
		res = server_base_.download_file_size(ct,t)
	else 
		res = server_base_.download_file(ct,t)
	end 
	
	if res then 
		download_file(cmd) 
	else 
		return true 
	end 
end 

function upload_add(t)
	if not t or not t.gid or not t.hid then  return  end 
	-- server_db_.upload_push_last({id = t.gid,cmd = t.cmd})
	-- server_db_.upload_push_last({id = t.hid,cmd = t.cmd})
	t.id = t.gid
	server_db_.upload_push_last(t)
	t.id = t.hid
	server_db_.upload_push_last(t)
end 

function upload_append(t,val)
	if not t or not t.gid or not t.hid or not val then  return  end 
	val = string.gsub(val,"\"","'")
	t.id = t.gid
	t.value = val
	server_db_.upload_push_last(t)
	t.id = t.hid
	t.value = nil
	server_db_.upload_push_last(t)
	
end 

function upload_check(t,val)
	if not t or not t.gid  or not val then  return  end 
	val = string.gsub(val,"\"","'")
	--t.value = val
	--t.id = t.gid
	--server_db_.upload_push_last(t)
	t.value = val
	server_db_.upload_push_last(t)
end

function upload_branch(t,val)
	if not t or not t.gid or not val then  return  end 
	val = string.gsub(val,"\"","'")
	server_db_.upload_push_last({id = gid,type = "add_branch",value = val})
end 

---------------------------------------------------------------------------

function import (t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "import"
	server_db_.download_push_last(t)
end

function import_hid(t)
	--if not t.id or not t.tree_id or not t.gid or not t.path then trace_out(t.id .. "Data error \n") return end 
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "import_hid"
	server_db_.download_push_last(t)
end 

function update(t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	if not update_status_ then 
		update_status_ = true
	end 
	t.type = "update"
	server_db_.download_push_last(t)
end  



function update_hid(t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "update_hid"
	server_db_.download_push_last(t)
end 

function update_gid(t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "update_gid"
	server_db_.download_push_last(t) 
end 


function download(t)
	--local temp = {id = id,type = str,op = op}
	server_db_.download_push_last(t)
end 

function checkout_download(t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "checkout_download_hid"
	checkout_download_ = true
	server_db_.download_push_last(t)
end

function checkout_download_gid(t)
	if t.tree then 
		rmenu_op_.init_tree(t.tree)
		t.tree = nil
	end 
	t.type = "checkout_download_gid"
	checkout_download_ = true
	server_db_.download_push_last(t)
end

-- function check_server_update(t)
	-- if t.tree then 
		-- rmenu_op_.init_tree(t.tree)
		-- t.tree = nil
	-- end 
	-- server_db_.download_push_last(t)
-- end 

function finish_upload_callback()
	trace_out("finish_upload_callback\n")
	
	local db = server_db_.return_upload_file_db()
	trace_out("id = " .. db[db.first].id .. "\n")

	server_db_.upload_pop_first()
	--rmenu_op_.deal_progress_bar_callback_ifo()
	--rmenu_op_.upload_ok(db[db.first])
	upload_file(db[db.first])
end

function finish_upload_putkey(result,gid)
	trace_out("finish_upload_putkey\n")
	local db = server_db_.return_upload_file_db();
	server_db_.upload_pop_first()
	rmenu_op_.deal_progress_bar_callback_ifo()	
	trace_out("id = " .. db[db.first].id .. "\n")
	if string.find(string.lower(tostring(result)),"false")  or string.find(string.lower(tostring(result)),"nil") then 
		rmenu_op_.upload_false(db[db.first])
	else 
		rmenu_op_.upload_ok(db[db.first])
	end
	upload_file(db[db.first])
	
	
	
end

function finish_download_putkey(result,gid)
	trace_out("finish_download_putkey\n")
	local db =  server_db_.return_download_file_db()
	server_db_.download_pop_first()
	rmenu_op_.deal_progress_bar_callback_ifo(result)
	download_file()
end 

function finish_download_callback()
	trace_out("finish_download_callback\n")
	local db = server_db_.return_download_file_db()
	if not db or  not db[db.first] then return end 
	server_db_.download_pop_first()
	rmenu_op_.download_ok(db[db.first]) 
	rmenu_op_.deal_progress_bar_callback_ifo()	
	download_file(db[db.first].cmd)
end


----------------------------------------------------------
function download_user_gid_file(t)
	server_db_.download_push_last(t)
end 

function download_user_hid_file(t)
	server_db_.download_push_last(t)
end 

function set_download_tag(type)
	download_ok_tag_ = type
end

function download_id_file(t)
	t.GetSize = "YES" 
	server_db_.download_push_last(t)
	t.GetSize = nil 
	server_db_.download_push_last(t)
end

function upload_append(t)

	server_db_.upload_push_last(t)
end
