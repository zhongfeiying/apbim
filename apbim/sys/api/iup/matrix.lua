_ENV = module(...,ap.adv)

local iup_ = require"iuplua";

-- t={mat=,fields=}
function init_head(t)
	local mat = t.mat;
	local fields = t.fields;
	if type(fields)~="table" then return end
	mat.numcol = #fields;
	-- mat.numcol_visible = #fields;
	local lin = 0;
	mat.numlin = lin;
	for i,v in ipairs(fields) do
		mat["width"..i] = tonumber(v.Width);
		mat:setcell(lin,i,tostring(v.Head));
	end
end

-- t={mat=,fields=,minlin=}
local function add_virtual_lin(t)
	local mat = t.mat;
	local fields = t.fields;
	local minlin = t.minlin;
	
	local lin = 1;
	mat.numlin = lin;
	mat:setcell(lin,0,lin);
	for col,v in ipairs(fields) do
		mat:setcell(lin,col,"");
	end

	mat.numlin=math.max(lin,minlin);
	mat.redraw = "ALL";
end

-- t={mat=,fields=,dat=,minlin=,sortf=}
function init_list(t)
	local mat = t.mat;
	local fields = t.fields;
	local dat = t.dat;
	local minlin = t.minlin;
	local sortf = t.sortf;

	if type(fields)~="table" then return end
	add_virtual_lin(t);
	if type(dat)~="table" then return end
	local ary = type(sortf)=="function" and require"sys.table".sortv(dat, sortf) or require"sys.table".sortk(dat);
	if type(ary)~="table" then return end
	-- local maxlin = 0;
	for lin,key in ipairs(ary) do
		mat.numlin = lin;
		mat:setcell(lin,0,lin);
		for col,v in ipairs(fields) do
			mat:setcell(lin,col,tostring(v.Text(key,dat[key],dat)));
		end
		-- maxlin = lin;
	end
	
	mat.numlin=math.max(tonumber(mat.numlin),tonumber(minlin));
	mat.redraw = "ALL";
end

-- t={mat=,col=}
function get_selection_lin_text(t)
	local mat = t.mat;
	local col = t.col;
	local cell = mat.focus_cell;
	local lin = string.match(cell,"%d+");
	local txt = mat:getcell(lin,col);
	return txt;
end


-- t={mat=,lin=}
function select_lin(t)
	local mat = t.mat;
	if mat.ap_pre_selection_lin then mat["BGCOLOR" .. mat.ap_pre_selection_lin .. ":" .. "*"] = "255 255 255" end
	local cell = mat.focus_cell;
	local lin = t.lin or string.match(cell,"%d+");
	mat["BGCOLOR" .. lin .. ":" .. "*"] = "158 158 158";
	mat.ap_pre_selection_lin = lin;
	mat.redraw = "ALL";
end




