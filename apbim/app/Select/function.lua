_ENV = module(...,ap.sys)

function Cursor(sc)
	require"sys.cmd".set_select(sc);
end

function All(sc)
	require"sys.mgr".select_all{scene=sc,redraw=true};
	require"sys.mgr".update();
	require"sys.statusbar".show_selection_count();
end

function Cancel(sc)
	require"sys.mgr".select_none{scene=sc,redraw=true};
	require"sys.mgr".update();
	require"sys.statusbar".show_selection_count();
end

function Reverse(sc)
	require"sys.mgr".select_reverse{scene=sc,redraw=true};
	require"sys.mgr".update();
	require"sys.statusbar".show_selection_count();
end

--[[
function load()
	require"sys.menu".add{view=true,pos={"Window"},name={"Select","Cursor"},f=select_everything};
	require"sys.menu".add{view=true,pos={"Window"},name={"Select","All"},f=all};
	require"sys.menu".add{view=true,pos={"Window"},name={"Select","Cancel"},f=cancel};
	require"sys.menu".add{view=true,pos={"Window"},name={"Select","Reverse"},f=reverse};

	require"sys.msg.keydown".set{require"sys.msg.keydown".Ctrl(),key=string.byte('A'),f=all};
end
--]]
