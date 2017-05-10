local require = require 
local type = type

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M
-- require 'iup_dev'
local iup = require 'iuplua'

local item_select_all_ = iup.item{title = "Select All"}
local item_select_none_ = iup.item{title = "Select None"}
local menu_;


function pop(arg)
	arg = arg or {}
	local function init_menu( ... )
		menu_ = iup.menu{
			item_select_all_;
			item_select_none_;
		}
	end

	local function init_callback(arg)
		if type(arg.cbf) ~= 'function' then return end 
		function item_select_all_:action()
			arg.cbf("ON")
		end

		function item_select_none_:action()
			arg.cbf("OFF")
		end
	end

	local function init()
		init_menu()
		init_callback(arg)
	end
	if not menu_ then init() end
	menu_:popup(iup.MOUSEPOS,iup.MOUSEPOS)
end