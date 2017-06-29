return {
	name = 'BIM';
	information = 'Create  project folder !';
	icon = 'app/Apmgr/res/default_tpl.png';
	-- perview = 'app/Apmgr/res/projects.bmp';
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

