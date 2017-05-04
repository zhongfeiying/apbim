_ENV = module(...,ap.adv)
--去除头文件
local function remove_root(t,str)
	local t_new = {};
	for k ,v in pairs(t) do
	local m = string.match(v,str.."(.+)")
	table.insert(t_new,m)
	end
	return t_new;
end
--去除目录下所有的文件字符串
local	function get_all_files(dir_name)
			local i, files, popen = 0, {}, io.popen;
			for file_path in popen('dir "'..dir_name..'" /s /b /a-d'):lines() do
				i = i + 1
				files[i] = file_path
			end
			local files_new = remove_root(files,dir_name)
			return files_new
end
--将一个表复制到另一个新表
local function copy_to_t(t)
	local t_new = {};
	for k,v in pairs (t) do 
		t_new[k] = v
	end
	return t_new;
end


--功能       ： 返回文件标记为 本地 
--参数       ： 本地文件路径（字符串） 例： str = "text"
--返回值     ： 一个新的tab 内容为t = {text = "local"}
function get_file(str)
	local files = get_all_files(str)
	local t = {};
	for k,v in pairs(files) do 
		t[v] = "local"
	end 
	return t ;
end

--功能       ： 返回文件标记为 服务器
--参数       ： 服务器上的 文件的路径   例如 t = {{filename = "text"},{filename = "uuu"}}        
--返回值     ： 一个新的tab 内容为    new = {text = “server”,uuu = "server"}
function tab_new(t)
	local new = {};
	for k,v in pairs(t) do 
		new[v.filename] = "server"
	end
	return new
end

--功能       ： 查出两个tab中相同的文件路径 标记为两者都可以
--参数       ： 两个不同途径 的 文件的路径    t_user为服务器返回的tab 如 t_user = {text = “server”,uuu = "server"}   &  t_loc为本地返回的tab 如  t_loc = {text = “local”}
--返回值     ： 一个新的tab，  将参数全加入一个新table中，k相同 则v = “both”  如t = {text = "both",uuu = "server"}
function double_key(t_user,t_loc)
	local t = copy_to_t(t_user)
	for k,v in pairs (t_loc) do 
			if t[k] then t[k] = "both"
			else t[k] = "local" 
			end
	end	
	return t;
end


