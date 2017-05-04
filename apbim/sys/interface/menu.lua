_ENV = module(...,ap.adv)

local list_ = {};
local tree_ = {};

function init()
	list_ = {
		-- {name={"File","Close"},fixed=true};
		-- {name={"Window","Cascade"},fixed=true};
		-- {name={"Window","Tile Horizontal"},fixed=true};
		-- {name={"Window","Tile Vertical"},fixed=true};
		-- {name={"Arrange Icons"},fixed=true};
	};
	init_tree();
end
	
function init_tree()
	tree_ = {
		items = {
			{
				name = "File";
				fixed = -1;
				items = {
					{
						name = "Close";
						fixed = 0;
					};
				};
			};
			{
				name = "Window";
				fixed = 3;
				items = {
					{
						name = "Cascade";
						fixed = 0;
					};
					{
						name = "Tile Horizontal";
						fixed = 0;
					};
					{
						name = "Tile Vertical";
						fixed = 0;
					};
					{
						name = "Arrange Icons";
						fixed = 0;
					};
				};
			};
		};
	};
end

local function get_main_menu_pos(n)
	local count = require"sys.table".count(require"sys.mgr".get_all_scene());
	if count<=0 then return n-1 else return n end
end

-------------------------------------------------------
--return pos(key) by name
local function find(tab,name)
	if name=="" then return nil end
	if type(tab)~="table" then return nil end
	for i,v in ipairs(tab) do
		if v.name==name then
			return i;
		end
	end
	return nil;
end

local function app_clash(m)
	table.insert(m.name,1,"App");
	table.insert(m.name,2,m.app);
	m.pos=nil;
end

local function add_subname(tab,name,pos)
	if type(name)~="string" then return end
	local name_pos = find(tab.items,name);
	if type(name_pos)=="number" then return tab.items[name_pos] end
	if type(pos)=="string" then pos=find(tab.items,pos) end
	if type(pos)=="nil" then pos=#tab.items+1 end
	if type(pos)~="number" then return end
	table.insert(tab.items,pos,{name=name});
	return tab.items[pos];
end

local function add_m(m)
	m.pos = m.pos or {};
	local t = tree_;
	for i,v in ipairs(m.name) do
		t = add_subname(t,v,m.pos[i]);
		if t.id and m.name[i+1] then app_clash(m) add_m(m) return end
		if t.items and not m.name[i+1] then app_clash(m) add_m(m) return end
		if i==1 or m.name[i+1] then 
			t.items = t.items or {}; 
		else
			t.id = require"sys.interface.id".get_command_id();
			t.items = nil;
			-- t.f = m.f;
			-- t.frame = m.frame;
			-- t.view = m.view;
			if m.frame then require"sys.interface.id".set_frm_command{id=t.id,f=m.f} end
			if m.view then require"sys.interface.id".set_command{id=t.id,f=m.f} end
		end
	end
end


local function add_ms(ms)
	for i,v in pairs(ms) do
		add_m(v);
	end
end

local function fill_tree()
	add_ms(list_);
end
-------------------------------------------------------

local get_ = {};
get_.pop = function (t,m)
	t.flags = MF_POPUP;
	t.id = sub_menu{
		name = "";
		items = get_.items(m);
	};
	return t;
end
get_.null = function (t,m)
	t.flags = MF_SEPARATOR;
	t.id = 0
	t.name = "";
	return t;
end
get_.item = function (m)
	-- if m.fixed then return end -----------------------------
	local t = {
		name=m.name;
		id=m.id;
		fixed=m.fixed;
	};
	-- if not m.items then return t end
	-- return get_.pop(t,m);
	if m.items then return get_.pop(t,m) end
	if m.name=="" then return get_.null(t,m) end
	return t;
end
get_.items = function (m)
	local t = {};
	if not m.items then return t end
	for i=1,#m.items do
		local sub = get_.item(m.items[i]);------------------
		if sub then table.insert(t,sub) end------------------
		-- table.insert(t,get_.item(m.items[i]));
	end
	return t;
end
get_.main = function (m)
	local t = {
		name = m.name;
		fixed = m.fixed;
		items = get_.items(m);
	};
	return t;
end

local function show_fixed(n,m)
-- require'sys.table'.totrace{show_fixed=n,m=m}
	for i=1, #m.items do
-- require'sys.table'.totrace{i=i,name=m.items[i].name,fixed=m.items[i].fixed}
		if not m.items[i].fixed then
			insert_menu(get_submenu(frm,get_main_menu_pos(n)),i-1,m.items[i]);
		end
		-- insert_menu(get_submenu(frm,get_main_menu_pos(n)),i+m.fixed,m.items[i]);
	end
end

local function show_other(n,m)
-- require'sys.table'.totrace{show_other=n,m=m.name}
	m.nposition = get_main_menu_pos(n);
	add_menu(frm,m);
end

local function show_main(n,m)
-- require'sys.table'.totrace{show_main=n,m=m.name}
	local main = get_.main(m);
	if main.fixed then 
		show_fixed(n,main);
	else 
		show_other(n,main);
	end
end


local function show_tree()
-- require'sys.table'.totrace{tree_items=tree_.items}
	for i,v in ipairs(tree_.items) do
		show_main(i,v);
	end
end

-------------------------------------------------------

local function del_sub(m,n,p)
-- require'sys.table'.totrace{del_sub=n,m=m}
	del_menu(frm,get_submenu(frm,get_main_menu_pos(p)),n-1)
end

local function del_subs(m,n)
	local s = m.items;
	for i=#s,1,-1  do
		if not s[i].fixed then
			del_sub(s[i],i,n);
		end
	end
end

local function del_main(m,n)
-- require'sys.table'.totrace{del_main=n,m=m.name}
	del_menu(frm,get_mainmenu(frm),get_main_menu_pos(n))
end

local function del_menu()
	local s = tree_.items;
	if type(s)~="table" then return end
	for i=#s,1,-1  do
		if not s[i].fixed then
			del_main(s[i],i);
		else
			del_subs(s[i],i);
		end
	end
end

-------------------------------------------------------

--[[
arg={
	app = "app/Steel";
	name = {"Steel","Draw","Beam"};
	pos = {"Window",nil,"Column"};
	f = ;
	frame = true;
	view = true;
};
--]]
function add(arg)
	table.insert(list_,arg);
end

function show()
	fill_tree();
	show_tree();
end

function clear()
	del_menu();
	init_tree();
end
