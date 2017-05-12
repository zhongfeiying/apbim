
_ENV = module(...,ap.adv)

local ctr_require_ = require "app.workspace.ctr_require"
local workspace_ = ctr_require_.Workspace()

function open()
	if not workspace_.get_tree() then return end 
	workspace_.open()
end

function save()
	if not workspace_.get_tree() then return end 
	workspace_.save()
end

function upload()
	if not workspace_.get_tree() then return end 
	workspace_.upload()
end

function update()
	if not workspace_.get_tree() then return end 
	workspace_.update()
end


