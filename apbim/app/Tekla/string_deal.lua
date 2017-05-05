--module (...,package.seeall)
 -- _ENV = module_seeall(...,package.seeall)
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

function string_ansi(str)
	return str
	--local s = require"luaext".u82a(str);
	--return s;
end
