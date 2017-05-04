
local list = {'a','b','c'}
trace_out('loop 1:\n')
for i,v in ipairs(list) do trace_out(i..':'..v..'\n') end
-- list[2] = nil
table.remove(list,2);
trace_out('loop 2:\n')
for i,v in ipairs(list) do trace_out(i..':'..v..'\n') end
trace_out(#list..'#\n')
list[#list+1]='t'
trace_out('loop 3:\n')
for i,v in ipairs(list) do trace_out(i..':'..v..'\n') end

