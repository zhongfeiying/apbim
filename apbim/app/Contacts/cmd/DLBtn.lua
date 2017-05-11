_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local op_rmenu_ = require_files_.op_rmenu()
local op_disgroup_ = require_files_.op_disgroup()
local op_tree_ = require_files_.op_tree()

local cmds_ = {}





local function filter_datas(msg,selected_user) --筛选出与选择用户或者组相关的数据
	local datas = {}
	for k,v in pairs (msg) do 
		if v.From == selected_user  then 
			--datas[k] = {Time = v.Arrived_Time or v.Send_Time or v.Time,Id = k,Rid = v.rid,Pid = v.pid}
			--table.insert(datas,k)
			table.insert(datas,{Time = v.Arrived_Time or v.Send_Time or v.Time,Id = k,Rid = v.rid,Pid = v.pid})
		elseif v.To == selected_user  then 
			--datas[k] = {Time = v.Send_Time or v.Time,Id = k,Rid = v.rid,Pid = v.pid}
			table.insert(datas,{Time = v.Send_Time or v.Time,Id = k,Rid = v.rid,Pid = v.pid})
		end 
	end
	return datas
end 

local function sort(datas,re_datas,t)
	if #re_datas == 0 then 
		table.insert(re_datas,t.Id)
	else 
		for k,v in ipairs (re_datas) do 
			if tonumber(t.Time) <= tonumber(datas[v].Time) then
				return table.insert(re_datas,k,t.Id)
			end
		end 
		return table.insert(re_datas,t.Id)
	end 
	
end

local function deal_pid(msg,datas,re_datas,tempt,id)
	local cur = datas[id] or   {Time = msg[id].Arrived_Time or msg[id].Send_Time or msg[id].Time,Id = id,Rid = msg[id].rid,Pid = msg[id].pid}
	local rid = cur.Rid
	local pid = cur.Pid
	if pid ~= rid then 
		re_datas = deal_pid(msg,datas,re_datas,tempt,pid)
		if not tempt[id] then 
			tempt[id] = true
			re_datas[id] = cur
			sort(datas,re_datas,cur)
		end 
	else 
		if not tempt[rid] then 
			tempt[rid] = true
			re_datas[rid] =  datas[rid] or {Time = msg[rid].Arrived_Time or msg[rid].Send_Time or msg[rid].Time,Id = rid,Rid = msg[rid].rid,Pid = msg[rid].pid}
			sort(datas,re_datas, datas[rid])
		end 
		re_datas = re_datas[rid]
		if not tempt[id] then 
			tempt[id] = true
			re_datas[id] = cur
			sort(datas,re_datas, cur)
		end  
	end 
	re_datas = re_datas[id]
	return re_datas
end

local datas_ = {
	['1'] = {Time = 2,Id = '1'};
	['2'] = {Time = 4,Id = '2',Pid = '1',Rid = '1'};
	['3'] = {Time = 5,Id = '3',Pid = '1',Rid = '1'};
	['4'] = {Time = 12,Id = '4'};
	['5'] = {Time = 8,Id = '5',Pid = '2',Rid = '1'};
	['6'] = {Time = 5,Id = '6',Pid = '2',Rid = '1'};
	[1] = '1';
	[2] = '5';
	[3] = '3';
	[4] = '4';
	[5] = '2';
	[6] = '6';
}

local function sort_datas(datas,msg)--将筛选好的数据归档（处理回复）并排序
	--datas  = datas_
	local i = 1;
	local tempt,re_datas = {},{}
	while true do 
		if i > #datas then break end 
		local id = datas[i]
		if not tempt[id] then 
			
			local cur = datas[id]
			if cur.Rid then 
				deal_pid(msg,datas,re_datas,tempt,id)
			else 
				tempt[id] = true
				re_datas[id] = cur
				sort(datas,re_datas,cur)
			end 
		end 
		i = i + 1
	end 
	return re_datas
end 

local function contact_dlbtn(tree,id)
	
end

--arg = {Name ,}
local function get_branch(arg)
	return {Title = arg.Name,Kind = 'BRANCH',Datas = {},Image = arg.Image,Attr = {DLbtn = contact_dlbtn,AttrIndex = arg.Index},BranchOpen = arg.BranchOpen,BranchClose = arg.BranchClose}
end

local function get_leaf(arg)
	return {Title = arg.Name,Kind = 'LEAF',Image = arg.Image,Attr = {DLbtn = contact_dlbtn,AttrIndex = arg.Index}}
end

--require 'sys.dt'.date_text(v.Time) 
local function get_tree_datas(msgs,datas,history,new)
	local t = {}
	for k,v in ipairs (datas) do 
		if msgs[v.Id] then
			local t = msgs[v.Id]
			if msgs[v.Id].Read then 
				if v.From then 
				--table.insert(history,)
				table.insert(history,get_leaf{Name = v.From .. ' : ' ..  t.From .. ' ' .. t.Name or 'Error',Index = v.Id})
				else 
				table.insert(history,get_leaf{Name =t.Name or 'Error',Index = v.Id})
				end 
			else 
				if v.From then 
				table.insert(new,get_leaf{Name =  v.From .. ' : ' .. t.From .. ' ' .. t.Name or 'Error',Index = v.Id})
				else 
				table.insert(new,get_leaf{Name =  t.Name or 'Error',Index = v.Id})	
				end 
			end 
		end 
	end 
end 

local function get_data(msg,selected_user)
	local filter_datas = filter_datas(msg,selected_user)
	--trace_out('filter_datas = ')
	
	table.sort(filter_datas,function(a,b) return a.Time < b.Time end )
	--require 'sys.table'.totrace(filter_datas)
	--local sort_datas_ = sort_datas(filter_datas,msg)
	local datas = {}
	local messages = get_branch{Name = 'Messages',BranchOpen = true}
	table.insert(datas,messages)
	local history =get_branch{Name = 'History',BranchClose = true}
	table.insert(messages.Datas,history)
	local new = get_branch{Name = 'UnRead',BranchOpen = true}
	table.insert(messages.Datas,new)
	get_tree_datas(msg,filter_datas,history.Datas,new.Datas)
	--require 'sys.table'.totrace(datas)
	return datas
end

cmds_.contacts_file = function (tree)
	local id = tree:get_selected_id()
	--trace_out('cmds_.contacts_file id = ' .. id .. '\n')
	local oldData = op_rmenu_.get_node_index_data()
	if not oldData then return end 
	--require 'sys.table'.totrace(oldData)
	local selected_user = oldData.Name
	local arg = {}
	arg.Type = 'Contact'
	arg.Attr = oldData
	arg.Datas = get_data(require 'sys.net.msg'.get_all(),selected_user) or {}
	local dlg_msg_ = require_files_.dlg_msg()
	dlg_msg_.pop(arg)
end 

local function get_members(members)
	local t = {}
	for k,v in pairs (members) do 
		table.insert(t,k)
	end 
	return t
end
 
cmds_.groups_file = function (tree) 
	local id = tree:get_selected_id()
	--trace_out('cmds_.contacts_file id = ' .. id .. '\n')
	local oldData = op_rmenu_.get_node_index_data()
	if not oldData then return end 
	local arg = {}
	arg.Type = 'Group'
	arg.Members = get_members(op_disgroup_.open(oldData.Gid) or {}) 
	arg.Datas = get_data(require 'sys.net.msg'.get_all()) or {}
	local dlg_msg_ = require_files_.dlg_msg()
	dlg_msg_.pop(arg)
end 

function get_function(str)
	if type(cmds_[str]) == 'function' then return cmds_[str] end
end
