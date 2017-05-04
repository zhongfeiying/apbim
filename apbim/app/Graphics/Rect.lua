_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Graphics/Rect";
	-- Points={[1],[2]};
};
require"sys.Entity".Class:met(Class);

--callback
--[[
function Class:on_write_info()
	self:set_info{
		{Classname = self.Classname};
		{Type = self.Type};
		{Point1 = require"sys.text".array(self:get_pt(1))};
		{Point2 = require"sys.text".array(self:get_pt(2))};
		{Area = self:get_area()};
		{Date = self:get_date_text()}
	};
end
--]]

function Class:on_write_info()
	self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	self:add_info_text("Area",self:get_area());
	self:add_info_text("Date",self:get_date_text());
	self:add_info_text("Color",require"sys.text".color(self.Color));
	self:add_info_text("Point1",require"sys.text".array(self:get_pt(1)));
	self:add_info_text("Point2",require"sys.text".array(self:get_pt(2)));
end

function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt1 = self:get_pt(1);
	local pt2 = self:get_pt(2);
	self:set_shape_diagram{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z};
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt2.y,(pt1.z+pt2.z)/2};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt1.y,(pt1.z+pt2.z)/2};
				};
				lines = {{1,3},{1,4},{2,3},{2,4}};
			};
		};
	};
end

function Class:on_draw_wireframe()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt1 = self:get_pt(1);
	local pt2 = self:get_pt(2);
	self:set_shape_wireframe{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z};
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt2.y,(pt1.z+pt2.z)/2};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt1.y,(pt1.z+pt2.z)/2};
				};
				lines = {{1,3},{1,4},{2,3},{2,4}};
			};
		};
	};
end

function Class:on_draw_rendering()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt1 = self:get_pt(1);
	local pt2 = self:get_pt(2);
	self:set_shape_rendering{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z};
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt2.y,(pt1.z+pt2.z)/2};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt1.y,(pt1.z+pt2.z)/2};
				};
				outer = {4,2,3,1};
			};
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z};
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt2.y,(pt1.z+pt2.z)/2};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt1.y,(pt1.z+pt2.z)/2};
				};
				outer = {1,3,2,4};
			};
		};
	};
end

function Class:get_area()
	local pt1 = self:get_pt(1);
	local pt2 = self:get_pt(2);
	local pt3 = {pt1.x,pt2.y,(pt1.z+pt2.z)/2};
	local pt4 = {pt2.x,pt1.y,(pt1.z+pt2.z)/2};
	local cx = pt1:distance(pt3);
	local cy = pt1:distance(pt4);
	return cx*cy;
end


