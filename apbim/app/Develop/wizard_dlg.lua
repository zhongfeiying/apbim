_ENV = module(...,ap.adv)

local iup = require"iuplua"

local app_label_ = iup.label{title="Name:",size="30X"};
local app_text_ = iup.text{expand="Horizontal",value="NewApp"};
local app_cb_all_ = iup.list{expand="Yes","on_load()","on_init()"};
local new_app_ = iup.button{title="Create",size="60X15"};

local class_label_ = iup.label{title="Name:",size="30X"};
local class_text_ = iup.text{expand="Horizontal",value="NewClass"};
local pclass_label_ = iup.label{title = "Parent:",size="30X"};
local pclass_text_ = iup.list{expand="Horizontal",value="sys.Entity",dropdown="Yes",editbox="Yes","sys.Item","sys.Entity","sys.Group"};
local class_cb_all_ = iup.list{expand="Yes","on_write_info()","on_edit()","on_draw_diagram()","on_draw_wireframe()","on_draw_rendering()"};
local new_class_ = iup.button{title="Create",size="60X15"};

-- local menu_ = iup.tree{expand="Yes",ADDROOT  = "NO"};
-- local cur_lable_ = iup.label{title="Menu Text:",size="60X"};
-- local cur_text_ = iup.text{expand="Horizontal"};
-- local cbf_lable_ = iup.label{title="Function Name:",size="60X"};
-- local cbf_text_ = iup.text{expand="Horizontal"};
-- local cbf_frame_toggle_ = iup.toggle{title="Frame"};
-- local cbf_view_toggle_ = iup.toggle{title="View"};
-- local add_ = iup.button{title="Add",size="60X"};
-- local del_ = iup.button{title="Delete",size="60X"};

local ok_ = iup.button{title="OK",size="60X15"};
local cancel_ = iup.button{title="Close",size="60X15"};

local dlg_ = iup.dialog{
	title = "Wizard";
	rastersize = "480X"; 
	iup.tabs{
		iup.vbox{
			tabtitle = "App";
			iup.frame{
				title = "App:";
				iup.vbox{
					iup.hbox{app_label_,app_text_};
					iup.frame{
						title="Callback function:";
						iup.hbox{app_cb_all_};
					};
					iup.hbox{iup.fill{},new_app_};
				};
			};
		};
		iup.vbox{
			tabtitle = "Class";
			iup.frame{
				title = "Class:";
				iup.vbox{
					iup.hbox{class_label_,class_text_};
					iup.hbox{pclass_label_,pclass_text_};
					iup.frame{
						title="Callback function:";
						iup.hbox{class_cb_all_};
					};
					iup.hbox{iup.fill{},new_class_};
				};
			};
		};
	};
	alignment="ARight";
	margin="10x10";
};
		-- iup.frame{
			-- title = "Menu:";
			-- iup.vbox{
				-- menu_;
				-- iup.hbox{cur_lable_,cur_text_};
				-- iup.hbox{cbf_lable_,cbf_text_};
				-- iup.hbox{cbf_frame_toggle_,cbf_view_toggle_,iup.fill{},add_,del_};
			-- };
		-- };
		-- iup.hbox{cancel_};

-- local cur_pos_ = 0;

local APP_ = "_APP_";
local CLASS_ = "_CLASS_";
local PCLASS_ = "_PCLASS_";

local main_code_ = [[
_ENV = module(...,ap.adv)

function on_load()
	_G.package.loaded["app._APP_.function"] = nil;
	require"app._APP_.function".load();
end

function on_init()
end

]];

