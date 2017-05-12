_ENV = module(...,ap.adv)


local function color(sc)
	require "app.Configure.color".pop("cfg/color_index.lua")
end


function load()
	require"sys.menu".add{frame=true,view=true,app="Configure",pos={"Window"},name={"Tools","Custom","Color"},f=color};
end
