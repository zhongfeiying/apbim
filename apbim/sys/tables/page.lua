_ENV = module(...,ap.adv)

require( "iuplua" )
require( "iupluacontrols" )

local g_tree_={};
local g_model_db_=nil;

Page={
	index_=1,
	name_="",
	iupframe_={},
};
Page.__index = Page;
function create_page(t)
	if getmetatable(t)==Page then return end;
	t = t or {};
	setmetatable(t,Page);	
	return t;
end
function set_parent(parent, child)
	parent.__index = parent
	setmetatable(child, parent)
end

function Page:met(t)	
	setmetatable(t,self);
	self.__index = self;
	return t;
end

--****************---------------------------------------------
local controller_ = nil;


function Page:create_tree_controller(tree)
	g_tree_.DELNODE0 = "SELECTED";
	controller_ = require"sys.tree.controller".create_controller();
	if(g_model_db_ == nil)	then
		g_model_db_ = require"sys.tree.model_db".create_model_db();
	end
	local tree_control_ = require"sys.tree.tree".create_tree();

	tree_control_:set(g_model_db_:get_db());
	tree_control_:set_iuptree(g_tree_);
	tree_control_:show();
	
	controller_:set(g_model_db_,tree_control_);
end	
function get_tree_controller()
	return controller_;
end

function Page:set_name(name)
	self.name_ = name;
end	
function Page:set_data(model_db)
	g_model_db_ = model_db;
end	
function Page:get_data()
	
end	
function Page:set_model_db(model_db)
	self.model_db_ = model_db;
end	
function Page:tree_add(parent_node,sub_node)
	controller_:tree_add(parent_node,sub_node);
end
