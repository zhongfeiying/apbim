local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
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
local user_ = require 'sys.user'
local doc_cfg_file_ = ''


local function admin_data()
	return {
		project = {
			title = '工程',
			
			image = {open ='app/ProjectMgr/res/projects.bmp',close =  'app/ProjectMgr/res/projects.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get;
				__title = 'ProjectList';
			};
		};
		dahe= {
			title = '大河',
		};
		{
			index = project;
			{
				{
					index = dahe;
					{};
				};
			};
		}
	}
end

local function init_data()
	-- return admin_data()
	----[[
	local user =  user_.get() or {user = 'Default',}
	return {
		user = {
			title = user.user,
			data= {
				rmenu = require 'app.projectmgr.workspace.workspace.rmenu'.get;
				__title = 'User';
			};
			image = {open ='app/ProjectMgr/res/user.bmp',close =  'app/ProjectMgr/res/user.bmp'} ;
			state = 'expanded',
			
		};
		project = {
			title = '工程',
			image = {open ='app/ProjectMgr/res/projects.bmp',close =  'app/ProjectMgr/res/projects.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.projects.rmenu'.get;
				__title = 'ProjectList';
			};
		};
		contact = {
			title = '联系人',
			
			image = {open ='app/ProjectMgr/res/contacts2.bmp',close =  'app/ProjectMgr/res/contacts2.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.contacts.rmenu'.get;
				__title = 'Contacts';
			};
		};
		recycle  = {
			title = '回收站',
			image = {open ='app/ProjectMgr/res/recycles.bmp',close =  'app/ProjectMgr/res/recycles.bmp'} ;
			data= {
				rmenu = require 'app.projectmgr.workspace.recycles.rmenu'.get;
				__title = 'recycles';
			};
		};
		private  = {
			title = '私人文件夹',
			image = {open ='app/ProjectMgr/res/private.bmp',close =  'app/ProjectMgr/res/private.bmp'} ;
			data = {
				rmenu = require 'app.projectmgr.workspace.privates.rmenu'.get;
				__title = 'privates';
			};
		};
		family = {
			title = '族';
			image = {open ='app/ProjectMgr/res/family.bmp',close =  'app/ProjectMgr/res/family.bmp'} ;
			data = {
				rmenu = require 'app.projectmgr.workspace.family.rmenu'.get;
				__title = 'family';
			};
		};
		{
			index = 'user';
			{
				{
					index='project';
					{};
				};
				{
					index='contact';
					{};
				};
				{
					index = 'private';
					{};
				};
				{
					index='family';
					{};
				};
				{
					index='recycle';
					{};
				};
			};
		};

	};
	--]]
	--save_file()
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	-- data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return init_data()
end





