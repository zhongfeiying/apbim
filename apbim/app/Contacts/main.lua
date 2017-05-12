--module(...,package.seeall)

_ENV = module(...,ap.adv)
local FilePath_ = "app.Contacts.function"
function on_load()
	_G.package.loaded[FilePath_] = nil;
	require (FilePath_).load();
end

function on_init()
end

function on_esc()
end

function un_load()
	function_.unload()
end


