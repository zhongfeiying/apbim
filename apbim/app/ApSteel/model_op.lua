 _ENV = module(...,ap.adv)
function get_class(name)
	local all = require "sys.mgr".get_all();
	for k,v in pairs(all) do
		local val = require "sys.mgr".get_table(k,v);
		if(val.Classname == name)then
			return v;
		end	
	end
	return nil;
	
end

function show_by_data(data)
	local all = require "sys.mgr".get_all();
	for k,v in pairs(all) do
		local val = require "sys.mgr".get_table(k,v);
		local str = require "app.Tekla.import_mgr".create_date_str(val.time_str);			
		if(str == data)then
			--require "sys.table".totrace(val);
			require "sys.mgr".select(val,true);	
			require "sys.mgr".redraw(val);	
		end
	end
		
	require "sys.mgr".update();
end






