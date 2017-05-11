module(...,package.seeall)
require "iuplua"
local dlg_ = nil
local data_ = nil;
local get_sel_ = nil;
local function init_buttons()	
	local wid = "100x"
	btn_cancel_ = iup.button{title = "Cancel",rastersize = wid}
	btn_ok_ = iup.button{title = "Ok",rastersize = wid}
end

local function init_controls()	
	local wid = "150x"
	tree_branch_ = iup.tree{
			--ADDROOT = "NO";
			MARKMODE="SINGLE";
			rastersize = "300x400";
		}
	lab_sel_type_ = iup.label{title = "Select : "}
	txt_sel_type_ = iup.text{readonly = "YES",expand = "HORIZONTAL"}
	
	
end

local function init_dlg()	
	dlg_ = iup.dialog{
		iup.vbox{
			--iup.hbox{lab_sel_type_,txt_sel_type_};
			tree_branch_;
			iup.hbox{btn_ok_,btn_cancel_};
			margin = "10x10";
			alignment = "ARIGHT";
		};
		title = "Branch Show";
		resize = "NO";
	}
end


local function init_callback()
	local save_sel_id = nil
	function btn_cancel_:action()
		dlg_:hide();
	end
	
	function btn_ok_:action()
		if save_sel_id then 
			get_sel_ = tree_branch_["title" .. save_sel_id]
		else 
			if data_.cur_branch  then 
				get_sel_ = data_.cur_branch 
			end
		end
		dlg_:hide();
	end
	
	function tree_branch_:selection_cb(id, states)
		if states  == 1 then 
			if tree_branch_["kind" .. id] == "BRANCH" then 
				tree_branch_.MARK  = "CLEARALL"
				tree_branch_["MARKED" .. (id + 1)]  = "YES"
				save_sel_id = id + 1
			else 
				save_sel_id = id
			end 
		end 
	end
	
	-- function tree_branch_:button_cb(button, pressed, x, y, str)
		
		-- if string.find(str,"1") then 
		--	trace_out("here\n")
		-- end
	-- end
end

local function init_val(tab)
	local nums = 0 
	for k,v in ipairs (tab) do 
		nums = nums + 1 
		if nums == 1 then 
			tree_branch_.addleaf0 = "master"
		else 
			tree_branch_["addleaf2"] = v
		end 
	end 
	if tab.cur_branch then 
		local counts = tonumber(tree_branch_.COUNT)
		local cur_id = 0
		for i = 1,counts do 
			if tree_branch_["title" .. cur_id] == tab.cur_branch then 
				tree_branch_.MARK  = "CLEARALL"
				tree_branch_["MARKED" .. cur_id]  = "YES"
				--txt_sel_type_.value = cur_sel_
				break
			end
			cur_id = cur_id + 1
		end
	end
end  
local function init_tree()
	tree_branch_.DELNODE = "ALL"
	tree_branch_.addbranch = "Master"
	tree_branch_.INSERTBRANCH0 = "Branches"
end 

local function init_data()
	--txt_sel_type_.value  = ""
	get_sel_ = nil;
	init_tree()
	if not data_ then return end 
	init_val(data_)
end 

local function show()
	dlg_:map()
	init_data()
	dlg_:popup()
end

local function init()
	init_buttons()
	init_controls()
	init_dlg()
	init_callback()
	
	dlg_:map()
	init_data()
	dlg_:popup()
end

function set_data(data)
	data_ = data
end

function get_data()
	return get_sel_
end

function pop(tree,id)
	if dlg_ then show() else  init() end 
end




