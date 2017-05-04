_ENV = module(...,ap.adv)
require( "iuplua" )
require( "iupluacontrols" )


Page_Tree={
	index_=1,
	name_="",
	iupframe_={},

	tree_={};
	model_db_=nil;
};
Page_Tree.__index = Page_Tree;



function create_page(t)
	if getmetatable(t)==Page_Tree then return end;
	t = t or {};
	setmetatable(t,Page_Tree);	
	return t;
end

require"app.tables.page".Page:met(Page_Tree);


function Page_Tree:create()
	self.tree_ = iup.tree{ADDEXPANDED  = "NO";};
	trace_out("Page_Tree:create.name_ = " .. self.name_ .."\n");	
	self.iupframe_ = iup.frame{self.tree_,size = "75x100"};
	self.iupframe_.tabtitle = self.name_;

	return self;
	
end	


