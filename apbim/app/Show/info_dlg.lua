_ENV = module(...,ap.adv)

local iup = require"iuplua";
local iupcontrol = require"iupluacontrols"

local dlg_ = nil;

function pop(sc)

	local togs_ = {};
	local ok_ = iup.button{title="OK",rastersize="60x30"};
	local cancel_ = iup.button{title="Cancel",rastersize="60x30"};

	local function set_entity_info_text_ks(ent,ppts)
		if type(ent)~="table" then return end
		local s = require"sys.Entity".Class.get_info_text(ent);
		if type(s)~="table" then s={} end
		for k,v in pairs(s) do
			ppts[k]=v;
		end
	end
		
		

	local function get_info_text_ks()
		local ents = require"sys.mgr".get_scene_all();
		if not ents then return {} end
		local ppts = {};
		local run = require"sys.progress".create{title="Init",count=require"sys.table".count(ents),time=1};
		for k,v in pairs(ents) do
			v = require"sys.mgr".get_table(k,v);
			set_entity_info_text_ks(v,ppts);
			run();
		end
		return ppts;
	end

	local function set_toggle_vs()
		local ppts = get_info_text_ks();
		togs_ = {};
		for k,v in pairs(ppts) do
			local tog = iup.toggle{title=k,expand="Horizontal"};
			table.insert(togs_,iup.fill{});
			table.insert(togs_,tog);
		end
	end

	local function init()
		set_toggle_vs();
		dlg_ = iup.dialog{
			title = "Information";
			rastersize = "300X400";
			margin = "10x10";
			iup.vbox{
				iup.frame{
					iup.vbox(togs_);
				};
				iup.hbox{iup.fill{},ok_,cancel_};
			};
		};
	end

	local function get_toggle_selection_ks()
		local sels = {};
		for i,v in pairs(togs_) do
			if v.title then
				if v.value == "ON" then sels[v.title] = true else sels[v.title] = false end
			end
		end
		return sels;
	end

	local function set_entity_info_show(ent,sels)
		for k,v in pairs(sels) do
			require"sys.Entity".Class.set_info_show(ent,k,v);
		end
	end

	local function show_text()
		local sels = get_toggle_selection_ks();
		local ents = require"sys.mgr".get_scene_all();
		if not ents then return {} end
		local ppts = {};
		local run = require"sys.progress".create{title="Show",count=require"sys.table".count(ents),time=1};
		for k,v in pairs(ents) do
			v = require"sys.mgr".get_table(k,v);
			set_entity_info_show(v,sels);
			require"sys.mgr".redraw(v);
			run();
		end
		require'sys.mgr'.update();
	end

	function ok_:action()
		show_text();
		dlg_:hide();
	end

	function cancel_:action()
		dlg_:hide();
	end

	if dlg_ then dlg_:hide() end
	init();
	dlg_:show();
end
