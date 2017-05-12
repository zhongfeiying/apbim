_ENV = module(...,ap.adv)

Class = {
	Classname = "app/sys/Model";
};
require"sys.Group".Class:met(Class);

function Class:push_item(item)
	if type(item)~='table' then return end
end


