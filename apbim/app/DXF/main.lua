_ENV = module(...,ap.adv)

function on_load()
	_G.package.loaded["app.DXF.function"] = nil;
	require"app.DXF.function".load();
end

function on_init()
end

