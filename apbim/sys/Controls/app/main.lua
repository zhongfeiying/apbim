local require = require;
-- _ENV = module(...)

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local str = 'sys.Controls.App.'
local op_ = require (str .. 'op')
local dlg_ = require (str .. 'dlg')

function pop(file,solution)
	op_.init(file,solution)
	dlg_.pop{
		appDatas = op_.get_app_datas(),
		solutionDatas = op_.get_solution_datas();
		init_app_data = op_.init_app_data,
		init_solution_data = op_.init_solution_data,
		matrix_click_callback = op_.matrix_click_callback,
		ok_action = op_.ok_action,
		save_action = op_.save_action,
		delete_action = op_.delete_action,
	}
end

