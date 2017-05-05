--module(...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
 local require = require

local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

function on_load()
	require"app.Tekla.function".load();
end

function on_init()
end

function on_esc()
end

