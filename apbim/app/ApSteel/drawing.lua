 _ENV = module(...,ap.adv)

local function get_points(points)
	local pts={};
	for i=1,#points do
		local pt = {x=points[i][6],x=points[i][7],x=points[i][8]};
		pt.x = points[i][6];
	end
end
local function save_lines(lines,pts)

end
local function save_surface(suface,file)
	local pts = get_points(suface.points);
	save_lines(suface.lines,pts);
end
local function save_member(mem,file)
	local diags = mem:get_shape_diagram();
	require "sys.table".totrace(diags);
	for k,v in pairs(diags.surfaces) do
		save_surface(v,file);		
	end	
end

local function save_plate(plate,file)
	trace_out("This si a plate \n");
end

function create_drawing(plane_name)
	local file_name = plane_name .. ".lua";	
	--写图纸文件
	local file = io.open(file_name,"w")
	file:write("database {\n");
	local mems = {} --or get_mems();	
	require "app.ApObject.Database".add_styles();
	--写标注样式库
	require "app.ApObject.Database".save_file_dim_styles(file);
	--写实体
	local all = require "sys.mgr".get_all();
	for k,v in pairs(all) do
		local val = require "sys.mgr".get_table(k,v);
		--require "sys.table".totrace(val);
		if(val.Classname == "app/Steel/Member")then
			save_member(val,file);			
		elseif(val.Classname == "app/Steel/Plate")then
			save_plate(val,file);
		end	
	end	
	--保存文件
	file:write("};\n");
	file:close()

	
end

