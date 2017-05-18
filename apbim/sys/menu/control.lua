local type = type;
local trace_out = trace_out;
local ipairs = ipairs;
local table = table;
local string = string
local print = print
local add_menu = add_menu;
local sub_menu = sub_menu
local get_submenu = get_submenu
local insert_menu = insert_menu
local frm = frm;
local MF_POPUP = MF_POPUP;
local MF_SEPARATOR = MF_SEPARATOR;

local ID_MGR = require "sys.res.id_mgr";
local language_ = require 'sys.language'
_ENV = module(...)
local cur_language_;
local menus_;
local function init_language()
	cur_language_ = language_.get() or 'English'
end

local function set_menus_data(menus)
	menus_ = menus
end

local function get_menu_title(keyword)
	if not menus_ or not menus_[keyword]  then return end 
	local title =  menus_[keyword].languages[cur_language_]
	return title
end

local function create_items(data,items,level)
	local names,pos;
	if not names  then names,pos = {file =  get_submenu(frm,0);window = get_submenu(frm,1);},-1 end 
	for k,v in ipairs (data) do 
		if v.subs and not level then
			local name =  string.lower(v.name)
			local menuhwnd = names[name]
			if name == 'window' then pos = pos + 1 end
			if name == 'file' then pos = pos + 1 end
			if menuhwnd then 
				local items = {}
				create_items(v.subs,items,1) 
				for i = #items,1,-1 do 
					insert_menu(menuhwnd,items[i]) 
				end 
			else 
				pos = pos+ 1;
				local menu = {}
				menu.name = v.name
				menu.nposition = pos
				menu.items = {}
				create_items(v.subs,menu.items,1) 
				add_menu(frm,menu)
				names[name] = get_submenu(frm,pos)
			end 
		elseif  v.subs and level then
			local submenu = {};
			submenu.name = v.name
			submenu.items = {}
			create_items(v.subs,submenu.items,1)
			table.insert(items,{name = v.name,id = sub_menu(submenu) ,flags = MF_POPUP})
		elseif  not v.subs then
			if v.name and v.name ~= '' then 
				local sys_id = ID_MGR.new_id();
				ID_MGR.map(sys_id,v.keyword);
				table.insert(items,{name = get_menu_title(v.keyword) or v.name,id = sys_id})
			else 
				table.insert(items,{name = '' ,flags =  MF_SEPARATOR })
			end 
		end 
	end 
end


function create_menus(styles,menus)
	if type(styles)~='table' then return end
	if type(menus)~='table' then return end	
	init_language()
	set_menus_data(menus)
	ID_MGR.set_menus(menus);
	create_items(styles);
end



