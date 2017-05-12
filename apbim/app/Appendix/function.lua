_ENV = module(...,ap.adv)


local function get_item_view_marks(id,item)
	item = require'sys.mgr'.get_table(id,item);
	if type(item)~='table' then return end
	if not item.View then return end
	local view = require'sys.mgr'.get_table(item.View);
	if type(view)~='table' then return end
	if type(view.Marks)~='table' then return end
	return view.Marks;
end



local function File_All(sc)
	require'sys.dock'.add_page(require'app.Appendix.file_page'.pop{});
	require'sys.dock'.active_page(require'app.Appendix.file_page'.get());
end

local function File_Find_OR(sc)
	local function filter(id,item)
		local marks = get_item_view_marks(id,item);
		if type(marks)~='table' then return false end
		local ents = require'sys.mgr'.get_scene_selection(sc)
		if type(ents)~='table' then return true end
		for k,v in pairs(ents) do
			if marks[k] then 
				return true;
			end
		end
	end
	require'sys.dock'.add_page(require'app.Appendix.file_page'.pop{filter=filter});
	require'sys.dock'.active_page(require'app.Appendix.file_page'.get());
end

local function File_Find_AND(sc)
	local function filter(id,item)
		local marks = get_item_view_marks(id,item);
		if type(marks)~='table' then return false end
		local ents = require'sys.mgr'.get_scene_selection(sc)
		if type(ents)~='table' then return true end
		for k,v in pairs(ents) do
			if not marks[k] then 
				return false;
			end
		end
		return true;
	end
	require'sys.dock'.add_page(require'app.Appendix.file_page'.pop{filter=filter});
	require'sys.dock'.active_page(require'app.Appendix.file_page'.get());
end

local function Photo_All(sc)
	require'sys.dock'.add_page(require'app.Appendix.photo_page'.pop{});
	require'sys.dock'.active_page(require'app.Appendix.photo_page'.get());
end

local function Photo_Find_OR(sc)
	local function filter(id,item)
		local marks = get_item_view_marks(id,item);
		if type(marks)~='table' then return false end
		local ents = require'sys.mgr'.get_scene_selection(sc)
		if type(ents)~='table' then return true end
		for k,v in pairs(ents) do
			if marks[k] then 
				return true;
			end
		end
	end
	require'sys.dock'.add_page(require'app.Appendix.photo_page'.pop{filter=filter});
	require'sys.dock'.active_page(require'app.Appendix.photo_page'.get());
end

local function Photo_Find_AND(sc)
	local function filter(id,item)
		local marks = get_item_view_marks(id,item);
		if type(marks)~='table' then return false end
		local ents = require'sys.mgr'.get_scene_selection(sc)
		if type(ents)~='table' then return true end
		for k,v in pairs(ents) do
			if not marks[k] then 
				return false;
			end
		end
		return true;
	end
	require'sys.dock'.add_page(require'app.Appendix.photo_page'.pop{filter=filter});
	require'sys.dock'.active_page(require'app.Appendix.photo_page'.get());
end




function load()
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","File","All"},f=File_All};
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","File","Find","OR"},f=File_Find_OR};
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","File","Find","AND"},f=File_Find_AND};
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","Photo","All"},f=Photo_All};
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","Photo","Find","OR"},f=Photo_Find_OR};
	require"sys.menu".add{app="Appendix",frame=true,view=true,pos={"Window"},name={"Appendix","Photo","Find","AND"},f=Photo_Find_AND};
end
