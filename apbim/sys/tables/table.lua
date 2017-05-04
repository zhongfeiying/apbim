_ENV = module(...,ap.adv)
require( "iuplua" )
require( "iupluacontrols" )


Table={
	index=1,
	pages_={},
	iuptab_={},
};
Table.__index = Table;
function create_table(t)
	if getmetatable(t)==Table then return end;
	t = t or {};
	setmetatable(t,Table);	
	return t;
end

function Table:add(page)
	if(page.name_)then
		table.insert(self.pages_,page);
	end
end	
function Table:get_id(name)
	for i = 1,#self.pages_ do
		if(name == self.pages_[i].name_)then
			return i;
		end
	end		
	return -1;
end	
function Table:del(name)
	if(name)then
		self.pages_[name] = nil;
	end
end	
function Table:show()

end	
function Table:create()
	if(self.pages_)then
		self.iuptab_ = iup.tabs{self.pages_[1].iupframe_,TABTYPE="BOTTOM",expand="YES"};
		for i = 2,#self.pages_ do
			iup.Append(self.iuptab_, self.pages_[i].iupframe_);
		end		
		return self.iuptab_;
	else
		return {};
	end	
end	
function Table:hide()
	
end	
function Table:open(file)
	
end	
function Table:save(file)
	
end	
function Table:create_controller()
	for i = 1,#self.pages_ do
		self.pages_[i]:create_tree_controller();
	end		
	
end	
function Table:add_item(page_name,parent_node,sub_node)
	local id = self:get_id(page_name);
	if(id ~= -1)then
		self.pages_[id]:tree_add(parent_node,sub_node);
	end
end

function Table:add_branch(page_name,parent_node,sub_node)
	local id = self:get_id(page_name);
	if(id ~= -1)then
		self.pages_[id]:tree_add_branch(parent_node,sub_node);
	end
end
