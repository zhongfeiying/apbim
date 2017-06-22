
local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local default_path_ = 'app/projectmgr/data/'
local user_ = require 'sys.user'

function get_user_list(arg)
	local user = user_.get()
	local file = default_path_ .. user.gid
	-- require 'sys.net.main'.get_file(user.gid,file)
	local data = require"sys.io".read_file{file=file,key = 'db'};
	-- require 'sys.table'.totrace(data)
	arg.cbf()
	return data
	-- require"sys.net.file".get{name=user.gid;path=file;cbf=arg.cbf};
end

function update_user_list()
	local user = user_.get()
	local file = default_path_ .. user.gid
	-- require 'sys.net.main'.get_file(user.gid,file)
	require"sys.net.file".get{name=user.gid;path=file;cbf=arg.cbf};
end

function send_change()
end



