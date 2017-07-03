return {
	name = 'BIM';
	information = 'Create  project folder !';
	icon = 'app/Apmgr/res/projects.bmp';
	-- preview = 'app/Apmgr/res/prebim.bmp';
	attributes = {
		['create time'] = '';
		
	};
	structure = {
		{
			attributes = {name = '模型';};
			{
				{
					attributes = {name = '3D';};
				};
				{
					attributes = {name = 'Views';};
					{
						{
							attributes = {name = '左视图';};
							{};
						};
						{
							attributes = {name = '俯视图';};
							{};
						};
						{
							attributes = {name = '前视图';};
							{};
						};
					};
				};
			};
		};
		{
			attributes= {name = '图纸';};
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

