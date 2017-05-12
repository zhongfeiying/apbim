local require = require;

_ENV = module(...)

local dat_ = require'sys.toolbar.dat'
local style_ = require'sys.toolbar.style'

function init()
	dat_.init();
end

function add(t)
	dat_.add(t);
end

function update()
	style_.update();
end

