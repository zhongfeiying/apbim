
local require  = require 
local package_loaded_ = package.loaded
local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M
local cur_language_ = require 'sys.language'
local language_package_ = require 'app.LoginPro.language_package'
local menu_ = require 'sys.menu'
local dlg_login_ = require 'app.LoginPro.dlg_login'
local language_package_;

local require_data_file_ = function(file) package_loaded_[file] = nil return require(file) end
local function login_user()
	local function on_ok()
		require 'sys.main'.login_ok()
	end

	dlg_login_.pop{on_ok = on_ok}
end

local function logout_user()
end

local function get_languages(str)
	if not language_package_ then 
		language_package_ = require_data_file_ 'app.LoginPro.language_package'
	end
	return language_package_[str]
end

function on_load()
	menu_.add{
		keyword = 'ApBIM.User.Login';
		action = login_user;
		name='User.Login',
		frame = true,
		view = true,
	--	languages = get_languages('Login');
	}
	menu_.add{
		keyword = 'ApBIM.User.Logout';
		action = logout_user;
		name='User.Logout',
		frame = true,
		view = true,
	--	languages = get_languages('Logout');
	}
	menu_.add{
		keyword = 'ApBIM.User.Change Password';
		action = logout_user;
		name='User.Change Password',
		frame = true,
		view = true,
	--	languages = get_languages('Change Password');
	}
end

function on_update()
end

function on_unload()
end
