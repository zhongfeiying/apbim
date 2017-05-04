_ENV = module(...,ap.adv)

local bars_ = {300,300,150,150,150,150};

function init()
	statusbar_set_parts(frm,bars_)
end

function show_text(str)
	if type(str)~="string" then str="" end
	statusbar_set_text(frm,0,str);
end

function show_id(str)
	if type(str)~="string" then str="" end
	statusbar_set_text(frm,#bars_-5,str);
end

function show_path(str)
	if type(str)~="string" then str="" end
	statusbar_set_text(frm,#bars_-4,str);
end

function show_file(str)
	if type(str)~="string" then str="" end
	str = ""..str;
	statusbar_set_text(frm,#bars_-3,str);
end

function show_name(str)
	if type(str)~="string" then str="" end
	str = ""..str;
	statusbar_set_text(frm,#bars_-2,str);
end

function show_model_count(n)
	statusbar_set_text(frm,#bars_-1,"Count: "..n);
end

function show_selection_count(n)
	statusbar_set_text(frm,#bars_-0,"Selection: "..n);
end

