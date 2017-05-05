--module(...,package.seeall)
 _ENV = module_seeall(...,package.seeall)


Class = {
	Classname = "app/Tekla/import_mgr";
	
	historys_ = {},
	
	
};
require"sys.Entity".Class:met(Class);

function create_date_str(date_tab)
	if(date_tab == nil)then
		return "error";	
	end
	local str = date_tab.year .. "-" .. date_tab.month .. "-" .. date_tab.day .. "_" .. date_tab.hour .. ":" .. date_tab.min .. ":" .. date_tab.sec;
	return str;
end	

function Class:add(date_tab)
	local str = create_date_str(date_tab);
	-- trace_out(str .. "\n");
	table.insert(self.historys_,str);
end

