local ipairs = ipairs;
local require = require;
local type = type;

local reload = reload;

local M = {};
_G[...] = M;
package.loaded[...] = M;
_ENV = M;


local apps_ = nil;

--用户配置加载app后：
--方案1：全部卸载然后重新加载√
--方案2：差异比较后卸载和加载×
--方案3：直接重启程序重新加载×

local function unload()
	if type(apps_)~='table' then return end
	for i,v in ipairs(apps_) do
		require(v).on_unload();
	end
end

function load()
	unload();
	local apps_ = reload'cfg.app';
	if type(apps_)~='table' then return end
	for i,v in ipairs(apps_) do
		reload(v).on_load();
	end
end

function init()
	if type(apps_)~='table' then return end
	for i,v in ipairs(apps_) do
		require(v).on_init();
	end
end
