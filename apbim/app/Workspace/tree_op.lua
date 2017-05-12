--module(...,package.seeall)

_ENV = module(...,ap.adv)
local ver_base_op_ = require "app.workspace.ctr_require".base_op()
local luaext_ = require "app.workspace.ctr_require".luaext()
local workspace_ = require "app.workspace.ctr_require".Workspace()
local nums_ = 0
----------------------------------------------------------------------------------------------
--树形控件节点图标、文本颜色设置
function get_image(tree,str,id) --设置图标样式
	local image = nil;
	if str == "Messages" then 
		image = "app\\Message\\Messages.bmp"
		if id and tree["kind" .. id] == "LEAF" then 
			image = "app\\Message\\Messages.bmp"
		end
	elseif str == "Contacts" then 
		image = "app\\Contact\\Contacts.bmp"
		if id and tree["kind" .. id] == "LEAF" then 
			image = "app\\Contact\\Contact.bmp"
		end
	elseif str == "Documents" then 
	--	image = "app\\Image\\File.bmp"
		if id and tree["kind" .. id] == "LEAF" then 
			image = "app\\Workspace\\Res\\File.bmp"
		end
	end
	return image
end

function set_image(tree,id,str) --设置树节点图标
	tree["IMAGE" .. id] = str
	 if id and tree["kind" .. id] == "BRANCH" then 
		tree["IMAGEEXPANDED" .. id] = str
	end 
end

function set_color(tree,id,type)
	if type == "Normal"  then 
		tree["COLOR" .. id] = "0 0 0"
	elseif type == "Version" then 
		tree["COLOR" .. id] = "0 0 255"
	
	elseif type == "ChangeLocal" then 
		tree["COLOR" .. id] = "255 0 0"
	-- elseif type == "all" then 
		-- tree["COLOR" .. id] = "255 0 255"
	elseif type == "submit" then 
		tree["COLOR" .. id] = "255 0 0"
	elseif type == "missing" then 
		tree["COLOR" .. id] = "200 200 200"
	elseif type == "update" then 
		tree["COLOR" .. id] = "255 0 255"
	elseif type == "all" then 
		tree["COLOR" .. id] = "0 255 255"
	elseif type == "NeedUpdata" then 
		tree["COLOR" .. id] = "255 0 255"
	end
end

----------------------------------------------------------------------------------------------
function enter_edit_mode(tree,id,type)
	if tree["kind" .. id] == "BRANCH" then 
	tree["STATE" .. id] = "EXPANDED"
	end 
	tree.MARK = "CLEARALL"
	if type then 
		tree.VALUE = "PREVIOUS"
		tree.VALUE = "NEXT"
	else 
		tree.VALUE = "NEXT"
	end 
	
	tree["MARKED" .. (id + 1)] = "YES" 
	tree.RENAME  = "YES"--]]
end





-----------------------------------------------------------------------------------------
-- get tree data 
-- data = {name = "";datas = {{};{}}}

local function recursion_get_tree_datas(tree,tid,data,rest,type)
	data.datas = {}
	local node_counts = tonumber(tree["CHILDCOUNT" .. tid])
	if node_counts == 0 then return end 
	local cur_id = tid + 1;
	for i = 1, node_counts do 
		local childdata = {}
		childdata.name = tree["title" .. cur_id]
		if tree["KIND" .. cur_id] == "BRANCH" then 
			local t =iup.TreeGetUserId(tree,cur_id)
			t = t or {}
			if t and not type then 
				if not t.gid then t.gid = luaext_.guid() iup.TreeSetUserId(tree,cur_id,t) end 
				childdata.attributes = t
			end
			recursion_get_tree_datas(tree,cur_id,childdata,rest,type)
			cur_id = cur_id + tree["TOTALCHILDCOUNT" .. cur_id]
		else
			local t =iup.TreeGetUserId(tree,cur_id)
			t = t or {}
			if t and not type then 
				if not t.gid then t.gid = luaext_.guid() iup.TreeSetUserId(tree,cur_id,t) end 
				childdata.attributes = t

				if t.res then 
					for k,v in ipairs (t.res) do 
						if not v.gid then 
							v.gid = luaext_.guid()
							iup.TreeSetUserId(tree,cur_id,t)
						end
						table.insert(rest,v)
					end
				end
			end 
		end
		table.insert(data.datas,1,childdata)
		cur_id = cur_id + 1;
	end
end

function get_tree_data(tree,tid,type)
	local tab = {}
	local rest = {}
	tab.name = tree["title" .. tid]
	local t =iup.TreeGetUserId(tree,tid)
	t = t or {}
	if t and not type then 
		if not t.gid then t.gid = luaext_.guid()  end 
		if not t.mgid then t.mgid = require "sys.mgr".get_model_id() end
		
		local file = workspace_.get_cur_zip_file()
		if not t.filename and file then t.filename = "Sample/BCA/"  .. string.match(file,".+\\(.+)")  end
		iup.TreeSetUserId(tree,tid,t)
		tab.attributes = t
	end 
	recursion_get_tree_datas(tree,tid,tab,rest,type)
	return tab,rest
end



local function recursive_set_tree_datas(tree,data,tid,type)
	for k,v in ipairs(data) do
		if v.datas then 
			tree["addbranch" .. tid] = v.name
			if v.attributes and not type then 
				iup.TreeSetUserId(tree,tid+1,v.attributes)
			end 
			recursive_set_tree_datas(tree,v.datas,tid + 1,type)
		else 
			tree["addleaf" .. tid] = v.name
			if v.attributes and not type then 
				iup.TreeSetUserId(tree,tid+1,v.attributes)
			end 
			set_image(tree,tid + 1,get_image(tree,"Documents",tid + 1))
		end 
	end 
end

function set_tree_datas(tree,data,type)
	if data.name then 
		tree.title0 = data.name
		iup.TreeSetUserId(tree,0,nil)
		if data.attributes and not type then 
			iup.TreeSetUserId(tree,0,data.attributes)
		end
		if data.datas then 
			recursive_set_tree_datas(tree,data.datas,0,type)
		end
	end 
end 
----------------------------------------------------------------------------------------------

function get_tree_node_ID(tree,pid,val)
	local childcounts = tonumber(tree["childcount" .. pid])
	local cur_id = pid+1
	for i = 1,childcounts do 
		local title = tree["title" .. cur_id]
		if string.lower(title) == string.lower(val) then 
			
		end
	end
end
