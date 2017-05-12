_ENV = module(...,ap.adv)
local dlg_ = require 'app.SelectJoint.dlg_joint'
local search_joint_ = {}

local function table_is_empty(t)
	return _G.next(t) == nil 
end

local function get_cur_joint(id)
	--trace_out('here\n')
	local all = require 'sys.mgr'.get_all()
	for k,v in pairs (all) do 
		if v.Type == 'Joint' then 
			for m,n in pairs (v.Parts) do
				if m == id then 
					return v
				end 
			end 
		end 
	end 
end

local function Joint()
	local cur = require 'sys.mgr'.cur()
	if not cur or table_is_empty(cur)  then iup.Message('Notice','Please selected !') return end 
	--require 'sys.table'.totrace(cur)
	local cur_joint;
	search_joint_ = search_joint_ or {}
	local id = cur.mgrid
	if not search_joint_[id] then 
		cur_joint = cur.Type and cur.Type == 'Joint' and  cur or  get_cur_joint(id) 
		if not cur_joint then iup.Message('Notice','The selected component has no connection.') return end 
		search_joint_[cur_joint.mgrid] = cur_joint.mgrid
	else 
		cur_joint =  require 'sys.mgr'.get_table(search_joint_[id])
	end 
	local curs = require 'sys.mgr'.curs()
	for k,v in pairs (curs) do 
		if require 'sys.mgr'.is_light(v)   then 
			require 'sys.mgr'.select(v,false);
			require 'sys.mgr'.redraw(v)
		end 
	end 
	require 'sys.mgr'.update()
	
	require 'sys.mgr'.select(cur_joint,true);
	require 'sys.mgr'.redraw(cur_joint)
	--require 'sys.table'.totrace(cur_joint.Parts)
	--trace_out('joint id  = ' .. cur_joint.mgrid .. '\n')
	for k,v in pairs (cur_joint.Parts) do
		search_joint_[k] = cur_joint.mgrid
		--trace_out('k = ' .. k .. '\n')
		local t =  require 'sys.mgr'.get_table(k)
		require 'sys.mgr'.select(t,true);
		require 'sys.mgr'.redraw(t)
	end 
	require 'sys.mgr'.update()
	--require 'sys.table'.totrace(cur_joint)
	dlg_.pop{Datas = cur_joint.Info.Text}
end

local function Test()
	trace_out('start =-=====================================\n')
	local curs = require 'sys.mgr'.curs()
	
	for k,v in pairs (curs) do 
		trace_out('k = ' .. k .. '\n')
		
	end 
	trace_out('end =-=====================================\n')
end 

local function Tes2()
	local all = require 'sys.mgr'.get_all()
	local t = {}
	for k,v in pairs (all) do 
		if v.Type == 'Joint' then 
			t[k] = v
		end
	end 
	require 'app.Contacts.file.file_op'.save_file('C:\\helo.lua',t)
end

function load()
	require"sys.menu".add{view=true,pos={"Window"},name={"Select","Joint"},f=Joint};
	--require"sys.menu".add{view=true,pos={"Window"},name={"Select","Test"},f=Test};
	
	--require"sys.menu".add{view=true,pos={"Window"},name={"Select","Tes2"},f=Tes2};
end

