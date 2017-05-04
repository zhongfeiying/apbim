_ENV = module(...,ap.adv)

--[[
db ={
	[gid]={--消息id（global）
		rid=,--回复或转发的主消息id（root）
		pid=,--回复或转发的消息id（parent）
		Code=,--消息生成的代码段
		Name=,--消息标题
		Text=,--消息内容（可无）
		View={},--sys.Group对象（制作消息时的视图）
		Marks={--消息关联的构件ids
			[gid]=true,
			...
		};
		Files={--附件
			[1]={--文件id（hash）
				hid=,--文件id（hash）
				Type=,--类型（图纸、文档）
				Name=,--文件名（不包含路径）
				Path=,--文件路径（本地路径，未下载无路径）
				Text=,--文件说明（可无）
				View={},--sys.Group对象（添加时的视图）
			},
			...
		},
		Channel=,--是否广播频道消息
		From=,--发送人
		To=,--接收人
		Send_Time=,--发送时间
		Arrived=,--是否送达
		Arrived_Time=,--送达时间
		Read=,--是否阅读
		Read_Time=,--阅读时间
		Read_cbf,--阅读的回调函数
		Confirm=,--确认内容（true或者string）
		Confirm_Time=,确认时间
		Confirm_cbf=,确认的回调函数
		exe_cbf=--消息执行的回调函数
	},
	...
}
--]]
local db_ = {};
local env_ = {};
local rcvfs_ = {};

local CFG_FILE = '__msg_list.lua';
local CFG_PATH = require'sys.mgr'.get_path()..'msg\\';
local CFG_KEY = 'db';
local DB_PATH = require'sys.mgr'.get_db_path();
local EXNAME = '.lua';
local FLAG = '84753206=2'
require'sys.api.dos'.md(CFG_PATH);

local function call_rcvfs(id)
	for i,v in ipairs(rcvfs_) do
		v(id);
	end
end

local function add_id(id)
	-- local old = db_[id];
	db_[id] = db_[id] or {};
	return id;
end

function get_msg(id)
	-- db_[id] = db_[id] or {}
	return db_[id];
end

function get_all()
	return db_;
end

function del_msg(id)
	db_[id] = nil;
end

function add_envf(name,f)
	env_[name] = f;
end

function resgister_rcvf(f)
	if type(f)=='function' then table.insert(rcvfs_,f) end
end


local function send_arrived_report(id,user)
	local msg = get_msg(id);
	if type(msg)~="table" then return end
	if msg.Arrived_Report or require"sys.mgr".get_user()==user then return end
	local time = os.time();
	local str = 'ap_set_msg_id("'..id..'") ap_set_msg_type_report() ap_set_msg_arrived(true) ap_set_msg_arrived_time('..time..') \n'
	require"sys.net.main".send_msg(user,str);
	-- msg.Arrived = true;
	-- msg.Arrived_Time = time;
	msg.Arrived_Report = true;
	add_msg{Code=str}
end

local function send_read_report(id,user)
	local msg = get_msg(id);
	if type(msg)~="table" then return end
	if msg.Read_Report or require"sys.mgr".get_user()==user then return end
	local time = os.time();
	local str = 'ap_set_msg_id("'..id..'") ap_set_msg_type_report() ap_set_msg_read(true) ap_set_msg_read_time('..time..') \n'
	require"sys.net.main".send_msg(user,str);
	-- msg.Read = true;
	-- msg.Read_Time = time;
	msg.Read_Report = true;
	add_msg{Code=str}
end

local function send_confirm_report(id,user,arg)
	local msg = get_msg(id);
	if type(msg)~="table" then return end
	if msg.Confirm_Report or require"sys.mgr".get_user()==user then return end
	local time = os.time();
	local arg_str = type(arg)=='string' and string.format("%q",arg) or tostring(arg)
	local str = 'ap_set_msg_id("'..id..'") ap_set_msg_type_report() ap_set_msg_confirm('..arg_str..') ap_set_msg_confirm_time('..time..') \n'
	require"sys.net.main".send_msg(user,str);
	-- msg.Confirm = true;
	-- msg.Confirm_Time = time;
	msg.Confirm_Report = true;
	add_msg{Code=str}
end

local function get_code_id(id)
	return 'ap_set_msg_id("'..(id or require"luaext".guid())..'") \n';
end

local function get_code_name(str)
	return 'ap_set_msg_name("'..(str or "Unname")..'") \n';
end

local function get_code_text(str)
	-- return 'ap_set_msg_text("'..(str or "")..'") \n';
	return 'ap_set_msg_text('..string.format("%q",(str or ""))..') \n';
end

local function get_code_from(str)
	return 'ap_set_msg_from("'..(str or require"sys.mgr".get_user())..'") \n';
end

local function get_code_to(str)
	return 'ap_set_msg_to("'..str..'") \n';
end

local function get_code_send_time(num)
	return 'ap_set_msg_send_time('..(num or os.time())..') \n';
end

local function get_code_arrived_report(id,b)
	return b and 'ap_send_arrived_report("'..id..'","'..require"sys.mgr".get_user()..'") \n' or ''
