_ENV = module(...,ap.adv)

function on_load()
	_G.package.loaded["app.Honda.function"] = nil;
	require"app.Honda.function".load();
end

function on_init()
end

