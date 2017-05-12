_ENV = module(...,ap.adv)
local require_files_ = require "app.Contacts.require_files"
local luaext_ = require_files_.luaext()



function update_project(zipfile,f)
	require "sys.mgr".upload{zipfile = zipfile,cbf = f}
end

function send_view()
	local sc = require "sys.mgr".get_cur_scene()
	if not sc then iup.Message("Notice","No current view !") return end 
	local vw = require "sys.mgr".get_view(sc)
	local smd = require "sys.Group".Class:new(vw)
	smd:set_name("View:" .. smd.Time)
	smd:set_scene(sc)
	smd:add_scene_all()
	require "sys.mgr".add(smd)
	return smd and smd.mgrid
end