end

local function get_code_read_report(id,b)
	return b and 'ap_set_msg_read_cbf(function() ap_send_read_report("'..id..'","'..require"sys.mgr".get_user()..'") end) \n' or ''
end

local function get_code_confirm_report(id,b)
	return b and 'ap_set_msg_confirm_cbf(function(arg) ap_send_confirm_report("'..id..'","'..require"sys.mgr".get_user()..'",arg) end) \n' or ''
end

local function get_code_channel()
	return 'ap_set_msg_type_channel() \n';
end

local function get_code(t)
	local id = t.id or require"luaext".guid();
	local str = "";
	str = str..get_code_id(id);
	str = str..get_code_name(t.Name);
	str = str..get_code_text(t.Text);
	str = str..get_code_from(t.From);
	str = str..get_code_to(t.To);
	str = str..get_code_send_time(t.Send_Time);
	str = str..get_code_arrived_report(id,t.Arrived_Report);
	str = str..get_code_read_report(id,t.Read_Report);
	str = str..get_code_confirm_report(id,t.Confirm_Report);
	str = str..t.Code;
	return str;
end

-- t={Code=}
local function load_code(t)
	if not t.Code then return end
	local msgid,is_msg_report = nil,nil;
	function ap_get_id() return msgid end;
	function ap_get_msg() return get_msg(msgid) end;
	add_envf("ap_set_msg_id",function(id) msgid=add_id(id) end);
	-- add_envf("ap_get_msg_id",function() return msgid end);
	-- add_envf("ap_get_msg",function() return get_msg(msgid) end);
	add_envf("ap_this_msg",function() return get_msg(msgid) end);
	add_envf("ap_set_msg_type_report",function() is_msg_report=true end);
	require'sys.net.env'.add(ap_get_id,ap_get_msg);
	add_envf("ap_send_arrived_report",send_arrived_report);
	add_envf("ap_send_read_report",send_read_report);
	add_envf("ap_send_confirm_report",send_confirm_report);
	if type(t.Code)~="string" then require"sys.str".totrace("sys.net.msg.rcv(), load msg error:\n"..tostring(t.Code).."\n") return end
	local f = load(t.Code,'sys.net.msg.load_code()','bt',env_);
	if type(f)~="function" then require"sys.str".totrace("sys.net.msg.rcv(), load msg error:\n"..t.Code.."\n") return end
	local result = f();
	if type(msgid)~="string" then require"sys.str".totrace("sys.net.msg.rcv(), error: msgid is nil.\n"..t.Code.."\n") return end
	if is_msg_report then return end
	get_msg(msgid).Code = t.Code;
end

-- t={Code=,From=,To=,File=}
local function tofile(t)
	local dt = require'sys.dt'.time_text(os.time());
	local f=io.open(CFG_PATH..t.File,'a');
	f:write('---- ['..t.From..'] ==>> ['..t.To..'] '..dt..'  ----\n');
	f:write(t.Code);
	f:close();
end

-- t={Code=}
function add_msg(t)
	load_code(t)
	update();
end

-- t={hid=,cbf=}
local function download_hid_file(t)
	local name = t.hid;
	local old_file = DB_PATH..name;
	local new_file = DB_PATH..name..EXNAME;
	if require'sys.io'.is_there_file{file=new_file} then t.cbf(new_file) return end
	require'sys.net.file'.get{name=t.hid,path=DB_PATH,cbf=function()
		os.rename(old_file,new_file);
		t.cbf(new_file)
	end}
end

local function get_unhid_flag_str(str)
	local s = 1;
	local e = string.len(FLAG);
	if string.sub(str,s,e)~=FLAG then return end
	-- if string.sub(str,s,e)~=FLAG then require'sys.str'.totrace("get_unhid_flag_str = "..str..'\n'); return end
	return string.sub(str,e+1,-1);
end

-- t={Code=,From=}
function rcv_msg(t)
require"sys.str".totrace('Received a new Message\n');
	-- tofile{Code=str,From=t.From,To=require"sys.mgr".get_user(),File="send_record.lua"};
	local str = get_unhid_flag_str(t.Code);
	if not str then add_msg(t) --[[update()--]] return end
	download_hid_file{
		hid=str,
		cbf=function(file)
			t.Code = require'sys.io'.get_file_str{file=file};
			add_msg(t)
			-- update();
			tofile{Code=t.Code,From=t.From,To=require"sys.mgr".get_user(),File="rcv_record.lua"};
		end
	}
	-- add_msg(t)
end

-- t={Code=,From=}
function rcv_channel(t)
require"sys.str".totrace('Received a new Channel\n');
-- require"sys.table".totrace{rcv=Code};
	local str = get_unhid_flag_str(t.Code);
	if not str then add_msg(t) return end
	download_hid_file{hid=str,cbf=function(file)
		t.Code = require'sys.io'.get_file_str{file=file};
		add_msg(t)
		-- update();
		tofile{Code=t.Code,From=t.From,To=require"sys.mgr".get_user(),File="rcv_record.lua"};
	end}
	-- add_msg(t)
