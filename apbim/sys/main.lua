require'sys.main.ap'
require"sys.msg";

_ENV = module(...,ap.adv)

local mgr_ = require'sys.mgr'
local function_ = require'sys.function'	
local app_ = require'sys.app'
local menu_ = require'sys.menu'
local toolbar_ = require'sys.toolbar'
local statusbar_ = require'sys.statusbar'
local workspace_ = require 'sys.workspace'
local login_dlg_ = require 'sys.interface.login_dlg'
-- local login_dlg_ = require 'app.LoginPro.main'
function load()
	menu_.init();
	toolbar_.init();
	workspace_.init()
	app_.load();
	function_.load();
	menu_.update();
	toolbar_.update();
	workspace_.update();
end

function init()
	app_.init();
	mgr_.init();
	statusbar_.init();
end

function login_ok()
	
	load();
	init();
end

function login()	
	login_ok()
	--login_dlg_.pop{on_ok = login_ok}
end

login()

--require"sys.dock".create();

