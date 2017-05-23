require 'iup_dev'
local iuptree = require 'iupTree'
require 'iuplua'
tree = iuptree.Class:new()
local function rule(str)
	return {
		icon = 'd:/user_open.bmp';
		tip = 'hello';
	}
end
tree:init_path_data('E:\\Sync\\workingGit\\apbim\\apbim\\sys\\api',rule)
tree:set_rastersize('400x400')
tree:set_expand_all('YES')
local function f(id)
	tree:set_expand_all('YES')
	
	print(tree:get_selected_path())
end

tree:set_lbtn(f)


local dlg = iup.dialog{
	tree:get_tree();
}



dlg:popup()

