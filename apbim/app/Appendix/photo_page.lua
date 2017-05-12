_ENV = module(...,ap.adv)

local PATH_= "DB/"
local EXNAME_= ".bmp"

local iup = require"iuplua"
local iupcontrol = require"iupluacontrols"

local pic_lab_ = iup.label{expand="Horizontal--",flat="YES",rastersize="400X200",image="test.bmp"};
local pic_txt_ = iup.text{expand="Horizontal"};
local pic_mat_ = iup.matrix{expand="Yes",READONLY="YES",resizematrix="YES"};
local update_ = iup.button{title="Update",rastersize="X30",expand="Horizontal"};
local add_btn_ = iup.button{title="Add"	,rastersize="60X30"};
local del_btn_ = iup.button{title="Delete"	,rastersize="60X30"};
local open_view_btn_ = iup.button{title="Open View"	,rastersize="100X30"};
local open_file_btn_ = iup.button{title="Open File"	,rastersize="100X30"};
local Highlight_tog_ = iup.toggle{title="Highlight"	,rastersize="100X30"};
-- local Rendering_tog_ = iup.toggle{title="Rendering"	,rastersize="100X30"};
local Show_Hide_tog_ = iup.toggle{title="Show/Hide"	,rastersize="100X30"};

local dlg = iup.vbox{
	tabtitle = "Photo";
	margin = "5x5";
	alignment = "aRight";
	-- size = "800x800";
	iup.vbox{
		iup.frame{pic_lab_};
		iup.hbox{pic_txt_};
		iup.hbox{update_,add_btn_,del_btn_,open_view_btn_,};
		iup.hbox{iup.fill{},Highlight_tog_,Show_Hide_tog_};
		iup.hbox{pic_mat_};
	};
}

local pic_mat_fields_ = {
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
	{
		Width = 50;
		Head = "State";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and v.View and "*" or "";
			return str;
		end
	};
	{
		Width = 100;
		Head = "Time";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and require'sys.dt'.time_text(v.Time) or 0;
			return str;
		end
	};
	{
		Width = 200;
		Head = "Position";
		Text = function(k,v,s)
			local v = require"sys.mgr".get_table(k,v);
			local str = type(v)=="table" and v.Remark or 0;
			return str;
		end
	};
};


