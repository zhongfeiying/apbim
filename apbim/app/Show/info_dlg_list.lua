_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"

local list_ = iup.list{expand="Yes",editbox="Yes"}
local show_ = iup.button{title="Show",rastersize="60x30"};

local dlg_ = iup.dialog{
	title = "Property";
	rastersize = "300X500";
	margin = "5x5";
	iup.vbox{
		iup.hbox{list_};
		iup.hbox{iup.fill{},show_};
	};
};

local function get_property_ks()
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return {} end
	local ppts = {};
	local run = require"sys.progress".create{title="Init",count=require"sys.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if type(v.on_register_property)=="function" then
			v:on_register_property(ppts);
		end
		run();
	end
	return ppts;
end

local function get_toggle_vs()
	local ppts = get_property_ks();
	local togs = {};
	for k,v in pairs(ppts) do
		local tog = iup.toggle{title=k,expand="Horizontal"};
		table.insert(togs,tog);
	end
	return togs;
end

local function init()
	local ks = get_property_ks();
	local vs = require"sys.table".sortk(ks);
	list_[1] = nil;
	for i,v in ipairs(vs) do
		list_[i] = v;
	end
end

local function show_text()
	local str = list_.text;
	
	local ents = require"sys.mgr".get_scene_all();
	if not ents then return {} end
	local ppts = {};
	local run = require"sys.progress".create{title="Show",count=require"sys.table".count(ents),time=1};
	for k,v in pairs(ents) do
		v = require"sys.mgr".get_table(k,v);
		if type(v.on_register_property)=="function" then
			v:on_register_property(ppts);
		end
		run();
	end
end

function show_:action()
	show_text();
end

function list_:doubleclick()
	show_text();
end

function pop(sc)
	init();
	dlg_:show();
end
