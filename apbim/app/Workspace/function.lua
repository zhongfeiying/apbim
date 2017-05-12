
_ENV = module(...,ap.adv)
--module(...,package.seeall)
local workspace_ = require "app.workspace.ctr_require".Workspace()
--local resource_dlg_ = require "app.Singapore_BIM.dlg_resource"
--local Dlg_BCA_Project_ = require"app.Singapore_BIM.Dlg_BCA_Project"
local dlg_rev_assign_ = require "app.workspace.ctr_require".dlg_rev_assign()
local dlg_tree_rename_ = require "app.workspace.ctr_require".dlg_tree_rename()
local dlg_project_list_ = require "app.workspace.ctr_require".dlg_project_list()
local file_op_ = require "app.workspace.ctr_require".file_op()
local status_ = false

local id_ =require "sys.interface.id"
local function Create_Model()
	--trace_out("Create_Model \n")
	--Dlg_BCA_Project_.pop();
end 

local function Create_Resource()
	--trace_out("Create_Resource \n")
	--resource_dlg_.pop();
end 

local function Create_Statistic()
	trace_out("Create_Statistic \n")
end 
--[[
local function Open_Workspace() 
	workspace_.locate_tab_page()
	dlg_project_list_.pop(status)
	local val = dlg_project_list_.get_data()
--	if val then 
--		status_ = true
--	end
end

local function Save_Project()
--	if status_ then 
		workspace_.save_pro(create_pro_)
--	end
end



local function New_Project()
--	if not status_ then 
--		workspace_.create()
--		status_ = true
--	else
	--local alarm = iup.Alarm("Notice","Do you want to create a new project ?","Yes","No")
	--if alarm  ~= 1 then return end
	workspace_.locate_tab_page()
	workspace_.create_new_project()
	--workspace_.change_pro()
end


--]]
local function table_is_empty(t)
	return _G.next(t) == nil
end


local function New_Project()
--	if not status_ then 
--		workspace_.create()
--		status_ = true
--	else
	--local alarm = iup.Alarm("Notice","Do you want to create a new project ?","Yes","No")
	--if alarm  ~= 1 then return end
	workspace_.new()
	
	--workspace_.change_pro()
end


local function Open_Workspace() 
	workspace_.open()
end

local function Save_Project()
--	if status_ then 
		workspace_.save()
--	end
end

local function locate_node()
	workspace_.locate_tab_page()
	local curs = require "sys.mgr".curs()
	if not curs or table_is_empty(curs) then return end 
	local tab = workspace_.get_links_tab()
	if not tab then return end 
	local status = false
	local linkslist = {}
	for k,v in ipairs(tab) do 
		local curstatus =false
		for m,n in pairs (v.ifo) do
			if curs[m] then status =true curstatus = true break  end 
		end
		if curstatus then table.insert(linkslist,v) end
	end
	if not status then iup.Message("Warning","No association of nodes !") return end 
	dlg_rev_assign_.set_data(linkslist,tab)
	dlg_rev_assign_.pop()
end

local function Open_Project_Folder()
	workspace_.Open_Project_Folder()
	-- local path = file_op_.get_bca_save_path()
	-- if not path then iup.Message("Warning","The project path is not exist !") return end 
	-- os.execute("explorer \"" .. path .. "\"")
end

local function Upload()
	workspace_.upload()
end



