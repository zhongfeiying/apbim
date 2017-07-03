local string = string
local require  = require 
local require  = function (str)  return require(string.lower(str)) end 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type
local pairs = pairs
local g_next_ = _G.next
local os_time_ = os.time
local print = print
local ipairs = ipairs

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local iup = require 'iuplua'

local function require_data_file(file)
	package_loaded_[file] = nil
	return require (file)
end

local lfs = require 'lfs'
local luaext_ = require 'luaext'
local disk_ =  require 'app.Apmgr.disk'
local dlg_create_project_ =  require 'app.apmgr.dlg.dlg_create_project'
local dlg_info_ = require 'app.apmgr.dlg.dlg_info'
local tree_ =  require 'app.apmgr.project.tree'
local version_ = require 'app.Apmgr.version'
local temp_path_ = 'app/apmgr/temp/'
local project_ = require 'app.Apmgr.project.project'


local function table_is_empty(t)
	return g_next_(t) == nil
end

local function get_tpl_data()
	local path = 'app/apmgr/tpl/'
	local require_path = string.gsub(path,'/','.')
	local t = disk_.get_folder_contents(path)
	local data = {}
	for k,v in pairs(t) do 
		local name = string.sub(k,1,-5)
		local str = require_path ..  name
		local t = require_data_file(str)
		table.insert(data,t)
	end
	table.sort(data,
		function (a,b)
			if a.name and b.name then
				return string.lower(a.name) < string.lower(b.name)
			end
		end
	)
	table.insert(data,1,{name = 'Null'})
	return data
end

local function get_project_data()
	local project_info;--{name,path,data,pop,open}
	local function on_next(warning,arg)
		local content = disk_.get_folder_contents('Projects/')
		for k,v in pairs(content) do 
			content[string.lower(k)] = true
		end
		local file = string.lower(arg.name) .. '.apc'
		if content[file] then warning() return end 
		project_info = arg
		return true
	end
	
	dlg_create_project_.pop{on_next = on_next,data = get_tpl_data()}
	if type(project_info) ~= 'table' then return end 
	project_info.data = project_info.data or {}
	local attributes,tpldata = project_info.data.attributes,project_info.data.structure
	if project_info.pop then 
		local function on_ok(arg)
			attributes = arg
		end
		dlg_info_.pop{data = attributes,on_ok = on_ok}
	end
	return project_info,attributes,tpldata
end

	
local function save_project_files(arg)
	if type(arg) ~= 'table' then return end 
	local zipfile = arg.zipfile
	local data = arg.data
	for k,v in ipairs (data) do 
		if  v.id  and v.str then 
			disk_.save_to_zipfile(zipfile, v.id,v.str )
		end
	end	
end

local function project_turn_zipdata(arg)
	local saveData = {}
	local gid = arg.gid
	if not gid then return end 
	saveData[gid] = {}
	saveData[gid].id =gid
	local gidData = version_.get_gid_data{gid = gid,name = arg.name,info =  arg.info,versions = {}}
	saveData[gid].str  = disk_.serialize_to_str(gidData) 
	local data =arg.tpl 
	if type(data) == 'table' and not table_is_empty(data) then
		local function loop_data(data,id)
			local folderIndexData =  {}
			for k,v in ipairs(data) do 
				local attr = type(v) == 'table' and v.attributes
				if  type(attr) == 'table' then 
					local gid = luaext_.guid() 
					if #v  ~= 0  then 
						gid = gid .. '0'
						loop_data(v[1],gid)
					else 
						gid = gid .. '1'
						if attr.info and attr.info.disklink then 
							table.insert(saveData,{str = disk_.read_file(attr.info.disklink,'string'),id =  project_.get_folder_indexId(gid)})
						end
					end
					table.insert(saveData,{str =disk_.serialize_to_str( version_.get_gid_data{gid = gid,name = attr.name,info =  attr.info,versions = {}} ) ,id =  gid})
					table.insert(folderIndexData,version_.get_folder_data{name = attr.name,gid = gid})
				end
			end
			table.insert(saveData,{str =disk_.serialize_to_str( folderIndexData ),id =   project_.get_folder_indexId(id)})
		end
		loop_data(data,gid)
	end
	return saveData
end


function project_new()
	local project_info,attributes,tpldata = get_project_data()
	if type(project_info) ~= 'table' then return end 
	local gid = luaext_.guid() .. '0'
	local filename = project_info.name .. '.apc'
	local path = project_.get_project_path()
	local zipfile =  path.. filename
	disk_.create_project(zipfile,gid)
	local posid = tree_.add_project{name =  project_info.name,file = zipfile}
	local data = project_turn_zipdata{gid = gid,name = project_info.name,tpl = tpldata,info = attributes}
	save_project_files{zipfile = zipfile,data = data}
	if project_info.open then 
		tree_.set_marked(posid)
		project_open()
	end
end

function open_folder(id)
	local tree = tree_.get()
	local tid =id or  tree_.get_id()
	if not tid then return end 
	local data = tree:get_node_data(tid)
	if not data or data.opened then return end
	data.opened = true
	tree:set_node_data(data,tid)
	local gid = data.gid or project_.project_index_id()
	if not gid then return end 
	if string.sub(gid,-1,-1) == '1' then return end 
	local nextIndexId = project_.get_folder_indexId(gid)
	project_.add_cache_data(nextIndexId)
	local data = project_.get_id_data(nextIndexId)
	for k,v in ipairs(data) do 
		if v.gid then 
			local nextIndexId = project_.get_folder_indexId(v.gid)
			project_.add_cache_data(nextIndexId)
		end
	end
	tree_.open_folder(tid)
end

local function open(data,id)
	project_.set(data.file)
	project_.open()
	local gid = project_.project_index_id()
	if not gid then return end 
	local nextIndexId = project_.get_folder_indexId(gid)
	if not nextIndexId then return end 
	project_.add_cache_data(nextIndexId)
	local data = project_.get_id_data(nextIndexId)
	if data then 
		tree_.add_folder_list(data,id)
		open_folder(id)
	end
end

project_open = function ()
	local tree = tree_.get()
	local id =tree:get_tree_selected()
	if not id then return end 
	local data = tree:get_node_data(id)
	if type(data) ~= 'table' or not data.file  then return end 
	local pro = project_.get()
	if  pro and  data.file ~= pro then
		if not project_close('Open') then return end 
	end 
	open(data,id)
	data.opened = true
	tree:set_node_data(data,id)
end

project_save = function (f)
	local zipfile = project_.get()
	if not zipfile then return end
	local id = tree_.get_index_id(zipfile)
	if not id then return end 
	project_.save()
end

function project_delete()
end

function project_close(str)
	if str and str == 'Open' then 
		local a =  iup.Alarm('Notice','Whether to quit and save the existing project  ? ','yes','no')
		if a  ~= 1 then return  end 
	end
	project_save()
	tree_.close_project()
	project_.init()
	return true
end