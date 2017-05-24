
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local language_list_ = {
	['English'] = 'English';
	['Chinese'] = 'Chinese';
}
local language_ = 'Chinese'
--local language_ ='English'

function set(language)
	language_ =language and  language_list_[language] or 'English'
end

function get()
	return language_
end


