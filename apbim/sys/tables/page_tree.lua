_ENV = module(...,ap.adv)
require( "iuplua" )
require( "iupluacontrols" )


Page={
	index_=1,
	name_="",
	iupframe_={},

	tree_={};
	model_db_=nil;
	
	controller_ = nil;
	
};
Page.__index = Page;
function create_page(t)
	if getmetatable(t)==Page then return end;
	t = t or {};
	setmetatable(t,Page);	
	return t;
end

--****************---------------------------------------------
--local controller_ = nil;
function Page:create_tree_controller(tree)
	self.tree_.DELNODE0 = "SELECTED";
	self.controller_ = require"sys.tree.controller".create_controller();
	if(self.model_db_ == nil)	then
		self.model_db_ = require"sys.tree.model_db".create_model_db();
	end
	local tree_control_ = require"sys.tree.tree".create_tree();


	tree_control_:set(self.model_db_:get_db());
	tree_control_:set_iuptree(self.tree_);
	tree_control_:show();
	
	self.controller_:set(self.model_db_,tree_control_);
end	
function Page:get_tree_controller()
	return self.controller_;
end
--****************---------------------------------------------


function Page:create()
	self.tree_ = iup.tree{ADDEXPANDED="NO",CANFOCUS = "NO";};
	self.iupframe_ = iup.frame{self.tree_,size = "75x100"};
	self.iupframe_.tabtitle = self.name_;

	return self;
	
end	
function Page:set_name(name)
	self.name_ = name;
end	
function Page:set_model_db(model_db)
	self.model_db_ = model_db;
end	
function Page:get_data()
	
end	
function Page:tree_add(parent_node,sub_node)
	self.controller_:tree_add(parent_node,sub_node);
end
function Page:tree_add_branch(parent_node,sub_node)
	self.controller_:tree_add_branch(parent_node,sub_node);
end