-- t={filter=}
function pop(t)
	t = t or {};
	
	local function get_dat_items()
		local all_ = require"sys.mgr".get_class_all(require"app.Appendix.Photo".Class);
		local dat_ = require'sys.table'.filter(all_,t.filter or function()return true end);
		return dat_;
	end

	local function download_files()
		local dat = get_dat_items();
		for k,v in pairs(dat) do
			local item = require"sys.mgr".get_table(k,v);
			if item.Path and not require'sys.io'.is_there_file{file=item.Path} then 
				require'sys.net.file'.get{
					name = item.hid..EXNAME_,
					path = PATH_,
					cbf = function()
						item.Path = PATH_..item.hid..EXNAME_;
					end
				}
			end
		end
	end
	
	local function init_name_mat()
		local dat = get_dat_items();
		require'sys.api.iup.matrix'.init_head{mat=pic_mat_,fields=pic_mat_fields_};
		require'sys.api.iup.matrix'.init_list{mat=pic_mat_,fields=pic_mat_fields_,dat=dat,minlin=50,sortf=function(k) return dat[k].Time end};
		download_files();
	end

	local function init()
		init_name_mat();
		dlg:show();
	end

	local function on_add()
		local sc = require'sys.mgr'.get_cur_scene();
		if not sc then iup.Alarm("Error","Open a view, please","OK") return end
		local name = pic_txt_.value;
		if not name or name=="" then iup.Alarm("Error","Input a name, please","OK") return end
		
		local file = require'sys.api.image'.save_bmp{scene=sc,file=PATH_..name}
		local hid = require'sys.hid'.get_by_file(file)
		os.rename(file,PATH_..hid..EXNAME_);
		
		require'sys.net.file'.send{
			name=hid..EXNAME_,
			path=PATH_,
			cbf=function() 
				local view = require'sys.Group'.get_view{Name=name};
				local item = require'app.Appendix.Photo'.Class:new{Name=name,hid=hid}
				if type(view)=="table" then item.View = view.mgrid end
				require"sys.mgr".add(item);
				require"sys.statusbar".show_model_count();
				init_name_mat();
			end
		}
	end

	local function get_selection_lin_item()
		local id = require'sys.api.iup.matrix'.get_selection_lin_text{mat=pic_mat_,col=1};
		-- local all = require"sys.mgr".get_class_all(require"app.Appendix.Photo".Class);
		local all = get_dat_items();
		if not all[id] then return end
		local item = require"sys.mgr".get_table(id);
		if type(item)~="table" then return end
		return item
	end

	local function get_selection_lin_view()
		local item = get_selection_lin_item();
		if not item then return end
		if not item.View then return end
		local view = require"sys.mgr".get_table(item.View);
		if type(view)~="table" then return end
		return view
	end

	local function on_del()
		local item = get_selection_lin_item();
		if not item then return end
		require"sys.mgr".del(item);
		require"sys.statusbar".show_model_count();
		init_name_mat();
	end
	
	local function on_open_view()
		local view = get_selection_lin_view();
		if not view then return end
		view:open{name=view.Name};
		Highlight_tog_.value = "ON"
		-- Rendering_tog_.value = "ON"
		Show_Hide_tog_.value = "ON"
	end

	local function open_file(item) 
		if item.Path and require'sys.io'.is_there_file{file=item.Path} then 
			-- require'sys.api.dos'.start(item.Path) 
			pic_lab_.image=item.Path;
			dlg:show();
			return true 
		end
	end
	
	local function download_file(item,open)
		-- local str = require'sys.api.iup.file_dlg'.save{name=item.Path or item.Name,exname=require'sys.str'.get_exname(item.Name)}
		-- if not str or str=='' then return end
		require'sys.net.file'.get{
			name = item.hid..EXNAME_,
			path = PATH_,
			cbf = function()
				item.Path = PATH_..item.hid..EXNAME_;
				if open then open_file(item) end
			end
		}
	end
	
	local function on_open_file()
		local item = get_selection_lin_item();
		if type(item)~="table" then return end
		if not open_file(item) then download_file(item,true) end
	end

	local function on_Darken()
		require"sys.mgr".select_none{redraw=ture};
		require"sys.mgr".update();
	end

	local function on_Highlight()
		local view = get_selection_lin_view();
		if not view then return end
		local light = Highlight_tog_.value == "ON" and true or nil;
		view:select_marks(light);
		require"sys.mgr".update();
	end
	
	-- local function on_Rendering()
		-- local view = get_selection_lin_view();
		-- if not view then return end
		-- local light = Highlight_tog_.value == "ON" and true or nil;
		-- view:select_marks(light);
		-- require"sys.mgr".update();
		-- local sc or require"sys.mgr".get_cur_scene();
		-- local ents = view.mgrids;
		-- if not ents then return end
		-- local run = require"sys.progress".create{title="Diagram",count=require"sys.table".count(ents),time=1};
		-- for k,v in pairs(ents) do
			-- v = require"sys.mgr".get_table(k,v);
			-- if view.Marks and view.Marks[k] then
				-- require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Rendering);
			-- elseif view.Marks and not view.Marks[k] then
				-- require"sys.View".set_mode(sc,v.mgrid,require"sys.Entity".Diagram);
			-- end
			-- require"sys.mgr".redraw(v,sc);
			-- run();
		-- end
		-- require"sys.mgr".update();
	-- end
	
	local function get_view_title(view)
		return Show_Hide_tog_.value == "ON" and (view.Name or "File") or (view.Name or "File").." - #";
	end

	local function on_Show_Hide()
		local view = get_selection_lin_view();
		if not view then return end
		local ents = Show_Hide_tog_.value == "ON" and view.mgrids or view.Marks;
		ents = ents or {};
		local scs = require"sys.mgr".find_scene{name=get_view_title(view)};
		if require'sys.table'.count(scs)>=1 then 
			require"sys.mgr".set_active_scene(scs[1]);
		else 
			require"sys.View".new_view{ents=ents,name=get_view_title(view)};
			require"sys.mgr".update();
		end
	end

	local function on_select_lin()
		require'sys.api.iup.matrix'.select_lin{mat=pic_mat_}
		on_open_file();
	end
	
	local function on_name_mat()
	end
	
	
	function pic_mat_:click_cb(lin,col,str)
		-- if string.find(str,"1") and string.find(str,"D") then on_look() end
		on_select_lin();
		on_name_mat();
	end
	
	function update_:action()init()end
	function add_btn_:action()on_add()end
	function del_btn_:action()on_del()end
	function open_view_btn_:action()on_open_view()end
	function open_file_btn_:action()on_open_file()end
	function Highlight_tog_:action()on_Highlight()end
	-- function Rendering_tog_:action()on_Rendering()end
	function Show_Hide_tog_:action()on_Show_Hide()end

	init();
	-- require'sys.api.iup.key'.register_k_any{dlg=dlg,[iup.K_CR]=on_look};
	-- require'sys.net.msg'.resgister_rcvf(init);
	return dlg;
end

function get()
	return dlg;
end