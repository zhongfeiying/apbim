local require = require
local type = type
local pairs = pairs
local string = string

_ENV = module(...)

local IO = require'sys.io'
local Mgr = require'sys.mgr'
local Iup = require'sys.iup'
local Code = require'sys.api.code'

local Link_SQLServer = require"app.Work.Link_SQLServer".Class
local Report_Dlg = require'app.Work.link_report_dlg'

local function export_items(its)
	local str = Iup.save_file_dlg{extension="LUA";directory="C:\\";};
	if not str or str=="" then return end
	if type(its)~='table' then return end
	require'app.Contacts.File.file_op'.save_table_to_file(str,its);
	Code.save{file=str,data=its,returnKey=true};
end

local function import_items(sc)
	sc = sc or Mgr.new_scene{name='Import'};
	local str = Iup.open_file_dlg{extension="LUA";directory="C:\\";};
	if not str or str=="" then return end
	local its = IO.read_file{file=str,key='db'};
	if type(its)~='table' then return end
	for k,v in pairs(its) do
		Mgr.add(v);
		Mgr.draw(v,sc);
	end
	Mgr.update(sc);
end

function Import_Lua(sc)
	import_items(sc);
end

function Export_Lua(sc)
	export_items(Mgr.curs());
end

function Link_Show(sc)
	require'app.Work.link_dlg'.pop();
end

local function is_link(str,f)
end

local function is_link(it,f)
end

function Link_Find(sc)
	local str = Iup.open_file_dlg{extension='LUA';directory='C:\\';}
	if not str or str=='' then return end
	if not IO.is_there_file(str) then return end
	str = string.sub(str,1,-5);
	_G.package.loaded[str] = nil;
	local f = require(str);
	
	local all = Mgr.get_class_all(Link_SQLServer);
	if type(all)~='table' then return end
	
	for k,v in pairs(all) do
		local t = require'app.Work.SQLServer_dlg'.get_sql_row(v.src.Table,v.src.id)
		if type(t)=='table' then
			if f(t) then
				local it = Mgr.get_table(v.dstid);
				Mgr.select(it,true);
				Mgr.redraw(it);
			end
		end
	end
	Mgr.update(sc);
end

function Link_Report_Selection(sc)
	local s = Mgr.curs();
	Report_Dlg.pop{src=s};
end

function Link_Report_View(sc)
	local s = Mgr.get_scene_all(sc);
	Report_Dlg.pop{src=s};
end

function Link_Report_All(sc)
	local s = Mgr.get_all();
	Report_Dlg.pop{src=s};
end

