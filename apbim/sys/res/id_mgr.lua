local pairs = pairs
local tostring = tostring
local trace_out = trace_out
local id_ = ID

_ENV = module(...)

local map_={};
local map_reverse_={};

--关联表
local menus_={};
local toolbars_={};
local elses_={};


function new_id()
	id_=id_+1;
	return id_;
end 
function map(id,value)
	if(value==nil) then 
	--	trace_out("value == nil in functon map(id,value)\n");
		return 
	end
	--trace_out("id = ".. id .. ";value = " .. value .."\n");
	map_[id] = value;
	map_reverse_[value] = id;
end 

function get_map_value(id)
	return map_[id];
end
function get_map_id(value)
	return map_reverse_[value];
end

function clear()
	map_=nil;
	map_={};
	map_reverse_=nil;
	map_reverse_={};
end
--关联表设置
function set_menus(db)
	menus_ = db;
end
function set_toolbars(db)
	toolbars_ = db;
end
function set_elses(db)
	elses_ = db;
end

function get_action(id)
	local key =  map_[id];	
	if(not key)then
		trace_out("It's exist the key,id = " .. id .. "\n");
		return;
	end
	if(menus_[key])then
		if(menus_[key].view )then
			return menus_[key].action;
		else
			return nil;
		end	
	elseif(toolbars_[key])then
		if(toolbars_[key].view )then
			return toolbars_[key].action;
		else
			return nil;
		end	
	else
		return nil;
	end	
	
end

function get_frame_action(id)
	local key =  map_[id];	
	if(not key)then
		trace_out("It's exist the key,id = " .. id .. "\n");
		return;
	end
	if(menus_[key])then
		if(menus_[key].frame )then
			return menus_[key].action;
		else
			return nil;
		end	
	elseif(toolbars_[key])then
		if(toolbars_[key].frame )then
			return toolbars_[key].action;
		else
			return nil;
		end	
	else
		return nil;
	end	
	
end



