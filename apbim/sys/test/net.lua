
local name_putkey = 'test_net_putkey.lua'
local name_send = 'test_net_send.lua'
local path_src = 'sys/test/net/src/'
local path_dst = 'sys/test/net/dst/'

-- require'sys.net.main'.putkey_file(name,path_src)
-- require'sys.net.main'.send_file(name,path_src)
-- require'sys.net.main'.get_file(name,path_dst)
-- putkey_file('22BIWNIM5B7FQAJ7GA3C7J_1.lua','sys/test/net/src/22BIWNIM5B7FQAJ7GA3C7J_1.lua')
-- get_file('22BIWNIM5B7FQAJ7GA3C7J_1.lua','sys/test/net/dst/22BIWNIM5B7FQAJ7GA3C7J_1.lua')


local stime_ = os.clock();
-- require'sys.net.file'.putkey{name=name,path=path_src,cbf=function()trace_out('putkey: '..name..' endof.\n')end}
-- require'sys.net.file'.send{name=name,path=path_src,cbf=function()--[[trace_out('send: '..name..' endof.\n')--]]end}
-- require'sys.net.file'.get{name=name,path=path_dst,cbf=function()--[[trace_out('get: '..name..' endof.\n')--]]trace_out('Net Test:'..os.clock()-stime_..'s.\n')end}
-- require'sys.net.file'.send{name="cf8bdf3955c7e4670e19e39983128700fb2f2562hid.lua",path=path_src,cbf=function()--[[trace_out('send: '..name..' endof.\n')--]]end}
-- require'sys.net.file'.get{name="tbj__msg_list.lua",path=path_dst,cbf=function()trace_out('get: '..path_dst..' endof.\n')end}

local ts = {
	{name=name_putkey,path=path_src,typef=require'sys.net.file'.putkey};
	{name=name_send,path=path_src,typef=require'sys.net.file'.send};
	{name=name_putkey,path=path_dst,typef=require'sys.net.file'.get};
	{name=name_send,path=path_dst,typef=require'sys.net.file'.get};
};

-- require'sys.net.file'.putkey{name='BETTER__msg_list.lua',path='cfg\\msg\\',cbf=function()trace_out('putkey: '..name..' endof.\n')end}
-- test();

require'sys.net.file'.putkey{name='BETTER__project_list.lua',path='cfg/user/',cbf=function()
	trace_out('putkey: endof.\n')
	require'sys.net.file'.get{name='BETTER__project_list.lua',path='cfg/user/',cbf=function()
		trace_out('get: endof.\n')
	end};
end};


-- require'sys.net.main'.send_file("hid1.lua",path_src)
-- require'sys.net.main'.send_file("hid12.lua",path_src)
-- require'sys.net.main'.send_file("hid123.lua",path_src)
-- require'sys.net.main'.send_file("hid1234.lua",path_src)
-- require'sys.net.main'.send_file("hid12345.lua",path_src)

-- os.rename('DB/2f5b3301d74a1370e405682b257a3b6f63218de4hid','DB/2f5b3301d74a1370e405682b257a3b6f63218de4hid.lua');

-- local ts = {
	-- {name='test1 (1).lua',path=path_src};
	-- {name='test1 (2).lua',path=path_src};
	-- {name='test1 (3).lua',path=path_src};
	-- {name='test1 (4).lua',path=path_src};
-- };
-- require'sys.net.file'.sends(ts,function()trace_out('Net Test:'..os.clock()-stime_..'s.\n')end);

-- local name = 'test_1461571826.lua'
-- local name = "test_"..os.time()..".lua"
-- local path_src = 'sys/test/net/src/'
-- local path_dst = 'sys/test/net/dst/'
-- local f = io.open(path_src..name,'w')
-- f:write('a = a*2 return "x123"');
-- f:close()
-- require'sys.net.file'.putkey{name=name,path=path_src,cbf=function() trace_out('putkey: '..name..' endof.\n') end}
-- require'sys.net.file'.send{name=name,path=path_src,cbf=function() --[[trace_out('get: hid1234.lua endof.\n')--]] trace_out('Net(get) Test:'..os.clock()-stime_..'s.\n') end}
-- require'sys.net.file'.get{name=name,path=path_dst,cbf=function() --[[trace_out('get: hid1234.lua endof.\n')--]] trace_out('Net(get) Test:'..os.clock()-stime_..'s.\n') end}
-- require'sys.net.file'.send{name=name,path=path,cbf=function() trace_out('send: '..name..' endof.\n') require'sys.net.file'.putkey{name=name,path=path,cbf=function() trace_out('putkey: '..name..' endof.\n') end} end}



-- local ct = hub_connect("www.apcad.com",8000);
-- local str = 'TestMsg,'..os.time()
-- trace_out(str..'\n')
-- local s = "sendmsg\r\n" .. 'BETTER' .. "\r\n0\r\n" .. string.len(str) .. "\r\n" .. str .. "\r\n"
-- local prefix = string.len(s) .. "\r\n" .. s
-- hub_send(ct,prefix)
-- trace_out('hub_send\n')

-- require'sys.net.user'.reg{user="tbj",password="0",mail="tbj@qq.com",phone="18642874239",cbf=function(gid)trace_out('reg:'..gid..'\n')end}
-- require'sys.net.user'.reg{user="BETTER_1",password="0",mail="test@qq.com",phone="18642874239",cbf=function(gid)trace_out('reg:'..gid..'\n')end}
-- require'sys.net.user'.reg{user="BETTER_2",password="0",mail="test@qq.com",phone="18642874239",cbf=function(gid)trace_out('reg:'..gid..'\n')end}
-- require'sys.net.user'.reg{user="TestUser",password="123",mail="TestUser@qq.com",phone="0411-84753206",cbf=function(gid)trace_out('reg:'..gid..'\n')end}

-- require'sys.net.main'.send_msg("BETTER",'abc\n)')
-- require'sys.net.main'.send_msg("BETTER",'ap_trace_out("test msg id:"..ap_get_msg_id().."")')

-- require'sys.net.user'.login{user="BETTER_1",password="0",cbf=function(gid)trace_out('login:'..gid..'\n')end}
-- require'sys.net.user'.login{user="BETTER",password="0",cbf=function(gid)trace_out('login:'..gid..'\n')end}

-- local channet_id_ = "test_123"
-- require'sys.net.user'.login{user="BETTER",password="0",cbf=function(gid)
		-- trace_out('login:'..gid..'\n')
		-- require'sys.net.main'.subscribe(channet_id_)
-- end}
