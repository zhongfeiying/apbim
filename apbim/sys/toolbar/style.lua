local require = require;
local reload = reload;

_ENV = module(...)

local control_ = require'sys.toolbar.control';
local dat_ = require'sys.toolbar.dat'


--[[
return{
	[1]={
		bmpname = 'cfg/bmp/toolbar1.bmp';
		[1]={
			name="",
			keyword="",
			image=,
		},
		[2]={
			name="",
			keyword="",
			image=,
		},
		[3]={name=nil},--分隔符
		...
		},
	};
	[2]={
		...
	};
	...
}; 
--]]

function update()
	--clear_toolbar()	--卸载掉全部工具条然后重新加载
	local style = reload('cfg.toolbar');
	local dat = dat_.get_all();
	control_.create_toolbars(style,dat);	
end

--[[
需要：
--配置用户自定义菜单的界面
1.读原始菜单数据文件
2.读自定义菜单文件
3.自定义修改菜单
4.写自定义菜单文件
--]]

