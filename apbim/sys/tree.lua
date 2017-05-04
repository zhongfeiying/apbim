

function create_dlgtree()
	require"sys.tables.create".create_tabs();  
	dlgtree_show(frm,false);
end

function frmclose()
	os.exit()
	-- require"sys.api.progress".close();
	-- iup.Destroy(require "sys.tables.create".get_dlg());
end
