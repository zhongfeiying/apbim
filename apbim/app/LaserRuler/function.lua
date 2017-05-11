_ENV = module(...,ap.adv)
local dis_x_ = 0   -- 每个模型的起始点
local dis_ = 1000  -- 修改每个模型的间距

local function draw_section(space,str,alignment)
	if not require"sys.io".is_there_file{file="app/LaserRuler/Member.lua"} then return end
	local t =require"app.LaserRuler.Member".Class:new{Type="LaserRuler",Color={0,0,255}};
	t:add_pt{0,dis_x_,0};
	t:add_pt{1000,dis_x_,0};
	
	dis_x_ = dis_x_ + dis_
	t:set_mode_rendering();
	local dis_pos = 0
	local cur_nums = 0;
	for data in string.gmatch (str,"[^,]+") do 
		if not string.find(data,"%d") then break end 
		cur_nums = cur_nums + 1
		local nums = 0
		local w1,w2 = nil,nil
		for per_data in string.gmatch(data,"[^%s]+") do 
			nums = nums + 1
			if nums == 1 then 
				w1 = per_data
			elseif nums == 2 then 
				w2 = per_data
			end
		end 
		if cur_nums == 1 then 
			if not w2 then 
				t.Circle=true;
				w2 = w1
			else 
				t.Circle=false;
			end
		else
			if t.Circle then 
				w2 = w1
			else 
				if not w2 then 
					w2 = w1 
				end
			end
		end
		if alignment then t.Alignment = true end
		t:add_section{w1=w1,w2=w2,p=dis_pos};
		dis_pos = dis_pos + space;
	end 
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
	require"sys.mgr".scene_scale{scene=sc,scale=1,update=true}
end

local function get_file()
	local f = require"sys.iup".open_file_dlg{directory="Sample/LaserRuler/",extension="lsr"};
	if not f or f=="" then return end
	return f;
end

local function deal_str_ifo(str)
	local space = nil;
	local i = string.find(str,":")
	if not i then 
		space = 1
	else 
		space = string.sub(str,1,i-1)
		str = string.sub(str,i+1,-1)
	end
	return space,str
end

local function Alignment_Center()
	sc = sc or require"sys.mgr".new_scene();
	local f = get_file();
	if not f then return end
	local file = io.open(f,"r")
	local str = file:read("*all")
	file:close()
	local space,str = deal_str_ifo(str)
	draw_section(space,str)
end

local function Alignment_Side()
	sc = sc or require"sys.mgr".new_scene();
	local f = get_file();
	if not f then return end
	local file = io.open(f,"r")
	local str = file:read("*all")
	file:close()
	local space,str = deal_str_ifo(str)
	draw_section(space,str,true)
end

function load()
	require"sys.menu".add{view = true,frame = true,app="LaserRuler",pos={"Window","Close"},name={"LaserRuler","Alignment Center"},f=Alignment_Center};
	require"sys.menu".add{view = true,frame = true,app="LaserRuler",pos={"Window","Close"},name={"LaserRuler","Alignment Side"},f=Alignment_Side};
end