end

-- t={str=,cbf=}
local function upload_hid_file(t)
	local name = require'sys.hid'.str_to_file{str=t.str,path=DB_PATH};
	local old_file = DB_PATH..name;
	local new_file = DB_PATH..name..EXNAME;
	require'sys.net.file'.send{name=name,path=DB_PATH,cbf=function()
		os.rename(old_file,new_file);
		t.cbf(name)
	end}
end

--[[
t={
	rid=,--主消息id
	pid=,--父消息id
	To=,--接收人
	Code=,--代码段
	Name=,--标题
	Text=,--内容
	View={},--sys.Group对象（制作消息时的视图）
	Files={--附件
		[1]={--文件id（hash）
			hid=,--文件id（hash）
			Name=,--文件名（不包含路径）
			Path=,--文件路径（本地路径，未下载无路径）
			Text=,--文件说明（可无）
			View={},--sys.Group对象（制作消息时的视图）
		},
		...
	},
	Arrived_Report=true,--是否要求送达报告
	Read_Report=true,--是否要求已读回执
	Confirm_Report=true--是否要求确认回执
}
--]]
function send_msg(t)
	require"sys.str".totrace('send_msg:\n'..t.Code..'\n');
	local str = get_code(t);
	tofile{Code=str,From=require"sys.mgr".get_user(),To=t.To,File="send_record.lua"};
	require'sys.table'.totrace{send_msg=1}
	upload_hid_file{str=str,cbf=function(name) 
		require'sys.net.main'.send_msg(t.To,FLAG..name)
		add_msg{Code=str}
		-- update();
	end}
end

--[[
t={
	To=,--接收人
	Code=,--代码段
	Name=,--标题
	Text=,--内容
	view={},--sys.Group对象（制作消息时的视图）
	marks={--消息关联的构件ids
		[gid]=true,
		...
	};
	Files={--附件
		[hid]={--文件id（hash）
			Name=,--文件名（不包含路径）
			Path=,--文件路径（本地路径，未下载无路径）
			Text=,--文件说明（可无）
			marks={--消息关联的构件ids
				[gid]=true,
				...
			};
		},
		[1]={--文件id（hash）
			hid=,--文件id（hash）
			Name=,--文件名（不包含路径）
			Path=,--文件路径（本地路径，未下载无路径）
			Text=,--文件说明（可无）
			marks={--消息关联的构件ids
				[gid]=true,
				...
			};
		},
		...
	},
}
--]]
function send_channel(t)
	local str = get_code(t);
	str = str..get_code_channel();
	tofile{Code=str,From=require"sys.mgr".get_user(),To=t.To,File="send_record.lua"};
	upload_hid_file{str=str,cbf=function(name) 
		require'sys.net.main'.send_channel(t.To,FLAG..name)
		add_msg{Code=str}
		-- update();
	end}
end

local function unit_table(t)
	for k in pairs(t.src) do
		if not t.dst[k] then t.dst[k]=v end
	end
end

local function open()
	local name = require'sys.mgr'.get_user()..CFG_FILE;
	local path = CFG_PATH;
	local s = require"sys.io".read_file{file=path..name,key=CFG_KEY}
	if type(s)~="table" then return end
	for k,v in pairs(s) do
		if not db_[k] then db_[k]=v end
		unit_table{src=v,dst=db_[k]};
		load_code(v);
	end
end

local function save()
	t = t or {}
	local name = require'sys.mgr'.get_user()..CFG_FILE;
	local path = CFG_PATH;
	require"sys.table".tofile{file=path..name,src=db_,tip=CFG_KEY}
end
local function save()
	local name = require'sys.mgr'.get_user()..CFG_FILE;
	local path = CFG_PATH;
	require"app.Contacts.File.file_op".save_table_to_file(path..name,db_);
end

-- t={cbf=}
function download(t)
	t = t or {}
	os.remove(CFG_PATH..require'sys.mgr'.get_user()..CFG_FILE);
	local name = require'sys.mgr'.get_user()..CFG_FILE;
	local path = CFG_PATH;
	require"sys.net.file".get{name=name;path=path;cbf=t.cbf};
	-- require"sys.net.file".get{
		-- name = name;
		-- path = path;
		-- cbf = function()
			-- open();
			-- if type(t.cbf)=='function' then t.cbf() end
		-- end
	-- }
end

-- t={cbf=}
function upload(t)
	t = t or {}
	local name = require'sys.mgr'.get_user()..CFG_FILE;
	local path = CFG_PATH;
	-- require"sys.table".tofile{file=path..name,src=db_,tip=CFG_KEY}
	require"sys.net.file".putkey{name=name;path=path;cbf=t.cbf}
end

function update_net()
	open();
	download{cbf=function()
		open();
		save();
		upload{cbf=function()
			call_rcvfs();
		end};
	end}
end
function update_net()
	open();
	save();
	upload{
		cbf=function()
			download{
				cbf=function()
					open();
					save();
					call_rcvfs();
				end
			};
		end
	}
end
function update()
	open();
	save();
	call_rcvfs();
end
update();
