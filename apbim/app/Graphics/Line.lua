_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Graphics/Line";
	-- Points = {[1],[2]};
	-- Color = {255,255,255};
};
require"sys.Entity".Class:met(Class);

--callback

function Class:on_edit()
	require"app/Graphics/line_dlg".pop();
end
--[[
function Class:on_write_info()
	self:set_info{
		{Classname = self.Classname};
		{Type = self.Type};
		{Point1 = require"sys.text".array(self:get_pt(1))};
		{Point2 = require"sys.text".array(self:get_pt(2))};
		{Length = self:get_length()};
		{Date = self:get_date_text()}
	};
end
--]]

---[[
function Class:on_write_info()
	self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	self:add_info_text("Length",self:get_length());
	self:add_info_text("Date",self:get_date_text());
	self:add_info_text("Color",require"sys.text".color(self.Color));
	-- self:add_info_text("Point1",require"sys.text".array(self:get_pt(1)));
	-- self:add_info_text("Point2",require"sys.text".array(self:get_pt(2)));
end
--]]

function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local shape = {surfaces={{points={},lines={}}}}
	local pts = self:get_pts(); 
	for i=1,#pts do
		table.insert(shape.surfaces[1].points,{cr.r,cr.g,cr.b,1,1,pts[i].x,pts[i].y,pts[i].z})
		local e = i<(#pts) and i+1 or 1
		table.insert(shape.surfaces[1].lines,{i,e})
	end
	self:set_shape_diagram(shape)
	-- local pt1 = self:get_pt(1);
	-- local pt2 = self:get_pt(2);
	-- self:set_shape_diagram{
		-- surfaces = {
			-- {
				-- points = {
					-- {cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z};
					-- {cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z};
				-- };
				-- lines = {{1,2}};
			-- };
		-- };
	-- };
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
					{cr.r,cr.g,cr.b,1,1,pt1.x,pt1.y,pt1.z+1};
					{cr.r,cr.g,cr.b,1,1,pt2.x,pt2.y,pt2.z+1};
				};
				outer = {1,2,4,3};
				lines = {{1,2}};
			};
		};
	};
end


