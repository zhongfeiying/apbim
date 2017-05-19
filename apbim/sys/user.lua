
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M


local user_;

function set(user)
	user_ = user
end

function get()
	return user_
end
