_ENV = module(...,ap.adv)

local function Copy_to_USB(sc)
	_G.package.loaded["app.Honda.sort"] = nil;
	require"app.Honda.sort"
end


function load()
	require"sys.menu".add{app="Honda",frame=true,view=true,pos={"Window"},name={"Honda","Copy MP3 to USB"},f=Copy_to_USB};
end
