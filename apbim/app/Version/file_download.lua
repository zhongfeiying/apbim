_ENV = module(...,ap.adv)

local cmd_status_ = "";
local cur_parent_node_ = "";

local downloading_={};

function set_cur_info(status,node)	
	cmd_status_ = status;	
	cur_parent_node_ = node;	
end

function init_downloading(ids)
	--trace_out("ids  \n")
	--require "sys.table".totrace(ids)
	init_send_connect()
	for k,v in ipairs(ids) do 
		local tmp = v;
		downloading_[tmp.id] = tmp.id;
		--trace_out("file = " .. v .. "downloading.\n");
		
		get_file(v.id);
	end
end
function init_downloading_by_id(ids)
	init_send_connect()
	--require "sys.table".totrace(ids)
	for k,v in ipairs(ids) do 
		local tmp = v;
		downloading_[tmp] = tmp;
		get_file(v);
	end
end

function op_pull(file)

end
function op_push(file)

end
function get_table_num(ids)
	local num=0;
	for k,v in pairs(ids) do 
		num = num+1;
	end
	return num;	
end
function op_import_gid(file)

end

function op_get_files(file)
	downloading_[file]=nil;
	local num = get_table_num(downloading_);
	if(num == 0)then
		trace_out("num == 0,start inserting to tree.\n");
		require"app.Version.version_op".set_status();
	end
end

function operate(file)
	trace_out("download file ok = " .. file .. "\n");
	
	if(cmd_status_ == "pull")then
		op_pull(file);
	elseif (cmd_status_ == "push")then
		op_push(file);	
	elseif (cmd_status_ == "import_gid")then
		op_import_gid(file);
	elseif (cmd_status_ == "get_files")then --better api
		op_get_files(file);
	end
end