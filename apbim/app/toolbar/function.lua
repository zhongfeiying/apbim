_ENV = module(...,ap.adv)

local id_ =require "sys.interface.id"
local select_ = require 'app.select.function'
local project_ = require 'app.project.function'
local view_ = require 'app.view.function'
local tekla_ = require 'app.tekla.function'
local dxf_ =  require 'app.dxf.function'
local show_ =  require 'app.show.function'

local edit_ = require 'app.edit.function'
local snape_ = require 'app.snap.function'
local graphics_ =  require 'app.graphics.function'
local steel_ =  require 'app.steel.function'
local model_ =  require 'app.model.function'

local selectJoint_ =  require 'app.selectjoint.function'

local work_ =  require 'app.work.function'





-- local ID_SELECT_CURSOR = id_.get_command_id();
-- local ID_SELECT_ALL = id_.get_command_id();
-- local ID_SELECT_CANCEL = id_.get_command_id();
-- local ID_SELECT_REVERSE = id_.get_command_id();
-- local ID_TOOLBAR_CMD= id_.get_command_id();
local id = -1

local function buttons(arg)
	id = arg.pos or (id + 1)
	return {iBitmap=id,idCommand=arg.id,iString=arg.name,fsState= arg.fsState or TBSTATE_ENABLED,fsStyle=arg.fsStyle or BTNS_BUTTON}
	--fsStyle=BTNS_BUTTON+BTNS_CHECK
end

local function get_sep()
	return {iString = '',idCommand=id_.get_command_id(),fsStyle= BTNS_SEP}
end

local function get_basic_data()
	return {
		id = id_.get_command_id();
		bmpname = "app/toolbar/toolbar.bmp",
		dxButton = 0, 
		dyButton = 0,
		dxBitmap = 16,
		dyBitmap = 16,
		buttons ={};
		nbmps = 20, 
	}
end

local function get_nbmps(arg)
	if #arg.buttons > tonumber(arg.nbmps) then 
		arg.nbmps = #arg.buttons
	end 
end

local function insert_project_toolbar(arg)
	local ID_PROJECT_NEW = id_.get_command_id();
	local ID_PROJECT_OPEN = id_.get_command_id();
	local ID_PROJECT_SAVE = id_.get_command_id();
	local ID_PROJECT_UPLOAD = id_.get_command_id();
	local ID_PROJECT_DOWNLOAD = id_.get_command_id();
	local ID_PROJECT_CLEAR = id_.get_command_id();
	local ID_PROJECT_CLOSE = id_.get_command_id();
	id_.frm_commands()[ID_PROJECT_NEW]=project_.New
	id_.frm_commands()[ID_PROJECT_OPEN]=project_.Open
	id_.frm_commands()[ID_PROJECT_SAVE]=project_.Save
	id_.commands()[ID_PROJECT_NEW]=project_.New
	id_.commands()[ID_PROJECT_OPEN]=project_.Open
	id_.commands()[ID_PROJECT_SAVE]=project_.Save
	id_.commands()[ID_PROJECT_UPLOAD]=project_.Upload
	id_.commands()[ID_PROJECT_DOWNLOAD]=project_.Download
	id_.commands()[ID_PROJECT_CLEAR]=project_.Clear
	id_.frm_commands()[ID_PROJECT_CLOSE]=project_.Clear
	table.insert(arg.buttons,buttons{name = "New",id = ID_PROJECT_NEW})
	table.insert(arg.buttons,buttons{name = "Open",id = ID_PROJECT_OPEN})
	table.insert(arg.buttons,buttons{name = "Save",id = ID_PROJECT_SAVE})
	-- table.insert(arg.buttons,buttons{name = "Submit",id = ID_PROJECT_UPLOAD})
	-- table.insert(arg.buttons,buttons{name = "Update",id = ID_PROJECT_DOWNLOAD})
	-- table.insert(arg.buttons,buttons{name = "Clear",id = ID_PROJECT_CLEAR})
	-- table.insert(arg.buttons,buttons{name = "Close",id = ID_PROJECT_CLOSE})
	
	--{iBitmap=0,idCommand=ID_PROJECT_NEW,iString="New Project",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK},
