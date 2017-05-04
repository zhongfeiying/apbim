_ENV = module(...,ap.adv)

local iup_ = require"iuplua";


-- t={name=,path=,exname=}
function save(t)
	local exname = t.exname and '*.'..t.exname or "*.*"
	local pathname = t.path and (string.sub(t.path,-1)=='\\' or string.sub(t.path,-1)=='/') and t.path..t.anme or t.path or t.name;
	local dlg = iup.filedlg{DIALOGTYPE= "SAVE";rastersize = "1600x800";filter=exname}
	dlg.file = pathname;
	dlg.title = "Save"
	dlg:popup()
	local str = dlg.value;
	if not str then return str end
	if t.exname and require'sys.str'.get_exname(str)~=t.exname then str=str..'.'..t.exname end
	return str;
end

 