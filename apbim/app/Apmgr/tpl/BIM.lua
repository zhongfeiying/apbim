return {
	name = 'BIM';
	information = 'Create  project folder !';
	icon = 'app/Apmgr/res/projects.bmp';
	-- preview = 'app/Apmgr/res/prebim.bmp';
	attributes = {
		Name = '';
		ID = '';
		['Create Time'] = '';
	};
	structure = {
		{
			attributes = {name = '图纸';};
			{};
		};
		{
			attributes= {name = '模型';};
			{};
		};
		{
			attributes= {name = '质疑';};
			{};
		};
		{
			attributes= {name = '传票';};
			{};
		};
		{
			attributes= {name = '设计图';};
			{};
		};
	};
}