end

local function insert_tekla_toolbar(arg)
	local ID_IMPORT_TEKLA = id_.get_command_id();
	id_.frm_commands()[ID_IMPORT_TEKLA]=tekla_.open_tekla
	table.insert(arg.buttons,buttons{name = "Import Tekla",id = ID_IMPORT_TEKLA})
end

local function insert_dxf_toolbar(arg)
	local ID_IMPORT_DXF = id_.get_command_id();
	id_.frm_commands()[ID_IMPORT_DXF]=dxf_.Import_DXF
	table.insert(arg.buttons,buttons{name = "Import DXF",id = ID_IMPORT_DXF})
end

local function insert_view_toolbar(arg)
	local ID_VIEW_NEW = id_.get_command_id();
	local ID_VIEW_SHOW = id_.get_command_id();
	local ID_VIEW_HIDE = id_.get_command_id();
	local ID_VIEW_FIT = id_.get_command_id();


	id_.frm_commands()[ID_VIEW_NEW]=view_.New
	id_.commands()[ID_VIEW_NEW]=view_.New
	id_.commands()[ID_VIEW_SHOW]=view_.Show
	id_.commands()[ID_VIEW_HIDE]=view_.Hide
	id_.commands()[ID_VIEW_FIT]=view_.Fit

	table.insert(arg.buttons,buttons{name = "View New",id = ID_VIEW_NEW})
	table.insert(arg.buttons,buttons{name = "View Show",id = ID_VIEW_SHOW})
	table.insert(arg.buttons,buttons{name = "View Hide",id = ID_VIEW_HIDE})
	table.insert(arg.buttons,buttons{name = "View Fit",id = ID_VIEW_FIT})
	
end

local function insert_view_mode_toolbar(arg)
	local ID_VIEW_MODE_3D = id_.get_command_id();
	local ID_VIEW_MODE_TOP = id_.get_command_id();
	local ID_VIEW_MODE_FRONT = id_.get_command_id();
	local ID_VIEW_MODE_BACK = id_.get_command_id();
	local ID_VIEW_MODE_LEFT = id_.get_command_id();
	local ID_VIEW_MODE_RIGHT = id_.get_command_id();
	local ID_VIEW_MODE_BOTTOM = id_.get_command_id();


	id_.commands()[ID_VIEW_MODE_3D]=function(sc)require"sys.mgr".scene_to_3d{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_TOP]=function(sc)require"sys.mgr".scene_to_top{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_FRONT]=function(sc)require"sys.mgr".scene_to_front{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_BACK]=function(sc)require"sys.mgr".scene_to_back{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_LEFT]=function(sc)require"sys.mgr".scene_to_left{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_RIGHT]=function(sc)require"sys.mgr".scene_to_right{scene=sc,update=true}end
	id_.commands()[ID_VIEW_MODE_BOTTOM]=function(sc)require"sys.mgr".scene_to_bottom{scene=sc,update=true}end

	
	table.insert(arg.buttons,buttons{name = "View 3D",id = ID_VIEW_MODE_3D})
	table.insert(arg.buttons,buttons{name = "Top",id = ID_VIEW_MODE_TOP})
	table.insert(arg.buttons,buttons{name = "Front",id = ID_VIEW_MODE_FRONT})
	table.insert(arg.buttons,buttons{name = "Back",id = ID_VIEW_MODE_BACK})
	table.insert(arg.buttons,buttons{name = "Left",id = ID_VIEW_MODE_LEFT})
	table.insert(arg.buttons,buttons{name = "Right",id = ID_VIEW_MODE_RIGHT})
	table.insert(arg.buttons,buttons{name = "Bottom",id = ID_VIEW_MODE_BOTTOM})

	
end

