module(...,package.seeall)
require "iuplua"
require "iupluacontrols"
local dlg_ = nil;
local db_ = nil



local function init_buttons()
	local wid = "100x"
	btn_close_ = iup.button{title = "Close",rastersize = wid}
end 

local function init_controls()
	local wid = "100x"
	matrix_ver_ = iup.matrix{}
end 

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{matrix_ver_};
			iup.hbox{btn_close_};
			alignment = "ARIGHT";
			margin = "10x10";
		};
		title = "Display Details";
		--rastersize = "x600";
		resize = "NO";
	}
end 


local function matrix_select(lin, col,type)
	matrix_ver_["MARK" .. lin .. ":" .. 1] = type
	matrix_ver_["MARK" .. lin .. ":" .. 2] = type
end


local function init_msg()
	function btn_close_:action()
	
		dlg_:hide();
		matrix_ver_.DELLIN = "1-" .. matrix_ver_.numlin 
	end 
	function matrix_ver_:click_cb(lin, col, status)
		matrix_select(lin, col,1)  
	end 
	function dlg_:close_cb()
		matrix_ver_.DELLIN = "1-" .. matrix_ver_.numlin 
	end
	
end

local function init_matirx_control()
	matrix_ver_.numcol = 2
	matrix_ver_.numlin = 10
	matrix_ver_.HIDDENTEXTMARKS = "YES"
	matrix_ver_.READONLY = "YES"
	matrix_ver_.RASTERWIDTH0 = "50x"
	matrix_ver_.RASTERWIDTH1 = "200x"
	matrix_ver_.RASTERWIDTH2 = "600x"
	matrix_ver_.MARKMODE = "CELL"
	matrix_ver_:setcell(0,0,"Id")
	matrix_ver_:setcell(0,1,"Key")
	matrix_ver_:setcell(0,2,"Value")
	matrix_ver_.NUMCOL_VISIBLE = 2
	matrix_ver_.NUMLIN_VISIBLE = 10
end  


local function get_met(t,new_t,db)
	
	local met = getmetatable(t);
	if met then
		get_met(met,new_t,db);
	end
	for k,v in pairs(t) do
		if  k ~= "__Projects" and not db[k] then 
			new_t[k] = v
		end 
	end
end 

local function get_t(t)
	local new_t = {}
	local db = {}
	for k,v in pairs (t) do 
		db[k] = v
	end 
	get_met(t,new_t,db)
	return new_t
end

local function init_matrix()
	if not db_ then return end 
	matrix_ver_.numlin = 5
	local t = get_t(db_)
	local nums = 0
	for k,v in pairs (t) do 
		nums = nums + 1
		if nums > tonumber(matrix_ver_.numlin) then 
			matrix_ver_.numlin = nums
		end 
		matrix_ver_:setcell(nums,0,nums)
		matrix_ver_:setcell(nums,1,k)
		if type(v) == "table"  then 
			if #v == 0 then 
				matrix_ver_:setcell(nums,2,"Null Table")
			else 
				for m,n in ipairs (v) do 
					if m == 1 then 
						matrix_ver_:setcell(nums,1,k .. "[1]")
						matrix_ver_:setcell(nums,2,n)
					else
						nums = nums + 1
						if nums > tonumber(matrix_ver_.numlin) then 
							matrix_ver_.numlin = nums
						end 
						matrix_ver_:setcell(nums,0,nums)
						matrix_ver_:setcell(nums,1,k .. "[" .. m .. "]")
						matrix_ver_:setcell(nums,2,n)
					end 
				end 
			end 
		else 
			matrix_ver_:setcell(nums,2,v)
		end 
		
	end 
	matrix_ver_.redraw  = "ALL"
end 

local function init_data()
	matrix_nums_ = 0
	init_matirx_control()
	init_matrix() 
end 

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	init_data()
	dlg_:popup()
end

local function show()
	init_data()
	dlg_:popup()
end



function pop()
	if dlg_ then show() else init() end 
end 

function set_data(t)
	db_ = t
	
end 

