_ENV = module(...,ap.adv)
--路径返回path_a或者文件返回file
local function file_path(str)
	if string.find(str,"\\",-1) then return "path_a"
	else return "file"
    end  	
end
--真文件返回file假文件返回nil
local function file_str(str)
	if io.open(str) then return "file"--file表示是文件，nil表示字符串不存在
	else return "nil"
    end	
end
--真路径返回folder假路径返回nil
local function path_str(str)
	local filename = "wyg.sdr23f435crgvsgf5364fxcdfv"
	local f,f_=io.open(str..filename,"r"),io.open(str..filename,"w")
    if f then  f:close(str..filename) return  "folder" --folder表示是路径，nil表示不存在
	else
		if f_ then f_:close(str..filename) os.remove(str..filename) return "folder"
		else return "nil"
		end
    end
end
--功能：把一个表示形式为一个文件（夹）的字符串，直接创建 文件（夹）。例：“c:\aa\bb\cc\dd.txt”创建到dd.txt
--参数：str，一个字符串，它表示形式是一个文件（夹）
--返回：无
function create(str)
    for i=-1,-string.len(str),-1 do 
		j=string.find(str,"\\",i)
	if j then break end;  	
	end
	local a=string.sub(str,1,j)
	local b=string.sub(str,j+1,-1)
	if file_str(str)=="file" then return end
	os.execute("mkdir ".."\""..a.."\"")
	local f = io.open(str, 'w')
	if string.sub(str,-1,-1)~="\\" then f:close(str) end
end
--功能：把一个表示形式为一个文件（夹）的字符串，判断它是文件，返回file，是文件夹，返回folder，否则是不存在的文件（夹），返回nil。
--参数：str，一个字符串，它表示形式是一个文件（夹）
--返回：返回值是路径则调用路径函数，返回值是文件则调用文件函数
function is_there (str)
	local  c=file_path(str)
   if "file"==c then return file_str(str)
   else return path_str(str)
   end
end
--功能：把一个表示形式为一个文件（夹）的字符串，只创建到它的最后一个文件夹。例：“c:\aa\bb\cc\dd.txt”只创建到cc
--参数：str，一个字符串，它表示形式是一个文件（夹）
--返回：无
function create_folder(str)
	for i=-1,-string.len(str),-1 do 
		j=string.find(str,"\\",i)
	if j then break end;  	
	end
	local a=string.sub(str,1,j)
	local b=string.sub(str,j+1,-1)
	if path_str(a)=="folder" then return end
	os.execute("mkdir ".."\""..a.."\"") 
	io.open(a, 'w')
end