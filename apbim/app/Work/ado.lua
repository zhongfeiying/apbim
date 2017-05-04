
require("luacom")
 
local ADO = {}
ADO.__index = ADO
 
function ADO.new(create_string)
local cat = luacom.CreateObject("ADOX.Catalog")
assert(cat)
cat:Create(create_string)
end
 
function ADO_Open(connection_string)
local self = {}
self.connection = luacom.CreateObject("ADODB.Connection")
assert(self.connection)
self.connection.ConnectionString = connection_string
self.connection:Open()
return setmetatable(self,ADO)
end
 
function ADO:close()
self.connection:Close()
self.connection = nil
self.recordset = nil
end
 
function ADO:exec(statement)
 
if statement == "%BEGIN" then
self.connection:BeginTrans()
return
elseif statement == "%COMMIT" then
self.connection:CommitTrans()
return
elseif statement == "%ROLLBACK" then
self.connection:RollbackTrans()
return
end
 
if self.recordset == nil then
self.recordset = luacom.CreateObject("ADODB.RecordSet")
elseif self.recordset.State ~= 0 then
self.recordset:Close()
end
 
self.recordset:Open(statement, self.connection)
 
end
 
 
function ADO:row()
 
if self.recordset == nil then
return nil
elseif self.recordset.ActiveConnection == nil then
return nil
end
 
if self.recordset.EOF == true then
return nil
end
 
local row = {}
local fields = self.recordset.Fields
local i = 0
 
while i < fields.Count do
local field = fields:Item(i)
row[i] = field.Value
row[field.Name] = field.Value
i = i + 1
end
 
self.recordset:MoveNext()
 
return row
 
end


--[[
local db_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=test.mdb"
-- create the database; will throw a COM exception if already exists,
-- so we use pcall()
pcall(ADO.new,db_string)
local db = ADO_Open(db_string)
 
db:exec("create table test (name char(30), phone char(20))")
db:exec("insert into test values ('Bill Gates', '666-6666')")
db:exec("insert into test values ('Paul Allen', '606-0606')")
db:exec("insert into test values ('George Bush', '123-4567')")
 
db:exec("select * from test where name <> 'Bill Gates'")
 
t = db:row()
 
while t ~= nil do
print(tostring(t.name).."\t"..tostring(t.phone))
t = db:row()
end
 
db:exec("drop table test")
db:close()
--]]
