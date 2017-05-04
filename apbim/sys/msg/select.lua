_ENV = module(...,ap.adv)


local select_main_objids_ = {};
local run_calculate_,close_calculate_ = nil,nil;
local selecting_ = nil;

function is_selecting()
	return selecting_;
end

function begin_selecting()
	selecting_ = true;
end

function end_selecting()
	select_main_objids_ = {};
	selecting_ = nil;
end

-- local xxx_ = 0; 

local function run_calculate()
	if type(run_calculate_)=="function" then run_calculate_() end
end

local function close_calculate()
	if type(close_calculate_)=="function" then close_calculate_() end
end

function begin_calucate()
	if type(run_calculate_)=="function" or type(close_calculate_)=="function" then return end
	run_calculate_,close_calculate_ = require"sys.progress".create{title="Calculate Count ... ",time=1,msg=true,dlg=false,update=false};
end

function end_calucate()
	close_calculate();
	run_calculate_,close_calculate_ = nil,nil;
end


local function add_item_to_objids(objid)
	table.insert(select_main_objids_,objid);
end

local function get_mgrids_by_objids(objids)
	local mgrids = {}
	for i,v in ipairs(objids) do
		local mgrid = require"sys.mgr.scene.index".get_mgrid(v);
		mgrids[mgrid] = true;
	end
	return mgrids;
end

local function set(k,v,light,is_redraw)
	local ent = require"sys.mgr".get_table(k,v);
	require"sys.mgr".select(ent,light);
	if is_redraw then require"sys.mgr".redraw(ent) end
end

local function set_olds(olds,news,ctr,shf,is_redraw,run)
	if ctr or shf then return end
	-- local oldn = require"sys.table".count(olds);
	-- local run,close = require"sys.progress".create{title="Cancel Selected ... ",count=oldn,time=1,dlg=true,update=false};
	for k,v in pairs(olds) do
		if not news[k] then 
			set(k,v,nil,is_redraw);
		end
		run();
	end
	-- close();
end

local function set_news(olds,news,ctr,shf,is_redraw,run)
	-- local newn = require"sys.table".count(news);
	-- local run,close = require"sys.progress".create{title="Select ... ",count=newn,time=1,dlg=true,update=false};
	for k,v in pairs(news) do
		if not olds[k] then
			set(k,v,true,is_redraw);
		elseif ctr then
			set(k,v,nil,is_redraw);
		end
		run();
	end
	-- close();
end

-- t={olds=,news=,redraw=true}
local function set_s(t)
	local olds = t.olds or {};
	local news = t.news or {};
	local ctr = is_ctr_down();
	local shf = is_shf_down();
	local oldn = require"sys.table".count(olds);
	local newn = require"sys.table".count(news);
	local run,close = require"sys.progress".create{title="Select ... ",count=oldn+newn,time=1,dlg=true,update=false};
	set_olds(olds,news,ctr,shf,t.redraw,run)
	set_news(olds,news,ctr,shf,t.redraw,run)
	close();
end

local function set_all()
	if is_selecting() then return end
	begin_selecting();
	local olds = require"sys.mgr".curs();
	local news = select_main_objids_;
	-- local olds = require"sys.table".deepcopy(require"sys.mgr".curs());
	-- local news = require"sys.table".deepcopy(select_main_objids_);
	set_s{olds=olds,news=get_mgrids_by_objids(news),redraw=true};
	require"sys.mgr".update();
	end_selecting();
end

function start()
	begin_calucate();
end

function step(objid)
	begin_calucate();
	run_calculate();
	add_item_to_objids(objid);
end

function stop()
	set_all()
	end_calucate();
end


--[[
function set_all()
	local objids = select_main_objids_;
	local olds = require"sys.mgr".curs();
	local oldn = require"sys.table".count(olds);
	local news = get_mgrids_by_objids(objids);
	local newn = #objids;
	local run = require"sys.progress".create{title="Select ... ",count=oldn+newn,time=1};
	local ctr = is_ctr_down();
	local shf = is_shf_down();
	for k,v in pairs(olds) do
		if not ctr and not shf and not news[k] then 
			local ent = require"sys.mgr".get_table(k);
			require"sys.mgr".select(ent,nil);
			require"sys.mgr".redraw(ent) 
		end
		run();
	end
	for k,v in pairs(news) do
		local ent = require"sys.mgr".get_table(k);
		if not require"sys.mgr".is_light(ent) then
			require"sys.mgr".select(ent,true);
			require"sys.mgr".redraw(ent);
		elseif ctr then
			require"sys.mgr".select(ent,nil);
			require"sys.mgr".redraw(ent);
		end
		run();
	end
	init();
end
--]]
