_ENV = module(...,ap.adv)
require( "iuplua" )
require( "iupluacontrols" )

local select_id_=-1;
local cur_id_ = 0;	
local cur_index_ = 0;	


Tree={
	index=1,
	iuptree_=1,
	items_={},
};
Tree.__index = Tree;
function create_tree(t)
	if getmetatable(t)==Tree then return end;
	t = t or {};
	setmetatable(t,Tree);
	return t;
end
--树的操作
function Tree:add_leaf(id,item)
	self.iuptree_["ADDLEAF"..id] = item.name;	
	iup.TreeSetUserId(self.iuptree_,id+1,item);
	cur_id_ = cur_id_ + 1;
end
function Tree:add_branch(id,item)
	self.iuptree_["ADDBRANCH"..id] = item.name;
	iup.TreeSetUserId(self.iuptree_,id+1, item);
	cur_id_ = cur_id_ + 1;
end
function Tree:insert_leaf(id,item)
	self.iuptree_["INSERTLEAF"..id] = item.name;	
	iup.TreeSetUserId(self.iuptree_,id+1, item);
	cur_id_ = cur_id_ + 1;
end
function Tree:insert_branch(id,item)
	self.iuptree_["INSERTBRANCH"..id] = item.name;
	iup.TreeSetUserId(self.iuptree_,id+1, item);
	cur_id_ = cur_id_ + 1;
end
function Tree:del_leaf(id)
	self.iuptree_["delnode"..id] = "SELECTED";
	--删除节点后进行删除相关的数据
	local val = iup.TreeGetUserId(self.iuptree_,id);
end
function Tree:del_branch(id)
	self.iuptree_["delnode"..id] = "SELECTED";
	--删除节点后进行删除相关的数据
	local val = iup.TreeGetUserId(self.iuptree_,id);
end
function Tree:edit_leaf(id)

end
function Tree:edit_branch(id)
	
end
function Tree:clear()
end
--树的保存和读取
function Tree:open(file)
end
function Tree:save(file)
end
function Tree:add_sons(tree,tab)
	local nums = 0;
	local cur_depth_id = 0
	for k,v in ipairs (tab) do 
		if #v.sons > 0 then 
			if nums == 0  then			
				self:add_branch(cur_id_,v);
				cur_depth_id = cur_id_
			else
				self:insert_branch(cur_depth_id,v);
				cur_depth_id = cur_depth_id + tree["TOTALCHILDCOUNT" .. cur_depth_id] + 1
			end
			self:add_sons(tree,v.sons)
		else
			if nums == 0 then			
				self:add_leaf(cur_id_,v);
				cur_depth_id = cur_id_
			else 
				self:insert_leaf(cur_depth_id,v);
				cur_depth_id = cur_depth_id + 1
			end
		end
		nums = nums + 1;
	end 
end


function Tree:show()
	cur_id_ = 0;	
	local nums = 0;
	local cur_depth_id = 0
	for k,v in ipairs (self.items_) do 
		if #v.sons > 0 then 
			if nums == 0 then 
				self.iuptree_["ADDBRANCH".. 0] = v.name
				cur_depth_id = cur_id_
				self:add_sons(self.iuptree_,v.sons)
			else 
				self:insert_branch(cur_depth_id,v);
				cur_depth_id = cur_depth_id + self.iuptree_["TOTALCHILDCOUNT" .. cur_depth_id] + 1
				self:add_sons(self.iuptree_,v.sons)
			end 
		else 
			if nums == 0 then			
				self.iuptree_["ADDLEAF".. 0] = v.name
				cur_depth_id = cur_id_
			else 
				self:insert_leaf(cur_depth_id,v);
				cur_depth_id = cur_depth_id + 1
			end
		end 
		nums = nums + 1;
	end--]]

end

--树数据的整体操作
function Tree:set_iuptree(itree)
	--cur_id_ = 0; 
	self.iuptree_ = itree;
	function self.iuptree_:rightclick_cb(nid) --树的右键回调函数
		local val = iup.TreeGetUserId(self,nid);
		if(val)then	
			val:popup_right_menu(val);
		end	
	end
		
	function self.iuptree_:showrename_cb(id)
	end

	function self.iuptree_:rename_cb(id)
	end

	function self.iuptree_:selection_cb(nid)
		select_id_ = nid;		
	end
	function self.iuptree_:button_cb(button, pressed, x, y,status)
		if string.find(status,"1") and string.find(status,"D") then  --双击
			local val = iup.TreeGetUserId(self,select_id_);
			if(val)then	
				--trace_out(val.name .. "\n");
				if(val.nm_dbclick)then
					val.nm_dbclick(val);
				end	
			end
		elseif(string.find(status,"1") and pressed == 1)then --单击
			local val = iup.TreeGetUserId(self,select_id_);
			if(val)then	
				if(val.nm_click)then
					val.nm_click(val);
				end	
			end
		end
		--iup.SetFocus(frm);
		--on_lbuttonup();
	end
	
	
end
function Tree:set(items)
	self.items_ = items;
end














