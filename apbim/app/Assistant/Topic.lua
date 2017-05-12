_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Assistant/Topic";
	-- Points = {[1]};
	-- Title = ;
	-- Text = ;
	-- Color = {255,255,255};
	-- ids = {[id]=true,...};
};
require"sys.Entity".Class:met(Class);

function Class:on_edit()
	require'sys.dock'.add_page(require'app.Assistant.topic_page'.pop());
	require'sys.dock'.active_page(require'app.Assistant.topic_page'.pop());
	-- require'app.Assistant.topic_page'.pop()
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
					{cr.r,cr.g,cr.b,1,1,pt.x,pt.y,pt.z};
				};
				lines = {{1,1}};
				texts = {{ptno=1,r=cr.r,g=cr.g,b=cr.b,str=self.Title or "<<?>>"};};
			};
		};
	};
end
--[[
function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	local r = (self.Side or 10)/2;
	self:set_shape_diagram{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y-r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y-r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y+r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y+r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y-r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y-r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y+r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y+r,pt.z+r};
				};
				lines = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}};
				texts = {
					{ptno=1,r=cr.r,g=cr.g,b=cr.b,str="?"};
				};
			};
		};
	};
end
--]]
--[[
function Class:on_draw_wireframe()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	local r = (self.Side or 10)/2;
	self:set_shape_wireframe{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y-r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y-r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y+r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y+r,pt.z-r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y-r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y-r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x+r,pt.y+r,pt.z+r};
					{cr.r,cr.g,cr.b,1,1,pt.x-r,pt.y+r,pt.z+r};
				};
				lines = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}};
				texts = {
					{ptno=1,r=1,g=0,b=0.5,str="?"};
				};
			};
		};
	};
end
--]]
--[[
function Class:on_draw_rendering()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	local pts = {
		{cr.r,cr.g,cr.b,0,1,pt.x-500,pt.y-500,pt.z-500};
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
			{points = pts,outer = {1,2,6,5}};
			{points = pts,outer = {2,3,7,6}};
			{points = pts,outer = {3,4,8,7}};
			{points = pts,outer = {4,1,5,8}};
		};
	};
end
--]]

