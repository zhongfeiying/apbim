local dofile = dofile;
local require = require;
local reload = reload;

_ENV = module(...)

local control_ = require'sys.menu.control';
local dat_ = require'sys.menu.dat';

--[[
tree={
	[1]={
		name="",
		subs={
		[1]={
			name="",
			subs={},
		},
		[2]={
			name="",
			keyword="",
		},
		[3]={name=nil},分隔符
		...
		},
	},
	[2]={},
	...
}; 
--]]

function update()
	--clear_menu()	--卸载掉全部菜单然后重新加载
	-- local style = reload('cfg.menu');
	local style = dofile('cfg/menu.lua');
	local dat = dat_.get_all();
	control_.create_menus(style,dat);
end

--[[
需要：
--配置用户自定义菜单的界面
1.读原始菜单数据文件
2.读自定义菜单文件
3.自定义修改菜单
4.写自定义菜单文件
--]]

