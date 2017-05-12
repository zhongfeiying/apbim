_ENV = module(...,ap.adv)
local iup_ = require "iuplua";

local f_x_label_ = iup_.label{title="X="}
local f_x_text_ = iup_.text{expand="HORIZONTAL",value=8000}
local f_y_label_ = iup_.label{title="Y="}
local f_y_text_ = iup_.text{expand="HORIZONTAL",value=6000}
local f_h_label_ = iup_.label{title="H="}
local f_h_text_ = iup_.text{expand="HORIZONTAL",value=3000}
local w_label_ = iup_.label{title="W="}
local w_text_ = iup_.text{expand="HORIZONTAL",value=3000}
local d_h_label_ = iup_.label{title="H="}
local d_h_text_ = iup_.text{expand="HORIZONTAL",value=1200}


local ok_ = iup_.button{title="OK",rastersize="60X30"};
local cancel_ = iup_.button{title="Cancel",rastersize="60X30"};

dlg_ = iup_.dialog
{
	title="WDF", 
	iup_.vbox{
		iup_.tabs{
			iup_.vbox
			{
				tabtitle = "Æ½Ì¨",
				iup_.hbox{f_x_label_,f_x_text_,f_y_label_,f_y_text_,f_h_label_,f_h_text_};
			};
			iup_.vbox
			{
				tabtitle = "Â¥ÌÝ",
				iup_.hbox{w_label_,w_text_};
			};
			iup_.vbox
			{
				tabtitle = "»¤À¸",
				iup_.hbox{d_h_label_,d_h_text_};
			};
		};
		iup_.hbox{ok_, cancel_};
		alignment="ARIGHT";
	};
	rastersize="500x", 
	margin="10x10";
}

local opt_={x=0,y=0,z=0};

local function add_ent(t,sc)
	sc = require"sys.mgr".get_cur_scene() or require"sys.mgr".new_scene{name="Test"};
	t:set_mode_rendering();
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end


-- local function run()end


local function add_f_plate(pts)
	local t =require"app.Steel.Plate".Class:new{Type="WDF",Mode=require"sys.Entity".Rendering};
	t.Color={128,128,0};
	t.Thick = 50;
	t:align_top();
	t:add_pts(pts)
	add_ent(t);
end

local function add_f_column(pt1,pt2)
	local t =require"app.Steel.Member".Class:new{Type="WDF"};
	t.Color={255,0,0};
	t.Section="HH150*150*130*20";
	t:add_pts{pt1,pt2};
	add_ent(t);
end

local function add_f_brace(pt1,pt2)
	local t =require"app.Steel.Member".Class:new{Type="WDF"};
	t.Color={255,0,255};
	t.Section="P50*5";
	t:add_pts{pt1,pt2};
	add_ent(t);
end

local function add_d(pt1,pt2,h)
	local pt3 = require"sys.geometry".Point:new{pt1.x,pt1.y,pt1.z+h};
	local pt4 = require"sys.geometry".Point:new{pt2.x,pt2.y,pt2.z+h};
	local t =require"app.Steel.Member".Class:new{Type="WDF"};
	t.Color={0,0,255};
	t.Section="P60*2";
	t:add_pts{pt3,pt4};
	add_ent(t);
	
	local dis = pt1:distance(pt2);
	local nor = pt2 - pt1;
	local i,step = 0,500;
	while step*i < dis  do
		local s = require"sys.table".deepcopy(pt1);
		local e = require"sys.table".deepcopy(pt3);
		s:polarto(nor,step*i);
		e:polarto(nor,step*i);
		local t =require"app.Steel.Member".Class:new{Type="WDF"};
		t.Color={128,0,255};
		t.Section="P15*0.2";
		t:add_pts{s,e};
		add_ent(t);
		i = i+1;
	end
end

local function add_w_brace(pt1,pt2)
	local t =require"app.Steel.Member".Class:new{Type="WDF"};
	t.Color={0,0,255};
	t.Section="HH100*100*80*20";
	t:add_pts{pt1,pt2};
	add_ent(t);
end