local function_code_ = [[
_ENV = module(...,ap.adv)

local function Trace_Out_AppName(sc)
	trace_out("AppName: _APP_\n");
end

local function Create_Line(sc)
	line_x_ = line_x_ and line_x_+3000 or 0;
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/Graphics/Line.lua"} then trace_out("There isn't the file :  app/Graphics/Line.lua\n") return end
	local t =require"app.Graphics.Line".Class:new{Type="Assistant",Color={0,255,0}};
	t:add_pt{line_x_+0,0,5000};
	t:add_pt{line_x_+0,3000,5000};
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end

local function Create_Beam(sc)
	beam_x_ = beam_x_ and beam_x_+3000 or 0;
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/Steel/Member.lua"} then trace_out("There isn't the file :  app/Steel/Member.lua\n") return end
	local t =require"app.Steel.Member".Class:new{Type="Beam",Color={0,0,255},Section="H-200*100*5*15"};
	t:add_pt{beam_x_+0,2000,3000};
	t:add_pt{beam_x_+0,1000,3000};
	t:set_mode_rendering();
	t:align_bottom();
	t:align_right();
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end

local function Create_Rect(sc)
	rect_x_ = rect_x_ and rect_x_+3000 or 0;
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/Graphics/Rect.lua"} then trace_out("There isn't the file :  app/Graphics/Rect.lua\n") return end
	local t =require"app.Graphics.Rect".Class:new{Type="Assistant",Color={127,127,127}};
	t:set_mode_rendering();
	t:add_pt{rect_x_+0,0,-2000};
	t:add_pt{rect_x_+2000,3000,-2000};
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end

local function Create_NewClass_Object(sc)
	local classname = "NewClass";
	obj_x_ = obj_x_ and obj_x_+3000 or 0;
	sc = sc or require"sys.mgr".new_scene();
	if not require"sys.io".is_there_file{file="app/_APP_/"..classname..".lua"} then trace_out("There isn't the file :  app/_APP_/"..classname..".lua\n") return end
	_G.package.loaded["app._APP_."..classname] = nil;
	local t =require("app._APP_."..classname).Class:new{Type="Undefined",Color={255,0,255}};
	t:add_pt{obj_x_+0,2000,0};
	t:set_mode_rendering();
	t:update_data();
	require"sys.mgr".add(t);
	require"sys.mgr".draw(t,sc);
	require"sys.mgr".update(sc);
end

function load()
	require"sys.menu".add{app="_APP_",frame=true,view=true,pos={"Window"},name={"_APP_","Trace Out","AppName"},f=Trace_Out_AppName};
	require"sys.menu".add{app="_APP_",frame=true,view=true,pos={"Window"},name={"_APP_","Create","Line"},f=Create_Line};
	require"sys.menu".add{app="_APP_",frame=true,view=true,pos={"Window"},name={"_APP_","Create","Beam"},f=Create_Beam};
	require"sys.menu".add{app="_APP_",frame=true,view=true,pos={"Window"},name={"_APP_","Create","Rect"},f=Create_Rect};
	require"sys.menu".add{app="_APP_",frame=true,view=true,pos={"Window"},name={"_APP_","Create","NewClass Object"},f=Create_NewClass_Object};
end
]];

local class_code_ = [[
_ENV = module(...,ap.adv)

Class = {
	Classname = "app/_APP_/_CLASS_";
};
require"_PCLASS_".Class:met(Class);

function Class:on_edit()
end

function Class:on_write_info()
	self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	self:add_info_text("Date",self:get_date_text());
	self:add_info_text("Color",require"sys.text".color(self.Color));
	self:add_info_text("Point",require"sys.text".array(self:get_pt(1)));
end

function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	self:set_shape_diagram{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z+500};
				};
				lines = {{1,7},{2,8},{3,5},{4,6}};
			};
		};
	};
end

function Class:on_draw_wireframe()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	self:set_shape_wireframe{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z-500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z+500};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z+500};
				};
				lines = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}};
			};
		};
	};
end

function Class:on_draw_rendering()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	local pts = {
		{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z-500};
		{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z-500};
		{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z-500};
		{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z-500};
		{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z+500};
		{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z+500};
		{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z+500};
		{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z+500};
	};
	self:set_shape_rendering{
		surfaces = {
			{points = pts,outer = {4,3,2,1}};
			{points = pts,outer = {5,6,7,8}};
			-- {points = pts,outer = {1,2,6,5}};
			-- {points = pts,outer = {2,3,7,6}};
			-- {points = pts,outer = {3,4,8,7}};
			-- {points = pts,outer = {4,1,5,8}};
		};
	};
end
]]



local function create_app_folder(name)
	local path = "app\\"..name.."\\";
	require"sys.api.dir".create_folder(path)
end

local function create_app_main_file(name)
	local file = "app\\"..name.."\\main.lua";
	if require"sys.io".is_there_file{file=file} then return end
	local str = string.gsub(main_code_,APP_,name);
	local f = io.open(file,"w");
	if not f then return end
	f:write(str);
	f:close();
end

local function create_app_function_file(name)
	local file = "app\\"..name.."\\function.lua";
	if require"sys.io".is_there_file{file=file} then return end
	local str = string.gsub(function_code_,APP_,name);
	local f = io.open(file,"w");
	if not f then return end
	f:write(str);
	f:close();
end

local function create_class_file(app,class,pclass)
	local file = "app\\"..app.."\\"..class..".lua";
	if require"sys.io".is_there_file{file=file} then return end
	local str = class_code_;
	local str = string.gsub(str,APP_,app);
	local str = string.gsub(str,CLASS_,class);
	local str = string.gsub(str,PCLASS_,pclass);
	local f = io.open(file,"w");
	if not f then return end
	f:write(str);
	f:close();
end

local function create_app()
	local name = tostring(app_text_.value);
	if name =="" then return end
	create_app_folder(name);
	create_app_main_file(name);
	create_app_function_file(name);
	return name;
end

local function create_class()
	local appname = create_app();
	local classname = tostring(class_text_.value);
	local pclassname = tostring(pclass_text_.value);
	if appname =="" or classname =="" or pclassname =="" then return end
	create_class_file(appname,classname,pclassname);
end

function new_app_:action()
	create_app();
end

function new_class_:action()
	create_class();
end

function ok_:action()
	dlg_:hide();
end

function cancel_:action()
	dlg_:hide();
end

function pop(sc)
	dlg_:show();
end
