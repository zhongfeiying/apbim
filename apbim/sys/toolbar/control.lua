local type = type;
local trace_out = trace_out;
local ipairs = ipairs;
local table = table;
local io = io
local print = print
local require = require

local crt_toolbar = crt_toolbar;
local frm = frm;
local BTNS_SEP = BTNS_SEP;
local TBSTATE_ENABLED = TBSTATE_ENABLED;
local BTNS_CHECK = BTNS_CHECK;

local ID_MGR = require "sys.res.id_mgr";
local next_ = _G.next
local menu_dat_ = require'sys.menu.dat'

--[[

TBSTATE_CHECKED  The button has the TBSTYLE_CHECK style and is being clicked. 
TBSTATE_ELLIPSES  Version 4.70. The button's text is cut off and an ellipsis is displayed. 
TBSTATE_ENABLED  The button accepts user input. A button that doesn't have this state is grayed. 
TBSTATE_HIDDEN  The button is not visible and cannot receive user input. 
TBSTATE_INDETERMINATE  The button is grayed. 
TBSTATE_MARKED  Version 4.71. The button is marked. The interpretation of a marked item is dependent upon the application.  
TBSTATE_PRESSED  The button is being clicked. 
TBSTATE_WRAP  The button is followed by a line break. The button must also have the TBSTATE_ENABLED state. 

--]]
_ENV = module(...)

local function bmp_image(imagefile)
	if imagefile then 
		local file = io.open(imagefile,'r')
		if file then
			file:close()
			return imagefile
		end 
	end
	return  "sys/res/toolbar1.bmp"
end 

local function  menu_keyword( keyword )
	-- body
	local db = menu_dat_.get_all() or {}
	return db[keyword]
end

local function create_toolbar(toolbar,toolbar_db)
	local buts = {};
	for k,v in ipairs (toolbar) do 
		if v.name then 
			local sys_id = ID_MGR.new_id();
			ID_MGR.map(sys_id,v.keyword);
			local tbar = toolbar_db[v.keyword] or menu_keyword(v.keyword);
			if tbar then
				local fsStyle = tbar.checkbox  and  BTNS_CHECK
				table.insert(buts,{iBitmap  = v.image -1,idCommand = sys_id,iString = v.name,fsState  = TBSTATE_ENABLED,fsStyle = fsStyle});
			else	
				table.insert(buts,{iBitmap  =v.image -1,idCommand = sys_id,iString = v.name,fsState  =  TBSTATE_ENABLED,fsStyle = fsStyle});
				--trace_out("The toolbar isn't exist in database.\n");
			end
		else 
			table.insert(buts,{iString  = '' ,fsStyle = BTNS_SEP,fsState  = TBSTATE_ENABLED })
		end 
	end 
	local toolbar_id = ID_MGR.new_id();
	
	local bmpname = bmp_image(toolbar.bmpname )
	
	local sys_toolbar = {
		id = toolbar_id;-- 工具条标识
		bmpname =bmpname;
		nbmps = 1;
		buttons = buts;
	};	
	crt_toolbar(frm,sys_toolbar)
end

local function  table_is_empty( t )
	return next_(t) == nil	-- body
end

local function create_items(styles,toolbars)
	for k,v in ipairs (styles) do 
		if not table_is_empty( v ) then 
			create_toolbar(v,toolbars); 
		end 
	end 
end


function create_toolbars(styles,toolbars)
	if type(styles)~='table' then return end
	ID_MGR.set_toolbars(toolbars);
	create_items(styles,toolbars);
end



