_ENV = module(...,ap.adv)

Class = {
	Classname = "app/Steel/Member";
	-- Points={[1],[2],[3],...};
	-- Section = "H200*50*5*8";
	-- Beta = 90;
	-- Alignment = {0,0};
	-- Color = {255,255,255};
};
require"sys.Entity".Class:met(Class);

--callback

function Class:on_edit()
	require'app.Steel.Member_dlg'.pop();
end

---[[
function Class:on_write_info()
	-- self:init_info();
	-- self:add_info_text("Classname",self.Classname);
	self:add_info_text("Type",self.Type);
	-- self:add_info_text("NO.",self.assembly_number);
	-- self:add_info_text("PartNO.",self.part_number);
	-- self:add_info_text("Material.",self.material);
	self:add_info_text("Section",self.Section);
	self:add_info_text("Length",self:get_length());
	self:add_info_text("Beta",(self.Beta or 0));
	self:add_info_text("Alignment",self:get_alignment_text());
	-- self:add_info_text("Date",self:get_date_text());
	-- self:add_info_text("Color",require"sys.text".color(self.Color));
	-- for i,v in ipairs(self:get_pts()) do
		-- self:add_info_text("Point"..i,require"sys.text".array(self:get_pt(i)));
	-- end
end
--]]

--[[
function Class:on_write_info()
	-- self:set_info{};
	self:add_info{Classname = self.Classname};
	self:add_info{Type = self.Type};
	for i,v in ipairs(self:get_pts()) do
		self:add_info{["Point"..i]=require"sys.text".array(self:get_pt(i))};
	end
	self:add_info{Length = self:get_length()};
	self:add_info{Section = self.Section};
	self:add_info{Beta = (self.Beta or 0)};
	self:add_info{Alignment = self:get_alignment_text()};
	self:add_info{Date = self:get_date_text()};
end
--]]

function Class:on_draw_diagram()
	self:set_shape_diagram(require"app.Steel.shape".draw_member(self,"diagram"));
end

function Class:on_draw_wireframe()
	self:set_shape_wireframe(require"app.Steel.shape".draw_member(self,"wireframe"));
end

function Class:on_draw_rendering()
	self:set_shape_rendering(require"app.Steel.shape".draw_member(self,"rendering"));
end

function Class:on_draw_text()
	local cr = self:get_color_gl();
	local pt1 = self:get_pt(1);
	local pt2 = self:get_pt(2);
	self:set_shape_text{
		surfaces = {
			{
				points = {
					{cr.r,cr.g,cr.b,1,1,(pt1.x+pt2.x)/2,(pt1.y+pt2.y)/2,(pt1.z+pt2.z)/2};
				};
				texts = {
					{ptno=1,r=1-cr.r,g=1-cr.g,b=1-cr.b,str=self.Section,font="System",h=20,size=64};
				};
			};
		};
	};
end


function Class:get_alignment_text()
	local align = type(self.Alignment)=="table" and self.Alignment or {};
	local x = align.x or align.h or align[1] or 0;
	local y = align.y or align.v or align[2] or 0;
	local h = "";
	if x==0.5 then h=h.."Left" end
	if x==0 then h=h.."Center" end
	if x==-0.5 then h=h.."Right" end
	local v= "";
	if y==-0.5 then v=v.."Top" end
	if y==0 then v=v.."Center" end
	if y==0.5 then v=v.."Bottom" end
	return h..v;
end

function Class:get_alignment()
	return type(self.Alignment)=="table" and self.Alignment or {0,0};
end

function Class:align_left()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[1] = 0.5;
	self:modify();
	return self;
end

function Class:align_center_h()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[1] = 0;
	self:modify();
	return self;
end

function Class:align_right()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[1] = -0.5;
	self:modify();
	return self;
end

function Class:align_top()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[2] = -0.5;
	self:modify();
	return self;
end

function Class:align_center_v()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[2] = 0;
	self:modify();
	return self;
end

function Class:align_bottom()
	if type(self.Alignment)~="table" then self.Alignment={} end
	self.Alignment[2] = 0.5;
	self:modify();
	return self;
end


function Class:get_foucs_pt()
	if type(self.Points)~="table" then return 0 end
	if #self.Points<=0 then return require"sys.geometry".Point:new{0,0,0} end
	if #self.Points<=1 then return require"sys.geometry".Point:new(self.Point[1]) end
	return (require"sys.geometry".Point:new(self.Points[1])+require"sys.geometry".Point:new(self.Points[2]))*0.5;
end

function Class:get_length()
	return require"sys.geometry".Point:new(self.Points[1]):distance(self.Points[2]);
end