local function add_w(pt1,pt2,w,h)
	local pt3 = require"sys.geometry".Point:new{pt1.x+w,pt1.y,pt1.z};
	local pt4 = require"sys.geometry".Point:new{pt2.x+w,pt2.y,pt2.z};
	add_d(pt1,pt2,h);
	add_d(pt3,pt4,h);
	add_w_brace(pt1,pt2);
	add_w_brace(pt3,pt4);
	
	local dis = pt1:distance(pt2);
	local nor = pt2 - pt1;
	local i,step,wy = 0,500,300;
	while step*i < dis  do
		local s1 = require"sys.table".deepcopy(pt1);
		local e1 = require"sys.table".deepcopy(pt3);
		local s2 = require"sys.table".deepcopy(pt1);
		local e2 = require"sys.table".deepcopy(pt3);
		s1:polarto(nor,step*i);
		e1:polarto(nor,step*i);
		s2:polarto(nor,step*i);
		e2:polarto(nor,step*i);
		s1.y = s1.y - wy;
		s2.y = s2.y + wy;
		e1.y = e1.y - wy;
		e2.y = e2.y + wy;
		local t =require"app.Steel.Plate".Class:new{Type="WDF"};
		t.Color={255,0,255};
		t.Thick = 20;
		t:align_top();
		t:add_pts{s1,e1,e2,s2};
		add_ent(t);
		i = i+1;
	end

end

function ok_:action()
	if not require"sys.io".is_there_file{file="app/Steel/Member.lua"} then return end
	if not require"sys.io".is_there_file{file="app/Steel/Plate.lua"} then return end
	
	local sc = require"sys.mgr".new_scene{name="Test"};
	dlg_:hide();

	local fx = tonumber(f_x_text_.value); fx = fx<1 and 1 or fx;
	local fy = tonumber(f_y_text_.value); fy = fy<1 and 1 or fy;
	local fz = tonumber(f_h_text_.value); fz = fz<1 and 1 or fz;
	local w = tonumber(w_text_.value); w = w<1 and 1 or w;
	local h = tonumber(d_h_text_.value); h = h<1 and 1 or h;
	
	local pt01 = require"sys.geometry".Point:new{opt_.x,opt_.y,opt_.z};
	local pt02 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y,opt_.z};
	local pt03 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y+fy,opt_.z};
	local pt04 = require"sys.geometry".Point:new{opt_.x,opt_.y+fy,opt_.z};
	
	local pt011 = require"sys.geometry".Point:new{opt_.x+fx*1/4,opt_.y-fz,opt_.z};
	local pt012 = require"sys.geometry".Point:new{opt_.x+fx*1/4+w,opt_.y-fz,opt_.z};
	
	local pt21 = require"sys.geometry".Point:new{opt_.x,opt_.y,opt_.z+fz};
	local pt22 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y,opt_.z+fz};
	local pt23 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y+fy,opt_.z+fz};
	local pt24 = require"sys.geometry".Point:new{opt_.x,opt_.y+fy,opt_.z+fz};
	
	local pt211 = require"sys.geometry".Point:new{opt_.x+fx*1/4,opt_.y,opt_.z+fz};
	local pt212 = require"sys.geometry".Point:new{opt_.x+fx*1/4+w,opt_.y,opt_.z+fz};
	
	local pt11 = require"sys.geometry".Point:new{opt_.x,opt_.y,opt_.z+fz/4};
	local pt12 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y,opt_.z+fz/4};
	local pt13 = require"sys.geometry".Point:new{opt_.x+fx,opt_.y+fy,opt_.z+fz/4};
	local pt14 = require"sys.geometry".Point:new{opt_.x,opt_.y+fy,opt_.z+fz/4};

	add_f_plate{pt21,pt22,pt23,pt24};
	add_f_column(pt01,pt21);
	add_f_column(pt02,pt22);
	add_f_column(pt03,pt23);
	add_f_column(pt04,pt24);
	add_f_brace(pt11,pt12);
	add_f_brace(pt12,pt13);
	add_f_brace(pt13,pt14);
	add_f_brace(pt14,pt11);
	
	add_d(pt21,pt211,h);
	add_d(pt22,pt212,h);
	add_d(pt22,pt23,h);
	add_d(pt23,pt24,h);
	add_d(pt24,pt21,h);

	add_w(pt011,pt211,w,h);	
		

	-- local sc = require"sys.mgr".get_cur_scene() or require"sys.mgr".new_scene{name="Test"};
	

	-- require"sys.mgr".update(sc);
	-- require"sys.statusbar".show_model_count();
end

function dlg_:k_any(n)
	if n==iup.K_CR then ok_:action() end
end

function cancel_:action()
	dlg_:hide();
end

function pop()
	dlg_:show()
end

