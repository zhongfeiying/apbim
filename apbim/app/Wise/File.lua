_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Wise/File";
	-- hid = 
	-- Name = ""
	-- View = 
};
require"sys.Item".Class:met(Class);

------------------------------

-- function Class:add()
	-- require"sys.Item".Class.add(item);
	-- if type(self)~="table" then return self end
	
	-- return self;
-- end

--t={archive=,}
function Class:save(t)
	if not require"sys.Item".Class.save(self,t) then return end
	
	local hid = self.hid;
	require'sys.zip'.add(t.archive,require'sys.mgr'.get_zip_model()..hid,'file',require'sys.mgr'.get_db_path()..hid);
end
