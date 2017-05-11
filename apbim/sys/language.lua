
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local language_list_ = {
	['English'] = true;
	['Chinese'] = true;
}
local language_ = 'English'

function set(language)
	if language_list_[language] then 
		language_ = language
	end
end

function get()
	return language_
end