local ID_PROJECT_NEW = id_.get_command_id();
local ID_PROJECT_SAVE = id_.get_command_id();
local ID_PROJECT_OPEN = id_.get_command_id();
local ID_PROJECT_LOCATE = id_.get_command_id();
--ID_PROJECT_NEW = New_Project()
local function load_ctrbar()
	crt_toolbar(frm,
	{
		id = 100001,
		bmpname = "res/project_tool_bar.bmp",
		nbmps = 35, 
		dxButton = 0, 
		dyButton = 0,
		dxBitmap = 16,
		dyBitmap = 16,
		buttons = {
			{iBitmap=0,idCommand=ID_PROJECT_NEW,iString="New",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			{iBitmap=1,idCommand=ID_PROJECT_OPEN,iString="Open",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			{iBitmap=2,idCommand=ID_PROJECT_SAVE,iString="Save",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			{iBitmap=3,idCommand=ID_PROJECT_LOCATE,iString="Locate",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			--{iBitmap=2,idCommand=ID_SHOW_LINE,iString="Show Line",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			--{iBitmap=3,idCommand=ID_SHOW_FRAME,iString="Show Frame",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON,},
			{iBitmap=4,idCommand=ID_SHOW_RENDER,iString="Show Render",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON,},
			{iBitmap=5,idCommand=ID_SHOW_TREE,iString="Show Tree",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			
			{iBitmap=6,idCommand=ID_ROOM_ITEM,iString="Add Room Item",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
		
			{iBitmap=7,idCommand=ID_ROOM_ALL,iString="Add Room All",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON},
			
			{iBitmap=8,idCommand=ID_SELECT_MEMBER,iString="Select Member",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=9,idCommand=ID_SELECT_PLATE,iString="Select Plate",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=10,idCommand=ID_SELECT_BOLT,iString="Select Bolt",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=11,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=12,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			

			{iBitmap=13,idCommand=ID_SELECT_MEMBER,iString="Select Member",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=14,idCommand=ID_SELECT_PLATE,iString="Select Plate",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=15,idCommand=ID_SELECT_BOLT,iString="Select Bolt",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=16,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=17,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=18,idCommand=ID_SELECT_MEMBER,iString="Select Member",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=19,idCommand=ID_SELECT_PLATE,iString="Select Plate",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=20,idCommand=ID_SELECT_BOLT,iString="Select Bolt",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=21,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=22,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=23,idCommand=ID_SELECT_PLATE,iString="Select Plate",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=24,idCommand=ID_SELECT_BOLT,iString="Select Bolt",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=25,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=26,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=27,idCommand=ID_SELECT_BOLT,iString="Select Bolt",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},
			{iBitmap=28,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=29,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=30,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=31,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=32,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			{iBitmap=33,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
			
			{iBitmap=34,idCommand=ID_SELECT_IGNORE,iString="Select Anything",fsState=TBSTATE_ENABLED,fsStyle=BTNS_BUTTON+BTNS_CHECK,},			
		},
	}	
);

id_.frm_commands()[ID_PROJECT_NEW]=New_Project
id_.frm_commands()[ID_PROJECT_OPEN]=Open_Workspace
id_.frm_commands()[ID_PROJECT_SAVE]=Save_Project
id_.frm_commands()[ID_PROJECT_LOCATE]=locate_node

id_.commands()[ID_PROJECT_NEW]=New_Project
id_.commands()[ID_PROJECT_OPEN]=Open_Workspace
id_.commands()[ID_PROJECT_SAVE]=Save_Project
id_.commands()[ID_PROJECT_LOCATE]=locate_node
--id_.commands()[ID_PROJECT_SAVE]=require"function".project_save;
end


local page_status_ = false
local function load_page()

	if page_status_ then return end 
	workspace_.create()
	page_status_ = true
end

local function test()
	require "app.contacts.sendapi.op_project".send_view()
end

local function download()
workspace_.download()

end

function Update_Porject_List()
	workspace_.Update_Porject_List()
end

function load()
	--require"sys.menu".add{view=true,pos={"Window"},name={"Singapore BIM","Create Model"},f=Create_Model};
	--require"sys.menu".add{view=true,pos={"Window"},name={"Singapore BIM","Create Resource"},f=Create_Resource};
	--require"sys.menu".add{view=true,pos={"Window"},name={"Singapore Beam","Create Statistic"},f=Create_Statistic};
	-- load_page()
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","New"},f=New_Project};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Open"},f=Open_Workspace};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Save"},f=Save_Project};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Upload"},f=Upload};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Update Porject List"},f=Update_Porject_List};
	--require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Download"},f=Download};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Locate Node"},f=locate_node};
	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Open Project Folder"},f=Open_Project_Folder};
	
	--require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","BCA","Test"},f=test};
--	require"sys.menu".add{view=true,frame =true ,app = "Workspace",pos={"Window","Close"},name={"File","test"},f=test};
	load_ctrbar()
end


function unload()
end

