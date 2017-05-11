--module(...,package.seeall)
_ENV = module(...,ap.adv)

local import_counts_ = 0
local function insert_name(db,name,type)
	import_counts_= import_counts_ + 1
	local tab = {}
	tab.name = name
	if type == "branchname" then 
		tab.datas = {};
	end 
	table.insert(db,tab);
end

local function get_db(db,pos,type)
	local cur_floor = math.floor(pos/4)
	if type == "leafname" then 
		cur_floor = cur_floor -1;
	end 
	if cur_floor == 0 then 
		return db;
	end 
	while (cur_floor > 0) do 
		db = db[#db].datas;
		cur_floor = cur_floor - 1;
	end 
	return db;
end 

local function insert_data(line,db)
	if string.find(line,"[^|^ ]+") then 
		local pos = 0;
		local save_str = nil;
		local save_type = nil;
		while pos do 
			pos = string.find(line,"%S+",pos+1)
			if string.sub(line,pos,pos) ~= "|" and string.sub(line,pos,pos) ~= "\\" and string.sub(line,pos,pos) ~= "+" then 
				save_str = string.sub(line,pos,-1)
				save_type = "leafname"
				insert_name(get_db(db,pos,save_type),save_str,"leafname")
				break;
			end
			if  string.sub(line,pos,pos) == "+" or string.sub(line,pos,pos) == "\\" then 
				save_str = string.sub(line,pos+4,-1)
				save_type = "branchname"
				insert_name(get_db(db,pos,save_type),save_str,"branchname")
				break;
			end
		end
	end 
end

local function get_data(datas,cur_path)
	--local num,db,path,popen,cur_path = 0,datas_.datas,datas_.name,io.popen,datas_.name .. "\\";
	local num = 0
	--cur_path = string.gsub(cur_path,"\\","\\\")
	if string.sub(cur_path,-1,-1) == "\\" then 
		cur_path = string.sub(cur_path,1,-2)
	end 
	trace_out("cur_path = " .. cur_path .. "\n")
	for line in io.popen("tree /f /a " .. "\"" .. cur_path .. "\""):lines() do
		num = num + 1;
		if num  >= 4 then 
			if string.find(line,"没有子文件夹") then return  end 
			if string.find(line,"%S+") then 
				insert_data(line,datas)
			end 
		end
	end
end

function get_folder_content(cur_path) --获得文件夹内容；
	import_counts_ = 1
	local data,tab = {},{}
	--local str = string.reverse(cur_path)
	-- tab.name = string.reverse(string.sub(str,1,string.find(str,"\\") -1))
	-- if not string.find(tab.name,"%S+") then 
		-- tab.name = string.gsub(cur_path,"\\","/")
	-- end
	-- if string.sub(cur_path,-1,-1) == "\\" then 
		-- cur_path = string.sub(cur_path,1,-2)
	-- end 
	
	tab.name = string.match(cur_path,".+\\(.+)") or cur_path
	if string.sub(tab.name,-1,-1) == "\\" then 
		tab.name = string.sub(tab.name,1,-2)
	end 
	tab.datas = {}
	get_data(tab.datas,cur_path)
	table.insert(data,tab)
	return data,import_counts_
end

function get_cur_folder_content(cur_path)
	local datas = {}
	if string.sub(cur_path,-1,-1) == "\\" then 
		cur_path = string.sub(cur_path,1,-2)
	end 
	for line in io.popen("dir /b /a-d-h " .. "\"" .. cur_path .. "\""):lines() do
		table.insert(datas,{name = line})
	end
	for line in io.popen("dir /b /ad " .. "\"" .. cur_path .. "\""):lines() do
		table.insert(datas,{name = line,datas = {}})
		for line in io.popen("dir /b /a-h " .. "\"" .. cur_path .. "\\" .. line .. "\""):lines() do 
			table.insert(datas[#datas].datas,{name = line})
			break;
		end 
	end
	return datas;
end

function makedir(dir)
	if not dir then return end 
	os.execute("if not exist " .. "\"" .. dir .. "\"" .. " mkdir " .. "\"" .. dir .. "\"");
end 

--离散文件取id文件前两位建立文件夹存储并且返回文件相对存储路径
function get_dir(file,path)
	local dir = string.sub(file,1,2)
	if path then 
		makedir(path .. dir .. "\\")
	end 
	return dir .. "\\"
end 

