local require  = require 
local package_loaded_ = package.loaded
local io = io
local string = string 
local table = table
local type = type

local M = {}
local modname = ...
_G[modname] = M
package_loaded_[modname] = M
_ENV = M

local file = 'app.ProjectMgr.info.user_gid_projects_file'

local function init_data()
	return {
		{
			name = '大和项目',id = 1,

			{
				{
					name = 'App';
					{
						{
							name = 'Menu',exe = true;
						};
						{
							name = 'Toolbar',exe = true;
						};
					};
				};
				{
					name = '模型';id=4;
					{
						{
							name ='梁',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='柱',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='板',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='组',id =5;
							{
								{
									name ='第一工区',id =5;
								}	
							};
						};
						{
							name ='层',id =5;
							{
								{
									name ='第一层',id =5;
								},	
								{
									name ='第二层',id =5;
								},	
								{
									name ='顶层',id =5;
								},	
								{
									name ='地下一层',id =5;
								},	
							};
						};
						{
							name ='族',id =5;
							{
								{
									name ='系统组',id =5;
								},	
								{
									name ='自定义族',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '文档';id=4;
						{
							{
								name ='图纸',id =5;
								{
									{

										name ='柱图',id =5;
									},	
									{
										name ='梁图',id =5;
									},	
								};
							};
							{
								name ='管理文件',id =5;
								{
									{
										name ='工程计划.doc',id =5;
									},	
									{
										name ='审核.doc',id =5;
									},	
								};
							};
							{
								name ='知识库',id =5;
								{
									{
										name ='算量方法',id =5;
									},	
									{
										name ='重量统计',id =5;
									},	
								};
							};
							{
								name ='材料统计',id =5;
								{
									{
										name ='C型钢',id =5;
									},	
									{
										name ='	H型钢',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '团队';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '附注';id=4;
					{
						{
							name ='2017-5-2对柱疑问',id =5;
						};
						{
							name ='2017-5-12对B-23疑问',id =5;
						};
					};
				};
				{
					name = '工作流';id=4;
					{
						{
							name ='所有工作流',id =5;
						};
						{
							name ='正在进行',id =5;
						};
						{
							name ='已完成',id =5;
						};
					};
				};
			};
		};
		{
			name = '肯德基',id = 2,

			{
				{
					name = '模型';id=4;
					{
						{
							name ='梁',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='柱',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='板',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='组',id =5;
							{
								{
									name ='第一工区',id =5;
								}	
							};
						};
						{
							name ='层',id =5;
							{
								{
									name ='第一层',id =5;
								},	
								{
									name ='第二层',id =5;
								},	
								{
									name ='顶层',id =5;
								},	
								{
									name ='地下一层',id =5;
								},	
							};
						};
						{
							name ='族',id =5;
							{
								{
									name ='系统组',id =5;
								},	
								{
									name ='自定义族',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '文档';id=4;
						{
							{
								name ='图纸',id =5;
								{
									{

										name ='柱图',id =5;
									},	
									{
										name ='梁图',id =5;
									},	
								};
							};
							{
								name ='管理文件',id =5;
								{
									{
										name ='工程计划.doc',id =5;
									},	
									{
										name ='审核.doc',id =5;
									},	
								};
							};
							{
								name ='知识库',id =5;
								{
									{
										name ='算量方法',id =5;
									},	
									{
										name ='重量统计',id =5;
									},	
								};
							};
							{
								name ='材料统计',id =5;
								{
									{
										name ='C型钢',id =5;
									},	
									{
										name ='	H型钢',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '团队';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '附注';id=4;
					{
						{
							name ='2017-5-2对柱疑问',id =5;
						};
						{
							name ='2017-5-12对B-23疑问',id =5;
						};
					};
				};
				{
					name = '工作流';id=4;
					{
						{
							name ='所有工作流',id =5;
						};
						{
							name ='正在进行',id =5;
						};
						{
							name ='已完成',id =5;
						};
					};
				};
			};		};
		{
			name = '麦当劳',id = 3,

			{
				{
					name = '模型';id=4;
					{
						{
							name ='梁',id =5;
							{
								{
									name ='B-1',id =5;
								}	
							};
						};
						{
							name ='柱',id =5;
							{
								{
									name ='C-1',id =5;
								}	
							};
						};
						{
							name ='板',id =5;
							{
								{
									name ='PL-1',id =5;
								}	
							};
						};
						{
							name ='组',id =5;
							{
								{
									name ='第一工区',id =5;
								}	
							};
						};
						{
							name ='层',id =5;
							{
								{
									name ='第一层',id =5;
								},	
								{
									name ='第二层',id =5;
								},	
								{
									name ='顶层',id =5;
								},	
								{
									name ='地下一层',id =5;
								},	
							};
						};
						{
							name ='族',id =5;
							{
								{
									name ='系统组',id =5;
								},	
								{
									name ='自定义族',id =5;
								},	
							};
						};
					};
				};
				{
					
						name = '文档';id=4;
						{
							{
								name ='图纸',id =5;
								{
									{

										name ='柱图',id =5;
									},	
									{
										name ='梁图',id =5;
									},	
								};
							};
							{
								name ='管理文件',id =5;
								{
									{
										name ='工程计划.doc',id =5;
									},	
									{
										name ='审核.doc',id =5;
									},	
								};
							};
							{
								name ='知识库',id =5;
								{
									{
										name ='算量方法',id =5;
									},	
									{
										name ='重量统计',id =5;
									},	
								};
							};
							{
								name ='材料统计',id =5;
								{
									{
										name ='C型钢',id =5;
									},	
									{
										name ='	H型钢',id =5;
									},	
								};
							};
							
						};					
				};
				{
					name = '团队';id=4;
					{
						{
							name ='zgb',id =5;
						};
					};
				};
				{
					name = '附注';id=4;
					{
						{
							name ='2017-5-2对柱疑问',id =5;
						};
						{
							name ='2017-5-12对B-23疑问',id =5;
						};
					};
				};
				{
					name = '工作流';id=4;
					{
						{
							name ='所有工作流',id =5;
						};
						{
							name ='正在进行',id =5;
						};
						{
							name ='已完成',id =5;
						};
					};
				};
			};		};--]]
	}
end

local function init_file()
	local filename = string.gsub(file,'%.','/')
	local file = io.open(filename,'w+')
	if file then file:close() return true end 
end 

function init()
	package_loaded_[file] = nil
	data_ = init_file() and type(require (file)) == 'table' and require (file)  or init_data()
end

function get()
	return data_
end

function add(arg)
end

function edit(arg)
end

function delete(arg)
end




