_ENV = module(...,ap.adv)


Controller={
	model_db_=1,
	tree_=1,
};
Controller.__index = Controller;
function create_controller(t)
	if getmetatable(t)==Controller then return end;
	t = t or {};
	setmetatable(t,Controller);
	return t;
end


function Controller:set(model_db,tree)
	self.model_db_ = model_db;
	self.tree_ = tree;
end


function Controller:db_add(parent_id,item)
	self.model_db_:add(parent_id,item);
	self.tree_:add_leaf(parent_id,item);
end
function Controller:db_edit(parent_id,item)
	self.model_db_:edit(parent_id,item);
	self.tree_:edit_leaf(parent_id,item);
end
function Controller:db_del(parent_id,item)
	self.model_db_:del(parent_id,item);
	self.tree_:del_leaf(parent_id,item);
end
function Controller:db_clear(parent_id,item)
	self.model_db_:clear(parent_id,item);
	self.tree_:clear(parent_id,item);
end
function Controller:tree_add(parent_id,item)
	self.tree_:add_leaf(parent_id,item);
	self.model_db_:add(parent_id,item);
end
function Controller:tree_edit(parent_id,item)
	self.tree_:edit_leaf(parent_id,item);
	self.model_db_:edit(parent_id,item);
end
function Controller:tree_del(parent_id,item)
	self.tree_:del_leaf(parent_id,item);
	self.model_db_:del(parent_id,item);
end
function Controller:tree_clear(parent_id,item)
	self.tree_:clear(parent_id,item);
	self.model_db_:clear(parent_id,item);

end
function Controller:tree_add_branch(parent_id,item)
	self.tree_:add_branch(parent_id,item);
	self.model_db_:add(parent_id,item);
end
