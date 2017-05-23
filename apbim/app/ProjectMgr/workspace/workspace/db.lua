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
local keydown_ = require 'app.ProjectMgr.workspace.keydown_control'
local function init_data()
	return {
		user = {
			title = user_,
			data= {
				rbtn =  function (tree,id) keydown_.set(require 'app.projectmgr.workspace.workspace.keydown') keydown_.rbtn(tree,id) end;
			};
			image = {open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} ;
			state = 'expanded',
		};
		project = {
			title = '工程列表',
			
			image = {open ='app/ProjectMgr/res/projects_open.bmp',close =  'app/ProjectMgr/res/projects_close.bmp'} ;
			data= {
				entrance =  'app.projectmgr.workspace.projects.main';
				rbtn =  function (tree,id) keydown_.set(require 'app.projectmgr.workspace.projects.keydown') keydown_.rbtn(tree,id) end ;				
			};
		};
		contact = {
			title = '联系人列表',
			
			image = {open ='app/ProjectMgr/res/user_open.bmp',close =  'app/ProjectMgr/res/user_close.bmp'} ;
			data= {
				entrance =  'app.projectmgr.workspace.contacts.main';
				rbtn =  function (tree,id) keydown_.set(require 'app.projectmgr.workspace.contacts.keydown') keydown_.rbtn(tree,id) end ;
			};
		};
		recycle  = {
			title = '回收站',
			image = {open ='app/ProjectMgr/res/recycles_open.bmp',close =  'app/ProjectMgr/res/recycles_close.bmp'} ;
			data= {
				entrance =  'app.projectmgr.workspace.recycles.main';
				rbtn =  function (tree,id) keydown_.set(require 'app.projectmgr.workspace.recycles.keydown') keydown_.rbtn(tree,id) end ;
			};
		};
		private  = {
			title = '私人文件夹',
			image = {open ='app/ProjectMgr/res/privates_open.bmp',close =  'app/ProjectMgr/res/privates_close.bmp'} ;
			data = {
				entrance =  'app.projectmgr.workspace.privates.main';
				rbtn =  function (tree,id) keydown_.set(require 'app.projectmgr.workspace.privates.keydown') keydown_.rbtn(tree,id) end ;
			};
		};
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




