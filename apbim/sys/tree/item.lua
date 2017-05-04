_ENV = module(...,ap.adv)
require( "iuplua" )
require( "iupluacontrols" )

local select_val_=-1;
local cur_id_ = 0;	
local cur_index_ = 0;	


Item={
	index=1,
	name="",
	sons={},
	link = {},--关联信息
	--回调函数
	nm_click=function() end,
	nm_dbclick=function() end,
	rclk_menu={},
	menus_={},
};
Item.__index = Item;
function create_item(t)
	if getmetatable(t)==Item then return end;
	t = t or {};
	setmetatable(t,Item);
	
	--t:create_right_menu()
	return t;
end
function Item:popup_right_menu(val)
	select_val_ = val;
	menus_:popup(iup.MOUSEPOS,iup.MOUSEPOS);	
	
end	

function Item:create_right_menu()	
	menus_ = iup.menu{};	
	for i=1,#self.rclk_menu  do 
		local menu = self.rclk_menu[i];
		local mnu = iup.item{title = menu.name};
		iup.Append(menus_, mnu)
	
		function mnu:action()
			if(menu.fun)then
				menu.fun(select_val_);
			end
		end
	end		
	
	
	--[[
	
	item_open_ = iup.item{title = "Open"}
	item_save_ = iup.item{title = "Save"}
	item_update_ = iup.item{title = "Update"}

	menu_project_ = iup.menu{
		item_open_;
		item_save_;
		item_update_;
	};	
	
	function item_open_:action()
		trace_out("item_open_:action\n");	
		
	end
	function item_save_:action()
		trace_out("item_save_:action\n");	
		
	end
	function item_update_:action()
		trace_out("item_update_:action\n");	
		
	end--]]
	
end
--[[

local function create_menus(right_menus)	
	local ms = iup.menu{};	
	for i=1,#right_menus  do 
		trace_out(right_menus[i].name .. "\n");
		local m = iup.item{title = right_menus[i].name};
		iup.Append(ms, m)
	
		function m:action()
			right_menus[i].clk_fun();
		end
	end		
	
	return ms;
end
function get_menus(db)
	local menus_all = {};
	for i=1,#db  do 
		local menus = create_menus(db[i].right_menus);
		table.insert(menus_all,menus);
	end		
	return menus_all;
end



--]]

