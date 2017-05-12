_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Steel/MemberArc";
	-- Points={[1],[2],[3]};
	-- Angle = 90;
};
require"app.Steel.Member".Class:met(Class);

--callback

--[[
function Class:on_write_info()
	self:set_info{};
	self:add_info{Classname = self.Classname};
	self:add_info{Type = self.Type};
	self:add_info{OPoint=require"sys.text".array(self:get_pt(1))};
	self:add_info{NPoint=require"sys.text".array(self:get_pt(2))};
	self:add_info{SPoint=require"sys.text".array(self:get_pt(3))};
	self:add_info{Angle=self.Angle};
	self:add_info{Length = self:get_length()};
	self:add_info{Section = self.Section};
	self:add_info{Beta = self.Beta};
	self:add_info{Aligment = require"sys.text".array(self.Alignment)};
	self:add_info{Date = self:get_date_text()};
end
-]]


function Class:on_write_info()
	self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	self:add_info_text("NO.",self.assembly_number);
	self:add_info_text("PartNO.",self.part_number);
	self:add_info_text("Material.",self.material);
	self:add_info_text("Section",self.Section);
	self:add_info_text("Length",self:get_length());
	self:add_info_text("Beta",(self.Beta or 0));
	self:add_info_text("Alignment",self:get_alignment_text());
	self:add_info_text("Date",self:get_date_text());
	self:add_info_text("Color",require"sys.text".color(self.Color));
	self:add_info_text("OPoint",require"sys.text".array(self:get_pt(1)));
	self:add_info_text("NPoint",require"sys.text".array(self:get_pt(2)));
	self:add_info_text("SPoint",require"sys.text".array(self:get_pt(3)));
end
