require 'iup_dev'
local iuptree = require 'iupTree'
require 'iuplua'
tree = iuptree.Class:new()
local function rule(str,path,status)
	local title = str
	if status ==0 then 
		title = 1
	end
	return {
		icon = 'd:/user_open.bmp';
		tip = str;
		
		title =title;
	}
end
tree:init_path_data('E:\\Sync\\workingGit\\apbim\\apbim\\sys\\api',rule)
tree:set_rastersize('400x400')
tree:set_expand_all('YES')
-- tree:set_tree_tip('')
local f1 = function(id,status)
	-- print(id,status)
end

tree:set_selection_cb(f1)

local function f(id)
	tree:set_expand_all('YES')
	
	print(tree:get_selected_path())
end

tree:set_lbtn(f)


local dlg = iup.dialog{
	tree:get_tree();
}



dlg:popup()

