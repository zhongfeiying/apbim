_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Steel/Joint";
	-- Points={[1]};
	-- Color = {255,255,255};
	-- Parts = {};
};
require"sys.Entity".Class:met(Class);

--callback
---[[
function Class:on_write_info()
	self:add_info_text("Type",self.Type);
end
--]]

--[[
function Class:on_draw_diagram()
	local cr = require"sys.geometry".Color:new(self.Color):get_gl()
	local pt = self:get_pt(1);
	self:set_shape_diagram{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z-1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x-  0,pt.y-675,pt.z-1000};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z-1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x+675,pt.y-  0,pt.z-1000};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z-1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x+  0,pt.y+675,pt.z-1000};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z-1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x-675,pt.y+  0,pt.z-1000};
					
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y-500,pt.z+1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x-  0,pt.y-675,pt.z+1000};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y-500,pt.z+1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x+675,pt.y-  0,pt.z+1000};
					{cr.r,cr.g,cr.b,1,1,pt.x+500,pt.y+500,pt.z+1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x+  0,pt.y+675,pt.z+1000};
					{cr.r,cr.g,cr.b,1,1,pt.x-500,pt.y+500,pt.z+1000};
					-- {cr.r,cr.g,cr.b,1,1,pt.x-675,pt.y+  0,pt.z+1000};
				};
				-- lines = {{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8},{8,1},{9,10},{10,11},{11,12},{12,13},{13,14},{14,15},{15,16},{16,9},{1,13},{3,15},{7,11},{5,9}};
				lines = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,7},{2,8},{3,5},{4,6}};
			};
		};
	};
end

function Class:on_draw_wireframe()
	self:set_shape_wireframe();
end

function Class:on_draw_rendering()
	self:set_shape_rendering();
end
--]]

function Class:get_foucs_pt()
	if type(self.Points)~="table" then return 0 end
	if #self.Points<=0 then return require"sys.geometry".Point:new{0,0,0} end
	return require"sys.geometry".Point:new(self.Points[1]);
end

function Class:add_part(id)
	self.Parts = self.Parts or {}
	self.Parts[id] = true;
end



