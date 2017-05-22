require 'iup_dev'
local iuptree = require 'iupTree'
require 'iuplua'
tree = iuptree.Class:new()
tree:init_path_data('E:\\Sync\\workingGit\\apbim\\apbim\\sys\\api')
tree:set_rastersize('400x400')
local dlg = iup.dialog{
	tree:get_tree();
}

dlg:popup()

