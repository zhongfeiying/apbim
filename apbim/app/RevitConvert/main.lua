--_ENV = module_seeall(...,package.seeall)
local require = require 

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV =M

local menu_ = require 'sys.menu'
local function Convert()
	local path_ = 'app.RevitConvert.'
	local dlg_ = require (path_ .. 'dlg')
	local op_ = require (path_ .. 'op')
	op_.init()
	dlg_.pop{
		init_txt =  op_.init_txt;
		on_src =  op_.on_src;
		on_dst = op_.on_dst;
		on_ok =  op_.on_ok;
	}
end
 
function on_load()
	menu_.add{
		frame=true,
		view=true,
		keyword = 'AP.Revit.Convert';
		action = Convert;
	}
end
