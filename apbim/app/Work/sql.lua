require "app.Work.ado"

function open_access(mdb)
	--AccessDatabaseEngine_X64.exe
	local str = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=test.mdb"
	-- local str = string.format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=test.mdb=%s",mdb)
	local db = ADO_Open(str)
	return db
end

function open_sqlserver(server,database,uid,pwd)
	-- local str = "Provider=SQLOLEDB;Server=BETTER-PC;Database=master;uid=sa;pwd=hello"
	local str = string.format("Provider=SQLOLEDB;Server=%s;database=%s;uid=%s;pwd=%s",server,database,uid,pwd)
	db = ADO_Open(str)
	return db
end

function open_mysql(server,port,database,uid,pwd)
	-- 控制面板-管理工具-ODBC数据源
	-- local str = 'Driver={MySQL ODBC 5.3 ANSI Driver};Server=localhost;Port=3306;Database=test;User=root;Password=hello;Option=4;'
	local str = string.format("Driver={MySQL ODBC 5.3 ANSI Driver};Server=%s;Port=%s;Database=%s;uid=%s;pwd=%s",server,port,database,uid,pwd)
	db = ADO_Open(str)
	return db
end


-- local db = open_access('test.mdb')
-- local db = open_sqlserver('BETTER-PC','master','sa','hello')
-- local db = open_mysql('localhost',3306,'test','root','hello')
-- db:exec("create table test (name char(30), phone char(20))")
-- db:exec("insert into test values ('Bill Gates', '666-6666')")
-- db:exec("insert into test values ('Paul Allen', '606-0606')")
-- db:exec("insert into test values ('George Bush', '123-4567')")
-- db:exec("select * from test where name <> 'Bill Gates'")
-- db:exec('SELECT TOP 1000 [name],[phone] FROM [master].[dbo].[test]')
-- t = db:row()
-- while t ~= nil do
	-- trace_out(tostring(t.name).."\t"..tostring(t.phone)..'\n')
	-- t = db:row()
-- end
-- db:exec("drop table test")
-- db:close()
