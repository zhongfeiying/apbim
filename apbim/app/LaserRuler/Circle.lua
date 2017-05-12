_ENV = module(...,ap.adv)

Class = {
	Classname = "app/LaserRuler/Member";
};
require"sys.Entity".Class:met(Class);

--callback

function Class:on_write_info()
end

function Class:on_draw_diagram()
	self:set_shape_diagram(require"app.LaserRuler.shape".draw{spt=self:get_spt(),ept=self:get_ept(),sections=self.Sections,color=require"sys.geometry".Color:new(self.Color),circle=self.Circle,mode="diagram"});
end

function Class:on_draw_wireframe()
	-- self:set_shape_wireframe(require"app.LaserRuler.shape".draw{spt=self:get_spt(),ept=self:get_ept(),sections=self.Sections,color=self:get_color_gl(),circle=self.Circle,mode="wireframe"});
end

function Class:on_draw_rendering()
	self:set_shape_rendering(require"app.LaserRuler.shape".draw{spt=self:get_spt(),ept=self:get_ept(),sections=self.Sections,require"sys.geometry".Color:new(self.Color),circle=self.Circle,mode="rendering"});
end

-- arg={w1=,w2=,p=}
function Class:add_section(arg)
	if type(arg)~="table" then return self end
	if type(self.Sections)~="table" then self.Sections={} end
	table.insert(self.Sections,arg);
	return self;
end

function Class:get_spt()
	if type(self.Points)=="table" and type(self.Points[1])=="table" then return self.Points[1] end
	return {0,0,0};
end

function Class:get_ept()
	if type(self.Points)=="table" and type(self.Points[2])=="table" then return self.Points[2] end
	if type(self.Sections)=="table" and type(self.Sections[#self.Sections])=="table" then return {0,0,self.Sections[#self.Sections][p]} end
	return {0,0,1000};
end