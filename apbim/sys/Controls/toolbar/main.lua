local require = require;

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local str = 'sys.Controls.Toolbar.'

local dlg_ =  require(str .. 'dlg')
local op_ = require (str .. 'op')


function pop()
	
	dlg_.pop{
		menuData= op_.get_menu_data(),
		menuStyle = op_.get_menu_style(),
		styleFiles = op_.get_style_files(),
		on_save = op_.on_save,
		on_ok = op_.on_ok,
		on_dbclick_list = op_.on_dbclick_list,
		
	} 
end