local function insert_show_toolbar(arg)
	local ID_SHOW_PROPERTY = id_.get_command_id();
	local ID_SHOW_DIAGRAM = id_.get_command_id();
	local ID_SHOW_WIREFRAME = id_.get_command_id();
	local ID_SHOW_RENDING = id_.get_command_id();
	id_.commands()[ID_SHOW_PROPERTY]=show_.property
	id_.commands()[ID_SHOW_DIAGRAM]=show_.diagram
	id_.commands()[ID_SHOW_WIREFRAME]=show_.wireframe
	id_.commands()[ID_SHOW_RENDING]=show_.rendering
	
	table.insert(arg.buttons,buttons{name = "Show Property",id = ID_SHOW_PROPERTY})
	table.insert(arg.buttons,buttons{name = "Show Diagram",id = ID_SHOW_DIAGRAM})
	table.insert(arg.buttons,buttons{name = "Show Wireframe",id = ID_SHOW_WIREFRAME})
	table.insert(arg.buttons,buttons{name = "Show Rendering",id = ID_SHOW_RENDING})
	
end

local function insert_select_toolbar(arg)
	local ID_SELECT_CURSOR = id_.get_command_id();
	local ID_SELECT_ALL = id_.get_command_id();
	local ID_SELECT_CANCEL = id_.get_command_id();
	local ID_SELECT_REVERSE = id_.get_command_id();
	local ID_SELECT_JOINT = id_.get_command_id();
	
	id_.commands()[ID_SELECT_CURSOR]=select_.select_everything
	id_.commands()[ID_SELECT_ALL]=select_.all
	id_.commands()[ID_SELECT_CANCEL]=select_.cancel
	id_.commands()[ID_SELECT_REVERSE]=select_.reverse
	id_.commands()[ID_SELECT_JOINT]=selectJoint_.Joint
	
	table.insert(arg.buttons,buttons{name = "Select Cursor",id = ID_SELECT_CURSOR})
	table.insert(arg.buttons,buttons{name = "Select All",id = ID_SELECT_ALL})
	table.insert(arg.buttons,buttons{name = "Select Cancel",id = ID_SELECT_CANCEL})
	table.insert(arg.buttons,buttons{name = "Select Reverse",id = ID_SELECT_REVERSE})
	-- table.insert(arg.buttons,buttons{name = "Select Joint",id = ID_SELECT_JOINT})
	
	
end

local function  insert_edit_toolbar(arg)
	local ID_EDIT_PROPERTY = id_.get_command_id();
	local ID_EDIT_COPY = id_.get_command_id();
	local ID_EDIT_MOVE = id_.get_command_id();
	local ID_EDIT_DELETE = id_.get_command_id();
	
	id_.commands()[ID_EDIT_PROPERTY]=edit_.property
	id_.commands()[ID_EDIT_COPY]=edit_.copy
	id_.commands()[ID_EDIT_MOVE]=edit_.move
	id_.commands()[ID_EDIT_DELETE]=edit_.del
	
	table.insert(arg.buttons,buttons{name = "Edit",id = ID_EDIT_PROPERTY})
	table.insert(arg.buttons,buttons{name = "Copy",id = ID_EDIT_COPY})
	table.insert(arg.buttons,buttons{name = "Move",id = ID_EDIT_MOVE})
	table.insert(arg.buttons,buttons{name = "Delete",id = ID_EDIT_DELETE})
end

local function  insert_snape_toolbar(arg)
	local ID_SNAP_POINT = id_.get_command_id();
	id_.commands()[ID_SNAP_POINT]=snape_.Snap_Point
	table.insert(arg.buttons,buttons{name = "Snap Point",id = ID_SNAP_POINT})
	
end

local function insert_graphics_toolbar( arg)
	local ID_GRAPHICS_LINE = id_.get_command_id();
	id_.commands()[ID_GRAPHICS_LINE]=graphics_.draw_line
	table.insert(arg.buttons,buttons{name = "Draw Line",id = ID_GRAPHICS_LINE})
	-- body
end

local function insert_steel_toolbar( arg)
	local ID_STEEL_BEAM = id_.get_command_id();
	id_.commands()[ID_STEEL_BEAM]=steel_.draw_beam
	table.insert(arg.buttons,buttons{name = "Draw Beam",id = ID_STEEL_BEAM})
	-- body
