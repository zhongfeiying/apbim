local type = type;
local trace_out = trace_out;
local tonumber  = tonumber
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
local remove_menu = remove_menu
local del_menu = del_menu
local get_mainmenu = get_mainmenu

local ID_MGR = require "sys.res.id_mgr";
local language_ =require 'sys.language'
_ENV = module(...)

local cur_language_;
local cur_styles_;
local fixed_ = {}

function init_menu()
	local menus = {}
	local pos = 0
	local menu  = get_mainmenu(frm)
	while true do 
		local submenu = get_submenu(frm,pos)
		if not submenu or tonumber(submenu) == 0 then return 	
		elseif menus[submenu] then 
			pos = pos + 1
		else 
			menus[submenu] = true
			del_menu(frm,menu,pos)
		end
	end
end

local function save_fixed()
	--fixed_ = {file =  get_submenu(frm,0);window = get_submenu(frm,1);} 

end

local function turn_lan(name)
	if not cur_styles_ or  not cur_styles_.language_package then return  name end 
	local pkg = cur_styles_.language_package
	return pkg[name] and pkg[name][cur_language_] or name
end

local function create_items(data,items,level)
	if type(data) ~= 'table' then return end 
	local names,pos;
	if not level then names,pos = {},-1 end -- {file =  get_submenu(frm,0);window = get_submenu(frm,1);},-1 end 
	--if not level then names,pos = {file =  get_submenu(frm,0);window = get_submenu(frm,1);},-1 end 

	for k,v in ipairs (data) do 
		if v.subs and not level then
			local name =  string.lower(v.name)
			local menuhwnd = names[name]
	--		if name == 'window' then pos = pos + 1 end
	--		if name == 'file' then pos = pos + 1 end
			if menuhwnd then 
				local items = {}
				create_items(v.subs,items,1) 
				for i = #items,1,-1 do 
					insert_menu(menuhwnd,items[i]) 
				end 
			else 
				pos = pos+ 1;
				local menu = {}
				menu.name = turn_lan( v.name  ) 
				menu.nposition = pos
				menu.items = {}
				create_items(v.subs,menu.items,1) 
				add_menu(frm,menu)
				names[name] = get_submenu(frm,pos)
			end 
		elseif  v.subs and level then
			local submenu = {};
			submenu.name =turn_lan( v.name  ) 
			submenu.items = {}
			create_items(v.subs,submenu.items,1)
			table.insert(items,{name =turn_lan( v.name  ) ,id = sub_menu(submenu) ,flags = MF_POPUP})
		elseif  not v.subs then
			if v.name and v.name ~= '' then 
				local sys_id = ID_MGR.new_id();
				ID_MGR.map(sys_id,v.keyword);
				table.insert(items,{name = turn_lan( v.name  )  ,id = sys_id})
			else 
				table.insert(items,{name = '' ,flags =  MF_SEPARATOR })
			end 
		end 
	end 
end

local function init(styles)
	cur_language_ = language_.get()
	cur_styles_ = styles
end

local function close()
	cur_styles_ = nil
end 

function create_menus(styles,menus)
	if type(styles)~='table' then return end
	if type(menus)~='table' then return end	
--	save_fixed()
	init_menu()
	ID_MGR.set_menus(menus);
	init(styles)
	create_items(styles);
	close()
end





