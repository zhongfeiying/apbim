_ENV = module(...,ap.adv)

MODNAME = "Appendix";

function on_load()
	_G.package.loaded["app.Appendix.function"] = nil;
	require"app.Appendix.function".load();
end

function on_init()
end

