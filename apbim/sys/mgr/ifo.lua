_ENV = module(...,ap.adv)

local undefined_classname_list_ = {};

local function is_default(Classname)
	local f = io.open("ifo/"..tostring(Classname)..".lua","r");
	if f then
		f:close();
		return true;
	else
		return false;
	end
end

local function is_custom(Classname)
	local f = io.open(tostring(Classname)..".lua","r");
	if f then
		f:close();
		return true;
	else
		return false;
	end
end

local function is_ifo(Classname)
	if is_custom(Classname) or is_default(Classname) then
		return true;
	else
		return false;
	end
end

local function trace_undefined_classname(t)
	local str = type(t.Classname)=="string" and t.Classname or t.mgrid or "";
	if undefined_classname_list_[str] then return end
	trace_out("undefined class: "..tostring(str).."\n");
	undefined_classname_list_[str] = true;
end

--public-------------------------------------------------

function new(t)
	if type(t)~="table" then return nil end
	-- if type(t.Classname)~="string" then return require"sys.Item".Class:new(t) end
	if type(t.Classname)~="string" or not is_ifo(t.Classname) then 
		trace_undefined_classname(t);
		return require"sys.Item".Class:new(t);
	else
		return require(t.Classname).Class:new(t);
	end
end
