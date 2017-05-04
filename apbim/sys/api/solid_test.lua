_ENV = module(...,ap.adv)

local ent_ = require "app.Steel.Member";
local section_ = require "sys.api..section";
local solid_ = require "sys.api.solid";
local geo_ = require "sys.geometry";
local obj_ = require "sys.shape";
local mgr_ = require "sys.mgr";


function add_extrude_line()
	trace_out("#----1:add_extrude_line\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.extrude{
		mode = solid_.Line;
		solid = {
			color = {r=1,g=0,b=0};
			length = 5000;
			direction = {0,0,1};
		};
		placement = {
			base = {0,0,0};
		};
	};
	mgr_.add(ent);
end

function add_extrude_frame()
	trace_out("#----2:add_extrude_frame\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.extrude{
		mode = solid_.Frame;
		solid = {
			color = {r=0,g=1,b=0};
			length = 5000;
			direction = {0,0,1};
			bottom = {
				outer = {{0,0,0};{500,0,0};{0,500,0};};
				inners = {{{100,100,0};{300,100,0};{100,300,0};};};
			};
			top = {
				outer = {{0,0,0};{1800,0,0};{0,1800,0};};
				inners = {{{100,100,0};{1500,100,0};{100,1500,0};};};
			};
		};
		placement = {
			base = {0,5000,0};
		};
	};
	mgr_.add(ent);
end

function add_extrude_render()
	trace_out("#----3:add_extrude_render\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=1,b=0};
			length = 5000;
			direction = {0,0,1};
			bottom = {
				outer = {{0,0,0};{50,0,0};{50,50,0};{0,50,0};};
				inners = {{{20,20,0};{40,20,0};{40,40,0};{20,40,0};};};
			};
			top = {
				outer = {{0,0,0};{180,0,0};{180,180,0};{0,180,0};};
				inners = {{{10,10,0};{150,10,0};{150,150,0};{10,150,0};};};
			};
		};
		placement = {
			base = {0,10000,0};
		};
	};
	mgr_.add(ent);
end

function add_extrude_section_profile_size()
	trace_out("----#4:add_section_profile_size\n");
	local ent = ent_.Class:new{shape={}};
	local bouter,binners = section_.profile_points{type=section_.P,a=500,t=15.5;}
	local touter,tinners = section_.profile_points{type=section_.P,a=200,t=15.5;}
	ent.shape.diagram = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=1,b=0};
			length = 5000;
			direction = {0,0,1};
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,15000,0};
		};
	};
	mgr_.add(ent);
end

function add_extrude_section_profile_text()
	trace_out("----#5:add_section_profile_text\n");
	local ent = ent_.Class:new{shape={}};
	local bouter,binners = section_.profile("H-800*100*20*5.5");
	local touter,tinners = section_.profile "H-300*100*20*5.5";
	ent.shape.diagram = solid_.extrude{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=0,b=0};
			length = 5000;
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,20000,0};
		};
	};
	mgr_.add(ent);
end

function add_member()
	trace_out("#----11:add_member\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.member{
		mode = solid_.Render;
		section="C-500*300*100*15";
		color={r=1,g=0.5,b=0.5};
		pt1={0,0};
		pt2={5000,0}
	};
	local axis = geo_.Axis:new():set_offset_line{{0,0,0},{0,0,10000}};
	obj_.coord_l2g(ent.object,axis);
	mgr_.add(ent);
end

function add_revolve_line()
	trace_out("#----6:add_revolve_line\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.revolve{
		mode = solid_.Line;
		solid = {
			color = {r=0,g=1,b=0};
			angle = 135;
			axisline = {{3000,0,0},{3000,1,0}};
		};
		placement = {
			base = {0,0,5000};
		};
	};
	mgr_.add(ent);
end

function add_revolve_frame()
	trace_out("----#7:add_revolve_frame\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.revolve{
		mode = solid_.Frame;
		solid = {
			color = {r=0,g=0,b=1};
			angle = 135;
			axisline = {{3000,0,0},{3000,1,0}};
			bottom = {
				outer = {{0,0,0};{500,0,0};{0,500,0};};
				inners = {{{100,100,0};{300,100,0};{100,300,0};};};
			};
			top = {
				outer = {{0,0,0};{1800,0,0};{0,1800,0};};
				inners = {{{100,100,0};{1500,100,0};{100,1500,0};};};
			};
		};
		placement = {
			base = {0,5000,5000};
		};
	};
	mgr_.add(ent);
