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

-- add(gid,content,type,msg) --�����ֱ��� gid���ļ����ݡ����ͣ��Ƿ�Ϊ�ļ���file or dir������Ϣ add ��������ύ�Ĺ���

-- append(gid,content,type,ver)--�����ֱ��� gid���ļ����ݡ����ͣ��Ƿ�Ϊ�ļ���file or dir�����汾
-- get(gid,ver,type) --�����ֱ��� gid���汾 �����ͣ��Ƿ�Ϊ�ļ���file or dir��

-- push(gid,type)--�����ֱ��� gid���ļ����ݡ����ͣ��Ƿ�Ϊ�ļ���file or dir������Ϣ
--pull(gid,type)--�����ֱ��� gid �����ͣ��Ƿ�Ϊ�ļ���file or dir��

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



