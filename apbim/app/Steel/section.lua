_ENV = module(...,ap.adv)

-- local company_ = require"sys.api.section_rei";

local warning_ = {}--{[type]=section}
local types_ = {};


-- local function trace_section(type,str)
	-- if warning_[type] then return end
	-- trace_out("Warning: undefined section: "..str.."\n");
	-- warning_[type] = true;
-- end

local function trace_section(type,str)
	if warning_[str] then return end
	trace_out("Warning: undefined section: "..str.."\n");
	warning_[str] = true;
end


--------public--------
function type_sizes(str)
	local Type = string.match(str,"[^%d-]+");
	local szs = {};
	for sz in string.gmatch(str, "[%d.]+") do
		table.insert(szs,sz);
	end
	return Type,szs;
end

function profile(str,alignment)
	if type(str)~="string" then return end
	local Type,szs = type_sizes(str);
	-- local Type,szs = 'H',{100,100,5,13.5};
	if type(types_[Type])~="function" then trace_section(Type,str) Type = "default" end
	if type(types_[Type])~="function" then trace_section(Type,str) return end
	local outer,inners = types_[Type](szs,alignment);
	if not outer then trace_section(Type,str) return require'app.Steel.section.default'.get_section() end
	return outer,inners;
	-- return company_.get()[type](szs,alignment);
end

--t:type string,f:function
function add_type(t,f)
	types_[t] = f;
end

function load()
	local pos = "app\\Steel\\section\\";
	local files = require"sys.api.dir".get_filename_list(pos);
	local pos = "app.Steel.section.";
	for k,v in pairs(files) do
		if string.sub(k,-4,-1)=='.lua' then
			local file = pos..string.sub(k,1,-5);
			require(file);
		end
	end
end

load();

