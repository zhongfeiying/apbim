--module(...,package.seeall)

_ENV = module(...,ap.adv)
local tree_op_ = require "app.workspace.ctr_require".tree_op()

function set_node_attributes()
end

function set_tree_datas(tree,tid,data,str)
	for i = 1,#data do 
		if data[i].datas then
			if tonumber(tid)  < 0 then 
				tree["addbranch"] = data[i].name
			else 
				tree["addbranch" .. tid] = data[i].name
			end
			set_tree_datas(tree,tid + 1,data[i].datas,str)
			if data[i].attributes then 
				set_node_attributes(tree,data,i,tid)
				if data[i].attributes.show then 
					tree["STATE" .. (tid + 1)] = "EXPANDED"
				end 
			end		
		else
			if tonumber(tid)   < 0 then 
				tree["addleaf"] = data[i].name
			else 
				tree["addleaf" .. tid] = data[i].name
			end 
			if data[i].attributes then 
				set_node_attributes(tree,data,i,tid)
			end	
			local image = tree_op_.get_image(tree,str,tid + 1)
			tree_op_.set_image(tree,tid + 1,image)
		end 
	end 
end 

