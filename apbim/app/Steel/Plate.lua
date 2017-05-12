_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Steel/Plate";
	-- Thick = 10;
	-- Alignment = -0.5~0.5;(Offset,Top:-0.5,Bottom:0.5)
};
require"sys.Entity".Class:met(Class);

--callback

function Class:on_write_info()
	self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	self:add_info_text("Thick",self.Thick);
	self:add_info_text("Alignment",self:get_alignment_text());
	self:add_info_text("Date",self:get_date_text());
	self:add_info_text("Color",require"sys.text".color(self.Color));
	for i,v in ipairs(self:get_pts()) do
		self:add_info_text("Point"..i,require"sys.text".array(self:get_pt(i)));
	end
end

function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local obj = {surfaces={{points={},lines={}}}};
	local s = self:get_pts();
	if type(s)~="table" then return end
	if #s<3 then return end
	for i,v in ipairs(s) do
		local pt = {cr.r,cr.g,cr.b,1,1,v.x,v.y,v.z}
		local pt1 = i;
		local pt2 = i+1<=#s and i+1 or i+1-#s;
		table.insert(obj.surfaces[1].points,pt);
		table.insert(obj.surfaces[1].lines,{pt1,pt2});
	end
	self:set_shape_diagram(obj);
end

function Class:on_draw_wireframe()
	self:set_shape_wireframe(require"app.Steel.shape".draw_plate(self,"wireframe"));
end

function Class:on_draw_rendering()
	self:set_shape_rendering(require"app.Steel.shape".draw_plate(self,"rendering"));
end

function Class:get_alignment_text()
	if type(self.Alignment)~="number" then return "Center" end
	if self.Alignment==-0.5 then return "Top" end
	if self.Alignment==0.5 then return "Bottom" end
	return tostring(self.Alignment);
end

function Class:get_alignment()
	return self.Alignment or 0
end

function Class:align_top()
	self.Alignment = -0.5;
	self:modify();
	return self;
end

function Class:align_center()
	self.Alignment = 0;
	self:modify();
	return self;
end

function Class:align_bottom()
	self.Alignment = 0;
	self:modify();
	return self;
end


