_ENV = module(...,ap.adv)

local controller_pos_ = require "sys.tree.tree_dlg";

Message={
	index=1,
	iuptree_=1,
	items_={},
};
Message.__index = Message;
function create_message(t)
	if getmetatable(t)==Message then return end;
	t = t or {};
	setmetatable(t,Message);
	return t;
end

function Message:nm_click(name)
end	
function Message:nm_dbclick(name)
end	
function Message:rclk_menu_add(name)
end	
function Message:rclk_menu_del()
end	

function nm_click_g(val)
	
end	


function nm_dbclick_g(val)
	local res={};	
	local s = require"sys.mgr".get_class_all(require "app.Steel.Member".Class);
	for k,v in pairs(s) do
		--require "sys.table".totrace(v);
		if(v.assembly_number == val.link.assembly_number)then
			require "sys.mgr".select(v,true);
			require "sys.mgr".redraw(v);
		end
	end		
	require "sys.mgr".update();	
end	

function get_submodel(name)
	local s = require"sys.mgr".get_class_all(require"app.Model.Submodel".Class);
	for k,v in pairs(s) do
		if(v.name == name)then
			return v;
		end
	end
	return nil;
end

function rclk_menu_show(val)
	--require "sys.table".totrace(val);
	
	local submodel = get_submodel(val.name);
	if(submodel)then	
		submodel:show_entities{redraw=true};
		submodel:select_entities{light=true,redraw=true};

	end
end	
function rclk_menu_hide(val)
	--trace_out("rclk_menu_hide");
	local submodel = get_submodel(val.name);
	if(submodel)then	
		submodel:hide_entities{redraw=true};
	
	end
end	



function rclk_menu_add_g(id)
	local controller = controller_pos_.get_tree_controller();
	if(controller) then
		controller:tree_add(id,{name="test"});
	end
end	
function rclk_menu_del_g(id)
	local controller = controller_pos_.get_tree_controller();
	if(controller) then
		controller:db_del(id,{name="test"});
	end
end	
function rclk_menu_edit_g(id)
	local controller = controller_pos_.get_tree_controller();
	if(controller) then
		controller:tree_edit(id,{name="test"});
	end
end	
function rclk_menu_clear_g(id)
	local controller = controller_pos_.get_tree_controller();
	if(controller) then
		controller:db_clear(id,{name="test"});
	end
end	




