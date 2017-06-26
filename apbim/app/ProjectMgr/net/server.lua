
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local g_next_ = _G.next
local print = print
local trace_out = trace_out

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local default_path_ = 'app/projectmgr/data/'
local user_ = require 'sys.user'
local sys_io_ = require 'sys.io'


function init_user_list(arg)
	local user = user_.get()
	local file = default_path_ .. user.gid
	if sys_io_.is_there_file(file) then 
		arg.cbf()
	else 
		require"sys.net.file".get{name=user.gid;path=file;cbf=arg.cbf};
	end
	-- 
end

function get_user_list()
	local user = user_.get()
	local file = default_path_ .. user.gid
	print(file)
	local data = require"sys.io".read_file{file=file,key = 'db'};
	require 'sys.table'.totrace(data)
	return data
end

function update_user_list(arg)
	local user = user_.get()
	local file = default_path_ .. user.gid
	require"sys.net.file".get{name=user.gid;path=file;cbf=arg.cbf};
end

function save_user_list(data)
	local user = user_.get()
	local file = default_path_ .. user.gid
	local data = require"sys.io".read_file{file=file,key = 'db'};
end

function update_user_info(arg)
	arg = arg or {}
	local user = user_.get()
	require 'sys.net.main'.userinfo{user = user.user,gid = user.gid,cbf = arg.cbf}
end

function get_user_info(arg)
	-- local data =  user_.get_userinfo()
	-- if data then 
		-- arg.cbf()
	-- else 
		
	-- end 
	update_user_info(arg)
end

function send_change()
end



