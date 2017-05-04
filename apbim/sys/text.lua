_ENV = module(...,ap.adv)

function array(s)
	if type(s)~="table" then return "" end
	local str = "";
	for i,v in ipairs(s) do
		-- str = str..string.format("%d, ",v);
		str = str..tostring(v)..',';
	end
	return str;
end

function color(cr)
	-- local crs = require"sys.io".read_file{file="cfg/color_index.lua"};
	-- if type(cr)=="number" and type(crs[cr])=="table" then return crs[cr].name.."("..crs[cr][1]..","..crs[cr][2]..","..crs[cr][3]..")" end 
	local cr = require"sys.geometry".Color:new(cr)
	if type(cr)~="table" then return "" end
	local str = "";
	str = str..(cr.name or "");
	str = str..(cr.id and '('..cr.id..')' or "");
	str = str..'('..cr.r..','..cr.g..','..cr.b..')';
	-- for i,v in ipairs(crs) do
		-- if type(v)=="table" and v[1]==cr[1] and v[2]==cr[2] and v[3]==cr[3] then return v.name.."("..v[1]..","..v[2]..","..v[3]..")" end 
	-- end
	-- return cr[1]..","..cr[2]..","..cr[3];
end


