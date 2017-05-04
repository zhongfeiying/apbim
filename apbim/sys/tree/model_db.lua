_ENV = module(...,ap.adv)
local item_ = require "sys.tree.item";
local msg_ = require "sys.tree.message".create_message();
local mssage_ = require "sys.tree.message";


Model_DB={
	db_={},
};
Model_DB.__index = Model_DB;
function create_model_db(t)
	if getmetatable(t)==Model_DB then return end;
	t = t or {};
	setmetatable(t,Model_DB);
	return t;
end
local msgs_g = {{name="Show",fun=mssage_.rclk_menu_show},{name="Hide",fun=mssage_.rclk_menu_hide},};

function Model_DB:create_db_2()
	self.db_ = nil;
	self.db_ = {};
	
	local son3 = item_.create_item();
	son3.index = 3;
	son3.name = "CCC-3";
	son3.link = "Memeber3";
	son3.sons = {};
	son3.nm_click = mssage_.nm_click_g;
	son3.nm_dbclick = mssage_.nm_dbclick_g;
	son3.rclk_menu = msgs_g;
	son3:create_right_menu();

	local son4 = item_.create_item();
	son4.index = 4;
	son4.name = "AAA-4";
	son4.link = "Memeber4";
	son4.sons = {son3};
	son4.nm_click = mssage_.nm_click_g;
	son4.nm_dbclick = mssage_.nm_dbclick_g;
	son4.rclk_menu = msgs_g;
	son4:create_right_menu();

	local son5 = item_.create_item();
	son5.index = 5;
	son5.name = "AAA-5";
	son5.link = "Memeber4";
	son5.sons = {son4};
	son5.nm_click = mssage_.nm_click_g;
	son5.nm_dbclick = mssage_.nm_dbclick_g;
	son5.rclk_menu = msgs_g;
	son5:create_right_menu();

	local son6 = item_.create_item();
	son6.index = 6;
	son6.name = "AAA-6";
	son6.link = "Memeber4";
	son6.sons = {son5};
	son6.nm_click = mssage_.nm_click_g;
	son6.nm_dbclick = mssage_.nm_dbclick_g;
	son6.rclk_menu = msgs_g;
	son6:create_right_menu();
	
	local son7 = item_.create_item();
	son7.index = 7;
	son7.name = "AAA-7";
	son7.link = "Memeber4";
	son7.sons = {son3,son4,son6};
	son7.nm_click = mssage_.nm_click_g;
	son7.nm_dbclick = mssage_.nm_dbclick_g;
	son7.rclk_menu = msgs_g;
	son7:create_right_menu();
	
	
	
	local son8 = item_.create_item();
	son8.index = 8;
	son8.name = "AAA-8";
	son8.link = "Memeber4";
	son8.sons = {son5,son6};
	son8.nm_click = mssage_.nm_click_g;
	son8.nm_dbclick = mssage_.nm_dbclick_g;
	son8.rclk_menu = msgs_g;
	son8:create_right_menu();


	local son1 = item_.create_item();
	son1.index = 1;
	son1.name = "C-1";
	son1.link = "Memeber1";
	son1.sons = {son8,son7};
	son1.nm_click = mssage_.nm_click_g;
	son1.nm_dbclick = mssage_.nm_dbclick_g;
	son1.rclk_menu = msgs_g;
	son1:create_right_menu();

	local son2 = item_.create_item();
	son2.index = 2;
	son2.name = "A-1";
	son2.link = "Memeber2";
	son2.nm_click = mssage_.nm_click_g;
	son2.nm_dbclick = mssage_.nm_dbclick_g;
	son2.rclk_menu = msgs_g;
	son2:create_right_menu();
	son2.sons = {son3,son4,son5,son6};

	local item = item_.create_item();
	item.index = 1;
	item.name = "Model1";
	item.sons = {son1,son2};
	
	item.nm_click = mssage_.nm_click_g;
	item.nm_dbclick = mssage_.nm_dbclick_g;
	item.rclk_menu = msgs_g;
	item:create_right_menu();
	
	local item2 = item_.create_item();
	item2.index = 1;
	item2.name = "Model2";
	item2.sons = {son8};
	item2.nm_click = mssage_.nm_click_g;
	item2.nm_dbclick = mssage_.nm_dbclick_g;
	item2.rclk_menu = msgs_g;
	item2:create_right_menu();
	
	local item3 = item_.create_item();
	item3.index = 1;
	item3.name = "Model3";
	item3.sons = {};
	

	item3.nm_click = mssage_.nm_click_g;
	item3.nm_dbclick = mssage_.nm_dbclick_g;
	item3.rclk_menu = msgs_g;
	item3:create_right_menu();
	table.insert(self.db_,item);

end
function Model_DB:create_db_1()

	self.db_ = nil;
	self.db_ = {};
	
	
	local son8 = item_.create_item();
	son8.index = 8;
	son8.name = "All";
	son8.link = "Memeber4";
	son8.sons = {son5,son6};
	son8.nm_click = mssage_.nm_click_g;
	son8.nm_dbclick = mssage_.nm_dbclick_g;
	son8.rclk_menu = msgs_g;
	son8:create_right_menu();


	local son1 = item_.create_item();
	son1.index = 1;
	son1.name = "Else";
	son1.link = "son8";
	son1.sons = {son8};
	son1.nm_click = mssage_.nm_click_g;
	son1.nm_dbclick = mssage_.nm_dbclick_g;
	son1.rclk_menu = msgs_g;
	son1:create_right_menu();

	local son2 = item_.create_item();
	son2.index = 2;
	son2.name = "A-1";
	son2.link = "Memeber2";
	son2.nm_click = mssage_.nm_click_g;
	son2.nm_dbclick = mssage_.nm_dbclick_g;
	son2.rclk_menu = msgs_g;
	son2:create_right_menu();
	son2.sons = {son3};

	local item = item_.create_item();
	item.index = 1;
	item.name = "Model";
	item.sons = {son1};
	
	item.nm_click = mssage_.nm_click_g;
	item.nm_dbclick = mssage_.nm_dbclick_g;
	item.rclk_menu = msgs_g;
	
	item:create_right_menu();
	table.insert(self.db_,item);

end


function Model_DB:get_db()
	return self.db_;
end

function Model_DB:add(item)
	table.insert(self.db_,item);
end
function Model_DB:del(item)

end
function Model_DB:edit(item)
end
function Model_DB:open()

end
function Model_DB:save()
end
function Model_DB:clear()
end








