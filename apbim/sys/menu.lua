local require = require;

_ENV = module(...)

local dat_ = require'sys.menu.dat'
local style_ = require'sys.menu.style'

function init()
	dat_.init();
end

function add(t)
	dat_.add(t);
end

function update()
	style_.update()
end


function reload()
	style_.init()
	style_.update()
	
end
