local require  = require 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_file'
local user_ = 'Sjy' -- require 'user'.get()

local function init_data()
	return {
		user = {name = user_,id = 1,type = 'user'};
		project = {name = '工程列表',id = 2,type = 'projects',entrance =  'app.projectmgr.workspace.projects.main'};
		contact = {name = '联系人列表',id =3,type = 'contacts',entrance =  'app.projectmgr.workspace.contacts.main'};
		recycle  = {name = '回收站',id =4,type = 'recycle',entrance =  'app.projectmgr.workspace.recycles.main'};
		private  = {name = '私人文件夹',id =4,type = 'private',entrance =  'app.projectmgr.workspace.privates.main'};
		{
			index = 'user';
			{
				{
					index = 'private';
					{};
				};
				{
					index='project';
					{};
				};
				{
					index='contact';
					{};
				};
				{
					index='recycle';
					{};
				};
			};
		};

	};
	--save_file()
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return data_
end

function add(arg)
end

function edit(arg)
end

function delete(arg)
end




