_ENV = module(...,ap.adv)

local warnings_ = {};
local warnings_file_ = 'apx/dxf/Warning.lua'

local function Trace_Warning(name)
	local bool = warnings_[name];
	if not bool then
		warnings_[name] = true;
		require'sys.str'.totrace('Warning: '..name..'\n');
	end
end

-- arg={dxf,DXF}
function Read(arg)
	-- local dxf = require'apx.dxf.array'.Read(arg.file);
	-- local DXF = require'apx.dxf.DXF'.Class:new{Index=arg.key};
	-- DXF.Model = require'sys.mgr'.get_all();
	-- DXF.ids = require'sys.table'.index(DXF.Model,function(k,v) return type(v)=='table' and v[arg.key] or v.mgrid end)
	local dxf = arg.dxf;
	local DXF = arg.DXF;
	
	local function Loop_Sec(dx,sec)
		local run = require"sys.progress".create{title="DXF "..sec.Value,count=require"sys.table".count(sec),time=0.1,update=false,statusbar=false};
		for i,v in ipairs(sec) do
			local name = (sec.Value or '')..'\\'..(v.Value or '__Default');
			local f = require'apx.dxf.Tools'.Get_SEC_Read_Functon(name)
			if f then f(dxf,dx,i,DXF) else Trace_Warning(name) end
			run();
		end
	end
	local run = require"sys.progress".create{title="DXF",count=require"sys.table".count(dxf),time=0.1,update=false,statusbar=false};
	for i,v in ipairs(dxf) do
		Loop_Sec(i,v);
		run();
	end
	require'sys.table'.tofile{file=warnings_file_,src=warnings_}
end


