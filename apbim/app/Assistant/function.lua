_ENV = module(...,ap.adv)

local function All_Topic(sc)
	require'sys.dock'.add_page(require'app.Assistant.topic_page'.pop());
	require'sys.dock'.active_page(require'app.Assistant.topic_page'.pop());
end

local function Add_Topic(sc)
	if not sc then return end
	-- if not require"sys.io".is_there_file{file="app/Assistant/Note.lua"} then trace_out("There isn't the file :  app/Assistant/Topic.lua\n") return end
	require"sys.cmd".set{command=require"app.Edit.Create".new{class=require"app.Assistant.Topic".Class:new{Type="Assistant",Color={255,128,0}}}:set_count(1)};
end


function load()
	-- require"sys.menu".add{app="Assistant",view=true,pos={"Window"},name={"Assistant","Topic","All"},f=All_Topic};
	require"sys.menu".add{app="Assistant",view=true,pos={"Window"},name={"Assistant","Topic","Add"},f=Add_Topic};
end
