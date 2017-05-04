_ENV = module(...,ap.adv)
function load()
	require"sys.interface.menu".init();
	require"sys.app".cfg();
	require"sys.app".load();
	require"sys.function".load();
	require"sys.interface.menu".show();
end

function init()
	require"sys.app".init();
	require"sys.mgr".init();
	require"sys.statusbar".init();
end

function esc(sc)
	require"sys.app".esc();
	require"sys.cmd".esc(sc or require"sys.mgr".get_cur_scene());
end

function reload()
	require"sys.interface.menu".clear();
	load();
end

local function main()
	load();
	init();
	-- set_lighting(true);
	require"sys.net.main"
	require"sys.msg";
	-- require"sys.net";
	-- require"sys.tree";
	-- require"sys.net.queue".init();
	require"sys.dock".create();
	-- dlgtree_show(frm,false)
	-- require"sys.dock".add_page(require"iuplua".label{title="Test"});
	-- require"sys.statusbar".update();
end

require'sys.test.main'
require'sys.interface.login_dlg'.pop{on_ok=main};
-- main();

-- require"sys.net.test".test();