end

function add_revolve_render()
	trace_out("#----8:add_revolve_render\n");
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = solid_.revolve{
		mode = solid_.Render;
		solid = {
			color = {r=0,g=0,b=1};
			angle = 135;
			axisline = {{3000,0,0},{3000,1,0}};
			bottom = {
				outer = {{0,0,0};{50,0,0};{50,50,0};{0,50,0};};
				inners = {{{20,20,0};{40,20,0};{40,40,0};{20,40,0};};};
			};
			top = {
				outer = {{0,0,0};{180,0,0};{180,180,0};{0,180,0};};
				inners = {{{10,10,0};{150,10,0};{150,150,0};{10,150,0};};};
			};
		};
		placement = {
			base = {0,10000,5000};
		};
	};
	mgr_.add(ent);
end

function add_revolve_section_profile_size()
	trace_out("----#9:add_revolve_section_profile_size\n");
	local ent = ent_.Class:new{shape={}};
	local bouter,binners = section_.profile_points{type=section_.P,a=500,t=15.5;}
	local touter,tinners = section_.profile_points{type=section_.P,a=200,t=15.5;}
	ent.shape.diagram = solid_.revolve{
		mode = solid_.Render;
		solid = {
			color = {r=1,g=0,b=1};
			angle = 135;
			axisline = {{3000,0,0},{3000,1,0}};
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,15000,5000};
		};
	};
	mgr_.add(ent);
end

function add_revolve_section_profile_text()
	trace_out("----#10:add_revolve_section_profile_text\n");
	local ent = ent_.Class:new{shape={}};
	local bouter,binners = section_.profile("H-800*100*20*5.5");
	local touter,tinners = section_.profile "H-300*100*20*5.5";
	ent.shape.diagram = solid_.revolve{
		mode = solid_.Render;
		solid = {
			color = {r=0,g=0,b=1};
			angle = 135;
			axisline = {{3000,0,0},{3000,1,0}};
			bottom = {
				outer = bouter;
				inners = binners;
			};
			top = {
				outer = touter;
				inners = tinners;
			};
		};
		placement = {
			base = {0,20000,5000};
		};
	};
	mgr_.add(ent);
end

local			points_ = {
					{1,0,0, 0,0, 	0,	 0,   0}; 
					{0,1,0, 0,0, 1000,	 0,   0};
					{0,0,1, 0,0, 2000,	 0,1000};
					{0,0,1, 0,0, 2000,1000,1000};
					{0,1,0, 0,0, 1000,1000,	  0};
					{1,0,0, 0,0, 	0,1000,   0};
				};

function test_object()
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = {
		index = 1;
		surfaces = {
			{
				textured = 0;
				points = points_;
				outer = {1,2,3};
			};
		};
	};
	mgr_.add(ent);
end

function test_object2()
	local ent = ent_.Class:new{shape={}};
	ent.shape.diagram = {
		index = 1;
		surfaces = {
			{
				textured = 0;
				points = points_;
				outer = {4,5,6};
			};
		};
	};
	mgr_.add(ent);
end

function add()
	trace_out("####		test_.add()		####\n");
	local sc = require"sys.mgr".get_cur_scene();
	if not sc then sc = new_child(frm,"Test") require"sys.mgr.scene".main(sc) end
	add_extrude_line();
	add_extrude_frame();
	add_extrude_render();
	-- add_extrude_section_profile_size();
	add_extrude_section_profile_text();
	add_revolve_line();
	add_revolve_frame();
	add_revolve_render();
	-- add_revolve_section_profile_size();
	add_revolve_section_profile_text();
	-- add_member();
	-- test_object();
	-- test_object2();
	mgr_.draw_all(sc);
	mgr_.update(sc);
	trace_out("####		test_.add() End		####\n");
end
