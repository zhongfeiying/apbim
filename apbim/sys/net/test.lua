_ENV = module(...,ap.adv)

local name_putkey = 'net_test_putkey.lua'
local name_send = 'net_test_send.lua'
local path_src = 'sys/net/__temp/test/'
local path_dst = 'sys/net/__temp/test/'

local stime_ = os.clock();

local ts = {
	-- {name=name_putkey,path=path_src,typef=require'sys.net.file'.putkey};
	-- {name=name_send,path=path_src,typef=require'sys.net.file'.send};
	-- {name=name_putkey,path=path_dst..name_putkey..'.lua',typef=require'sys.net.file'.get};
	{name=name_send,path=path_dst,typef=require'sys.net.file'.get};
};

function test()
	require'sys.net.file'.load_s(ts,function()trace_out('Net Test:'..os.clock()-stime_..'s.\n')end);
end
-- test();

