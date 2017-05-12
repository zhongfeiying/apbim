_ENV = module(...,ap.adv)

local zip = require "luazip"

local zip_prj = "prj_name.apc";
local zip_ar = nil;

function open_zip()
	--zip_ar = zip.open(zip_prj, zip.CHECKCONS);
	--if(zip_ar ~= nil)then
		zip_ar = zip.open(zip_prj, zip.CREATE);	
		--zip_ar:add_dir("Model");
		--zip_ar:add_dir("res");
	--end	
end



function add_zip_file(file)	
	local stat = zip_ar:stat(file);
	if(stat == nil)then
		zip_ar:add(file,"file",file);	
	end	
	
end
function add_zip_dir(file,dir)
	local all = dir .. "\\" .. file;
	zip_ar:add(file,"file",all);	
--[[	
	local stat = ar:stat(fi);
	if(stat == nil)then
		ar:add(file,"file",file);	
	end
--]]
end

function clear_zip(file)
	os.remove(file);
end
function close()
	zip_ar:close();
end
function open_file(file)
	trace_out(file .. "1111\n");
		
	local zip_file = zip_ar:open(file,zip.OR(zip.FL_NOCASE, zip.FL_NODIR));
	local str = zip_file:read(-1);
	trace_out(str .. "\n");
	--require "app.t"
	--os.execute("start " .. zip_file.name)
--[[	
	local c = zip_file:read(1)
	while c ~= nil do
		io.write(c)
		c = f1:read(1)
	end
   
--]]

end


