module(...,package.seeall)

local dlg_ = nil
local get_Data_ = nil
local new_ver_data_ = {}
local return_data_ = {}

local function init_buttons()
	local wid = "100x"
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
end

local function init_controls()
	
	tree_show_ver_ = iup.tree{}
	tree_show_ver_.EXPANDALL = "YES"
	--tree_show_ver_.ADDROOT = "NO"
	tree_show_ver_.rastersize = "200x400";
	tree_show_ver_.SHOWRENAME="NO"
	frame1_ = iup.frame{tree_show_ver_,title = "Selected Version"}
	
	tree_new_ver_ = iup.tree{}
	tree_new_ver_.EXPANDALL = "YES"
	tree_new_ver_.rastersize = "200x400";
	tree_new_ver_.SHOWRENAME="NO"
	frame2_ = iup.frame{tree_new_ver_,title = "New Version"}
end

local function init_dlg()
	dlg_ = iup.dialog{
		iup.vbox{
			iup.hbox{frame1_,frame2_};
			iup.hbox{btn_ok_,btn_cancel_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Merge Folder";
		resize = "NO";
	}
end

local function deal_ok()
	local nums = tonumber(tree_new_ver_.CHILDCOUNT0)
	for i = 1,nums do 
		local t = iup.TreeGetUserId(tree_new_ver_,i)
		table.insert(return_data_,{hid = -1,gid = t.gid})
	end 
end 

local function deal_add_show(sel_id_show,type)
	local t = iup.TreeGetUserId(tree_show_ver_,sel_id_show)
	if t then 
		if not new_ver_data_[t.gid] then  
			new_ver_data_[t.gid] = t 
			tree_new_ver_.addbranch0 = t.filename or t.name
			iup.TreeSetUserId(tree_new_ver_,1,t)
		else 
			if type then 
			iup.Message("Warning","File or Floder already exists , You can not add again !") 
			end 
		end 				
	end 
end 

local function init_msg()
	function btn_ok_:action()
		return_data_ = {}
		deal_ok()
		dlg_:hide()
	end
	function btn_cancel_:action()
		new_ver_data_ = nil
		dlg_:hide()
	end
	function dlg_:close_cb()
		new_ver_data_ = nil
	end
	local sel_id_show = nil
	local sel_id_new = nil
	function tree_show_ver_:selection_cb(id, status)
		if status == 1  then 
			sel_id_show= id
		else 
			sel_id_show = nil
		end 
	end
	function tree_show_ver_:button_cb(button, pressed, x, y, status)
		
		if  string.find(status,"1")  and string.find(status,"D") then 
			if not sel_id_show then return end 
			if tonumber(tree_show_ver_["depth" .. sel_id_show]) == 0 then
				local nums = tonumber(tree_show_ver_["CHILDCOUNT" .. sel_id_show])
				local cur_id = sel_id_show + 1
				for i = 1,nums do 
					deal_add_show(cur_id)
					cur_id = cur_id + 1
				end 
				sel_id_show = nil
				tree_new_ver_.VALUE = "LAST"
				return
			end 
			deal_add_show(sel_id_show,1)
			sel_id_show = nil
			tree_new_ver_.VALUE = "LAST"
		end 
	end

	function tree_new_ver_:selection_cb(id, status)
		if status == 1 then 
			sel_id_new= id
		else 
			sel_id_new = nil
		end 
	end
	function tree_new_ver_:button_cb(button, pressed, x, y, status)
		
		if   string.find(status,"1")  and string.find(status,"D") then 
			if not sel_id_new then return end 
			if tonumber(tree_new_ver_["depth" .. sel_id_new]) == 0 then
					new_ver_data_ = {}
					tree_new_ver_["delnode" .. sel_id_new] = "CHILDREN"
					sel_id_new = nil
					tree_show_ver_.VALUE = "LAST"
				return 
			end 
			local t = iup.TreeGetUserId(tree_new_ver_,sel_id_new)
			if t then 
			new_ver_data_[t.gid] = nil
			end 
			tree_new_ver_["delnode" .. sel_id_new] = "SELECTED"
			sel_id_new = nil
			tree_show_ver_.VALUE = "LAST"
		end 
	end 

	-- function tree_new_ver_:branchopen_cb(id)
		-- return iup.IGNORE 
	-- end 
	function tree_new_ver_:branchclose_cb(id)
		return iup.IGNORE 
	end
	-- function tree_show_ver_:branchopen_cb(id)
		-- return iup.IGNORE 
	-- end 
	function tree_show_ver_:branchclose_cb(id)
		return iup.IGNORE 
	end
end

local function init_tree()
	tree_show_ver_.DELNODE = "ALL"
	tree_new_ver_.DELNODE = "ALL"
	tree_show_ver_.addbranch = ""
	tree_new_ver_.addbranch = ""
end 

local function init_data()
	new_ver_data_ = {}
	return_data_ = nil
	init_tree()
	if get_Data_ then 
		local nums = 0
		local cur_id = 0
		for k,v in pairs (get_Data_) do 
			if k ~= "name" then 
				if nums == 0 and tonumber(tree_show_ver_.COUNT) == 0 then
					tree_show_ver_.addbranch = v.attr.name .. " (" .. "Version " .. (nums + 1) .. "" .. ")"
					iup.TreeSetUserId(tree_show_ver_,0,v.attr)
				elseif   nums == 0 then 
					tree_show_ver_.title0 = v.attr.name .. " (" .. "Version " .. (nums + 1) .. "" .. ")"
					iup.TreeSetUserId(tree_show_ver_,0,v.attr)
				elseif   nums > 0 then 
					tree_show_ver_.insertbranch0 = v.attr.name .. " (" .. "Version " .. (nums + 1) .. "" .. ")"
					iup.TreeSetUserId(tree_show_ver_,cur_id+1,v.attr)
				end 
				for m,n in pairs (v.contents) do
					if nums == 0  then
						tree_show_ver_.addbranch0 = n.filename or n.name
						iup.TreeSetUserId(tree_show_ver_,1,n)
						cur_id = cur_id  + 1 
					else 
						tree_show_ver_["addbranch" .. (cur_id + 1)] = n.filename or n.name
						iup.TreeSetUserId(tree_show_ver_,(cur_id + 2),n)
					end 
				end 
				nums = nums + 1
			end 
			
		end 
		
		tree_new_ver_.title0 = get_Data_.name or  tree_show_ver_.title0
		
	end 
	tree_show_ver_.VALUE = "LAST"
	tree_new_ver_.VALUE = "LAST"
end


local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_msg()
	dlg_:map()
	init_data()
	dlg_:popup()
	
end

local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end


function pop()
	if dlg_ then show() else  init() end 
end

function set_data(t,name)
	get_Data_ = t
	if type(get_Data_) == "table" then 
	get_Data_.name = name
	end 
end

function get_data()
	return return_data_
end