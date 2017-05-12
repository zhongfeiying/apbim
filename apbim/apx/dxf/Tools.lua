_ENV = module(...,ap.adv)

local EXNAME = ".lua";
local CMD_PATH_ = "apx\\dxf\\CMD\\";
local SEC_PATH_ = "apx\\dxf\\CMD\\SEC\\";

-- t={file=,exname=,functionname=}
function Get_Function(t)
	if require"sys.api.dir".is_there_file(t.file..t.exname) and type(require(t.file))=="table" and type(require(t.file)[t.functionname])=="function" then return require(t.file)[t.functionname] else return nil end
end


function Get_CMD_Read_Functon(name)
	return Get_Function{file=CMD_PATH_..name,exname=EXNAME,functionname="Read"};
end

function Get_SEC_Read_Functon(name)
	return Get_Function{file=SEC_PATH_..name,exname=EXNAME,functionname="Read"};
end

function Is_Sec_End(k,v)
	if not k or not v then return true end
	if k==0 and v=='ENDSEC' then return true end
	if k==0 and v=='EOF' then return true end
end