end

local function insert_model_toolbar( arg )
	local ID_MODEL_SHOW_RENDERING = id_.get_command_id();
	local ID_MODEL_LINK_SHOW = id_.get_command_id();
	local ID_MODEL_LINK_FIND = id_.get_command_id();
	
	id_.commands()[ID_MODEL_SHOW_RENDERING]=model_.Rendering
	id_.frm_commands()[ID_MODEL_SHOW_RENDERING]=model_.Rendering

	id_.commands()[ID_MODEL_LINK_SHOW]=work_.Link_Show
	id_.commands()[ID_MODEL_LINK_FIND]=work_.Link_Find
	local pos = id+1
	table.insert(arg.buttons,buttons{name = "Show Link",id = ID_MODEL_LINK_SHOW,pos = pos+1})
	table.insert(arg.buttons,buttons{name = "Find Link ",id = ID_MODEL_LINK_FIND,pos = pos+2})
	table.insert(arg.buttons,buttons{name = "Show Model",id = ID_MODEL_SHOW_RENDERING,pos = pos})
	id = pos+2
	-- body
end

local function  insert_lua_toolbar( arg )
	local ID_WORK_IMPORT_LUA = id_.get_command_id();
	local ID_WORK_EXPORT_LUA = id_.get_command_id();
	id_.commands()[ID_WORK_IMPORT_LUA]=work_.Import_Lua
	id_.frm_commands()[ID_WORK_IMPORT_LUA]=work_.Import_Lua

	id_.commands()[ID_WORK_EXPORT_LUA]=work_.Export_Lua
	id_.frm_commands()[ID_WORK_EXPORT_LUA]=work_.Export_Lua
	table.insert(arg.buttons,buttons{name = "Import Lua",id = ID_WORK_IMPORT_LUA})
	table.insert(arg.buttons,buttons{name = "Export Lua",id = ID_WORK_EXPORT_LUA})
end


local function load_bar()
	local arg = get_basic_data()
	
	insert_project_toolbar(arg)
	-- table.insert(arg.buttons,get_sep())
	-- insert_tekla_toolbar(arg)
	-- insert_dxf_toolbar(arg)
	-- table.insert(arg.buttons,get_sep())
	insert_lua_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_view_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_view_mode_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_show_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_select_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_edit_toolbar(arg)
	table.insert(arg.buttons,get_sep())
	insert_snape_toolbar(arg)
	insert_graphics_toolbar(arg)
	insert_steel_toolbar(arg)
	insert_model_toolbar(arg)


	get_nbmps(arg)
	crt_toolbar(frm,arg)
	
	--insert_select_toolbar(arg)
	--insert_view_toolbar(arg)
	--insert_show_toolbar(arg)
	-- crt_toolbar(frm,
		-- {
			-- id = id_.get_command_id();
			-- bmpname = "app/toolbar/toolbar.bmp",
			-- nbmps = 20, 
			-- dxButton = 0, 
			-- dyButton = 0,
			-- dxBitmap = 16,
			-- dyBitmap = 16,
			-- buttons = {
				
				
				-- {iBitmap=3,idCommand=ID_SELECT_REVERSE,iString="Select Reverse",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
				-- {iBitmap=0,idCommand=ID_SELECT_CURSOR,iString="Select Cursor",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK},
				-- {iBitmap=1,idCommand=ID_SELECT_ALL,iString="Select All",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
				-- {iBitmap=2,idCommand=ID_SELECT_CANCEL,iString="Select Cancel",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
				-- {iBitmap=3,idCommand=ID_SELECT_REVERSE,iString="Select Reverse",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			-- },
		-- }
	-- );
	
	
	-- id_.commands()[ID_SELECT_CURSOR]=fun_.select_everything
	-- id_.commands()[ID_SELECT_ALL]=fun_.all
	-- id_.commands()[ID_SELECT_CANCEL]=fun_.cancel
	-- id_.commands()[ID_SELECT_REVERSE]=fun_.reverse
end


function load()
	load_bar()
end

