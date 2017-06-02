
local M = {}
local modname = ...
_G[modname] = M
package.loaded[modname] = M
_ENV = M

local file = 'cfg.language'

local language_list_ = {
	['English'] = 'English';
	['中文简体'] = 'Chinese';
}
local language_ = '中文简体'

function set(language)
	language_ = language and  language_list_[language] or language_
end

function get()
	return language_list_[language_]
end

function get_language_list()
	return language_list_
end


function init()
	local t = require  (file)
	set(t and t.language)
end


