--module(...,package.seeall)
 _ENV = module(...,ap.adv)

function on_load()
	require"app.ApBudget.function".load();
end

function on_init()
end

function on_esc()
end

