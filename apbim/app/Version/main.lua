_ENV = module(...,ap.adv)
local version_op_ = require "app.Version.version_op"

function on_load()
	require"app.Version.function".load();
end

function on_init()
end

function on_esc()
end
-------------------------------------------------------------------------------------------------------

-- add(gid,content,type,msg) --参数分别是 gid、文件内容、类型：是否为文件（file or dir）、消息 add 有添加与提交的功能

-- append(gid,content,type,ver)--参数分别是 gid、文件内容、类型：是否为文件（file or dir）、版本
-- get(gid,ver,type) --参数分别是 gid、版本 、类型：是否为文件（file or dir）

-- push(gid,type)--参数分别是 gid、文件内容、类型：是否为文件（file or dir）、消息
--pull(gid,type)--参数分别是 gid 、类型：是否为文件（file or dir）

function  add(gid,content,type,msg) 
	version_op_.add(gid,content,type,msg) 
end 

function  append(gid,content,type,ver)
	version_op_.putkey(gid,content,type,ver)
end 

function  get(gid,ver,type)
	return version_op_. get(gid,ver,type)
end 

function  push(gid,type)
	version_op_. push(gid,type)
end 

function  pull(gid,type)
	version_op_.pull(gid,type)
end 



