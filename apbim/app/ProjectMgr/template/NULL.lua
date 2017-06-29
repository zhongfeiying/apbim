Template = {
	interface = {
		name = 'Empty';
		information = 'Create  project folder !';
		image = 'app/projectMgr/res/projects.bmp';
		preimage = nil;
	};
	attributes = {
		{name = 'Name'};
		{name = 'ID'};
		{type = 'time',name = 'Create Time'};
	};
	structure = {
		{
			attributes= {title = '图纸';};
		};
		{
			attributes= {title = '模型';};
		};
		{
			attributes= {title = '质疑';};
		};
		{
			attributes= {title = '传票';};
		};
		{
			attributes= {title = '设计图';};
		};
	};
}

return Template
