_ENV = module(...,ap.adv)

local iup_ = require"iuplua";

-- t={extension=;directory=;}
function open_file_dlg(t)
	local extension = t and t.extension or "*";
	local directory = t and t.directory or "";
	
	local dlg = require"iuplua".filedlg{ filter = "*." .. extension , filterinfo = extension .." files",directory =directory;NOCHANGEDIR = "YES"}
    local file = "";
	dlg:popup()
    if dlg.status ~= "-1" then
        file = dlg.value;
    end
	return file
end

-- t={extension=;directory=;}
function save_file_dlg(t)
	local extension = t and t.extension or "*";
	local directory = t and t.directory or "";

    local dlg = require"iuplua".filedlg{ dialogtype="SAVE", filter = "*." .. extension , filterinfo = extension .." files",directory =directory;NOCHANGEDIR = "YES"}
	local file = "";
    dlg:popup()
    if dlg.status ~= "-1" then
        file = dlg.value
		if t.extension and(not string.find(file,extension)) then
			file = file .. "."	.. extension;
		end
	end
	return file
end

-- require "project_info".get_path()
-- t={directory=;}
function open_dir_dlg(t)
	local directory = t and t.directory or "";
	local dlg = require"iuplua".filedlg{DIALOGTYPE = "dir",directory =directory;NOCHANGEDIR = "YES" }
	local dir = nil;
	dlg.DIRECTORY = directory;
	dlg:popup()
    if dlg.status ~= "-1" then
        dir = dlg.value;
    end
	if not dir then return nil end
	return string.sub(dir,-1)=="\\" and dir or dir.."\\";
	-- return dir.."\\";
end

--栾盛业------START-----------------------------------------------------
--2013-11-12------------------------------------------------------------

--查找所有文件（非目录）
function get_all_files_main_dir(dir_name)
	local i, files, popen = 0, {}, io.popen;
	for file_path in popen('dir "'..dir_name..'"  /b /a-d'):lines() do
		i = i + 1
		files[file_path] = dir_name  .. file_path
	end
	return files
end


function get_files_in_dir(dir_name)
	local i, t, popen = 0, {}, io.popen;
	for filename in popen('dir "'..dir_name..'" /b '):lines() do
	  i = i + 1
	  t[i] = filename
	end
	return t
end

--查找所有文件（非目录）及子目录下文件路径
local function get_all_files(dir_name)
	local i, files, popen = 0, {}, io.popen;
	for file_path in popen('dir "'..dir_name..'" /s /b /a-d'):lines() do
		i = i + 1
		files[i] = file_path
	end
	return files
end

--根据文件路径取文件名
function get_file_name(file_path)
	local addr = 0;
	for i = -1, -#file_path, -1 do
		addr = string.find(file_path,"\\",i)
		if addr ~= nil then
			return string.sub(file_path,addr+1,#file_path)
		end
	end
end

--查找所有目录及子目录
local function get_all_dirs(dir_name)
	local i, dirs, popen = 0, {z}, io.popen;
	for dirname in popen('dir "'..dir_name..'" /s /b /ad'):lines() do
		i = i + 1
		dirs[i] = dirname
	end
	return dirs
end

--处理服务器路径
local function deal_serverpath(spath)
	local flag = 0
	for i = -1 , -#spath, -1 do
		local f = string.find(spath,"\\",i)
		if f ~= nil then flag = f break end
	end
	if flag == 0 then return "" end
	return string.sub(spath,1,flag-2)
end

--处理目录
local function deal_dir(dir)
	local d = {};
	for v in string.gmatch(dir,"[^\\\\]+") do
		d[#d+1] = v;
	end
	return d
end

--处理文件路径
local function deal_file_in_dir(dir, files)
	local f = {}
	for k,v in pairs(files) do
		if k ~= "dirs" then
			if dir == deal_serverpath(v.server_path) then
				table.insert(f,v.name)
			end
		end
	end
	return f
end

--获取目录树
local function get_dir_tree(files, path)
	local tree = {};
	table.insert(tree,{dir = {"",}, files = deal_file_in_dir("", files), local_path = string.sub(string.format("%q",path),2,#string.format("%q",path)-1), server_path = [[\\]]})
	for k,v in pairs(files.dirs) do
		local d = deal_dir(v);
		local f = deal_file_in_dir(v, files)
		table.insert(tree,{dir = d, files = f, local_path = string.sub(string.format("%q",path),2,#string.format("%q",path)-1)..v..[[\\]], server_path = [[\\]]..v..[[\\]]})
	end
	return tree
end

--获取文件服务器路径
local function get_file_serverpath(file_path, path)
	return string.sub(file_path,#path + 1,#file_path)
end

--根据绝对路径获取目录相对路径
local function get_dir_path(file_path, path)
	return string.sub(file_path,#path + 1,#file_path)
end

--获取文件及目录Table
function get_files_in_dir_sub(path)
	local files, dirs = {},{};
	local all_file = get_all_files(path);
	if all_file ~= nil then
		for i = 1,#all_file do
			local fname = get_file_name(all_file[i])
			local spath = get_file_serverpath(all_file[i],path)
			files[i] = {name = fname, path =  (string.gsub([=[]=]..all_file[i] ,[[\]],[[\\]])), server_path = (string.gsub([=[]=]..spath ,[[\]],[[\\]]))}
		end
	end
	local all_dirs = get_all_dirs(path)
	if all_dirs ~= nil then
		for i = 1 ,#all_dirs do
			local dir,path = (string.gsub([=[]=]..all_dirs[i] ,[[\]],[[\\]])),(string.gsub([=[]=]..path ,[[\]],[[\\]]))
			dirs[i] = get_dir_path(dir, path);
		end
		files.dirs = dirs
	end
	files.tree = get_dir_tree(files, path)
	return files
end

function write_files_dirs(files_dirs, fd_path)
	local files = io.open(fd_path, "w");
	files:write("files = {\n");
	for k,v in pairs(files_dirs) do
		if k ~= "dirs" and k ~= "tree" then
			files:write('\t{name="' .. v.name .. '",path="' .. v.path .. '", server_path = "'  .. v.server_path .. '"},\n');
		end
	end
	files:write("\tdirs = {--目录列表\n");
	for k,v in pairs(files_dirs.dirs) do
		files:write('\t\t{"' .. v .. '\\\\'..'"},\n');
	end
	files:write("\t},\n");
	files:write("\ttree = {\n");
	for k,v in pairs(files_dirs.tree) do
		files:write("\t\t{\n");
		files:write('\t\t\tdir = {');
		for dk,dv in pairs(v.dir) do
			if dk ~= #v.dir then
				files:write('"' .. dv .. '",');
			else
				files:write('"' .. dv .. '"');
			end
		end
		files:write('},\n');
		files:write('\t\t\tfiles = {');
		for fk,fv in pairs(v.files) do
			if fk ~= #v.files then
				files:write('"' .. fv .. '",');
			else
				files:write('"' .. fv .. '"');
			end
		end
		files:write('},\n');
		files:write('\t\t\tlocal_path = "'..v.local_path..'",\n');
		files:write('\t\t\tserver_path = "'..v.server_path..'"\n');
		files:write("\t\t},\n");
	end
	files:write("\t}\n}");
	io.close(files);
end

--判断目标文件夹存在，不存在则创建
function create_dir(dir_name)
	if dir_name ~= nil then
		os.execute("if not exist "..dir_name.." mkdir "..dir_name)
	end
end

--栾盛业--------END---------------------------------------------------
--2013-11-12------------------------------------------------------------




