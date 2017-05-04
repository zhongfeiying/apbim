
_ENV = module(...,ap.adv)

local bars_ = {150,150,300,150,150,100,100};

function init()
	statusbar_set_parts(frm,bars_)
end

function show_text(str)
	if type(str)~="string" then str="" end
	statusbar_set_text(frm,0,str);
end

function show_id(str)
	-- if type(str)~="string" then str="" end
	if type(str)~="string" then str=require"sys.mgr".get_model_id() or "ID" end
	statusbar_set_text(frm,#bars_-6,str);
end

function show_user(str)
	if type(str)~="string" then str=require"sys.mgr".get_user() or "Unlogin" end
	statusbar_set_text(frm,#bars_-5,str);
end

function show_path(str)
	if type(str)~="string" then str=require"sys.mgr".get_zip_path() or "Path" end
	statusbar_set_text(frm,#bars_-4,str);
end

function show_file(str)
	if type(str)~="string" then str=require"sys.mgr".get_zip_name() or "File" end
	statusbar_set_text(frm,#bars_-3,str);
end

function show_name(str)
	if type(str)~="string" then str=require"sys.mgr".get_model_name() or "Model" end
	statusbar_set_text(frm,#bars_-2,str);
end

function show_selection_count(n)
	if type(n)~="number" then n=require"sys.table".count(require"sys.mgr".curs()) or -1 end
	statusbar_set_text(frm,#bars_-1,"Selection: "..n);
end

function show_model_count(n)
	if type(n)~="number" then n=require"sys.table".count(require"sys.mgr.model".get():get_ids()) or -1 end
	statusbar_set_text(frm,#bars_-0,"Count: "..n);
end

function update()
	show_id();
	show_user();
	show_path();
	show_file();
	show_name();
	show_selection_count();
	show_model_count();
end

