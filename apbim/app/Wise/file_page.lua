_ENV = module(...,ap.adv)


local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local tree_ = require'apx.sjy.tree.tree'.get_class():new();


local dlg_ = iup.vbox{
	tabtitle = "Files";
	margin = "5x5";
	alignment = "aRight";
	-- size = "800x800";
	iup.vbox{
		iup.hbox{tree_:get_tree(),};
		-- iup.hbox{mat_,};
	};
}

local name_mat_fields_ = {
	{
		Width = 0;
		Head = "ID";
		Text = function(k,v,s)
			return k;
		end
	};
	{
		Width = 80;
		Head = "Name";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and v.Name or "";
			return str;
		end
	};
};


function pop(t)

	local function init_mat()
		local dat = require'sys.mgr'.get_all();
		require'sys.api.iup.matrix'.init_head{mat=mat_,fields=name_mat_fields_};
		require'sys.api.iup.matrix'.init_list{mat=mat_,fields=name_mat_fields_,dat=dat,minlin=50,sortf=function(k) return dat[k].Time end};
	end
	
	local function init_tree()
		local dat = require'sys.mgr'.get_all();
		local temp = {
			{
				Title = "apcad";
				Kind = "BRANCH";
				BranchOpen = true;
				Datas = {
					{
						Title = "main.lua";
						Kind = "LEAF";
					};
					{
						Title = "sys";
						Kind = "BRANCH";
						BranchOpen = true;
						Datas = {
							{
								Title = "main.lua";
								Kind = "LEAF";
							};
							{
								Title = "function.lua";
								Kind = "LEAF";
							};
							{
								Title = "Item.lua";
								Kind = "LEAF";
							};
							{
								Title = "Entity.lua";
								Kind = "LEAF";
							};
							{
								Title = "View.lua";
								Kind = "LEAF";
							};
							{
								Title = "Group.lua";
								Kind = "LEAF";
							};
							{
								Title = "menu.lua";
								Kind = "LEAF";
							};
							{
								Title = "statusbar.lua";
								Kind = "LEAF";
							};
							{
								Title = "dock.lua";
								Kind = "LEAF";
							};
							{
								Title = "geometry.lua";
								Kind = "LEAF";
							};
							{
								Title = "shap.lua";
								Kind = "LEAF";
							};
							{
								Title = "solid.lua";
								Kind = "LEAF";
							};
							{
								Title = "table.lua";
								Kind = "LEAF";
							};
							{
								Title = "str.lua";
								Kind = "LEAF";
							};
							{
								Title = "zip.lua";
								Kind = "LEAF";
							};
							{
								Title = "cmd";
								Kind = "BRANCH";
								BranchOpen = true;
								Datas = {
									{
										Title = "Idle.lua";
										Kind = "LEAF";
									};
									{
										Title = "Select.lua";
										Kind = "LEAF";
									};
								};
							};
							{
								Title = "net";
								Kind = "BRANCH";
								BranchOpen = true;
								Datas = {
									{
										Title = "user.lua";
										Kind = "LEAF";
									};
									{
										Title = "file.lua";
										Kind = "LEAF";
									};
									{
										Title = "queue.lua";
										Kind = "LEAF";
									};
								};
							};
							{
								Title = "mgr";
								Kind = "BRANCH";
								BranchOpen = true;
								Datas = {
									{
										Title = "model.lua";
										Kind = "LEAF";
									};
									{
										Title = "db.lua";
										Kind = "LEAF";
									};
									{
										Title = "version.lua";
										Kind = "LEAF";
									};
									{
										Title = "zip.lua";
										Kind = "LEAF";
									};
									{
										Title = "ifo.lua";
										Kind = "LEAF";
									};
									{
										Title = "class.lua";
										Kind = "LEAF";
									};
									{
										Title = "mode.lua";
										Kind = "LEAF";
									};
									{
										Title = "select.lua";
										Kind = "LEAF";
									};
									{
										Title = "scene.lua";
										Kind = "LEAF";
									};
									{
										Title = "scene";
										Kind = "BRANCH";
										BranchOpen = true;
										Datas = {
											{
												Title = "item.lua";
												Kind = "LEAF";
											};
											{
												Title = "index.lua";
												Kind = "LEAF";
											};
											{
												Title = "object.lua";
												Kind = "LEAF";
											};
										};
									};
									{
										Title = "draw.lua";
										Kind = "LEAF";
									};
									{
										Title = "drag.lua";
										Kind = "LEAF";
									};
								};
							};
						};
					};
					{
						Title = "app";
						Kind = "BRANCH";
						BranchOpen = true;
						Datas = {
							{
								Title = "Project";
								Kind = "BRANCH";
								BranchOpen = true;
								Datas = {
									{
										Title = "main.lua";
										Kind = "LEAF";
									};
									{
										Title = "function.lua";
										Kind = "LEAF";
									};
								};
							};
							{
								Title = "View";
								Kind = "BRANCH";
								BranchOpen = true;
								Datas = {
									{
										Title = "main.lua";
										Kind = "LEAF";
									};
									{
										Title = "function.lua";
										Kind = "LEAF";
									};
								};
							};
							{
								Title = "Show";
								Kind = "BRANCH";
							};
							{
								Title = "Select";
								Kind = "BRANCH";
							};
							{
								Title = "Edit";
								Kind = "BRANCH";
							};
							{
								Title = "Snap";
								Kind = "BRANCH";
							};
							{
								Title = "Model";
								Kind = "BRANCH";
							};
							{
								Title = "Steel";
								Kind = "BRANCH";
							};
							{
								Title = "Develop";
								Kind = "BRANCH";
							};
							{
								Title = "DXF";
								Kind = "BRANCH";
							};
						};
					};
				};
			};
		};
		-- for k,v in pairs(dat) do
			-- local node = {};
			-- node.Kind = v.Classname=='app/Wise/Folder' and 'BRANCH' or 'LEAF';
			-- node.Title = v.Name;
			-- node.Attr = v;
			-- table.insert(temp,node)
		-- end
		-- require'sys.table'.totrace{TREE = temp}
		tree_:set_datas(temp);
		-- tree_:show();
	end
	
	local function init()
		init_mat();
		init_tree();
		dlg_:show();
	end
	
	init();
	return dlg_;
end

function get()
	return dlg_;
end

