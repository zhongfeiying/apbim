-- package.cpath = package.cpath..";./?51.dll;./?.dll";
-- package.path = package.path..";?;?.lua";
package.cpath = "./?53.dll;./?.dll";
package.path = "?;?.lua";
-- trace_out(package.cpath..'\n')
-- trace_out(package.path..'\n')

function module_seeall(modname)
	-- local modname = ...
	local M = {}
	setmetatable(M,{__index=_G})
	_G[modname] = M
	package.loaded[modname] = M
	-- _ENV = M
	return M
end



-- require "SJYServer.main"
-- require"sys.net.main"
if type(get_scene_t)=="function" then require"sys.main" else  end
-- if type(hub_start)=="function" then require"ghub.main" else  end

--zgb
--dofile("cfg.commandline");
require"app.ApBudget.import".open_model("apbudget.lua");
require"app.Model.function".Rendering();